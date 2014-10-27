function peco-search-locate() {
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
      BUFFER="$(echo $selected | sed 's/ /\\ /g' | tr '[:cntrl:]' ' ')"
  fi
}

zle -N peco-search-locate