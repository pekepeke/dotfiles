# (( $+functions[$_Z_CMD] )) || return
zmodload zsh/parameter

function zaw-src-z() {
  # (
  #   IFS=$'\n';

    candidates=(`_z -l 2>&1 | sed 's/^[0-9\.]* *//g'`)
    # : ${(A)candidates::=$(_z -l 2>&1 | sed 's/^[0-9\.]* *//g' )}
    # _z \
    #     | sed -e 's/^[0-9\\. ]*//' -e 's/ /\\ /g' -e "s#^$HOME#~#" \
    #     | tac | tr '\n' '\0')}
    actions=("zaw-callback-execute" "zaw-callback-shell-exec" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "shell execute" "replace edit buffer" "append to edit buffer")
  # )
}

zaw-callback-shell-exec() {
  case $OSTYPE in
    cygwin*)
      cygstart "$1";;
    darwin*)
      open "$1";;
    bsd*)
      gnome-open "$1";;
    linux*)
      gnome-open "$1";;
    solaris*)
      gnome-open "$1";;
    *)
      ;;
  esac

}

zaw-register-src -n z zaw-src-z
