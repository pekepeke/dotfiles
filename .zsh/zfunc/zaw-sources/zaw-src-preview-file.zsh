#
# zaw-preview-file
#
# zaw source for xdg-open to open file
#

function zaw-src-preview-file() {
    local root parent d f
    setopt local_options null_glob

    if (( $# == 0 )); then
        root="${PWD}/"
    else
        root="$1"
    fi

    parent="${root:h}"
    if [[ "${parent}" != */ ]]; then
        parent="${parent}/"
    fi
    candidates+=("${parent}")
    cand_descriptions+=("../")

    # TODO: symlink to directory
    for d in "${root%/}"/*(/); do
        candidates+=("${d}/")
        cand_descriptions+=("${d:t}/")
    done

    for f in "${root%/}"/*(^/); do
        candidates+=("${f}")
        cand_descriptions+=("${f:t}")
    done

    actions=( "zaw-callback-preview-file" "zaw-callback-append-to-buffer" )
    act_descriptions=( "preview file or open directory" "append to edit buffer" )
    # TODO: open multiple files
    #options=( "-m" )
    options=( "-t" "${root}" )
}


function zaw-callback-preview-file() {
    local open
    local is_darwin
    case "${(L)OSTYPE}" in
        linux*|*bsd*)
            open="xdg-open"
            ;;
        darwin*)
            is_darwin=1
            ;;
        *)
            # TODO: what is the best fallback?
            open="xdg-open"
            ;;
    esac

    # TODO: symlink to directory
    if [[ -d "$1" ]]; then
        zaw zaw-src-preview-file "$1"
    else
        if [ x$is_darwin = x1 ]; then
          BUFFER="qlmanage -p ${(q)1} && cd $filed"
        else
          BUFFER="${open} ${(q)1}"
        fi
        zle accept-line
    fi
}

zaw-register-src -n preview-file zaw-src-preview-file
