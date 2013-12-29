import tesla;
import diggler.bot;
import std.array;
import std.algorithm;

void main()
{
    Bot.Configuration conf;
    conf.nick = "tesla3";
    conf.userName = "tesla3";
    conf.realName = "Tesla Lolzington";
    conf.commandPrefix = ".";

    auto bot = new Bot(conf);

    bot.registerCommands(new EchoCommands);

    auto client = bot.connect("irc://irc.lolutah.com/tesla-testing");
    client.onMessage ~= (user, target, message) {
                            auto titles = scrapeTitles(message);
                            foreach (t; titles)
                                client.sendf(target, "[ %s ]", t);
    };

    client.onNickInUse ~= badNick => badNick ~ "_";

    bot.run();
}

