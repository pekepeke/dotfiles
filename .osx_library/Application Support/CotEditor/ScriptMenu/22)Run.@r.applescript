(* written by satomacoto. 2011.1.30 *)
tell application "CotEditor"
	
	if exists front document then
		
		set p to the path of front document as Unicode text
		set e to (do shell script "echo \"" & p & "\"|awk -F . '{print $NF}'")		
		set h to (do shell script "echo $HOME")
		set d to h & "/Library/Application Support/CotEditor/ScriptMenu/Run.d/"
		set s to (d & e & ".applescript" as POSIX file)
		
		try
			run script file s with parameters {p}
		end try
		
	end if
	activate
	
end tell
