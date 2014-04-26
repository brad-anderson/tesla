import tesla;
import diggler.bot;
import std.array;
import std.algorithm;

void main()
{
    Bot.Configuration conf;
    conf.nickName = "tesla3";
    conf.userName = "tesla3";
    conf.realName = "Tesla Lolzington";
    conf.commandPrefix = ".";

    auto bot = new Bot(conf);

    auto note_cmds = new NoteCommands;
    bot.registerCommands(note_cmds);

    auto client = bot.connect("irc://irc.lolutah.com/tesla-testing");
    client.onMessage ~= (user, target, message) {
                            auto titles = scrapeTitles(message);
                            foreach (t; titles)
                                client.sendf(target, "[ %s ]", t);
    };
    client.onMessage ~= (user, _, __) {
                            note_cmds.dispatchPendingNotes(user.nickName.dup);
    };
    client.onJoin ~= (user, _) {
                            note_cmds.dispatchPendingNotes(user.nickName.dup);
    };

    client.onNickInUse ~= badNick => badNick ~ "_";

    bot.run();
}

