## アップデート可能なパッケージの一覧表示

yum check-update

## セキュリティ関連

### install

yum install yum-plugin-security

### 確認

yum --security check-update

### 重大度別に表示

yum updateinfo list
yum updateinfo list --sec-severity=Important
yum updateinfo list --sec-severity=Moderate
yum updateinfo list --sec-severity=Low

### CVE を確認

yum updateinfo list cves
yum updateinfo list --cve CVE-2012-2677
yum updateinfo info --cve CVE-2012-2677

### セキュリティ関連のパッケージのみをインストール

yum --security update
yum --security update-minimal
yum update --cve CVE-2012-3954

