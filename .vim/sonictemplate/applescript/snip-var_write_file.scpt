set newFile to new file with prompt "Output file:" default name "My New File"
open for access newFile with write permission
-- if you want to overwrite an existing file use set eof of newFile to 0 first.
write "something useful" to newFile
close access newFile
