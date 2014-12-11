### 全てのインスタンスの情報を取得
aws ec2 describe-instances | jq '.Reservations[].Instances[] | {PublicDnsName, PublicIpAddress, InstanceId, Tags}'
### インスンタンスへ `ssh` でアクセスするのに必要な情報を取得する。
aws ec2 describe-instances --filters Name=tag-value,Values="hogehoge*" |jq '.Reservations[].Instances[]|{InstanceId,PublicIpAddress,PrivateIpAddress,Tags}'
### ${instance_ID} の IP アドレスとアクセスに必要な `ssh` キーの情報を取得する。
aws ec2 describe-instances --filters Name=instance-id,Values="${instance_ID}" | jq '.Reservations[].Instances[]|{PublicIpAddress,KeyName}'
### アカウント上で稼働、停止している[インスタンス]のインスタンス ID とタグで設定している名前、プライベート、パブリック IP を取得して `csv` 形式で出力する。
aws ec2 describe-instances | ~/bin/jq -r '@csv "\(.Reservations[].Instances[] | [.InstanceId, .Tags[0].Value,.PrivateIpAddress,.PublicIpAddress])"'
### インスタンスを作成後に作成したインスタンス ID を取得する
aws ec2 run-instances \
--image-id ${ami_ID} \
--count 1 \
--instance-type t1.micro \
--key-name ${keyname} \
--security-group-ids ${security-group_ID} \
--subnet-id ${subnet_ID} \
--associate-public-ip-address | jq -c -r '.Instances[]|.InstanceId'

### ${instance_ID} を一時的に停止する。
aws ec2 stop-instances --instance-ids ${instance_ID}
### セキュリティグループ内からソースの IP と送信先のポートを取得して csv 形式で出力
aws ec2 describe-security-groups  | jq -r '@csv "\(.SecurityGroups[].IpPermissions[]|[.IpRanges[0].CidrIp,.ToPort])"'

### Elastic IP 一覧を取得
aws ec2 describe-addresses| jq '.':w
### AutoScalingで起動しているインスタンスの状態,InstanceID,PublicDnsName,PublicIpAddressの一覧を取得
aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=YOUR AUTOSCALING GROUP NAME" | jq '.Reservations[].Instances[] | {State, InstanceId, PublicDnsName, PublicIpAddress}'

### 自分で作成したAMIのName,ImageIdの一覧を取得
aws ec2 describe-images --owners self | jq '.Images[] | {Name, ImageId}'
### 自分で作成したAMIに特定のtagが付いているName,ImageIdの一覧を取得
aws ec2 describe-images --owners self --filter Name=tag-key,Values=YOUR TAG NAME Name=tag-value,Values=YOUR TAG VALUES | jq '.Images[] | {Name, ImageId}'
### 自分で作成したSnapshotに特定のtagが付いているSnapshotIdの一覧を取得
aws ec2 describe-snapshots --filter Name=tag-key,Values=YOUR TAG NAME Name=tag-value,Values=YOUR TAG VALUES | jq '.Snapshots[] .SnapshotId'
### 東京リージョンのEBSのVolumeId,SnapshotId,Sizeの一覧を取得
aws ec2 describe-volumes --region ap-northeast-1 | jq '.Volumes[]| {VolumeId, SnapshotId, Size}'

### ELBに紐付いているInstanceId,Statusを一覧取得
aws elb describe-instance-health --load-balancer-name YOUR ELB NAME | jq '.InstanceStates[]|{InstanceId, State}'

### RDSのインスタンスを取得
aws rds describe-db-instances
### RDSのEndPointとDB Instance Identifierを取得
aws rds describe-db-instances | jq '.DBInstances[] |{DBInstanceIdentifier,Endpoint}'
### RDS SnapshotのDBSnapshotIdentifier,DBInstanceIdentifierの一覧を取得
aws rds describe-db-snapshots | jq '.DBSnapshots[] | {DBSnapshotIdentifier, DBInstanceIdentifier}'

### S3 バケット一覧
aws s3api list-buckets | jq '.Buckets[] .Name'

### VPC一覧を取得
aws ec2 describe-vpcs | jq '.Vpcs[]'
### VPC Subnet一覧を取得
aws ec2 describe-subnets | jq '.Subnets[]'
### VPC RouteTable一覧を取得
aws ec2 describe-route-tables | jq '.RouteTables[]'

### IAM ユーザ一覧を取得
aws iam list-users

### ElasticBeanstalk ApplicationName,EnvironmentName,VersionLabel,EndpointURL,CNAMEを一覧取得
aws elasticbeanstalk describe-environments | jq '.Environments[] | {ApplicationName, EnvironmentName, VersionLabel, EndpointURL, CNAME}'
### ElasticBeanstalk 特定の環境で起動しているEC2インスタンスIDを取得
aws elasticbeanstalk describe-environment-resources --environment-name YOUR ENVIRONMENT NAME | jq '.EnvironmentResources.Instances[].Id'

### CloudTrail 東京リージョンのCloudTrailで出力しているS3bucketを取得
aws cloudtrail describe-trails --region ap-northeast-1 | jq '.trailList[] .S3BucketName'

### ダブルクォートとかは排す
- ダブルクォートを削除する

aws ec2 describe-instances | ~/bin/jq -r '.Reservations[].Instances[].InstanceType'

### select 文字列を部分一致させる
- この出力の中から `Name` に `bb` が含まれる `Name` を出力する場合

aws s3api list-buckets | jq -r '.Buckets[]|select(.Name |contains("bb"))'

### csv 形式で出力させる

- `@sh` や `@csv` を付けると任意の形式で出力することが出来る。(他に `@html` や `@base64` 等がある)

aws ec2 describe-instances | ~/bin/jq -r '@csv "\(.Reservations[].Instances[] | [.InstanceType, .InstanceId, .Tags[0].Value])"'

#### result @csv
```
"t1.micro","i-1234567a",
"t1.micro","i-1234567b",
"t1.micro","i-1234567c","aaaaaaaaaa"
"t1.micro","i-1234567d","ccccccccccc"
"t1.micro","i-1234567e","bbbbbbbbbbbb"
```

#### result @sh
```
't1.micro' 'i-1234567a' null
't1.micro' 'i-1234567b' null
't1.micro' 'i-1234567c' 'aaaaaaaaaa'
't1.micro' 'i-1234567d' 'ccccccccccc'
't1.micro' 'i-1234567e' 'bbbbbbbbbbbb'
```


