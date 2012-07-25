(*
Open Terminal
*)
(* written by satomacoto. 2010.3.6 *)

tell application "CotEditor"
	if exists front document then
		set thisFile to path of front document as Unicode text
		set tmp to AppleScript's text item delimiters
		set text item delimiters of Applescript to "/"
		set theList to every text item of thisFile
		set theContainer to text from text item 1 to text item -2 of theList as text
		set AppleScript's text item delimiters to tmp
		
		if theContainer is not "" then
			tell application "Terminal"
				if (count of windows) is 0 then
					do script with command "cd '" & theContainer & "'"
				else
					do script with command "cd '" & theContainer & "'" in window 1
				end if
				activate
			end tell
		end if
	end if
end tell
