# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:
# (($+functions[_peco_homebrew])) || . ~/.zsh/zfunc/peco/lib/homebrew.zsh
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
  (($+functions[_os_gui_shell])) || . ~/.zsh/zfunc/peco/lib/util.zsh
  if [ -n "$selected" ]; then
    local url=$(brew $1 info $selected | awk '/^http/ {print $0}' | head -1)
    if [ -n "$url" ];then
      _os_gui_shell "$url"
    fi
  fi
}
