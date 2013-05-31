/*!
    Library: Essentials, v1.0
        Essential functions for AutoHotkey.
    Author: ^x3ro (Björn Richter) <mail@x3ro.net>
    License:
*/

/*!
    Function: realpath(path)
        Returns canonicalized absolute pathname.

    Parameters:
        path    - The path being checked.

    Returns:
        string path - Returns the canonicalized absolute pathname on success. The resulting path will have no '/./' or 
                        '/../' components.
        bool false  - On failure, e.g. if the file does not exist.
*/
realpath(path) {
    ; Convert '/'' to '\'
    StringReplace path, path, "/", "\", All

    fileAttributes := FileExist(path)

    if (InStr(fileAttributes, "D")) {
        ; Its a directory. Use WorkingDir hack
        ; This hack uses the working dir to determine the realpath

        ; First save the working dir
        workingDir := A_WorkingDir

        ; then set the working dir to be the given path
        SetWorkingDir %path%

        ; and after that, set the realpath to be the working dir.
        realpath := A_WorkingDir

        ; Finally restore the original working dir.
        SetWorkingDir %workingDir%
    } else if (fileAttributes != "") {
        ; Seems to be a file. Get realpath of it
        Loop %path%, 1
        {
            realpath := A_LoopFileLongPath
        }
    } else {        
        ; No directory, no file, what is it? -> INVALID!!!
        realpath := false
    }

    return %realpath%
}

/*!
    Function: configRead(configFile, section, key [, default])
        Reads the value of a key in a section from a config (.ini) file and returns it. 

        The configRead() function supports inheritance. That means, assuming you have a section named 'bar' that should
        inherit from 'foo', you do it as follows:

        ; config.ini
        [foo]
        valueInFoo = 123
        overrideMe = baz

        [bar : foo]
        valueInBar = 456
        overrideMe = 789

        Now, bar knows every key/value of foo and can override it by simply redefining it.

    Parameters:
        configFile  - The path to the config file (relative or absolute)
        section     - The section in which to search for the key
        key         - The actual key
        default     - (optional) A default value, in case the key is not set (or empty)

    Returns:
        string value    - If everything went correct, the value of the specified key is returned.
        mixed default   - On failure, return the default value (if not set, string ERROR is returned)
                            e.g. if the file does not exist or if the key was not found.
*/
configRead(configFile, section, key, default="ERROR") {
    configFile := realpath(configFile)

    Loop read, %configFile%
    {
        if (RegExMatch(A_LoopReadLine, "^\[((.+?)( \: (.+?)|))\]$", foundSection)) {
            foundSectionFullName := foundSection1
            foundSection := foundSection2
            inheritsFrom := foundSection4

            if (foundSection == section) {
                IniRead value, %configFile%, %foundSectionFullName%, %key%, %default%

                if (value == default and inheritsFrom != "") {
                    value := configRead(configFile, inheritsFrom, key, default)
                }
                
                return value
            }
        }
    }

    return default
}
