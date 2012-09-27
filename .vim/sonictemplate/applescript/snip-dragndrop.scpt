displayName(choose file with prompt "Select a file:") --if double-clicked
return -- not needed, but shows that the script stops here when "run"

on open of finderObjects -- "open" handler triggered by drag'n'drop launches
  repeat with i in (finderObjects) -- in case multiple objects dropped on applet
    displayName(i) -- show file/folder's info
    if folder of (info for i) is true then -- process folder's contents too
      tell application "Finder" to set temp to (entire contents of i)
      repeat with j in (temp)
        display dialog j as string -- example of doing something with each item
      end repeat
    end if
  end repeat
end open
