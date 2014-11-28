# {{_name_}}() {
  local selected="$(ls | peco --query="$LBUFFER")"
  if [ -n "$selected" ]; then
    BUFFER="${selected}"
    # zle accept-line
  fi
# }
# zle -N {{_name_}}
