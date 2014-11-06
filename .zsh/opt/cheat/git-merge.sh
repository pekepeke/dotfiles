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
