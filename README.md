d-colorize
====================
[![Build Status](https://travis-ci.org/yamadapc/d-colorize.svg?branch=master)](https://travis-ci.org/yamadapc/d-colorize)
- - -

A partial port of Ruby's [colorize](https://github.com/fazibear/colorize)
library to D.

To put it simply, this is a simple helper for printing colored output to a
terminal.

## Installing
This package is registered in the dub registry as
[colorize](http://code.dlang.org/packages/colorize).

## Usage
```d
import std.stdio;
import colorize : colorize, fg;

void main()
{
  writeln("This is blue".colorize(fg.blue));
}
```

- - -

## Setting background, foreground and text modes:
```d
string colorize(
  const string str,
  const fg c,
  const bg b=bg.init,
  const mode m=mode.init
) pure;
```

Wraps a string around color escape sequences.

### Params
* str = The string to wrap with colors and modes
* c   = The foreground color (see the fg enum type)
* b   = The background color (see the bg enum type)
* m   = The text mode        (see the mode enum type)

### Example

```d
colorize("This is red over green blinking", fg.blue, bg.green, mode.blink)
```

- - -

## Setting background colors:
```d
string colorize(const string str, const bg b) pure; // alias to background
```

Wraps a string around a background color escape sequence.

### Params
* str = The string to wrap with background color `b`
* b   = The background color (see the bg enum type)

## Example
```d
colorize("This has a blue background", bg.blue);
background("This has a red background", bg.red);
```

- - -

## Setting text modes:
```d
string colorize(const string str, const mode m) pure; // alias to `style`
```

Wraps a string around a text mode.

### Params
* str = The string to wrap with style `m`
* m   = The text mode (see the mode enum type)

### Example
```d
colorize("This text is bold", mode.bold);
style("This text is blinking", mode.blink);
```

## Coloring with strings:
```d
string colorize(const string str, const string name) pure;
```

Wraps a string around the foreground color, background color or text style
represented by the color `name`. Foreground colors are represented by their enum
key (`"blue"` will be `34`, `"red"` `31`, and so on) and backgrounds/modes are
prefixed with either `"bg_"` or `"mode_"` (thus, `"bg_black"` will be `40`,
`"mode_bold"` `1` and so on).

### Example
```d
colorize("This text is blue", "blue");
"This is red over blue, blinking"
  .colorize("red")
  .colorize("bg_blue")
  .colorize("mode_blue");
```

### Params

## Available colors and modes
### `fg` enum type (Foreground colors)
Foreground text colors are available through the `fg` enum. Currently available
colors are:
- `fg.init` (39)
- `fg.black` (30)
- `fg.red` (31)
- `fg.green` (32)
- `fg.yellow` (33)
- `fg.blue` (34)
- `fg.magenta` (35)
- `fg.cyan` (36)
- `fg.white` (37)
- `fg.light_black` (90)
- `fg.light_red` (91)
- `fg.light_green` (92)
- `fg.light_yellow` (93)
- `fg.light_blue` (94)
- `fg.light_magenta` (95)
- `fg.light_cyan` (96)
- `fg.light_white` (97)

### `bg` enum type (Background colors)
Background colors are available with the same names through the `bg` enum. This
is because background colors come with an offset of 10 to their foreground
counterparts and we wanted to avoid calculating the offset at runtime.

### `mode` enum type (Text modes)
Text modes are available through the `mode` enum. Currently available text modes
are:
- `mode.init` (0)
- `mode.bold` (1)
- `mode.underline` (4)
- `mode.blink` (5)
- `mode.swap` (7)
- `mode.hide` (8)

## License
Copyright (c) 2014 Pedro Tacla Yamada. Licensed under the MIT license.
Please refer to the [LICENSE](LICENSE) file for more info.
