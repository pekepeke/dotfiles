# vim:fdm=marker sw=2 ts=2 ft=zsh expandtab:

_os_gui_shell() {
  eval $(get_os_gui_shell "$@")
}

_get_os_gui_shell() {
  case $OSTYPE in
    cygwin*)
      echo cygstart "$@";;
    darwin*)
      echo open "$@" ;;
    bsd*)
      echo xdg-open "$@" ;;
    linux*)
      echo xdg-open "$@" ;;
    solaris*)
      echo xdg-open "$@" ;;
    *)
      echo xdg-open "$@" ;;
  esac
}
