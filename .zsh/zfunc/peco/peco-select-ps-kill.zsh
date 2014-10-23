peco-select-ps-kill() {
  local pid=$(ps aux | peco --query "$LBUFFER" | awk '{ print $2 }')
  if [ x"${pid}" != x ];then
    kill $pid
  fi
}
peco-select-ps-kill-hup() {
  local pid=$(ps aux | peco --query "$LBUFFER" | awk '{ print $2 }')
  if [ x"${pid}" != x ];then
    kill -HUP $pid
  fi
}
zle -N peco-select-ps-kill
zle -N peco-select-ps-kill-hup
