peco-git-ls-files() {
  local cmd="files"
  if git rev-parse >/dev/null 2>&1; then
    cmd="git ls-files"
  elif ! which $cmd > /dev/null 2>&1; then
    cmd="find . -type f"
  fi
  local selected="$(eval $cmd | peco --query="$LBUFFER")"
  if [ -n "$selected" ]; then
    BUFFER="$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
    CURSOR=0
  fi
}
zle -N peco-git-ls-files
