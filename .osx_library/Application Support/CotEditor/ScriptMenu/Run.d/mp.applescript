(* written by satomacoto *)
on run {p}
	if p is not "" then
		set f to (do shell script "/usr/bin/basename \"" & p & "\"")
		set d to (do shell script "/usr/bin/dirname \"" & p & "\"")
		
		-- set terminal command
		set c to "cd " & d & "; mptopdf " & f
		
		tell application "Terminal"
			if (count of windows) is 0 then
				do script with command c
			else
				do script with command c in window 1
			end if
			activate
		end tell
		
	end if
	activate
end run
