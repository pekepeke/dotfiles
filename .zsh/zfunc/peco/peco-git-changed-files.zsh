peco-git-changed-files() {
  local selected="$(git status -s | peco --query="$LBUFFER" | awk '{ print $2}')"
  if [ -n "$selected" ]; then
    LBUFFER="$(echo $selected | tr "[:cntrl:]" " ")"
    CURSOR=0
  fi
}
zle -N peco-git-changed-files
