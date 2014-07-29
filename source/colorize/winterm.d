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
    // Only supports colour sequences, will output char incorrectly on invalid input.
    struct WinTermEmulation
    {
    public:
        void initialize() nothrow @nogc
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

        enum CharAction
        {
            write,
            drop,
            flush
        }

        // Eat one character and update color state accordingly.
        // What to do with the fed character.
        CharAction feed(dchar d) nothrow @nogc
        {
            final switch(_state) with (State)
            {
                case initial:
                    if (d == '\x1B')
                    {
                        _state = escaped;
                        return CharAction.flush;
                    }
                    break;

                case escaped:
                    if (d == '[')
                    {
                        _state = readingAttribute;
                        _parsedAttr = 0;
                        return CharAction.drop;
                    }
                    break;


                case readingAttribute:
                    if (d >= '0' && d <= '9')
                    {
                        _parsedAttr = _parsedAttr * 10 + (d - '0');
                        return CharAction.drop;
                    }
                    else if (d == ';')
                    {
                        executeAttribute(_parsedAttr);
                        _parsedAttr = 0;
                        return CharAction.drop;
                    }
                    else if (d == 'm')
                    {
                        executeAttribute(_parsedAttr);
                        _state = State.initial;
                        return CharAction.drop;
                    }
                    break;
            }
            return CharAction.write;
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

        void setForegroundColor(WORD fgFlags) nothrow @nogc
        {
            _currentAttr = _currentAttr & ~(FOREGROUND_BLUE	| FOREGROUND_GREEN | FOREGROUND_RED	| FOREGROUND_INTENSITY);
            _currentAttr = _currentAttr | fgFlags;
            SetConsoleTextAttribute(_console, _currentAttr);
        }

        void setBackgroundColor(WORD bgFlags) nothrow @nogc
        {
            _currentAttr = _currentAttr & ~(BACKGROUND_BLUE	| BACKGROUND_GREEN | BACKGROUND_RED	| BACKGROUND_INTENSITY);
            _currentAttr = _currentAttr | bgFlags;
            SetConsoleTextAttribute(_console, _currentAttr);
        }

        void executeAttribute(int attr) nothrow @nogc
        {
            switch (attr)
            {
                case 0:
                    // reset all attributes
                    SetConsoleTextAttribute(_console, consoleInfo.wAttributes);
                    break;

                default:
                    if ( (30 <= attr && attr <= 37) || (90 <= attr && attr <= 97) )
                    {
                        WORD color = 0;
                        if (90 <= attr && attr <= 97)
                        {
                            color = FOREGROUND_INTENSITY;
                            attr -= 60;
                        }
                        attr -= 30;
                        color |= (attr & 1 ? FOREGROUND_RED : 0) | (attr & 2 ? FOREGROUND_GREEN : 0)  | (attr & 4 ? FOREGROUND_BLUE : 0);
                        setForegroundColor(color);
                    }

                    if ( (40 <= attr && attr <= 47) || (100 <= attr && attr <= 107) )
                    {
                        WORD color = 0;
                        if (100 <= attr && attr <= 107)
                        {
                            color = BACKGROUND_INTENSITY;
                            attr -= 60;
                        }
                        attr -= 40;
                        color |= (attr & 1 ? BACKGROUND_RED : 0) | (attr & 2 ? BACKGROUND_GREEN : 0)  | (attr & 4 ? BACKGROUND_BLUE : 0);
                        setBackgroundColor(color);
                    }
            }
        }
    }
}



