peco-select-ghq() {
  local dir=$(ghq list -p | peco --query="$LBUFFER")
  if [ -n "${dir}" ]; then
    BUFFER="cd \"${dir}\""
    zle accept-line
  fi
}
zle -N peco-select-ghq
