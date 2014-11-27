import diggler.bot;
import std.algorithm;
import std.conv;
import std.array;

@category("hail")
class HailCommands : CommandSet!HailCommands
{
    mixin CommandContext!();

    @usage("gets everyones attention")
    void hail(in char[] text = "")
    {
        reply(channel.users
                     .map!(a => a.nickName)
                     .filter!(a => a != this.user.nickName)
                     .joiner(", ")
                     .text);
        if (!text.empty)
            reply("<%s> %s", user.nickName, text);
    }
}

