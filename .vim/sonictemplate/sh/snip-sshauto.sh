# http://qiita.com/wadahiro/items/977e4f820b4451a2e5e0
# 接続先情報
SSH_USER=test
SSH_PASS=mypass
SSH_HOST=your_ssh_server
REMOTE_CMD="ls -al"

if [ -n "$PASSWORD" ]; then
  cat <<< "$PASSWORD"
  exit 0
fi

# SSH_ASKPASSで呼ばれるシェルにパスワードを渡すために変数を設定
export PASSWORD=$SSH_PASS

# SSH_ASKPASSに本ファイルを設定
export SSH_ASKPASS=$0
# ダミーを設定
export DISPLAY=dummy:0

# SSH接続 & リモートコマンド実行
exec setsid ssh $SSH_USER@$SSH_HOST $REMOTE_CMD

