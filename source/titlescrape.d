import std.regex;
import std.net.curl;
import std.algorithm;
import std.range;
import std.array;
import std.conv;
import std.exception;

import entities;

string[] title_scrape(M)(in M message)
{
    static re_url   = ctRegex!(r"(https?|ftp)://[^\s/$.?#].[^\s]*", "i");
    static re_title = ctRegex!(r"<title.*?>(.*?)<", "si");
    static re_ws    = ctRegex!(r"(\s{2,}|\n|\t)");

    return matchAll(message, re_url)
              .map!(      match => match.captures[0] )
              .map!(        url => get4k(url).ifThrown([]) )
              .map!(    content => matchFirst(cast(char[])content, re_title) )
              .array // cache to prevent multiple evaluations of preceding
              .filter!( capture => !capture.empty )
              .map!(    capture => capture[1].idup.entitiesToUni )
              .map!(  uni_title => uni_title.replaceAll(re_ws, " ") )
              .array
              .ifThrown(string[].init); // [] should work, possible bug
}

auto get4k(U)(in U url)
{
    import etc.c.curl : CurlOption;
    auto http = HTTP();
    http.handle.set(CurlOption.range, "0-4096");

    // claim to be Chrome so sites don't discriminate (Facebook in particular)
    http.handle.set(CurlOption.useragent, "Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2225.0 Safari/537.36");

    return get(url, http);
}

