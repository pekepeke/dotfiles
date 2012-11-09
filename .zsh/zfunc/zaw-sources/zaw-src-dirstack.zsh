# zaw.zsh source for the elements of the directory stack.
# https://github.com/nakamuray/zaw
# Thank you very much, nakamuray!

zmodload zsh/parameter

function zaw-src-dirstack() {
    : ${(A)candidates::=$dirstack}
    actions=("zaw-callback-execute" "zaw-callback-replace-buffer" "zaw-callback-append-to-buffer")
    act_descriptions=("execute" "replace edit buffer" "append to edit buffer")
}

zaw-register-src -n dirstack zaw-src-dirstack
