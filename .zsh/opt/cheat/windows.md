## よく使うパス
- Windows ユーザー設定: %APPDATA%\Microsoft\Windows
- スタートメニュー: "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
- プログラム(All): %ProgramData%\Microsoft\Windows\Start Menu\Programs
- Google Chrome - %APPDATA%\Google\Chrome
- Firefox - %APPDATA%\Mozilla\Firefox\Profiles

## Tips
### 不要そうなサービス

```
| 名前                                    | 説明                                                                   |
|-----------------------------------------|------------------------------------------------------------------------|
| Diagnostic Policy Service               | Windows の診断を使わないなら無効                                       |
| Diagnostic Service Host                 | Windows の診断を使わないなら無効                                       |
| Diagnostic System Host                  | Windows の診断を使わないなら無効                                       |
| Distributed Link Tracking Client        | ドメインを使わないなら無効、ドメインを設定しないかぎり使用していません |
| Offline Files                           | LAN 間のファイルのキャッシュを使わないのなら無効                       |
| Print Spooler                           | プリンタを使わないなら無効                                             |
| Program Compatibility Assistant Service | プログラム互換性アシスタントを使わないなら無効                         |
| Server                                  | LAN を使用して他の機器と接続しないのであれば無効                       |
| TCP/IP NetBIOS Helper                   | ドメインや NetBIOS を使わないなら無効                                  |
| Windows Defender                        | セキュリティソフトでスパイウェア対策がされているなら無効               |
| Windows Search                          | Windows の高速検索を使わない、インデックス作成を止めたいなら無効       |
```

### which

```
where xcopy
# PSの場合
gcm notepad
Get-Command notepad
gcm notepad | fl
```

## Network

```
## ローカルエリア接続再起動
netsh interface set interface "ローカル エリア接続" disalbe
netsh interface set interface "ローカル エリア接続" enable
## wifi接続再起動
netsh int set int "ワイヤレス ネットワーク 接続" disable
netsh int set int "ワイヤレス ネットワーク 接続" enable
```

## bash on windows
### apt source 書き換え

```
sudo sed -i.bak -e "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.iij.ad.jp/pub/linux/ubuntu/archive/%g" /etc/apt/sources.list
sudo sed -i.bak -e "s%http://us.archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
```

### wsl-terminal
- https://github.com/goreliu/wsl-terminal

```
use_cbwin=1
shell="zsh -c 'cd; zsh -l'"
;shell="bash -c 'cd; bash -l'"
```


### etc

#### 初期状態にもどす

```
lxrun /?

# ↓が削除されない
# C:\Users\user01\AppData\Local\lxss\home
# C:\Users\user01\AppData\Local\lxss
lxrun /uninstall

# 全削除
lxrun /uninstall /full

# インストール
lxrun /install

lxrun /install /y
lxrun /setdefaultuser
```

## msys2

```
# pacman バージョン確認
pacman -Sl | grep 'pacman '

# pacman >= 5.0.1.6403, 5.0.1-1
pacman -Syuu

# pacman >= 4.2.16187
update-core
pacman -Suu

# other
pacman --needed -Sy bash pacman pacman-mirrors msys2-runtime msys2-runtime-devel
pacman -Suu

```

## WinMerge
### `EUC-JP`のカスタムコード
- 20932

## Fiddler
### Plugins
- http://www.telerik.com/fiddler/add-ons
- watcher
	- https://websecuritytool.codeplex.com/
	- 脆弱性チェックツール
		- http://news.mynavi.jp/articles/2010/04/21/fiddler/
- Compressibility
	- gzip した時どれくらいのサイズになるかを調べられるツール
- Traffic Differ
	- 差分チェックツール
- x5s
	- XSS用チェックツール
- intruder21
	- XSS用チェックツール

### HSTS対応(動かない?)
```
    public static RulesOption("HSTS")
    var m_HSTS: boolean = false;

    protected static var m_hsts = new Array();

    // static function OnBeforeRequest(oSession: Session) {

        if( m_HSTS && (undefined !== m_HstsInfo[ oSession.host ]) && (oSession.oRequest.headers.UriScheme=="http") ) {
            (function(){
                var t1 = +(new Date());
                var t2 = m_HstsInfo[ oSession.host ].timer;
                if( t2 >= t1 ){
                    oSession.oRequest.headers.UriScheme = "https";
                }
            })();
        }

    // static function OnBeforeResponse(oSession: Session) {

        // HSTS
        if( m_HSTS && (oSession.isHTTPS) && oSession.oResponse.headers.Exists( "Strict-Transport-Security" ) ) {
            (function(){
                var s : String = oSession.oResponse[ "Strict-Transport-Security" ];
                var m = /^max\-age\s*=\s*(\d+)\s*(;\s*(includeSubDomains)\s*)*/.exec( s );
                if( m !== null ) {
                    m_HstsInfo[ oSession.host ] = {
                        "timer" : +(new Date()) + ( m[ 1 ] ? m[ 1 ] : 0 ) * 1000
                        "includeSubDomains" : m[ 3 ] ? true : false
                    };
                }
            })();
        }
```

### リファラー削除

```
    public static RulesOption("Disable Referer")
    var m_DisableReferer: boolean = false;

        // static function OnBeforeRequest(oSession:Fiddler.Session) {
                // Disable Referer
                if (m_DisableReferer ){
                        oSession.oRequest.headers.Remove("Referer");
                }
```

### 各種ヘッダー削除

```
    // Remove Headers
    public static RulesOption("Remove Host")
    var m_RemoveHost: boolean = false;
    public static RulesOption("Remove User-Agent")
    var m_RemoveUserAgent: boolean = false;
    public static RulesOption("Remove Accept")
    var m_RemoveAccept: boolean = false;
    public static RulesOption("Remove Accept-Language")
    var m_RemoveAcceptLanguage: boolean = false;
    public static RulesOption("Remove Accept-Encoding")
    var m_RemoveAcceptEncoding: boolean = false;
    public static RulesOption("Remove Cookie")
    var m_RemoveCookie: boolean = false;

    // static function OnBeforeRequest(oSession: Session) {
        // Remove Headers
        if (m_RemoveHost && oSession.oRequest.headers.HTTPVersion == "HTTP/1.0") {
            oSession["x-overridehost"] = oSession.oRequest.host;
            oSession.oRequest.headers.Remove("Host");
        }
        if (m_RemoveUserAgent) {
            oSession.oRequest.headers.Remove("User-Agent");
        }
        if (m_RemoveAccept) {
            oSession.oRequest.headers.Remove("Accept");
        }
        if (m_RemoveAcceptLanguage) {
            oSession.oRequest.headers.Remove("Accept-Language");
        }
        if (m_RemoveAcceptEncoding) {
            oSession.oRequest.headers.Remove("Accept-Encoding");
        }
        if (m_RemoveCookie) {
            oSession.oRequest.headers.Remove("Cookie");
        }

```

### HTML書き換え

```
    public static RulesOption("Append Xxx")
    var m_AppendXxx: boolean = false;
    // static function OnBeforeResponse(oSession: Session) {
        if (m_AppendXxx && oSession.oResponse.headers.ExistsAndContains("Content-Type", "html")) {
            var oBody = oSession.GetResponseBodyAsString();
            // Remove any compression or chunking
            oSession.utilDecodeResponse();
            var oBody = System.Text.Encoding.UTF8.GetString(oSession.responseBodyBytes);

            oBody = oBody.Replace("</body>", "<script src=\"http://hoge/hogehoge.js\"></script></body>");

            oSession.utilSetResponseBody(oBody);
        }
```

### HSTS エラー回避
#### Fiddler 4.6.1.5+

- Click Tools > Fiddler Options.
- Click the HTTPS tab.
- Ensure that the text says Certificates generated by CertEnroll engine.
- Click Actions > Reset Certificates. This may take a minute.
- Accept all prompts

#### Fiddler 4.6.1.4 and earlier

- Click Tools > Fiddler Options
- Click the HTTPS tab
- Uncheck the Decrypt HTTPS traffic checkbox
- Click the Remove Interception Certificates button. This may take a minute.
- Accept all of the prompts that appear (e.g. Do you want to delete these certificates, etc)
- (Optional) Click the Fiddler.DefaultCertificateProvider link and verify that the dropdown is set to CertEnroll
- Exit and restart Fiddler
- Click Tools > Fiddler Options.
- Click the HTTPS tab
- Re-check the Decrypt HTTPS traffic checkbox
- Accept all of the prompts that appear (e.g. Do you want to trust this root certificate)


