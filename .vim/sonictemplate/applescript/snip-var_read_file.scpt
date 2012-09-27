set theFile to (choose file with prompt "Select a file to read:" of type {"TEXT"})
open for access theFile
set fileContents to (read theFile)
close access theFile

