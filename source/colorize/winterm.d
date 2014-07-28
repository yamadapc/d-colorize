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
        this(bool workardound = true) nothrow
        {
            _console = GetStdHandle(STD_OUTPUT_HANDLE);

            // saves console attributes
            _savedInitialColor = (0 != GetConsoleScreenBufferInfo(_console, &consoleInfo));

        }

        ~this()
        {
            if (_savedInitialColor)
            {
                SetConsoleTextAttribute(_console, consoleInfo.wAttributes);
                _savedInitialColor = false;
            }
        }

        void feed(dchar d) nothrow
        {

        }

    private:
        HANDLE _console;
        bool _savedInitialColor;
        CONSOLE_SCREEN_BUFFER_INFO consoleInfo;
    }
}



