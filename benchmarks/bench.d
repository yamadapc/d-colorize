import std.stdio;
import std.string : format;
import std.datetime : comparingBenchmark;

void main()
{
  auto bs = comparingBenchmark!(testColorizeString, testColorizeEnum,
      10_000);

  writeln("string : ", bs.baseTime);
  writeln("enum   : ", bs.targetTime);
  writeln("point  : ", bs.point);
}

static enum color : int
{
  black = 30,
  red = 31,
  green = 32,
  brown = 33,
  blue = 34,
  magenta = 35,
  cyan = 36,
  gray = 37,
  bg_black = 40,
  bg_red = 41,
  bg_green = 42,
  bg_brown = 43,
  bg_blue = 44,
  bg_magenta = 45,
  bg_cyan = 46,
  bg_gray = 47,
  bold = 0
}

void testColorizeString()
{
  auto str = colorize("this is blue", "blue");
}

void testColorizeEnum()
{
  auto str = colorize("this is blue", color.blue);
}

string colorize(const string str, const string color) pure
{
  int color_num = 0;
  switch (color) {
    case "black":   color_num = 30; break;
    case "red":     color_num = 31; break;
    case "green":   color_num = 32; break;
    case "brown":   color_num = 33; break;
    case "blue":    color_num = 34; break;
    case "magenta": color_num = 35; break;
    case "cyan":    color_num = 36; break;
    case "gray":    color_num = 37; break;

    case "bg_black":    color_num = 40; break;
    case "bg_red":      color_num = 41; break;
    case "bg_green":    color_num = 42; break;
    case "bg_brown":    color_num = 43; break;
    case "bg_blue":     color_num = 44; break;
    case "bg_magenta":  color_num = 45; break;
    case "bg_cyan":     color_num = 46; break;
    case "bg_gray":     color_num = 47; break;

    case "bold":        color_num = 0; break;

    default:
        throw new Exception("unknown color \"" ~ color ~ "\"");
  }

  return format("\033[%dm%s\033[0m", color_num, str);
}

string colorize(const string str, color c) pure
{
  return format("\033[%dm%s\033[0m", c, str);
}
