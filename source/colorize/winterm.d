/**
 * Authors: ponce
 * Date: July 28, 2014
 * License: Licensed under the MIT license. See LICENSE for more information
 * Version: 0.1.0
 */
module colorize.winterm;


version(Windows)
{
    import core.sys.windows.windows;

    // This is a state machine to enable terminal colors on Windows.
    // Parses and interpret ANSI/VT100 Terminal Control Escape Sequences.
    // Only supports fg and bg colors.
    struct WinTermEmulation
    {
    public:
        this(bool workardound = true) nothrow @nogc
        {
            // saves console attributes
            _console = GetStdHandle(STD_OUTPUT_HANDLE);
            _savedInitialColor = (0 != GetConsoleScreenBufferInfo(_console, &consoleInfo));

            _state = State.initial;
        }

        ~this() nothrow @nogc
        {
            // Restore initial text attributes on release
            if (_savedInitialColor)
            {
                SetConsoleTextAttribute(_console, consoleInfo.wAttributes);
                _savedInitialColor = false;
            }
        }

        // Eat one character and update color state accordingly. Return true if this character should be displayed.
        bool feed(dchar d) nothrow @nogc
        {
            final switch(_state) with (State)
            {
                case initial:
                    if (d == '\x1B')
                    {
                        _state = escaped;
                        return false;
                    }
                    break;

                case escaped:
                    if (d == '[')
                    {
                        _state = readingAttribute;
                        _currentAttr = 0;
                        return false;
                    }
                    break;


                case readingAttribute:
                    if (d >= '0' && d <= '9')
                    {
                        _parsedAttr = _parsedAttr * 10 + (_parsedAttr - '0');
                        return false;
                    }
                    else if (d == ';')
                    {
                        executeAttribute(_parsedAttr);
                        return false;
                    }
                    else if (d == 'm')
                    {
                        _state = State.initial;
                        return false;
                    }
                    break;
            }
            return true;
        }

    private:
        HANDLE _console;
        bool _savedInitialColor;
        CONSOLE_SCREEN_BUFFER_INFO consoleInfo;
        State _state;
        WORD _currentAttr;
        int _parsedAttr;

        enum State
        {
            initial,
            escaped,
            readingAttribute
        }           

        void executeAttribute(int attr) nothrow @nogc
        {
            switch (attr)
            {
          /+      case 0:
                    if (_savedInitialColor)
                        SetConsoleTextAttribute(_console, consoleInfo.wAttributes);
                    break;

                default:

                    if (30 <= attr && attr <= 37)
            }

            0	Reset all attributes
                1	Bright
                2	Dim
                4	Underscore	
                5	Blink
                7	Reverse
                8	Hidden

                Foreground Colours
                30	Black
                31	Red
                32	Green
                33	Yellow
                34	Blue
                35	Magenta
                36	Cyan
                37	White

                Background Colours
                40	Black
                41	Red
                42	Green
                43	Yellow
                44	Blue
                45	Magenta
                46	Cyan
                47	White
+/
                default:
            }
        }
    }
}



