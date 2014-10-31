peco-select-logfiles() {
  local pos=$CURSOR
  local selected=$(find -L ~/.mylog/logs -type f | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    if [ -n "$BUFFER" ]; then
    	BUFFER="${BUFFER[1,$pos]}${selected}${BUFFER[$pos,-1]}"
    else
      BUFFER="tail -f ${selected}"
    fi
    CURSOR=$#BUFFER
    zle -R -c
    # zle accept-line
  fi
}
zle -N peco-select-logfiles
