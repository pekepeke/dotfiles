#
# zaw-src-finder
#
# zaw source for Finder.app
#

which osascript > /dev/null 2>&1 || return

zaw-src-finder() {

  candidates=( \
  `cat <<EOM | osascript | sort -u
tell application "Finder"
  set cnt to count of windows
  set paths to ""
  repeat with i from 1 to cnt
    try
      set pt to POSIX path of (target of window i as Unicode Text)
      if paths is "" then
        set paths to pt
      else
        set paths to paths & "\n" & pt
      end if
    end try
  end repeat
  get paths
end tell
EOM
`\
  )
  actions=(zaw-src-finder-cd)
  act_descriptions=("finder for zaw")
}

zaw-src-finder-cd () {
  BUFFER="cd \"$1\""
  zle accept-line
}

zaw-register-src -n finder zaw-src-finder

