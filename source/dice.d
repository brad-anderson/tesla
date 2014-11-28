import diggler.bot;
import std.random;
import std.string : text;
import std.typetuple : TypeTuple;

@category("dice")
class DiceCommands : CommandSet!DiceCommands
{
    mixin CommandContext!();

    @usage("flip a coin")
    void flip()
    {
        reply(uniform!"[]"(0, 1) == 0 ? "heads" : "tails");
    }

    @usage("flip a coin")
    void coin()
    {
        flip();
    }

    /*alias Dice = TypeTuple!(3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 29, 20); // no staticIota yet
    foreach(i; Dice) 
    {
        @usage("roll a " ~ i.text ~ " sided die")
        void mixin("d" ~ i.text)()
        {
            reply(uniform!"[]"(1, i).text);
        }
    }*/
}

