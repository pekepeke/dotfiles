## 便利DNS周り

### IP指定系
hoge.127.0.0.1.nip.io
hoge.127.0.0.1.xip.io

### ループバック系
lvh.me
localtest.me
loopback.jp
www.loopback.jp
sub.domain.loopback.jp

## SOA レコード

```
dig -t soa example.com
example.com.             900     IN      SOA     ns-366.awsdns-45.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400
[domain]                 [ttl]   IN      SOA     [nameserver]          [contact]                     [serial] [refresh] [retry] [expire] [minimum]
```

- TTL
	- 問い合わせ結果のキャッシュ有効期間
- シリアル
	- ゾーン情報が更新したときに大きな数値になる。というか変更する。これで DNS の情報が新しくなったことを判断する。
- refresh
	- セカンダリサーバが更新を問い合わせる間隔。
- retry
	- セカンダリサーバがrefresh に失敗したときの再試行までの期間。refresh より必ず短くすること。
- expire
	- セカンダリサーバがrefresh に失敗しつづけた場合の、現在のデータの破棄されるまでの期間。
- minimum
	- ネガティブキャッシュの生存期間。他のネームサーバにおいて、ドメインが引けなかった場合に存在しなかったいう情報をキャッシュしておく期間。

### SOA レコードの定義

```
@ IN SOA   ns1.example.jp. postmaster.example.jp. (
               2003081901   ; Serial
               3600         ; Refresh
               900          ; Retry
               604800       ; Expire
               3600         ; Negative cache TTL
               )
```

