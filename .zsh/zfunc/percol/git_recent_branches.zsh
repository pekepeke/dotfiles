function percol_git_recent_branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | \
        perl -pne 's{^refs/heads/}{}' | \
        percol --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
        LBUFFER="git checkout ${selected_branch}"
    fi
}

