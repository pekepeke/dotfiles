## install
- https://chocolatey.org/install


```
@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
```

## usage
```
# install
choco install -y nodejs.install
choco install -y vivaldi -pre
choco install choco-cleaner -y
# upgrade
choco upgrade chocolatey -y
choco upgrade all --except="'skype,conemu'"
choco upgrade all

# パッケージリストの取得
choco list
# インストールしたものだけ
choco list -localonly
choco list -lo

```

