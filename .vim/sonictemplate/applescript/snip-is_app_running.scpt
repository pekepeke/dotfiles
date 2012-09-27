on appIsRunning(appName)
	tell application "System Events" to (name of processes) contains appName
end appIsRunning

-- USAGE:  if appIsRunning("Finder") then...
