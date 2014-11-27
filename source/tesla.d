import diggler.bot;
import irc.protocol;
import sdlang;
import std.stdio;
import std.encoding;
import std.exception;
import std.string;
import std.typecons;


import note;
import hail;
import titlescrape;

class Tesla
{
    this(string config_filename)
    {
        auto tesla_config = load_config(config_filename);
        Bot.Configuration conf = tesla_config[0];
        string[] connections = tesla_config[1];

        bot = new Bot(conf);

        auto note_cmds = new NoteCommands;
        bot.registerCommands(note_cmds);

        auto hail_cmds = new HailCommands;
        bot.registerCommands(hail_cmds);

        foreach (connection; connections)
        {
            auto client = bot.connect(connection);
            client.onMessage ~= (user, target, message) {
                auto titles = title_scrape(message);
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
    }

    alias bot this;

    Bot bot;
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
