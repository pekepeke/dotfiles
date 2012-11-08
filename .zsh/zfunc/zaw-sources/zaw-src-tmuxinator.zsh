#
# zaw-src-tmuxinator
#
# zaw source for tmuxinator
#

which tmuxinator > /dev/null 2>&1 || return

zaw-src-tmuxinator() {
  candidates=(
  `find ~/.tmuxinator -name *.yml | cut -d/ -f5 | sed s:.yml::g`
  )
  actions=(zaw-src-tmuxinator-start)
  act_descriptions=("start tmuxinator project")
}

zaw-src-tmuxinator-start() {
  BUFFER="mux \"$1\""
  zle accept-line
}

zaw-register-src -n tmuxinator zaw-src-tmuxinator

