import diggler.bot;
import std.regex;
import std.net.curl;
import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.encoding;

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

string[] scrapeTitles(in char[] message)
{
    import std.exception;
    import std.parallelism : paramap = map;

    static url_re = ctRegex!(r"(https?|ftp)://[^\s/$.?#].[^\s]*", "i");
    static title_re = ctRegex!(r"<title.*?>(.*?)<", "si");
    static ws_re = ctRegex!(r"(\s{2,}|\n|\t)", "g");

    auto utf8 = new EncodingSchemeUtf8;
    /*auto titles =
         matchAll(message, url_re)
        .map!(match => match.captures[0])
        .paramap!((url) => get(url).ifThrown([]))
        .map!(bytes => cast(string)
                       utf8.sanitize(cast(immutable(ubyte)[])bytes))
        .map!(content => matchFirst(content, title_re))
        .filter!(captures => !captures.empty)
        .map!(capture => capture[1].idup) // the captured title
        .map!(title => title.entities_to_uni
                            .replace(ws_re, " "))
        .array;
        */

    auto titles =
         matchAll(message, url_re)
        .map!(match => match.captures[0])
        .paramap!((url) => byChunkAsync(url))
        .map!(bytes => cast(string)
                       utf8.sanitize(cast(immutable(ubyte)[])bytes))
        .map!(content => matchFirst(content, title_re))
        .filter!(captures => !captures.empty)
        .map!(capture => capture[1].idup) // the captured title
        .map!(title => title.entities_to_uni
                            .replace(ws_re, " "))
        .array;

    return titles;
}
