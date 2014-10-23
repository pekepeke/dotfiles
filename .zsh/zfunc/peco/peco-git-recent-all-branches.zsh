function peco-git-recent-all-branches () {
local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads refs/remotes | \
  perl -pne 's{^refs/(heads|remotes)/}{}' | \
  peco --query "$LBUFFER")
if [ -n "$selected_branch" ]; then
  LBUFFER="git checkout -t ${selected_branch}"
fi
}
zle -N peco-git-recent-all-branches
