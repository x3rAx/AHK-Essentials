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
        string path - Returns the canonicalized absolute pathname on success. The resulting path will have no symbolic 
                        link, '/./' or '/../' components.
        bool false  - On failure, e.g. if the file does not exist.
*/
realpath(path) {
    ; This hack uses the working dir to determine the realpath

    ; But first check if the file / directory exists anyways
    if (!FileExist(path)) {
        return false
    }

    ; Now save the working dir
    workingDir := A_WorkingDir

    ; ... set the path to be the working dir and read the A_WorkingDir variable to geht the path without eventual dots
    SetWorkingDir %path%
    path := A_WorkingDir

    ; and finally restore the original working dir
    SetWorkingDir %workingDir%

    return %path%
}
