|||||
|---         |---            |---         |---            |
|ctrl+`b`    |プレフィックス |            |               |
|            |**基本**       |            |**session**    |
|`?`         |キー一覧       |`s`         |一覧選択       |
|`:`         |コマンド       |`d`         |デタッチ       |
|            |               |`&`         |名前変更       |
|            |               |            |               |
|            |**window**     |            |**pane**       |
|`c`         |新規作成       |`%`         |左右分割       |
|`w`         |選択           |`"`         |上下分割       |
|`0`-`9`     |指定番号へ移動 |`q`         |番号表示       |
|`&`         |破棄           |`→`        |方向へ移動     |
|`n`         |次へ           |ctrl+`→`   |サイズ変更     |
|`p`         |前へ           |`!`         |ウィンドウ化   |
|`l`         |以前のへ       |`x`         |破棄           |
|`'`         |入力番号へ     |`o`         |順に移動       |
|`.`         |番号変更       |`;`         |以前のへ移動   |
|`,`         |名前変更       |`z`         |最大化         |
|`f`         |検索           |space       |レイアウト変更 |
|            |**コピー**     |alt-`1`-`5` |レイアウト変更 |
|`[`         |モード開始     |`{`         |前方向に入替   |
|space       |開始位置決定   |`}`         |後方向に入替   |
|enter       |終了位置決定   |ctrl+`o`    |全体入れ替え   |
|`]`         |貼り付け       |`t`         |時計表示       |
|            |               |            |               |
|            |**plugin**     |            |**resurrect**  |
|`I`         |インストール   |ctrl+`s`    |tmux設定保存   |
|`U`         |アップデート   |ctrl+`r`    |tmux設定復活   |

|||
|---                         |---                     |
|**tmuxコマンド**            |                        |
|`tmux`                      |新規session開始         |
|`tmux new -s 名前`          |名前を付けてsession開始 |
|`tmux ls`                   |session一覧             |
|`tmux lsc`                  |接続クライアント一覧    |
|`tmux a`                    |session再開             |
|`tmux kill-session`         |セッションを終了        |
|`tmux kill-session -t 名前` |セッションを指定して終了|
|`tmux kill-server`          |tmux全体を終了          |
|`tmux source ~/.tmux.conf`  |.tmux.confの再読込      |
|`tmux -V`                   |バージョン確認          |

#### 複数のペインに対して同時にコマンドを実行する

```tmux
[prefix]:set-window-option synchronize-panes on
ls
[prefix]:set-window-option synchronize-panes off
```

#### バージョン
```console
> tmux -V
tmux 2.9a
```

#### .tmux.conf

```conf
# インデックス開始番号変更
set -g base-index 1
setw -g pane-base-index 1


# 履歴をたくさん保持
set -g history-limit 999999999


# ステータスバーの色変更
set -g status-fg colour255
set -g status-bg colour238


# プレフィックスキー変更
set-option -g prefix C-e
unbind-key C-b
bind-key C-e send-prefix


# マウス操作を有効にする
set-option -g mouse on


# ドラッグでコピーできるようにする
# brew install reattach-to-user-namespace
setw -g mode-keys vi
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"


# コピーモード完了時にクリップボードにコピー
# brew install reattach-to-user-namespace
unbind -T copy-mode-vi Enter
bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "reattach-to-user-namespace pbcopy"


# tmuxのプラグイン管理
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'


## tmux環境の保存・復活
set -g @plugin 'tmux-plugins/tmux-resurrect'


## Initialize TMUX plugin manager
## (keep this line at the very bottom of tmux.conf)
run '~/.tmux/plugins/tpm/tpm'
```


