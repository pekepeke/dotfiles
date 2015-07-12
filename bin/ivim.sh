#!/bin/bash


true=":"
false=$([ -e /bin/false ] && echo "/bin/false" || echo "false")
success=0
failure=1



usage() {
    local progname=`basename $0`

    cat <<EOM
    Usage
        $progname [{options}] [--] [{script} [{file}]]

    Options
        -h
            Show help.
EOM

    exit 1
}

die() {
    echo "$@" >&2
    exit 1
}

decho() {
    $VERBOSE && echo "debug:" "$@" >&2
}

ALL_TEMPFILES=()
add_tempfiles() {
    [ $# = 0 ] && return
    register_remove_all_tempfiles
    for f in "$@"; do
        ALL_TEMPFILES=($ALL_TEMPFILES "$f")
    done
}

IS_REGISTERED_REMOVE_ALL_TEMPFILES="$false"
register_remove_all_tempfiles() {
    $IS_REGISTERED_REMOVE_ALL_TEMPFILES || {
        trap 'remove_all_tempfiles' HUP INT QUIT TERM
        IS_REGISTERED_REMOVE_ALL_TEMPFILES="$true"
    }
}

remove_all_tempfiles() {
    local x=$?
    $IS_REGISTERED_REMOVE_ALL_TEMPFILES && {
        for t in "$ALL_TEMPFILES"; do
            decho "cleaning up $f..."
            rm -f "$t"
        done
    }
    exit $x
}

get_clone_tempfile() {
    local tempfile=`tempfile`
    add_tempfiles "$tempfile"

    if [ $# = 0 ]; then
        cat
    else
        cat "$@"
    fi >"$tempfile" || exit $?
    echo "$tempfile"
}

get_tempfile() {
    local tempfile=`tempfile`
    add_tempfiles "$tempfile"

    echo "$tempfile"
}

vim_write() {
    echo "write"
}

vim_quit() {
    echo "qall!"
}

get_script() {
    cat "$@" || exit $?
    $AUTO_WRITE && vim_write
    $AUTO_QUIT  && vim_quit
}

run_file() {
    [ $# -ge 2 ] || die "invalid args"

    local script="$1"
    shift
    decho "script: [$script]"

    local f
    for f in "$@"; do
        local t=`get_clone_tempfile "$f"`
        decho "tempfile: [$t]"
        echo "$script" | call_ex "$t"
        cat "$t"
    done
}

eval_code() {
    local files=()
    local f
    for f in "$@"; do
        files=($files "$f")
    done
    [ ${#files[*]} = 0 ] && {
        local t=`get_tempfile`
        cat >"$t"
        files=($t)
    }
    local script=$(
        for e in $EVAL_SOURCES; do
            echo "$e"
        done
        $AUTO_WRITE && vim_write
        $AUTO_QUIT && vim_quit
    )
    run_file "$script" "$files"
}

build_ex_command() {
    EX="ex"
    if $COMPATIBLE; then
        EX="$EX -N"
    fi
    if ! $LOAD_CONF; then
        EX="$EX -u NORC --noplugin"
    fi
    if $QUIET; then
        EX="$EX -"
    fi
}

call_ex() {
    [ $# = 1 ] || die "call_ex: must specify file to open"
    SCRIPT="$1" $EX "$1"
}

main() {
    build_ex_command
    if [ ${#EVAL_SOURCES[*]} != 0 ]; then
        eval_code "$@"
        return 0
    fi
    case $# in
        0) QUIET="$false"; build_ex_command; exec $EX ;;
        1) get_script "$1" | $EX ;;
        *) local out=`get_script "$1"`; shift; run_file "$out" "$@" ;;
    esac
}


VERBOSE="$false"
AUTO_WRITE="$true"
AUTO_QUIT="$true"
COMPATIBLE="$true"
LOAD_CONF="$false"
QUIET="$false"
EVAL_SOURCES=()


OPTIND_OLD=$OPTIND
OPTIND=1
while getopts hvWQclqe: opt; do
    case $opt in
        v) VERBOSE="$true" ;;
        W) AUTO_WRITE="$false" ;;
        Q) AUTO_QUIT="$false" ;;
        C) COMPATIBLE="$false" ;;
        l) LOAD_CONF="$true" ;;
        q) QUIET="$true" ;;
        e) EVAL_SOURCES=($EVAL_SOURCES "$OPTARG") ;;
        h) usage ;;
        ?) usage ;;
    esac
done
shift `expr $OPTIND - 1`
OPTIND=$OPTIND_OLD


main "$@"

