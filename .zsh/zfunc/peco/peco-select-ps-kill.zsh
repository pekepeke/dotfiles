peco-select-pid() {
  local pos=$CURSOR
  local pid=$(ps aux | peco --query "$LBUFFER" | awk '{ print $2 }')
  if [ x"${pid}" != x ];then
    BUFFER="${BUFFER[1,$pos]}${pid}${BUFFER[$pos,-1]}"
  fi
  zle -R -c
}

peco-select-ps-kill() {
  local pid=$(ps aux | peco --query "$LBUFFER" | awk '{ print $2 }')
  if [ x"${pid}" != x ];then
    kill $pid
  fi
  zle -R -c
}
peco-select-ps-kill-hup() {
  local pid=$(ps aux | peco --query "$LBUFFER" | awk '{ print $2 }')
  if [ x"${pid}" != x ];then
    kill -HUP $pid
  fi
  zle -R -c
}
zle -N peco-select-pid
zle -N peco-select-ps-kill
zle -N peco-select-ps-kill-hup
