d-colorize
====================

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
import colorize;

void main()
{
  writeln("This is blue".colorize(fg.blue));
}
```

#### `colorize(string str, fg c, bg b=bg.init, mode m=mode.init)`

Wraps a string around color escape sequences.

### Params
* str = The string to wrap with colors and modes
* c   = The foreground color (see the fg enum type)
* b   = The background color (see the bg enum type)
* m   = The text mode        (see the mode enum type)

## Example

```d
colorize("This is red over green blinking", fg.blue, bg.green, mode.blink)
```

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
- `fg.light\_black` (90)
- `fg.light\_red` (91)
- `fg.light\_green` (92)
- `fg.light\_yellow` (93)
- `fg.light\_blue` (94)
- `fg.light\_magenta` (95)
- `fg.light\_cyan` (96)
- `fg.light\_white` (97)

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
