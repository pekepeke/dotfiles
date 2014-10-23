peco-git-changed-files() {
  local selected=$(git status -s | peco --query="$LBUFFER" | awk '{ print $2}')
  if [ -n "$selected" ]; then
    LBUFFER="$selected"
    CURSOR=$#LBUFFER
  fi
}
zle -N peco-git-changed-files
