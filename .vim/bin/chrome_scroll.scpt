-- chrome.scpt: control Google Chrome
-- Author     : ramusara<ramusara@gmail.com>
on run argv
  tell application "Google Chrome"
    tell active tab of window 1
      if ("next" = item 1 of argv) then
        execute javascript "var x = document.documentElement.scrollLeft || document.body.scrollLeft; var y = document.documentElement.scrollTop || document.body.scrollTop; y += 100; window.scroll(x, y);"
      else if ("previous" = item 1 of argv) then
        execute javascript "var x = document.documentElement.scrollLeft || document.body.scrollLeft; var y = document.documentElement.scrollTop || document.body.scrollTop; y -= 100; window.scroll(x, y);"
      end if
    end tell
  end tell
end run