import diggler.bot;
import irc.protocol;
import std.regex;
import std.net.curl;
import std.algorithm;
import std.range;
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


string[] scrapeTitles(M)(in M message)
{
    import std.exception;
    import std.parallelism : paramap = map;

    static re_url = ctRegex!(r"(https?|ftp)://[^\s/$.?#].[^\s]*", "i");
    static re_title = ctRegex!(r"<title.*?>(.*?)<", "si");
    static re_ws = ctRegex!(r"(\s{2,}|\n|\t)");

    return matchAll(message, re_url)
              .map!(      match => match.captures[0] )
              .map!(        url => byChunk(url, 2048).front ) // just first 2k
              .map!(    content => matchFirst(cast(char[])content, re_title) )
              .array // cache to prevent multiple evaluations of preceding
              .filter!( capture => !capture.empty )
              .map!(    capture => capture[1].idup.entitiesToUni )
              .map!(  uni_title => uni_title.replaceAll(re_ws, " ") )
              .array
              .ifThrown(string[].init); // [] should work, possible bug
}
