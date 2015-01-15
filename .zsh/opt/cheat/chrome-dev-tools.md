## 最後の評価結果の参照
$_

## ファイル選択
Cmd+O
## 関数選択
Cmd+Shift+O
## 指定行へ移動
Cmd+L
## ソースの grep
Cmd+Opt+F

## debug
### Pause/Continue
F8
### Step over
F10
### Step into
F11
### Step out
Shift+F11

## Exception 発生
ステータスバーのポーズボタンを1回クリックですべての Exception をブレーク
もう一回クリックで catch されていない Exception をブレーク

## Workers
Pause on start にチェックを入れておくと、Web Workers 開始時にブレークする

## Console command

```javascript
$                  // getElementById
$$                 // querySelectorAll
$x                 // XPATH
clear              // コンソールクリア
copy               // クリップボードにコピー
dir                // オブジェクトツリーの表示
dirxml             // DOMツリーの表示
$0, $1, $2, $3, $4 // 前回フォーカスした要素を選択
inspect            // 要素を Elements パネルでフォーカス
keys               // オブジェクトの key を取得
monitorEvents      // 特定のイベントをモニタ
unmonitorEvent     // モニタを解除
profile            // profile 実行
profileEnd         // profile 終了
values             // オブジェクトの値を取得
```

## High Resolution Time

```javascript
performance.now() // webkitNow()
// performance.timing.navigationStart からの経過時間をミリ秒以下の精度で取得
```
