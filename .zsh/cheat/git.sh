git checkout --theirs AAA.xlsx        # merge 元のファイルを採用
git checkout --ours BBB.docx          # 今いるブランチのファイルを採用
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

# archive
git archive --format=zip --prefix=dir/ HEAD -o repo.zip
git archive --format=zip --prefix=projectname/ HEAD `git diff --name-only <commit>` -o archive.zip

