set the_path to "/"
set bin_path to "sh"
set script_path to "/path/to"

tell application "Terminal"
	do script "cd \"" & the_path & "\"; " & bin_path & " " & script_path & "; exit;"
end tell


