git push origin <branch>:<remote branch>              # ローカルのブランチをリモートにpush
git checkout -b <local branch> origin/<remote branch> # リモートのブランチをとってくる
git reset HEAD hoge/hoge.c; git checkout hoge/hoge.c  # git rmからの復活
git update-index --assume-unchanged web/README.md     # 更新ファイルを無視
git fsck --lost-found                                 # reset --HARD で消してしまった
git fsck | grep blob | cut -d ' ' -f3 | xargs git unpack-file
git show HEAD^:path/to/file                          # 中身表示
git checkout HEAD^ path/to/file                      # ファイルを戻す
git remote add upstream git://github.com/xxx/xxx.git # upstream 登録
git fetch upstream                                   # fetch
git merge upstream/master                            # merge

