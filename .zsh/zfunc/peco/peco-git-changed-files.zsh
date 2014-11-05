peco-git-changed-files() {
  local pos=$CURSOR
  local selected="$(git status -s | peco --query="$LBUFFER" | sed -e 's/^ *[^ ]\+ *//')"
  if [ -n "$selected" ]; then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}
zle -N peco-git-changed-files
