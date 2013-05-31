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
            realpath = %A_LoopFileLongPath%
        }
    } else {        
        ; No directory, no file, what is it? -> INVALID!!!
        realpath := false
    }

    return %realpath%
}
