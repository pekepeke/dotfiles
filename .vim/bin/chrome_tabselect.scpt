-- chrome.scpt: control Google Chrome
on run argv
  tell application "Google Chrome"
    tell first window
      set i to (active tab index)
      if ("right" = item 1 of argv) then
        set (active tab index ) to (i + 1)
      else if ("left" = item 1 of argv) then
        set (active tab index ) to (i - 1)
      end if
    end tell
  end tell
end run
