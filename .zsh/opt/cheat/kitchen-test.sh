# .kitchen.yml を作成する
kitchen init
# ドライバを表示する
kitchen driver discover
# インスタンス作成
kitchen create
# chef と busser をインストールして & convergence を実行
kitchen setup
# repo をアップロードし、chef-solo を実行する
kitchen converge
# テストを実行
kitchen verify
# インスタンス破棄
kitchen destroy
# create-destroy までを一括で実行
kitchen test
kitchen test --destroy=never
kitchen test --destroy=always

kitchen exec (all|instance|regexp) -c REMOTE_COMMAND
# 状態表示
kitchen list
# ssh でログインする
kitchen login
# .kitchen.yml と設定を読み込んだ ruby のプロンプトを起動
kitchen console

# ドライバ作成用の Gem プロジェクト雛形を作成する
kitchen driver

