peco-open-bundle-gem() {
  if bundle help >/dev/null 2>&1; then
    local selected=$(bundle show --paths | peco --query="$LBUFFER")
    if [ -n "${selected}" ]; then
      LBUFFER="cd $selected"
      CURSOR=$#LBUFFER
    fi
    zle -R -c
  fi
}
zle -N peco-open-bundle-gem
