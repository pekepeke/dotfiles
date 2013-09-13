set commandLine to "ls"

tell application "System Events"
	set appWasRunning to exists (processes where name is "iTerm")
	if appWasRunning then
		tell application "iTerm"
			make new terminal
			tell the current terminal
				activate current session
				launch session "Default Session"
				tell the last session
					write text commandLine
				end tell
			end tell
		end tell
		return
	end if

	set appWasRunning to exists (processes where name is "Terminal")
	tell application "Terminal"
		activate
		if appWasRunning then
			tell application "System Events" to tell process "Terminal" to keystroke "t" using command down
			delay 0.25
		end if
		do script commandLine in front window
	end tell
end tell
