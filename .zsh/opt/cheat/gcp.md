GCP
=====

# gsutil

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

# Container Builder

```
gcloud builds submit --tag gcr.io/[PROJECT_ID]/[IMAGE_NAME] .
gcloud builds submit --config cloudbuild.yaml \
  gs://cloud-build-examples/node-docker-example.tar.gz \
  --substitutions=_NODE_VERSION_1=v6.9.4, _NODE_VERSION_2=v9.5.0
gcloud builds submit --config [BUILD_CONFIG] --no-source
```

```
$PROJECT_ID: build.ProjectId
$BUILD_ID: build.BuildId
$COMMIT_SHA: build.SourceProvenance.ResolvedRepoSource.Revision.CommitSha
$SHORT_SHA: COMMIT_SHA の先頭 7 文字
$REPO_NAME: build.Source.RepoSource.RepoName（トリガーされたビルドでのみ使用可能）
$BRANCH_NAME: build.Source.RepoSource.Revision.BranchName（トリガーされたビルドでのみ使用可能）
$TAG_NAME: build.Source.RepoSource.Revision.TagName（トリガーされたビルドでのみ使用可能）
$REVISION_ID: build.SourceProvenance.ResolvedRepoSource.Revision.CommitSha（トリガーされたビルドでのみ使用可能）
```


```
steps:
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'gcr.io/my-project/my-image', '.']
  timeout: 500s
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'gcr.io/my-project/my-image']
- name: 'gcr.io/cloud-builders/kubectl'
  args: ['set', 'image', 'deployment/my-deployment', 'my-container=gcr.io/my-project/my-image']
  id: 'kubectl'
  env:
  - 'CLOUDSDK_COMPUTE_ZONE=us-east4-b'
  - 'CLOUDSDK_CONTAINER_CLUSTER=my-cluster'
- name: 'ubuntu'
  args: ['--version']
  env: 
  - 'CLOUDSDK_COMPUTE_ZONE=us-east1-b'
  - 'CLOUDSDK_CONTAINER_CLUSTER=node-example-cluster'
  dir: 'examples/hello_world'
  id: 'nodeversion'
  waitFor: 'kubectl'
  entrypoint: 'node'
  secretEnv: ['MY_SECRET']
  volumes:
  - name: 'vol1'
    path: '/persistent_volume'
  timeout: 500s
logsBucket: 'gs://my-bucket'
options:
  machineType: 'N1_HIGHCPU_8'
  sourceProvenanceHash: ['SHA256']
  diskSizeGb: 200
  substitutionOption: 'ALLOW_LOOSE'
  logStreamingOption: STREAM_ON
substitutions:
  _NODE_VERSION_1: v6.9.5
secrets: object(Secret)

timeout: 660s
tags: ['mytag1', 'mytag2']
images: ['gcr.io/my-project/myimage']
```

## GKEで固定IP

```
gcloud compute addresses create access-static-ip --global
gcloud compute addresses list --global

kubectl create -f ingress.yaml
```

```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: static-ip
  annotations:
    kubernetes.io/ingress.global-static-ip-name: "access-static-ip"
spec:
  tls:
  # This assumes tls-secret exists.
  - secretName: tls-secret
  backend:
    # This assumes http-svc exists and routes to healthy endpoints.
    serviceName: http-svc
    servicePort: 80
```

