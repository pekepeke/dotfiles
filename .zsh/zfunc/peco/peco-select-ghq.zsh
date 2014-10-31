peco-select-ghq() {
  local selected=$(ghq list -p | perl -pe 's/(\Q$ENV{HOME}\E(.*$))/~$2/' | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="cd $(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
    zle accept-line
  fi
}
zle -N peco-select-ghq
