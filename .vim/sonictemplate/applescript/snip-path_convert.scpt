set theUnixPath to "/Users/Shared/"
(POSIX file theUnixPath) as string
--> "Macintosh HD:Users:Shared:"

set theMacOSXPath to "Macintosh HD:Users:Shared:"
POSIX path of theMacOSXPath
--> "/Users/Shared/"
