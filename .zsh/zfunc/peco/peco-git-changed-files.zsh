peco-git-changed-files() {
  local selected="$(git status -s | peco --query="$LBUFFER" | sed -e 's/^ *[^ ]\+ *//')"
  if [ -n "$selected" ]; then
    BUFFER="$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
    CURSOR=0
  fi
}
zle -N peco-git-changed-files
