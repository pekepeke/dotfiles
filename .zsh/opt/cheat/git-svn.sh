# 標準構成で作成
git svn clone https://xxx/root/ -T trunk -b branches -t tags
git svn clone -s https://xxx/root/

# 同期
git svn fetch svn
git svn rebase

# ブランチ作成
git svn branch new-branch
git branch -r
git co -b l-new-branch new-branch
git dcommit

git svn fetch
# エラーのリビジョンから再開
git svn fetch -r 3594:HEAD

# リビジョン番号を指定して fetch
SVN_HEAD_REV=$(svn info $SVNURL/MyProject | grep '^Revision' | awk -F': ' '{print $2}')
git svn fetch -r 1:$SVN_HEAD_REV
