set the_path to "/"
set bin_path to "sh"
set script_path to "/path/to"

tell application "Finder"
	set a_count to count of Finder windows
	if a_count < 1 then
		error "Window not found" number -1700
	end if
	set the_win to window 1
	set the_path to (POSIX path of (target of the_win as alias))
end tell

tell application "Terminal"
	do script "cd \"" & the_path & "\"; " & bin_path & " " & script_path & "; exit;"
end tell


