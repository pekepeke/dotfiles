function percol_search_locate() {
    if [ $# -ge 1 ]; then
        SELECTED_FILE=$(locate $* | percol --match-method migemo)
        if [ $? -eq 0 ]; then
            echo $SELECTED_FILE | sed 's/ /\\ /g'
        fi
    else
        locate $*
    fi
}
