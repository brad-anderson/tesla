import std.stdio, std.string, std.stream, std.algorithm, std.array;
import std.socket, std.socketstream;
import std.regex;
import std.datetime;
import std.net.curl;
import std.xml;

enum irc_regex = ctRegex!(r"^(?:[:@]([^\s]+) )?([^\s]+)(?: ((?:[^:\s][^\s]* ?)*))?(?: ?:(.*))?$");
//enum url_regex = ctRegex!(r"(https?|ftp)://(-\.)?([^\s/?\.#-]+\.?)+(/[^\s]*)?", "gi");
enum url_regex = ctRegex!(r"^(https?|ftp)://[^\s/$.?#].[^\s]*$", "gi");
enum title_regex = ctRegex!(r"<title>(.*?)<", "si");
enum extra_whitespace_regex = ctRegex!(r"\s{2,}", "g");

class IrcBot
{
    this(string nick)
    {
        m_nick = nick;
    }

    ~this()
    {
        disconnect();
    }

    void connect(string host, ushort port)
    {
        m_host = host;
        m_port = port;

        m_socket = new TcpSocket(new std.socket.InternetAddress(host, port));
        m_stream = new SocketStream(m_socket);

        writefln("Setting nick to %s", "tesla");
        m_socket.send(format("NICK %s\r\n", "tesla"));
        m_socket.send(format("USER %s %s %s :Nikola Tesla\r\n", "tesla", "0", "*"));
    }

    void disconnect()
    {
        m_socket.close();
    }

    void join(string[] channels)
    {
        m_channels = channels;

        foreach(chan; m_channels)
        {
            writefln("Joining channel %s", chan);
            m_socket.send(format("JOIN %s\r\n", chan));
        }
    }

    bool connected()
    {
        return m_socket && m_socket.isAlive();
    }

    void process()
    {
        string line = m_stream.readLine().idup;

        auto c = match(line, irc_regex).front;
        auto source     = c[1];
        auto command    = c[2];
        auto target     = c[3];
        auto parameters = c[4];

        //writeln(line);
        writefln("---");
        writefln(" - time:       %s", Clock.currTime().toSimpleString);
        writefln(" - source:     %s", source);
        writefln(" - command:    %s", command);
        writefln(" - target:     %s", target);
        writefln(" - parameters: %s", parameters);

        if(command == "PING")
        {
            writeln("PONG");
            m_stream.writeLine(format("PONG %s", parameters));
        }

        if(command == "PRIVMSG")
        {
            auto urls = array(map!(a => a.captures[0])(match(parameters, url_regex)));
            if(urls.length > 0)
            {
                foreach(url; urls)
                {
                    try
                    {
                        string contents = get(url).idup;
                        auto title_match = match(contents, title_regex);
                        if(title_match)
                        {
                            auto title =
                                decode( // decode xml entities
                                    replace( // remove chains of two or more whitspace
                                        replace( // remove newlines
                                            strip(title_match.captures[1]), // remove whitespace padding
                                                "\n", ""), extra_whitespace_regex, " "));
                            
                            // Handle a few common entities the xml decoding
                            // won't catch
                            title = replace(title, "&laquo;", "\u00ab");
                            title = replace(title, "&raquo;", "\u00bb");
                            title = replace(title, "&copy;", "\u00a9");
                            title = replace(title, "&nbsp;", " ");
                            title = replace(title, "&reg;", "\u00ae");
                            title = replace(title, "&trade;", "\u2122");

                            channelAction(target, format("\x0314%s", title));
                        }
                        else
                        {
                            writefln("** Could not retrieve title **", url);
                        }

                    }
                    catch(CurlException e)
                    {
                        writefln("** Could not retrieve %s **", url);
                    }
                }
            }
        }
    }

    void channelMessage(string channel, string message)
    {
        m_stream.writeLine(format("PRIVMSG %s :%s", channel, message));
    }

    void channelAction(string channel, string action)
    {
        m_stream.writeLine(format("PRIVMSG %s :\x01ACTION %s\x01", channel, action));
    }


    string m_nick;
    string m_host;
    ushort m_port;
    string[] m_channels;
    TcpSocket m_socket;
    SocketStream m_stream;
}

void main()
{
    // argument parsing here

    auto nick = "tesla";
    auto host = "irc.lolutah.com";
    ushort port = 6667;
    auto chans = ["#tesla-testing"];

    writefln("Connecting to %s on port %d...", host, port);

    auto bot = new IrcBot(nick);


    bot.connect(host, port);
    bot.join(chans);
    scope(exit) bot.disconnect();

    while(bot.connected())
    {
        bot.process();
    }
}
