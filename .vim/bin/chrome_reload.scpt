tell application "Google Chrome"
    tell active tab of first window
        execute javascript "window.location.reload()"
    end tell
end tell
