(* written by satomacoto. 2012.1.23 *)
tell application "CotEditor"
	if exists front document then
		set p to the path of front document as Unicode text
		set e to (do shell script "echo \"" & p & "\"|awk -F . '{print $NF}'")
		set h to (do shell script "echo $HOME")
		set d to h & "/Library/Application\\ Support/CotEditor/ScriptMenu/Hello.d/"
		set s to (d & "hello." & e as POSIX file)
		
		try
			set {loc, len} to range of selection of front document
			set newStr to do shell script "cat " & (POSIX path of s)
			set numOfMove to count of character of newStr
			set contents of selection of front document to newStr
			set range of selection of front document to {loc + numOfMove, 0}
		end try
	end if
end tell
