# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# {{_name_}}() {
  local pos=$CURSOR
  local selected="$({{_cursor_}} | peco)"
  if [ -n "$selected" ]; then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
  fi
  zle -R
# }
# zle -N {{_name_}}

