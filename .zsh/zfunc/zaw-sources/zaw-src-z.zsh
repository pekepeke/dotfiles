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
    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
  # )
}

zaw-register-src -n z zaw-src-z
