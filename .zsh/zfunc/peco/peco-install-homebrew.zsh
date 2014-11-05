_peco_homebrew() {
  local selected=$(brew $1 search | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="brew $1 $2 $selected"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}
peco-install-homebrew() {
  _peco_homebrew "" install
}

zle -N peco-install-homebrew
peco-info-homebrew() {
  _peco_homebrew "" info
}
zle -N peco-info-homebrew

peco-install-homebrew-cask() {
  _peco_homebrew cask install
}
zle -N peco-install-homebrew-cask

peco-info-homebrew-cask() {
  _peco_homebrew cask info
}
zle -N peco-info-homebrew-cask
