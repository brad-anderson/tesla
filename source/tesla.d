import diggler.bot;
import irc.protocol;
import std.regex;
import std.net.curl;
import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.encoding;
import std.datetime;

import entities;

@category("echobot")
class EchoCommands : CommandSet!EchoCommands
{
    mixin CommandContext!();

    @usage("repeat the given text.")
    void echo(in char[] text)
    {
        reply("%s: %s", user.nick, text);
    }
}

struct Note
{
    string author;
    string message;
    SysTime time;
}

@category("notes")
class NoteCommands : CommandSet!NoteCommands
{
    mixin CommandContext!();

    Note[][string] notes;

    @usage("leaves a note for someone")
    void note(in char[] text)
    {
        static note_re = ctRegex!(r"(\S+?)\s+(.+)");

        auto m = matchFirst(text, note_re);

        if (!m.hit)
        {
            reply("%s: syntax is '<nick> <note...>'", user.nick);
            return;
        }

        auto addressee = m.captures[1];
        auto note = m.captures[2];
        notes[addressee] ~= Note(user.nick.dup, note.dup, Clock.currTime());

        reply("%s: %s will be notified when they talk or join", user.nick, addressee);
    }


    void dispatchPendingNotes(string user)
    {
        if (auto user_notes = user in notes)
        {
            foreach(note; *user_notes)
            {
                reply("%s: %s left a note for you %s ago:", user, note.author, Clock.currTime() - note.time);
                reply("%s: <%s> %s", user, note.author, note.message);
            }
            notes.remove(user);
        }
    }
}


auto scrapeTitles(M)(in M message)
{
    import std.exception;
    import std.parallelism : paramap = map;

    static url_re = ctRegex!(r"(https?|ftp)://[^\s/$.?#].[^\s]*", "i");
    static title_re = ctRegex!(r"<title.*?>(.*?)<", "si");
    static ws_re = ctRegex!(r"(\s{2,}|\n|\t)");

    auto utf8 = new EncodingSchemeUtf8;
    auto titles =
         matchAll(message, url_re)
        .map!(match => match.captures[0])
        .paramap!((url) => get(url).ifThrown([]))
        .map!(bytes => cast(string)
                       utf8.sanitize(cast(immutable(ubyte)[])bytes))
        .map!(content => matchFirst(content, title_re))
        .filter!(captures => !captures.empty)
        .map!(capture => capture[1].idup) // dup so GC can collect original
        .map!(title => title.entitiesToUni.replace(ws_re, " "))
        .array;

    return titles;
}
