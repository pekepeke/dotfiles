# hub
## リポジトリを閲覧

```
hub browse [user/repo]
```

## リポジトリをクローン

```
hub clone user/repo
```

## fork & pull-request

```
hub clone user/repo
git checkout -b Spike
git commit -m "fixes"
hub fork
git push Spike
hub pull-request
```

### HEAD の参照先を確認(pull request 先)

```
git symbolic-ref refs/remotes/origin/HEAD
```

### pull request 先を修正

```
git remote set-head --auto origin
```
