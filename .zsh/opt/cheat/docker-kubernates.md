Kubernates
============


## kubectl

```
# pod/rc/serviceを作成
kubectl create -f [pod/rc/service定義ファイル]

# pod一覧を確認
kubectl get pod
kubectl get pods -o wide
# STATUS
# Running： 稼働中
# Pending： Pod起動待ち
# ImageNotReady: dockerイメージ取得中
# PullImageError： dockerイメージ取得失敗
# CreatingContainer: Pod(コンテナ)起動中
# Error: エラー

# rc(Replication Controller)一覧を確認
kubectl get rc

# svc(Service)一覧を確認
kubectl get svc

# podを削除

kubectl delete pod [Pod名]
kubectl delete -f [作成時のPod定義ファイル]

# rc(Replication Controller)を削除
kubectl delete rc [rc名]

# svc(Service)を削除
kubectl delete svc [svc名]
kubectl delete -f [作成時のsvc定義ファイル]

# ログの確認
kubectl logs [pod名]

# pod/rc/svcの詳細を確認する
kubectl describe [Pod名/rc名/svc名]

# 起動したPodにログインする
kubectl exec -it [コンテナ名] /bin/bash

# Podの環境変数を確認
kubectl exec [Pod名] env

# Podのマウントされたボリュームを確認
kubectl exec [Pod名] ls /[Path]

# Pod（コンテナ）上でコマンドを実行
kubectl exec [Pod名] [コマンド]

# rc: コンテナ(Pod)の複製数を変更（Scale）する
kubectl scale rc [rc名] --replicas=[数]
```

