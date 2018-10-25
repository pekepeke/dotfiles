
## Status Code
http://www.asahi-net.or.jp/~ax2s-kmtn/ref/status.html

## プリフライトリクエスト
https://developer.mozilla.org/ja/docs/Web/HTTP/HTTP_access_control#Preflighted_requests

```
curl -X OPTIONS http://example.org -i
```

## Header

### X-Frame-Options
DENY：全ドメインで埋め込み禁止
SAMEORIGIN：ページと同一ドメイン内へのみ埋め込み許可
ALLOW-FROM uri：指定されたドメインのみ埋め込み許可

### X-Content-Type-Options: nosniff
ファイルの内容からファイルの種類を決定できないようにする

### Strict-Transport-Security: max-age=86400
設定した期間、連続してhttpsに接続されつづけるヘッダーフィールド。

### X-XSS-Protection
XSSフィルタリングの有無を指定するためのヘッダ

```
X-XSS-Protection: 0
X-XSS-Protection: 1
X-XSS-Protection: 1; mode=block
X-XSS-Protection: 1; report=<reporting-uri>
```

### Content-Security-Policy
Chromeバージョン25以降、Firefoxバージョン23以降が対応
https://developer.mozilla.org/ja/docs/Web/HTTP/CSP

- `default-src 'self'`
同じオリジン（同じURLスキーム、ホスト、ポート番号）からはすべてのコンテンツを読み込むようにしたい場合
- `default-src 'self' *.example.com`
指定したドメインとすべてのサブドメインからのコンテンツを許可したい場合

#### Content-Security-Policy-Report-Only
CSPと同様だが、ポリシーを強制せず、ポリシー違反が起きた時のレポーティングのみを行う

#### X-Content-Security-Policy
Chromeバージョン24以前が対応

#### X-WebKit-CSP
Firefoxバージョン22以前、Internet Explorerバージョン10が対応

### Public-Key-Pins
偽造された証明書による中間者攻撃を防ぐための機能。
レスポンスヘッダに本物の証明書の公開鍵のハッシュ値を Base64 にして付けておくことでブラウザが実際のサーバから送信されてくる証明書の公開鍵データのハッシュ値と比較して、不正な証明書の利用を検知する。

```
Public-Key-Pins: pin-sha256="base64=="; max-age=5184000; includeSubDomains; report-uri="https://www.example.net/hpkp-report"
```

### CORS 関連
XMLHttpRequestを使って、他のドメインなどからリソースを取得したいクロスドメイン通信をしたい場合に指定します。使う場合には詳しくはCORS (Cross-Origin Resource Sharing)勧告などを参考にして下さい。

```
Access-Control-Allow-Origin: http://www.example.com
Access-Control-Allow-Methods: POST, GET, OPTIONS
Access-Control-Allow-Headers: X-TRICORDER
Access-Control-Max-Age: 1728000
```

### P3P
http://www.ark-web.jp/sandbox/wiki/240.html

```
```

### X-Download-Options
ユーザーがダウンロードしたファイルを直接"開く"ことを防止したい場合に指定します。

```
X-Download-Options: noopen
```

### X-Permitted-Cross-Domain-Policies
「crossdomain.xml 」（Flash コンテンツから別ドメインにあるファイルを読み込む際に必要になる設定を記述したポリシーファイル）をサイトのドキュメントルートに置くことができない場合などに、同様の効果を発揮することができます。
- master-only マスターポリシーファイル（ /crossdomain.xml）のみが許可される
```
X-Permitted-Cross-Domain-Policies: master-only
```

