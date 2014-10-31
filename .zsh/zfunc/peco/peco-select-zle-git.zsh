function peco-select-zle-git() {
  local widgets=$(zle -l | grep git | grep -v peco-select-zle-git | peco | awk '{print $1}')
  if [ -n "$widgets" ]; then
    zle $widgets
  fi
}
zle -N peco-select-zle-git

