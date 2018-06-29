
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
####  Pod
Workloads リソースの最小単位.
Pod は1つ以上のコンテナから構成されており、ネットワークは隔離されておらず、IP Addressなどは共有している。言い換えると、2つのコンテナが入ったPodを作成した場合、2つのコンテナが同一のIP Addressを持つこととなる。

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-2pod
spec:
  containers:
    - name: nginx-container-112
      image: nginx:1.12
      ports:
      - containerPort: 80
    - name: nginx-container-113
      image: nginx:1.13
      ports:
      - containerPort: 8080
```

#### ReplicationController/ReplicaSet
ReplicaSet/ReplicationControllerはPodのレプリカを生成し、指定した数のPodを維持し続けるリソース
eplicationControllerではequality-based selectorでしたが、ReplicaSetではより強化されたset-based selectorを利用することで、柔軟なレプリケーションの設定が可能となった.
ReplicationControllerは今後廃止の流れなので、基本的にはReplicaSetを使用する.

```
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: sample-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```

#### Deployment
Deploymentは複数のReplicaSetを管理することで、ローリングアップデートやロールバックなどを実現可能にするリソースのこと.
切り替えの際には新しいReplicaSet上でコンテナが起動するか・ヘルスチェックが通っているかの確認をしながら、ReplicaSetを移行していく際のPod数の細かい指定が可能

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```

#### DaemonSet
全nodeに1 podずつ配置するリソース.
各Podが出すログを収集するFluentdや、各Podのリソース使用状況やノードの状態をモニタリングするDatadogなど、全Node上で必ず動作している必要のあるプロセスのために利用されることが多い.

```
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: sample-ds
spec:
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
```

#### StatefulSet
ReplicaSetの特殊な形とも言えるリソース.データベースなどstatefulなワークロードに対応するためのリソース.

- 生成されるPod名が数字でindexingされたものになる
- 永続化するための仕組みを有している
	- PersistentVolumeを使っている場合は同じディスクを利用して再作成される
	- Pod名が変わらない

```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: sample-statefulset
spec:
  replicas: 3
  selector:
    matchLabels:
      app: sample-app
  template:
    metadata:
      labels:
        app: sample-app
    spec:
      containers:
        - name: nginx-container
          image: nginx:1.12
          ports:
            - containerPort: 80
          volumeMounts:
          - name: www
            mountPath: /usr/share/nginx/html
  volumeClaimTemplates:
  - metadata:
      name: www
    spec:
      accessModes:
      - ReadWriteOnce
      resources:
        requests:
          storage: 1Gi
```

##### StatefulSetのスケーリング
ReplicaSetsと同様の方法で「kubectl scale」または「kubectl apply -f」を使ってスケールさせることが可能.
StatefulSetはReplicaSetなどとは異なり、複数のPodを並行して立てることはしません。1つずつPodを作成し、Ready状態になってから次のPodを作成し始めます。また、削除時にはIndexが一番大きいもの（一番新しいコンテナ）から削除します。そのため、冗長化構成を行う場合には、常にindex:0がMasterとなるような構成を取ることが可能です。

#### Job
コンテナを利用して一度限りの処理を実行させるリソース.

```
apiVersion: batch/v1
kind: Job
metadata:
  name: sample-paralleljob
spec:
  completions: 10
  parallelism: 2
  backoffLimit: 10
  template:
    metadata:
      name: sleep-job
    spec:
      containers:
      - name: sleep-container
        image: centos:latest
        command: ["sleep"]
        args: ["30"]
      restartPolicy: Never
```

##### restartPolicy

- restartPolicy: Neverの場合
	- Job用に生成されたPod内のプロセスが停止すると、新規のPodが生成してJobを遂行しようとする
- restartPolicy: OnFailureの場合
	- Job用に生成されたPod内のプロセスが停止すると、RESTARTSのカウントが増加し、使用していたPodを再利用してJobを遂行しようとする

##### completions / parallelism / backoffLimit

| ワークロード                | completions | parallelism | backoffLimit |
|-----------------------------|-------------|-------------|--------------|
| 1回だけ実行するタスク       | 1           | 1           | 1            |
| N並列で実行させるタスク     | M           | N           | P            |
| 1個ずつ実行するワークキュー | 未指定      | 1           | P            |
| N並列で実行するワークキュー | 未指定      | N           | P            |

#### CronJob
Cronのようにスケジュールされた時間にJobを生成する機能.

```
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: sample-cronjob
spec:
  schedule: "*/1 * * * *"
  concurrencyPolicy: Forbid
  startingDeadlineSeconds: 30
  successfulJobsHistoryLimit: 5
  failedJobsHistoryLimit: 5
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: sleep-container
            image: centos:latest
            command: ["sleep"]
            args: ["30"]
          restartPolicy: Never
```

##### spec.concurrencyPolicy

Allow（default）：同時実行に対して制限を行わない
Forbid：前のJobが終了していない場合は次のJobは実行しない（同時実行を行わない）
Replace：前のJobをキャンセルし、新たにJobを開始する

### Discovery & LBリソース
- Service
	- ClusterIP
	- NodePort
	- LoadBalancer
	- ExternalIP
	- ExternalName
	- Headless
- Ingress

#### Service
Serviceではエンドポイントを提供する複数のtypeが用意されており、要件に合わせて選択することが可能です。
基本的には、内部向けエンドポイントを払い出したいときに使う「type: ClusterIP」と、外部向けエンドポイントを払い出したいときに使う「type: LoadBalancer」を利用することが多いです

| Service      | エンドポイント                              |
|--------------|---------------------------------------------|
| ClusterIP    | Kubernetes Cluster内でのみ疎通可能なVIP     |
| ExternalIP   | 特定のKubernetes NodeのIP                   |
| NodePort     | 全Kubernetes Nodeの全IP（0.0.0.0）          |
| LoadBalancer | クラスタ外で提供されているLoadBalancerのVIP |
| ExternalName | CNAMEを用いた疎結合性の確保                 |
| Headless     | PodのIPを用いたDNS Round Robin              |

| Ingressの種類                               | 実装                             |
|---------------------------------------------|----------------------------------|
| クラスタ外のロードバランサを利用したIngress | GKE                              |
| クラスタ内にIngress用のPodを展開するIngress | Nginx Ingress<br>Nghttpx Ingress |

#### Headless Service
DNS Round Robin（DNS RR）を使ったエンドポイントを提供するもの.
作成すると `[Service名].[Namespace名].svc.[domain名]` で参照することができる.(通常サービスも同様)
DNS RR なので負荷分散には向かない.
StatefulSetの場合のみ、`[Pod名].[Service名].[Namespace名].svc.[domain名]` という形式でPod単位での名前解決を行えるようになっている.

```
apiVersion: v1
kind: Service
metadata:
  name: sample-svc
spec:
  type: ClusterIP
  clusterIP: None
  ports:
    - name: "http-port"
      protocol: "TCP"
      port: 80
      targetPort: 80
  selector:
    app: sample-app
```

#### ExterName
Service名の名前解決に対してCNAMEを返すリソースになります。使用する場面としては、別の名前を設定したい場合や、クラスタ内からのエンドポイントを切り替えやすくしたい場合などがあります。

```
kind: Service
apiVersion: v1
metadata:
  name: sample-externalname
  namespace: default
spec:
  type: ExternalName
  externalName: external.example.com
```

#### Ingress
IngressはL7 LoadBalancerを提供するリソースですが、厳密には「Kind: Service」タイプのリソースではなく、「Kind: Ingress」タイプのリソースになる

Ingressは下記の2種類に大別できます。

- クラスタ外のロードバランサを利用したIngress
	- GKE
- クラスタ内にIngress用のPodを展開するIngress
	- Nginx Ingress
	- Nghttpx Ingress

IngressでHTTPSを利用する場合には、証明書は事前にSecretとして登録しておく必要があります。Secretは、証明書の情報を元にYAMLファイルを自分で作成するか、証明書ファイルを指定して作成します。

```
# 証明書の作成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=sample.example.com"

# Secret の作成 (証明書ファイルを指定した場合)
kubectl create secret tls tls-sample --key /tmp/tls.key --cert /tmp/tls.crt
```

##### サンプルアプリのDeployment/Service
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sample-ingress-apps
spec:
  replicas: 1
  selector:
    matchLabels:
      ingress-app: sample
  template:
    metadata:
      labels:
        ingress-app: sample
    spec:
      containers:
        - name: nginx-container
          image: zembutsu/docker-sample-nginx:1.0
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: svc1
spec:
  type: NodePort
  ports:
    - name: "http-port"
      protocol: "TCP"
      port: 8888
      targetPort: 80
  selector:
    ingress-app: sample
```
##### Ingressのサンプル
```
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: sample-ingress
  annotations:
    ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: sample.example.com
    http:
      paths:
      - path: /path1
        backend:
          serviceName: svc1
          servicePort: 8888
  backend:
    serviceName: svc1
    servicePort: 8888
  tls:
  - hosts:
    - sample.example.com
    secretName: tls-sample
```

#### IngressリソースとIngress Controller

Ingressと一言で言っても、その指し示していることは、様々です。例を挙げると「Ingressリソース」とは、YAMLファイルで登録されるAPIリソースのことを意味しますし、「Ingress Controller」はIngressリソースがKubernetesに登録された際に、何らかの処理を行うものになります。処理の例としては、GCPのGCLBを操作することによるL7 LoadBalancerの設定や、NginxのConfigを変更してリロードを実施するなどが挙げられます。

##### GKEの場合
GKEの場合には、デフォルトでGKE用のIngress Controllerがデプロイされており、特に意識することなくIngressリソースごとに自動でIP エンドポイントが払い出されます。

##### Nginx Ingressの場合
Nginx Ingressを利用する場合には、Nginx Ingress Controllerを作成する必要があります。Nginx Ingressでは、Ingress Controller自体が「L7 相当の処理を行うPod」にもなっており、Controllerという名前ですが、実際の処理も行います。

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: default-http-backend
  labels:
    app: default-http-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: default-http-backend
  template:
    metadata:
      labels:
        app: default-http-backend
    spec:
      containers:
      - name: default-http-backend
        image: gcr.io/google_containers/defaultbackend:1.4
        livenessProbe:
          httpGet:
            path: /healthz
            port: 8080
            scheme: HTTP
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: default-http-backend
  labels:
    app: default-http-backend
spec:
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: default-http-backend
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-ingress-controller
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ingress-nginx
  template:
    metadata:
      labels:
        app: ingress-nginx
    spec:
      containers:
        - name: nginx-ingress-controller
          image: quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.14.0
          args:
            - /nginx-ingress-controller
            - --default-backend-service=$(POD_NAMESPACE)/default-http-backend
          env:
            - name: POD_NAME
              valueFrom:
                fieldRef:
                  fieldPath: metadata.name
            - name: POD_NAMESPACE
              valueFrom:
                fieldRef:
                  fieldPath: metadata.namespace
          ports:
          - name: http
            containerPort: 80
          - name: https
            containerPort: 443
          livenessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
          readinessProbe:
            httpGet:
              path: /healthz
              port: 10254
              scheme: HTTP
---
apiVersion: v1
kind: Service
metadata:
  name: ingress-endpoint
  labels:
    app: ingress-nginx
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: ingress-nginx
```

###### Ingress Class
デプロイしたIngress Controllerはクラスタ上の全てのIngressリソースを見てしまうため、衝突する可能性があります。その場合はIngress Classを利用することで、処理する対象のIngressリソースを分けることが可能です。

- Nginx Ingress Controllerの起動時に--ingress-classオプションを渡す
	- /nginx-ingress-controller --ingress-class=system_a ……
- Ingressリソースにannotationsをつける
	- kubernetes.io/ingress.class: "system_a"


### Config＆Storageリソース
Config＆Storageリソースは、コンテナに対して設定ファイル、パスワードなどの機密情報などをインジェクトしたり、永続化ボリュームを提供したりするためのリソースです。内部的に利用されているものを除いて、利用者が直接利用するものとしては、全部で3種類のConfig＆Storageリソースが存在します。

- Secret
- ConfigMap
- PersistentVolumeClaim

#### 環境変数の利用
Kubernetesでは、個別のコンテナに対する設定の内容は環境変数やファイルが置かれた領域をマウントして渡すことが一般的です。そこで、リソースの解説に入る前に、Kubernetesでの環境変数の扱いについて解説します。

Kubernetesで環境変数を渡す際には、podテンプレートにenvまたはenvFromを指定します。大きく分けて、下記の5つの情報源から環境変数を埋め込むことが可能です。

- 静的設定
- Podの情報
- Containerの情報
- Secretリソースの機密情報
- ConfigMapリソースからのKey-Value値

##### 静的設定
静的設定では、その名の通りspec.containers[].envに静的な値として定義します。

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-env
  labels:
    app: sample-app
spec:
  containers:
    - name: nginx-container
      image: nginx:1.12
      env:
        - name: MAX_CONNECTION
          value: "100"
        - name: K8S_NODE
          valueFrom:
            fieldRef:
              fieldPath: spec.nodeName
        - name: CPU_REQUEST
          valueFrom:
            resourceFieldRef:
              containerName: nginx-container
              resource: requests.cpu
        - name: CPU_LIMIT
          valueFrom:
            resourceFieldRef:
              containerName: nginx-container
              resource: limits.cpu
```

##### ConfigMapリソースからのKey-Value値

```
# 環境変数の展開を期待するYAML Manifest（一部成功）
apiVersion: v1
kind: Pod
metadata:
  name: sample-fail-env
  labels:
    app: sample-app
spec:
  containers:
    - name: nginx-container
      image: nginx:1.12
      command: ["echo"]
      args: ["$(TESTENV)", "$(HOSTNAME)"]
      env:
        - name: TESTENV
          value: "100"
```

##### Secret
- Generic（type: Opaque）
- TLS（type: kubernetes.io/tls）
- Docker Registry（type: kubernetes.io/dockerconfigjson）
- Service Account（type: kubernetes.io/service-account-token）

###### Generic
一般的なフリースキーマのSecretを作成する場合は、genericを指定します。作成方法は下記の4パターンがあります。

- ファイルから作成する（--from-file）
ファイル名がそのままKeyとなる.
拡張子が外せない場合、`--from-file=username=username.txt` などのように指定.

- yamlファイルから作成する

```
apiVersion: v1
kind: Secret
metadata:
  name: sample-db-auth
type: Opaque
data:
  username: cm9vdA==
  password: cm9vdHBhc3N3b3Jk
```

- kubectlから直接作成する（--from-literal）

```
kubectl create secret generic sample-db-auth \
    --from-literal=username=root --from-literal=password=rootpassword
```

- envfileから作成する

```
cat <<EOM > env_secret
username=root
password=rootpassword
EOM
kubectl create secret generic sample-db-auth --from-env-file ./env_secret
```

###### TLS
ecretを作成する場合は、tlsを指定します。TLSタイプのSecretはIngressリソースなどから利用することが一般的

```
# 証明書の作成
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /tmp/tls.key -out /tmp/tls.crt -subj "/CN=sample1.example.com"

# TLS Secret の作成
kubectl create secret tls tls-sample --key /tmp/tls.key --cert /tmp/tls.crt
```

###### Docker Registry

```
kubectl create secret docker-registry sample-registry-auth \
    --docker-server=REGISTRY_SERVER \
    --docker-username=REGISTRY_USER \
    --docker-password=REGISTRY_USER_PASSWORD \
    --docker-email=REGISTRY_USER_EMAIL
kubectl get secret -o json sample-registry-auth
```

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-pod
spec:
  containers:
    - name: secret-image-container
      image: REGISTRY_NAME/secret-image:latest
  imagePullSecrets:
    - name: sample-registry-auth
```

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-secret-single-env
spec:
  containers:
    - name: secret-container
      image: nginx:1.12
      volumeMounts:
      - name: config-volume
        mountPath: /config
      env:
        - name: DB_USERNAME
          valueFrom:
            secretKeyRef:
              name: sample-db-auth
              key: username
  volumes:
    - name: config-volume
      secret:
        secretName: sample-db-auth
        items:
        - key: username
          path: username.txt
```

#### Storage
##### Volume
Volumeは既存のボリューム（ホストの領域、NFS、Ceph、GCP Volume）などをYAML Manifestに直接指定することで利用可能にするものです。そのため、利用者が新規でボリュームを作成したり、既存のボリュームを削除したりといった操作を行うことはできません。また、YAML ManifestからVolumeリソースを作成するといった処理も行いません。

- EmptyDir
EmptyDirはPod用の一時的なディスク領域として利用可能です。PodがTerminateされると削除されます。

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-emptydir
spec:
  containers:
  - image: nginx:1.12
    name: nginx-container
    volumeMounts:
    - mountPath: /cache
      name: cache-volume
  volumes:
  - name: cache-volume
    emptyDir: {}
```

- HostPath
Kubernetes Node上の領域をコンテナにマッピングするプラグイン

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-hostpath
spec:
  containers:
  - image: nginx:1.12
    name: nginx-container
    volumeMounts:
    - mountPath: /srv
      name: hostpath-sample
  volumes:
  - name: hostpath-sample
    hostPath:
      path: /data
      type: DirectoryOrCreate
```

- nfs
- iscsi
- cephfs
- GCPPersistentVolume
- gitRepo

##### PersistentVolume
PersistentVolumeは、外部の永続ボリュームを提供するシステムと連携して、新規のボリュームの作成や、既存のボリュームの削除などを行うことが可能です。具体的には、YAML ManifestなどからPersistent Volumeリソースを別途作成する形になります。

下記項目を設定して作成する.
- ラベル
- 容量
- アクセスモード
- Reclaim Policy
- マウントオプション
- Storage Class
- PersistentVolumeごとの設定

@see https://kubernetes.io/docs/concepts/storage/persistent-volumes/

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sample-pv
  labels:
    type: nfs
    environment: stg
spec:
  capacity:
    storage: 10G
  accessModes:
    - ReadWriteMany
  persistentVolumeReclaimPolicy: Retain
  storageClassName: slow
  mountOptions:
    - hard
  nfs:
    server: xxx.xxx.xxx.xxx
    path: /nfs/sample
```

###### アクセスモード

| モード               | 内容                                            |
|----------------------|-------------------------------------------------|
| ReadWriteOnce（RWO） | 単一ノードからRead/Writeされます                |
| ReadOnlyMany（ROX）  | 単一ノードからWrite、複数ノードからReadされます |
| ReadWriteMany（RWX） | 複数ノードからRead/Writeされます                |

###### Reclaim Policy
- Retain
	- PersistentVolumeのデータも消さずに保持します
	- また、他のPersistentVolumeClaimによって、このPersistentVolumeが再度マウントされることはありません
- Recycle
	- PersistentVolumeのデータを削除（rm -rf ./*）し、再利用可能時な状態にします
	- 他のPersistentVolumeClaimによって再度マウントされます。
- Delete
	- PersistentVolumeが削除されます
	- GCE、AWS、OpenStackなどで確保される外部ボリュームの際に利用されます

##### PersistentVolumeClaim
PersistentVolumeClaimは、その名のとおり作成されたPersistentVolumeリソースの中からアサインするためのリソースになります。Persistent Volumeはクラスタにボリュームを登録するだけなので、実際にPodから利用するにはPersistent Volume Claimを定義して利用する必要があります。また、Dynamic Provisioning機能（あとで解説します）を利用した場合は、Persistent Volume Claimが利用されたタイミングでPersistent Volumeを動的に作成することが可能なため、順番が逆に感じられるかもしれません。

###### PersistentVolumeClaimの設定

- ラベルセレクター
- 容量
- アクセスモード
- Storage Class

```
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: sample-pvc
spec:
  selector:
    matchLabels:
      type: "nfs"
    matchExpressions:
      - {key: environment, operator: In, values: [stg]}
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 4Gi
```

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-pvc-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http"
      volumeMounts:
      - mountPath: "/usr/share/nginx/html"
        name: nginx-pvc
  volumes:
    - name: nginx-pvc
      persistentVolumeClaim:
       claimName: sample-pvc
```
###### Dynamic Provisioning
Dynamic Provisioningを使ったPersistentVolumeClaimの場合、PersistentVolumeClaimが発行されたタイミングで動的にPersistentVolumeを作成して、割り当てます。そのため「容量の無駄が生じない」「事前にPersistent Volumeを作成する必要がない」といったメリットがあるが、多くのProvisionerがReadWriteOnceのアクセスモードしかサポートしていないことが多い点に注意.
事前にStorageClassを作っておき、その後Dynamic Provisioning用のStorageClassを指定して、PersistentVolumeClaimを作成する.

```
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: sample-storageclass
parameters:
  type: pd-standard
provisioner: kubernetes.io/gce-pd
reclaimPolicy: Delete
```

```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sample-pvc-provisioner
  annotations:
    volume.beta.kubernetes.io/storage-class: sample-storageclass
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 3Gi
```

```
apiVersion: v1
kind: Pod
metadata:
  name: sample-pvc-provisioner-pod
spec:
  containers:
    - name: nginx-container
      image: nginx
      ports:
        - containerPort: 80
          name: "http"
      volumeMounts:
      - mountPath: "/usr/share/nginx/html"
        name: nginx-pvc
  volumes:
    - name: nginx-pvc
      persistentVolumeClaim:
       claimName: sample-pvc-provisioner
```
###### StatefulSetでのPersistentVolumeClaim Template
StatefulSetでのワークロードでは、データ領域は永続化されることが多いため、spec.volumeClaimTemplateの項目があります。claimTemplateを利用すると、PersistentVolumeClaimを別途定義する必要がなくなり、簡素化することが可能です。残りはContainerのvolumeMountsにvolumeClaimTemplateで指定した名前を指定するだけで完了となり、StatefulSetのYAMLだけで完結します。

```
piVersion: apps/v1beta1
kind: StatefulSet
metadata:
：
：
spec:
  template:
    spec:
      containers:
      - name: sample-pvct
        image: nginx:1.12
        volumeMounts:
        - name: pvc-template-volume
          mountPath: /tmp
  volumeClaimTemplates:
    - metadata:
        name: pvc-template-volume
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 10Gi
        storageClassName: "sample-storageclass"
：
：
```

##### Storage Class
Dynamic Provisioningの場合にユーザがPersistentVolumeClaimを使ってPersistentVolumeを要求する際に、どういったディスクが欲しいのかを指定するために利用されます。Storege Classの選択＝外部ボリュームの種別選択となります

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

