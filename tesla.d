import std.stdio, std.string, std.stream;
import std.socket, std.socketstream;
import std.regex;

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

        m_socket = new TcpSocket(new InternetAddress(m_host, m_port));
        m_stream = new SocketStream(m_socket);
        writefln("Setting nick to %s", m_nick);
        m_socket.send(format("NICK %s\r\n", m_nick));
        m_socket.send(format("USER %s %s %s :Nikola Tesla\r\n", m_nick, "0", "*"));
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
        while(!m_stream.eof())
        {
            string line = m_stream.readLine().idup;

            auto c = match(line, irc_regex).front;
            auto source     = c[1];
            auto command    = c[2];
            auto target     = c[3];
            auto parameters = c[4];

            writefln("Source: %s Command: %s Target: %s Parameters %s",
                    source, command, target, parameters);

            if(command == "PING")
            {
                writeln("Pongin'");
                m_socket.send(format("PONG %s\r\n", parameters));
            }
        }
    }


    enum irc_regex = ctRegex!(r"^(?:[:@]([^\s]+) )?([^\s]+)(?: ((?:[^:\s][^\s]* ?)*))?(?: ?:(.*))?$");
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
    auto chan = "#tesla-testing";

    writefln("Connecting to %s on port %d...", host, port);

    auto bot = new IrcBot(nick);
    bot.connect(host, port);
    bot.join([chan]);
    scope(exit) bot.disconnect();

    bot.process();
}
