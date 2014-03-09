function percol_git_recent_all_branches () {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes | \
      perl -pne 's{^refs/(heads|remotes)/}{}' | \
      percol --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
      LBUFFER="git checkout -t ${selected_branch}"
    fi
}
