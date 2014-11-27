import diggler.bot;
import std.datetime;
import std.regex;

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
            reply("%s: syntax is '<nick> <note...>'", user.nickName);
            return;
        }

        auto addressee = m.captures[1];
        auto note = m.captures[2];
        notes[addressee] ~= Note(user.nickName.dup, note.dup, Clock.currTime());

        reply("%s: %s will be notified when they talk or join", user.nickName, addressee);
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

