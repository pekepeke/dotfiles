git status -sb                         # 色足してくれてメッセージも要らないのも省いてくれる
git shortlog -sn                       # 誰がいくらコミットしたかを一覧表示

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
