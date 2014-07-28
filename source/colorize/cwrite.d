/**
 * Authors: ponce
 * Date: July 28, 2014
 * License: Licensed under the MIT license. See LICENSE for more information
 * Version: 0.1.0
 */
module colorize.cwrite;

import std.stdio : File, stdout;

import colorize.winterm;

/// Coloured write.
void cwrite(T...)(T args) if (!is(T[0] : File))
{
    stdout.cwrite(args);
}

/// Coloured writef.
void cwritef(T...)(T args)
{
    stdout.cwritef(args);
}

/// Coloured writefln.
void cwritefln(T...)(T args)
{
    stdout.cwritefln(args);
}

/// Coloured writeln.
void cwriteln(T...)(T args)
{
    // Most general instance
    stdout.cwrite(args, '\n');
}

/// Coloured writef to a File.
void cwritef(File f, Char, A...)(in Char[] fmt, A args)
{
    auto s = format(fmt, args);
    f.write(s); // TODO support colours
}

/// Coloured writef to a File.
void cwrite(S...)(File f, S args)
{
    import std.conv : to;

    string s = "";
    foreach(arg; args)
        s ~= to!string(arg);

    f.write(s);
}

