git config --global help.autocorrect 1 # git comitとかタイポしたときもcommitしてくれる
git config --global rerere.enabled 1   # 大規模merge時の作業を覚えてくれるらしい

# 一括書き換え
git filter-branch --commit-filter '
	GIT_AUTHOR_NAME="name"
	GIT_AUTHOR_EMAIL="author@gmail.com"
	GIT_COMMITTER_NAME="name"
	GIT_COMMITTER_EMAIL="author@gmail.com"
	git commit-tree "$@"
' HEAD
# 特定の名前だけ書き換え
git filter-branch --commit-filter '
if [ "$GIT_COMMITTER_NAME" = "old_name" ]; then
GIT_COMMITTER_NAME="new_name"
fi
git commit-tree "$@"
' HEAD
