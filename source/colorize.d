/**
 * Authors: Pedro Tacla Yamada
 * Date: June 9, 2014
 * License: Licensed under the MIT license. See LICENSE for more information
 * Version: 0.0.2
 */

import std.string : format;

private template color(int offset)
{
  static enum type : int
  {
    init = 39 + offset,

    black   = 30 + offset,
    red     = 31 + offset,
    green   = 32 + offset,
    yellow  = 33 + offset,
    blue    = 34 + offset,
    magenta = 35 + offset,
    cyan    = 36 + offset,
    white   = 37 + offset,

    light_black   = 90 + offset,
    light_red     = 91 + offset,
    light_green   = 92 + offset,
    light_yellow  = 93 + offset,
    light_blue    = 94 + offset,
    light_magenta = 95 + offset,
    light_cyan    = 96 + offset,
    light_white   = 97 + offset
  }
}

alias color!0 .type fg;
alias color!10 .type bg;

// Text modes
static enum mode : int
{
  init      = 0,
  bold      = 1,
  underline = 4,
  blink     = 5,
  swap      = 7,
  hide      = 8
}

/**
 * Wraps a string around color escape sequences.
 *
 * Params:
 *   str = The string to wrap with colors and modes
 *   c   = The foreground color (see the fg enum type)
 *   b   = The background color (see the bg enum type)
 *   m   = The text mode        (see the mode enum type)
 * Example:
 * ---
 * writeln("This is blue".colorize(fg.blue));
 * writeln(
 *   colorize("This is red over green blinking", fg.blue, bg.green, mode.blink)
 * );
 * ---
 */

string colorize(
  const string str,
  const fg c=fg.init,
  const bg b=bg.init,
  const mode m=mode.init
) pure
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

private template colorHelper(T)
{
  string fn(const string str, const T t=T.init)
  {
    return format("\033[%dm%s\033[0m", t, str);
  }
}

alias colorHelper!bg.fn background;
alias colorHelper!fg.fn foreground;
alias colorHelper!mode.fn style;

unittest
{
  import std.stdio;
  string ret;

  ret = "This is red on blue blinking"
    .foreground(fg.red)
    .background(bg.blue)
    .style(mode.blink);

  writeln(ret);
  assert(ret == "\033[5m\033[44m\033[31mThis is red on blue blinking\033[0m\033[0m\033[0m");
}
