import tesla;
import std.getopt;

void main(string[] args)
{
    string config_file = "tesla.conf";
    getopt(args, "config|c", &config_file);

    auto bot = new Tesla(config_file);
    bot.run();
}

