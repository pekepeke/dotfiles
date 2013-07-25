on run argv
    tell application "Google Chrome"
        tell active tab of first window
            execute javascript "window.history.go(" & (item 1 of argv) & ")"
        end tell
    end tell
end run
