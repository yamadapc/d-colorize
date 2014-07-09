import std.string : format;

static enum fg : int
{
  init = 39,

  black   = 30,
  red     = 31,
  green   = 32,
  yellow  = 33,
  blue    = 34,
  magenta = 35,
  cyan    = 36,
  white   = 37,

  light_black   = 90,
  light_red     = 91,
  light_green   = 92,
  light_yellow  = 93,
  light_blue    = 94,
  light_magenta = 95,
  light_cyan    = 96,
  light_white   = 97
}

static enum bg : int
{
  init = 49,

  black   = 40,
  red     = 41,
  green   = 42,
  yellow  = 43,
  blue    = 44,
  magenta = 45,
  cyan    = 46,
  white   = 47,

  light_black   = 100,
  light_red     = 101,
  light_green   = 102,
  light_yellow  = 103,
  light_blue    = 104,
  light_magenta = 105,
  light_cyan    = 106,
  light_white   = 107
}

static enum mode : int
{
  init      = 0,
  bold      = 1,
  underline = 4,
  blink     = 5,
  swap      = 7,
  hide      = 8
}


string colorize(string str, fg c, bg b=bg.init, mode m=mode.init)
  pure
{
  return format("\033[%d;%d;%dm%s\033[0m", m, c, b, str);
}

unittest
{
  import std.stdio;
  string ret;

  ret = "This is yellow".colorize(fg.yellow);
  writeln(ret);
  assert(ret == "\033[0;33;49mThis is yellow\033[0m");

  ret = "This is light green".colorize(fg.light_green);
  writeln(ret);
  assert(ret == "\033[0;92;49mThis is light green\033[0m");

  ret = "This is light blue with red background".colorize(fg.light_blue, bg.red);
  writeln(ret);
  assert(ret == "\033[0;94;41mThis is light blue with red background\033[0m");

  ret = "This is red on blue blinking".colorize(fg.red, bg.blue, mode.blink);
  writeln(ret);
  assert(ret == "\033[5;31;44mThis is red on blue blinking\033[0m");
}
