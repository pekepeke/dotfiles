set pathToMe to (choose file with prompt "Display path of:")
display dialog GetParentPath(pathToMe)

on GetParentPath(theFile)
	tell application "Finder" to return container of theFile as text
end GetParentPath
