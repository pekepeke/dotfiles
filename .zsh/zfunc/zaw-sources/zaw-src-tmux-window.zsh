zaw-src-tmux-window() {
  if [ -z $TMUX ]; then
    candidates=()
    actions=()
    act_descriptions=()
    return
  fi
  local IFS=$'\n'
  candidates=(`tmux list-window`)
  actions=(
    zaw-tmux-select-window
    zaw-tmux-kill-window
    zaw-tmux-link-window
    zaw-tmux-unlink-window
    zaw-tmux-swap-window
    )
  act_descriptions=(
    "select window"
    "kill window"
    "link window"
    "unlink window"
    "swap window"
  )
}

zaw-tmux-winno() {
  echo $1|cut -d':' -f1
}
zaw-tmux-select-window() {
  BUFFER="tmux select-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}
zaw-tmux-kill-window() {
  BUFFER="tmux kill-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}
zaw-tmux-link-window() {
  BUFFER="tmux link-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}
zaw-tmux-unlink-window() {
  BUFFER="tmux unlink-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}
zaw-tmux-swap-window() {
  BUFFER="tmux swap-window -d -t $(zaw-tmux-winno $1)"
  zle accept-line
}

zaw-register-src -n tmux-window zaw-src-tmux-window
