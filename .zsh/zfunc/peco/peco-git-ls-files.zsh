peco-git-ls-files() {
  local pos=$CURSOR
  local cmd="files"
  if git rev-parse >/dev/null 2>&1; then
    cmd="git ls-files"
  elif ! which $cmd > /dev/null 2>&1; then
    cmd="find . -type f"
  fi
  local selected="$(eval $cmd | peco --query="$LBUFFER")"
  if [ -n "$selected" ]; then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
    zle -R -c
  fi
}
zle -N peco-git-ls-files
