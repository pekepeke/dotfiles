peco-select-ghq() {
  local dir=$(ghq list -p | peco --query="$LBUFFER")
  if [ x"${dir}" = x ]; then
    cd "${dir}"
  fi
}
zle -N peco-select-ghq
