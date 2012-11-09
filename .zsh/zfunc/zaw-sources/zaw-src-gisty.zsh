# -*- sh -*-
zmodload zsh/parameter

function zaw-src-gisty() {
    candidates=("${(ps:\n:)$(gisty list)}")
    actions=("zaw-callback-gisty-append-to-buffer")
    act_descriptions=("append to edit buffer")
}

zaw-register-src -n gisty zaw-src-gisty

function zaw-callback-gisty-append-to-buffer() {
    local gitdir=`echo "${(j:; :)@}" | cut -d":" -f1`
    local destpath=$GISTY_DIR/$gitdir
    if [ -n "$gitdir" -a -d "$destpath" ]
    then
        LBUFFER="${BUFFER}${destpath}"
    fi
}
