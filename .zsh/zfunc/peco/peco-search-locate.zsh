function peco-search-locate() {
  local pos=$CURSOR
  local cmd
  case $OSTYPE in
    darwin*)
      cmd=mdfind ;;
    # cygwin*)
    #   ;;
    # bsd*)
    #   ;;
    # linux*)
    #   ;;
    # solaris*)
    #   ;;
    *)
      cmd=locate ;;
  esac

  locate selected=$(eval $cmd "$LBUFFER" $* | peco)
  if [ -n "$selected" ]; then
    BUFFER="${BUFFER[1,$pos]}$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')${BUFFER[$pos,-1]}"
    CURSOR=$#BUFFER
  fi
  zle -R
  # zle -R -c
}

zle -N peco-search-locate