zaw-src-tmux-layout() {
  if [ -z $TMUX ]; then
    candidates=()
    actions=()
    act_descriptions=()
    return
  fi
  local IFS=$'\n'
  candidates=(
    tiled
    even-vertical
    main-vertical
    main-vertical-with-change-pane
    even-horizontal
    main-horizontal
    main-horizontal-with-change-pane
  )
  actions=(zaw-tmux-layout-select)
  act_descriptions=(
    "tiled"
    "even vertical"
    "main vertical"
    "main vertical and change active pane"
    "even horizontal"
    "main horizontal"
    "main horizontal and change active pane"
  )
}

zaw-tmux-layout-select() {
  local winno=$(tmux display -p '#I')

  case "$1" in
    main-vertical-with-change-pane)
      BUFFER="tmux select-layout -t $winno main-vertical ; tmux swap-pane -s : -t 0 ; tmux select-pane -t 0 ; tmux resize-pane -R 9"
      ;;
    main-horizontal-with-change-pane)
      BUFFER="tmux select-layout -t $winno main-horizontal; tmux swap-pane -s : -t 0 ; tmux select-pane -t 0 ; tmux resize-pane -D 18"
      ;;
    *)
      BUFFER="tmux select-layout -t $winno $1"
    ;;
  esac

  zle accept-line
}

zaw-register-src -n tmux-layout zaw-src-tmux-layout
