peco-select-ls-la() {
  local selected="$('ls' -la | peco --query="$LBUFFER" | awk '{print $NF}')"
  if [ -n "$selected" ] ;then
    BUFFER="$(echo $selected | sed -e 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
    CURSOR=0
  fi
}
zle -N peco-select-ls-la
