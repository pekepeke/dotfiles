peco-select-ls-la() {
  local pos=$CURSOR
  local selected="$('ls' -la | peco --query="$LBUFFER" | awk '{print $NF}')"
  if [ -n "$selected" ] ;then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}
zle -N peco-select-ls-la
