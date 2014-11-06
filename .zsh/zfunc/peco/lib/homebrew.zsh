_peco_homebrew() {
  local selected=$(brew $1 search | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="brew $1 $2 $selected"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}
