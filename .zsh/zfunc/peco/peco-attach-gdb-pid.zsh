peco-attach-gdb-pid() {
  local pid=$(ps aux | peco --query="$LBUFFER" | awk '{print $2}' | head -n1)

  if [ -n "$pid" ]; then
    gdb -p $pid
  fi
  zle -R
  # zle -R -c
}
zle -N peco-attach-gdb-pid
