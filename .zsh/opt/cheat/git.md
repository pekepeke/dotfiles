git
====

## tips
### 派生元ブランチを出力

```
git show-branch | grep '*' | grep -v "$(git rev-parse --abbrev-ref HEAD)" | head -1 | awk -F'[]~^[]' '{print $2}'
```

## basic

```
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
# 派生元の変更 master -> develop (master -> fuga ==> develop -> fuga)
git rebase --onto develop master feature/fuga
# pull-r を取り消し
git revert -m 1 [hash]
```

## ブランチ操作

```
# branch の upstream を指定
git branch --set-upstream-to=origin/<branch> branch_name
# 設定の一覧を確認
git branch -vv
# rename
git branch -m [old] [new]
# remote branch 削除
git push origin :topic/xxxFeature
git push --delete origin topic/xxxFeature
# local の remote branch 削除
# git branch -r -d topic/xxxFeature
```

## archive

```
# archive
git archive --format=zip --prefix=dir/ HEAD -o repo.zip
git archive --format=zip --prefix=projectname/ HEAD `git diff --name-only <commit>` -o archive.zip

# ファイルのみ取得
git archive --remote=url master | tar x
```

## diff

```
# ignore tab, space
diff -BbwE old new

# ignore indent
git diff -b
# ignore whitespace
git diff -w
# add -p
git diff -w --no-color | git apply --cached
```

## ls-files

```
## 更新ファイル、untracking ファイル一覧の取得
git ls-files --modified --others --exclude-per-directory=.gitignore
```

## clean

```
## remove untracked files
git clean -f
## dry-run
git clean -n
## カレントディレクトリ内の追跡対象外ファイルおよび追跡対象外ディレクトリを削除
git clean -df
## カレントディレクトリ内の追跡対象外ファイルおよび Git では通常無視されるファイルを削除
git clean -xf
# カレントディレクトリ内の追跡対象外ファイルおよび追跡対象外ディレクトリ、および Git では通常無視されるファイルを削除
git clean -fdx
```

## stash

```
git stash -u
git stash list
git stash show [stash]
git stash apply [stash] # stash は破棄されない
git checkout stash@{0} fuga.rb
```

## config

```
# locally gitignore
vim .git/info/exclude

# minimum config
git config --global push.default upstream
git config --global pull.rebase true
git config --global alias.st status
git config --global alias.stt status -uno
git config --global alias.ss status -sb
git config --global alias.co checkout
git config --global alias.ls ls-files
git config --global alias.ci commit
git config --global alias.ca commit --amend
git config --global alias.br branch

git config --global help.autocorrect 1 # git comitとかタイポしたときもcommitしてくれる
git config --global rerere.enabled 1   # 大規模merge時の作業を覚えてくれるらしい

## msg : SSL certificate problem,  verify that the CA cert is OK. Details
got config --local http.sslVerify false
GIT_SSL_NO_VERIFY=true git clone https://xxx.com/repo
```

## commit

```
# fixes author
git commit --amend --author="$(git config user.name) <$(git config user.email)>"
```
### REDMINE
- refs #9999 @2h30m
- fixes #9999
- closes #9999

### Backlog
- #fix #fixes #fixed のどれかで処理済み
- #close #closes #closed のどれかで完了

```
XX-1234 完了 #fix
```

## log

```
git status -sb                         # 色足してくれてメッセージも要らないのも省いてくれる
git shortlog -sn                       # 誰がいくらコミットしたかを一覧表示
## 追加行数
git log --oneline --numstat --no-merges --pretty=format:"" | cut -f1 | awk 'BEGIN {sum=0} {sum+=$1} END {print sum}'
## 削除行数
git log --oneline --numstat --no-merges --pretty=format:"" | cut -f2 | awk 'BEGIN {sum=0} {sum+=$1} END {print sum}'
## 追加・削除
git log --numstat --pretty="%H"  | awk 'NF==3 {plus+=$1; minus+=$2} END {printf("+%d, -%d\n", plus, minus)}'
## 絞込
git log --author="hogehoge"
git log --since=2013-01-01 --until=2013-06-30

git log -p                              # パッチ形式のコミットログを表示する

git log --stat                          # コミットログとファイルの変更の状態を表示する
git log --name-status                   # ファイルの名前とステータスが表示

git log -5                              # 最近のコミットログを 5 つだけ表示
git log -n 5                            # 最近のコミットログを 5 つだけ表示
git log 2b8db..c39be                    # 特定の範囲のコミットログを表示

git log master...customize              # 二つのコミット間の差のコミットログを表示する
git log --left-right master...customize # 二つのコミット間の差のコミットログを表示する

git log file.txt                        # 特定のファイルのコミットログを表示する
git log -- file.txt                     # 特定のファイルのコミットログを表示する

git log --pretty=short                  # コミット、著者、タイトルを表示する
git log --abbrev-commit                 # コミット名を短縮形にする
git log --oneline                       # 一行で表示する
git log --relative-date                 # 相対的な日時で表示する
git log --graph                         # コミット履歴のグラフで表示する
git log --pretty=full                   # 著者に加えてコミッタを表示する
git log --pretty=fuller                 # 著者、コミッタ、AuthorDate、CommitDate を表示する

git log --grep=regexp --grep=a                   # コミットメッセージが正規表現にマッチするログを表示(OR)
git log -E -i --all-match --grep=regexp --grep=a # コミットメッセージが正規表現にマッチするログを表示(AND)
git log --author=regexp --committer=regexp       # 著者、コミッタを正規表現で検索してログを表示する

git log --until=2011-2-6 --since=2011-2-4        # 指定した時間以降のログを表示

git log --topo-order                             # コミットメッセージのログの表示順序を変更
git log --date-order
git log --reverse

# 過去の変更を検索
git log -p -Squery
# regexp
git log -p -S'query' --pickaxe-regex
# 過去の変更を検索＆同時にコミットしたファイルも表示
git log --stat -Squery --pickaxe-all
```

### 一括書き換え系

```
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
```

## merge

```
git checkout --theirs AAA.xlsx        # merge 元のファイルを採用
git checkout --ours BBB.docx          # 今いるブランチのファイルを採用

git checkout --theirs doc/xxx.txt     # rebase 時にmerge 済のファイルを採用

git add *.xlsx && git commit          # unmerged -> merged

git reflog; git reset --hard HEAD@{1} # --hard やり直し
git reflog --pretty=full              # reflog でログ参照
git reflog --stat                     # reflog でログ参照
git reset HEAD^                       # 最新のコミットをstaging状態に戻せる(--soft つきでもOK)

git revert f60f24d                    # revert コミットを作成
git revert -m 1 f60f24d               # merge コミットを revert(parent number を指定)
git show f60f24d                      # parent number を確認(049d32b = 1, ebbcb6a = 2)
commit f60f24d34845fba4e038b3e165f74973b3a19580
Merge: 049d32b ebbcb6a
# コンフリクトが多い場合に、差分を表示
git diff :1:index.html :3:index.html
```

## tag

```
# 表示
git tag
git tag -n
# タグをつける
git tag [tag-name]
git tag [tag-name] [commit-hash]
# タグを削除
git tag -d [tag-name]
# タグを検索して表示
git tag -l "A*"
# remote push
git push origin v0.9
```

## rev-parse

```
# ハッシュ
git rev-parse 1838ad4786...02cc4e713a
git rev-parse v0.1.1 # tag
git rev-parse 4b7688 # 省略ハッシュ

# gitリポジトリのディレクトリを返す
git rev-parse --git-dir

# 現在のディレクトリにリポジトリがあるかどうかを確認
git rev-parse --is-inside-work-tree

# リポジトリが共有リポジトリか確認
git rev-parse --is-bare-repository

# トップレベルディレクトリを絶対パスで取得
git rev-parse --show-toplevel

# サブディレクトリにいるときにトップレベルのディレクトリからの相対パスを出力
git rev-parse --show-cdup

# 使用可能なすべてのリファレンスを出力

git rev-parse --all

# ブランチ
git rev-parse --branches

# タグ
git rev-parse --tags

# リモート
git rev-parse --remotes

```

## submodule

```
git submodule update --init --recursive
git submodule foreach 'git checkout master; git pull'
git submodule foreach 'git submodule update --init'

# remove
git submodule deinit path/to/submodule
git rm path/to/submodule
# git config -f .gitmodules --remove-section submodule.path/to/submodule
```

## pull-request

```
git checkout -b someFeature
git push origin someFeature
git remote add upstream git://github.com/xxx/xxx.git
git stash
git checkout master
git pull upstream master
git checkout someFeature
git rebase master someFeature
git push origin master
git push origin someFeature
```

## new-workdir

```
git-new-workdir . ../foobar
```
