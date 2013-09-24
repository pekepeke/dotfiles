zaw-src-tmux-pane() {
  if [ -z $TMUX ]; then
    candidates=()
    actions=()
    act_descriptions=()
    return
  fi
  local IFS=$'\n'
  candidates=(`tmux list-panes`)
  actions=(zaw-tmux-select-pane)
  act_descriptions=("select tmux pane")
}

zaw-tmux-select-pane() {
  BUFFER="tmux select-pane -t $(echo $1|cut -d':' -f1)"
  zle accept-line
}

zaw-register-src -n tmux-pane zaw-src-tmux-pane

