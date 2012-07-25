(*
Open Finder
*)
(* written by satomacoto. 2010.1.26 *)

tell application "CotEditor"
	if exists front document then
		set thisFile to path of front document as Unicode text
		set tmp to AppleScript's text item delimiters
		set text item delimiters of Applescript to "/"
		set theList to every text item of thisFile
		set text item delimiters of Applescript to ":"		
		set theContainer to text from text item 1 to text item -2 of theList as text
		set theContainer to "Macintosh HD" & theContainer & ":"
		set AppleScript's text item delimiters to tmp
		
		if theContainer is not "" then
			tell application "Finder"
				open folder theContainer
				activate
			end tell
		end if
	end if
end tell
