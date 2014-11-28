import irc.client;
import diggler.bot;
import std.datetime;
import std.regex;
import msgpack;

enum NOTES_FILENAME = "notes.msgpack";

struct Note
{
    string author;
    string channel;
    string message;
    DateTime time;
}

@category("notes")
class NoteCommands : CommandSet!NoteCommands
{
    mixin CommandContext!();

    Note[][string] notes;

    this()
    {
        import std.file : exists, read;

        if (exists(NOTES_FILENAME))
        {
            auto pack_data = cast(ubyte[])read(NOTES_FILENAME);
            notes = pack_data.unpack!(Note[][string]);
        }

    }

    @usage("leaves a note for someone")
    void note(in char[] nick, in char[] note)
    {
        notes[nick] ~= Note(user.nickName.dup, channel.name, note.dup, cast(DateTime)Clock.currTime());
        save_notes(this);

        reply("%s: %s will be notified when they talk or join", user.nickName, nick);
    }
}

void dispatch_pending_notes(string user, string channel, NoteCommands command, IrcClient client)
{
    import std.array : empty;
    import std.algorithm : filter, remove;

    if (auto user_notes = user in command.notes)
    {
        auto channel_notes = filter!(n => n.channel == channel)(*user_notes);
        foreach(note; channel_notes)
        {
            client.sendf(channel, "%s: %s left a note for you %s ago:", user, note.author,
                    cast(DateTime)Clock.currTime() - note.time);
            client.sendf(channel, "%s: <%s> %s", user, note.author, note.message);
        }
        *user_notes = remove!(n => n.channel == channel)(*user_notes);

        if ((*user_notes).empty)
            command.notes.remove(user);

        save_notes(command);
    }
}

void save_notes(NoteCommands command)
{
    import std.file : write;
    write(NOTES_FILENAME, pack(command.notes));
}

