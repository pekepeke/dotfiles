function peco-select-zle() {
  local widgets=$(zle -l | peco --query "$LBUFFER" | awk '{print $1}')
  if [ x"$widgets" != x ]; then
    zle $widgets
  fi
}

zle -N peco-select-zle
