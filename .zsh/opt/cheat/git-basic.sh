# ローカルのブランチをリモートにpush
git push origin <branch>:<remote branch>
# リモートのブランチをとってくる
git checkout -b <local branch> origin/<remote branch>
# git rmからの復活
git reset HEAD hoge/hoge.c; git checkout hoge/hoge.c
# 更新ファイルを無視
git update-index --assume-unchanged web/README.md
# reset --HARD で消してしまった
git fsck --lost-found
git fsck | grep blob | cut -d ' ' -f3 | xargs git unpack-file
# 中身表示
git show HEAD^:path/to/file
# ファイルを戻す
git checkout HEAD^ path/to/file
# upstream 登録
git remote add upstream git://github.com/xxx/xxx.git
# fetch
git fetch upstream
# merge
git merge upstream/master
# remote で削除されたリポジトリを local 側も削除
git fetch --prune
# リポジトリURLを確認
git remote -v
# 特定コミット/branch のファイル内容を出力
git show <treeish>:<file>
# origin の変更
git remote set-url origin git@git.example.com:foo/bar.git
# 派生元の変更 master -> develop
git rebase --onto develop master feature/fuga
# pull-r を取り消し
git revert -m 1 [hash]
