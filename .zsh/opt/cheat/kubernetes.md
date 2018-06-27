
kubernetes
===========

## 環境構築について
- ローカルKubernetes
	- Minikube
	- Docker for Mac
- Kubernetes構築ツール
	- kubeadm
	- Rancher
- パブリッククラウド上のマネージドKubernetes
	- Google Kubernetes Engine（GKE）
	- Azure Container Service（AKS）
	- Elastic Container Service for Kubernetes（EKS）

## リソース

| リソースの分類          | 内容                                                         |
|-------------------------|--------------------------------------------------------------|
| Workloadsリソース       | コンテナの実行に関するリソース                               |
| Discovery＆LBリソース   | コンテナを外部公開するようなエンドポイントを提供するリソース |
| Config＆Storageリソース | 設定・機密情報・永続化ボリュームなどに関するリソース         |
| Clusterリソース         | セキュリティやクォータなどに関するリソース                   |
| Metadataリソース        | リソースを操作する系統のリソース                             |

### Workloadsリソース
- Pod
Workloads リソースの最小単位.
Pod は1つ以上のコンテナから構成されており、ネットワークは隔離されておらず、IP Addressなどは共有している。言い換えると、2つのコンテナが入ったPodを作成した場合、2つのコンテナが同一のIP Addressを持つこととなる。

- ReplicationController
- ReplicaSet
ReplicaSet/ReplicationControllerはPodのレプリカを生成し、指定した数のPodを維持し続けるリソース
eplicationControllerではequality-based selectorでしたが、ReplicaSetではより強化されたset-based selectorを利用することで、柔軟なレプリケーションの設定が可能となった.
ReplicationControllerは今後廃止の流れなので、基本的にはReplicaSetを使用する.

- Deployment
Deploymentは複数のReplicaSetを管理することで、ローリングアップデートやロールバックなどを実現可能にするリソースのこと.
切り替えの際には新しいReplicaSet上でコンテナが起動するか・ヘルスチェックが通っているかの確認をしながら、ReplicaSetを移行していく際のPod数の細かい指定が可能

- DaemonSet
- StatefulSet
- Job
- CronJob

#### Pod

### Discovery & LBリソース
- Service
	- ClusterIP
	- NodePort
	- LoadBalancer
	- ExternalIP
	- ExternalName
	- Headless
- Ingress

### Config＆Storageリソース
- Secret
- ConfigMap
- PersistentVolumeClaim

### Clusterリソース
クラスタ自体の振る舞いを定義するリソース
セキュリティや利便性に関する設定、ポリシーなどのリソースが該当する

- Namespace
- ServiceAccount
- Role
- ClusterRole
- RoleBinding
- ClusterRoleBinding
- NetworkPolicy
- ResourceQuota
- PersistentVolume
- Node

### Metadataリソース
クラスタ内の他のリソースの動作を制御するようなリソース

- CustomResourceDefinition
- LimitRange
- HorizontalPodAutoscaler

### namespace
初期状態で下記3つのNamespaceが作成される。
- default：デフォルトのNamespace
- kube-system：Kubernetesクラスタのコンポーネントやaddonが展開されるNamespace
- kube-public：全ユーザが利用できるConfigMapなどを配置するNamespace

## ~/.kube/config
kubectx がオヌヌメ？
- https://github.com/ahmetb/kubectx

```
# クラスタの定義
kubectl config set-cluster prd-cluster \
    --server=https://localhost:6443

# 認証情報の定義
kubectl config set-credentials admin-user \
    --client-certificate=./sample.crt \
    --client-key=./sample.key \
    --embed-certs=true

# コンテキストの定義 (クラスタ、認証情報、Namespace を定義)
kubectl config set-context prd-admin \
    --cluster=prd-cluster \
    --user=admin-user \
    --namespace=default
# コンテキストの切り替え
kubectl config use-context prd-admin
Switched to context "prd-admin".

# 現在のコンテキストを表示
kubectl config current-context
prd-admin
```

## cheat

```bash
# pod
kubectl get pod
kubectl describe pod [pod-name]
kubectl attach [pod-name]
kubectl logs [-f] [pod-name] [-c container-name]
kubectl exec -it [pod-name] /bin/sh
kubectl exec -it [pod-name] -- /bin/ls -l
kubectl port-forward [pod-name] 23306:3306


# replication controller
kubectl get rc
kubectl describe rc [rc-name]
kubectl rolling-update [rc-name] [new-image-url]
kubectl rolling-update [rc-name] -f [new-rc-schema-json-file-path]
kubectl scale rc [rc-name] --replicas=[num]

kubectl rollout history deployment [deployment]                    # 変更履歴
kubectl rollout undo deployment [deployment]                       # 一つ前にロールバック
kubectl rollout undo deployment sample-deployment --to-revision 1  # rev 指定


# service
kubectl service service
kubectl describe service [service-name] 

 cluster
kubectl cluster-info
gcloud compute instance-groups managed resize [gke-cluster-instance-group] --size [num]
```

