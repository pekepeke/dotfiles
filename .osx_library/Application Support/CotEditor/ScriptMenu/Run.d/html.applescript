(* written by satomacoto *)
on run {thePath}
	if (thePath is not "") then
		tell application "Safari"
			activate
			open location "file://" & thePath
		end tell
	end if
end run