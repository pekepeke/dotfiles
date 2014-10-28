peco-select-logfiles() {
  local selected=$(find -L ~/.mylog/logs -type f | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="tail -f ${selected}"
    CURSOR=0
    # zle accept-line
  fi
}
zle -N peco-select-logfiles
