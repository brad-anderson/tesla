import tesla;
import diggler.bot;
import std.array;
import std.algorithm;
import std.stdio;
import sdlang;
import std.typecons;

void main()
{
    auto tesla_config = load_config("tesla.conf");
    Bot.Configuration conf = tesla_config[0];
    string[] connections = tesla_config[1];


    auto bot = new Bot(conf);

    auto note_cmds = new NoteCommands;
    bot.registerCommands(note_cmds);

    auto hail_cmds = new HailCommands;
    bot.registerCommands(hail_cmds);

    foreach (connection; connections)
    {
        auto client = bot.connect(connection);
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
    }

    bot.run();
}

Tuple!(Bot.Configuration, string[]) load_config(string filename)
{
    try
    {
        Bot.Configuration config;
        auto root = parseFile(filename);
        config.nickName = root.tags["nick"][0].values[0].get!string();
        config.userName = root.tags["user"][0].values[0].get!string();
        config.realName = root.tags["real"][0].values[0].get!string();
        config.commandPrefix = root.tags["prefix"][0].values[0].get!string();

        string[] connections;
        foreach (connection; root.tags["connection"])
            connections ~= connection.values[0].get!string();

        return tuple(config, connections);
    }
    catch (SDLangParseException e)
    {
        stderr.writeln(e.msg);
        throw e;
    }

}
