GCP
=====

```
# ヘルプ表示
gsutil help cp

# バージョン確認「
gsutil version

# アップデート(非推奨 gcloud 経由でアップデートが推奨)
# gsutil update

# gsutil コマンドラインツール自体の単体・結合テストを実行するためのコマンド(完了まで30分ほどかかる)
gsutil test

# バケット内のオブジェクト一覧を出力
gsutil ls
gsutil ls -l gs://bucket/

# 新しくバケットを作成するためのコマンド (デフォルト: Storage=Multi-Regilnal、ロケーション=US)
gsutil mb gs://new-bucket
gsutil mb -c regional -l asia-northeast1 gs://new-bucket2

# バケットの削除(削除対象のバケットは空である必要がある)
gsutil rb

# コピー
gsutil cp [from] [to]
gsutil cp -r [from] [to]

# 削除
gsutil rm [path]
gsutil rm [folder]

# ファイル移動(GCS→S3とかをやる場合は gsutil config で設定が必要)
gsutil mv [from] [to]

# ファイル同期
gsutil rsync [from] [to]
gsutil rsync -r [from] [to]

# オブジェクトの内容を出力
gsutil cat [path...]

# ディスク容量の確認
gsutil du gs://bucket
gsutil du -c gs://bucket

# ハッシュ値を出力
gsutil hash [path]
```


