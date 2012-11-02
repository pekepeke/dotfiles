zaw-src-tmux-window() {
  if [ -z $TMUX ]; then
    candidates=("only work on running tmux")
    actions=(zaw-src-tmux-empty)
    act_descriptions=("only work on running tmux")
    return
  fi
  local IFS=$'\n'
  candidates=(`tmux list-window`)
  actions=(
    zaw-src-tmux-select 
    zaw-src-tmux-kill
    )
  act_descriptions=(
    "select window"
    "kill window"
  )
}

zaw-src-tmux-empty() {
  echo -n
}

zaw-tmux-winno() {
  echo $1|cut -d':' -f1
}
zaw-src-tmux-select() {
  BUFFER="tmux select-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}
zaw-src-tmux-kill() {
  BUFFER="tmux kill-window -t $(zaw-tmux-winno $1)"
  zle accept-line
}

zaw-register-src -n tmux-window zaw-src-tmux-window
