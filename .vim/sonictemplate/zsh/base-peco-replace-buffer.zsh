# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# {{_name_}}() {
  local selected=$({{_cursor_}} | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
  fi
  zle redisplay
  # zle -R -c
# }
# zle -N {{_name_}}

