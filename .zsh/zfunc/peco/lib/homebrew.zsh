_peco_homebrew() {
  local selected=$(brew $1 search | peco --query="$LBUFFER")
  if [ -n "$selected" ]; then
    BUFFER="brew $1 $2 $selected"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}
_peco_homebrew_open() {
  local selected="$(brew $1 search | peco --query="$LBUFFER")"
  if [ -n "$selected" ]; then
    local url=$(brew $1 info $selected | awk '/^http/ {print $0}' | head -1)
    if [ -n "$url" ];then
      case $OSTYPE in
        cygwin*)
          cygstart "$url";;
        darwin*)
          open "$url" ;;
        bsd*)
          xdg-open "$url" ;;
        linux*)
          xdg-open "$url" ;;
        solaris*)
          xdg-open "$url" ;;
        *)
          xdg-open "$url" ;;
          ;;
      esac
    fi
  fi
}