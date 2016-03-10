## tail
### 指定した行以降の表示

```
grep -n "fuga" filename
tail -n +100 filename
```

## sed
### 特定行の書き換え

```
# 3行目のみ
sed -e '3s/xxx/yyy/g'
# 3-5 行目を書き換え
sed -e '3,5s/xxx/yyy/g'
# 3-末行を書き換え
sed -e '3,5s/xxx/yyy/g'
```

### 特定行の削除

```
# 1-5 行目を削除
sed 1,5d
```

### 特定行の抽出

```
# 先頭行表示
sed -n -e 1p
# 末行表示
sed -n -e \$p
```

### 拡張正規表現(-E)
- `+?{}()|` のバックスペースの追加が不要になる。
