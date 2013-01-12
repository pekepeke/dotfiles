# (( $+functions[$_Z_CMD] )) || return
zmodload zsh/parameter

function zaw-src-z() {
  local IFS=$'\n';

  # candidates=(`_z -l 2>&1 | sed 's/^[0-9\.]* *//g' | sed 's/ /\ /g'`)
  candidates=(`_z -l 2>&1 | perl -ne 's/[\r\n]+//g;s/^[0-9\.]* *//g;$d=m/ /?"\"":"";print "$d$_$d\n";'`)
  # : ${(A)candidates::=$(_z -l 2>&1 | sed 's/^[0-9\.]* *//g' )}
  # _z \
    #     | sed -e 's/^[0-9\\. ]*//' -e 's/ /\\ /g' -e "s#^$HOME#~#" \
    #     | tac | tr '\n' '\0')}
  actions=("zaw-callback-z-cd" "zaw-callback-execute" "zaw-callback-z-shell-exec" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
  act_descriptions=("cd" "execute" "shell execute" "replace edit buffer" "append to edit buffer")
}

zaw-callback-z-cd() {
  BUFFER="cd $1"
  zle accept-line
}

zaw-callback-z-shell-exec() {
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
