## code

### 座標系

```
	self.superView?.convert(self.frame, to: targetView)
	targetView.convert(self.frame, from: self.superView)
```

### tableView

```
let rect = tableView.rectForRow(at: indexPath)
let rect = self.collectionViewLayout.layoutAttributesForItem(at: indexPath).frame
```


## RxSwift memo

#### rx.text/rx.controlEvent

| 操作内容                                                               | UITextField.rx.textイベントの発生回数 | 同時に発行されるUIControl.Eventイベント |
|------------------------------------------------------------------------|---------------------------------------|-----------------------------------------|
| サブスクライブ                                                         | 1回                                   | なし                                    |
| テキストフィールドをタップしてフォーカスを当てる                       | 1回                                   | editingDidBegin                         |
| 画面タップによってフォーカスを外す                                     | 1回                                   | editingDidEnd                           |
| キーボードで1文字入力する                                              | 1回                                   | editingChanged                          |
| キーボードでリターンキーをタップする                                   | 2回                                   | editingDidEndOnExitとeditingDidEnd      |
| UITextField.textにコードから文字を代入する                             | 0回                                   | なし                                    |
| UITextField.textにコードから文字を代入し、valueChangedメッセージを送る | 1回                                   | valueChanged                            |

## Xcode plugin

```
// http://qiita.com/usagimaru/items/59745e26584a00ddfba3
// http://qiita.com/u16suzu/items/c17615253561851cf32b
Alcatrazz
JDPluginManager
ColorSense
FuzzyAutocompletePlugin
HOStringSense
KSImageNamed

VVDocumenter
Lin
Xiblingual
XLog
BetterConsole
Injection for Xcode
CocoaControls
CocoaPodUI
```

## Tips
### Shortcut

- Ctrl+6 ： 表示中のクラスのメソッド一覧
- Cmd+Shift+O ： 全ファイルを対象にクラスやメソッドを検索
- Cmd+Shift+F ： 全ファイルを対象にファイル検索
- Cmd+Shift+[] ： タブ移動。[ で左に、] で右に移動
- Cmd+Ctrl+←→ ： 戻る / 進む
- Cmd+Ctrl+↑↓ ： .h / .m の切り替え
- Cmd+Ctrl+j ： カーソルのクラスやメソッドをドキュメント検索
- Cmd+クリックと同様の効果
- Cmd+0 ： Navigator（左ペイン）を開閉
- Cmd+Opt+0 ： Utilities（右ペイン）を開閉


### Print view hierarchy

```
po someView.value(forKey: "recursiveDescription")
po po UIApplication.shared.windows.first{$0.isKeyWindow}?.value(forKey: "recursiveDescription")
```

### Content Priority
- Content Hugging Priority
	- Content Hugging Priority が高いと、コンテンツのサイズを優先する
- Content Compression Resistance Priority
		- Content Compression Resistance Priority が高いと、小さくなりにくさの優先度を高くしている

### `which may not be supported by this version of Xcode.`

不足しているデバイスサポートファイルをDLして、`~/Library/Developer/Xcode/iOS\ DeviceSupport/`配下に入れる(ディレクトリはなければ作成する)
- https://github.com/filsv/iPhoneOSDeviceSupport

## Localize
### Code

```swift
// NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"] as String!
NSBundle.mainBundle().localizedInfoDictionary!["CFBundleName"] as String!
NSBundle.mainBundle().localizedInfoDictionary!["CFBundleDisplayName"] as String!
NSLocalizedString("NetworkError", comment: "NetworkError")
```

### 〜Xcode 5
- genstrings -a $(find . -name "*.m" -o -name "*.swift")
- update_storyboard_strings.sh
	- https://gist.github.com/ole/5007019
- 翻訳サービス
	- https://conyac.cc/ja
	- http://www.translated.net/ja/iphone-apps-localization

### XCode 6
- Editor > Export For Localization...
- OmegaT


## Build
### change Info.plist path
- Project -> Build Settings -> Packageing -> Info.plist File

## Memo

### Library
```
# Resource
https://github.com/mac-cain13/R.swift
https://github.com/SwiftGen/SwiftGen
https://github.com/ReactiveX/RxSwift
# Networking
https://github.com/Moya/Moya
https://github.com/Alamofire/Alamofire
https://github.com/ishkawa/APIKit
https://github.com/ashleymills/Reachability.swift
# Routing
https://github.com/hyperoslo/Compass
# Image
https://github.com/kean/Nuke
# Database
https://realm.io/
https://firebase.google.com/docs/firestore/
# Keychain
https://github.com/kishikawakatsumi/KeychainAccess
# file
https://github.com/saoudrizwan/Disk
# License
https://github.com/mono0926/LicensePlist
# Logger
https://github.com/DaveWoodCom/XCGLogger
https://github.com/SwiftyBeaver/SwiftyBeaver
# Test
https://github.com/Quick/Quick
https://github.com/kishikawakatsumi/SwiftPowerAssert
```

### Swift
#### pragma mark

```
// MARK: *****
// TODO: *****
// FIXME: *****

// 区切り線
// MARK: - *****
// TODO: ***** -
// FIXME: ***** -
```



## fastlane

https://docs.fastlane.tools/actions/

```
bundle exec fastlane actionsでアクション一覧
bundle exec fastlane listで現在のレーンの一覧
bundle exec fastlane init
```


### iOS

| アクション     | 説明                                     | 
|-----------|----------------------------------------| 
| deliver   | スクリーンショット、メタデータ、アプリをApp Storeにアップロードする | 
| snapshot  | 全デバイスを対象にアプリのスクリーンショット撮影を自動化する         | 
| frameit   | スクリーンショットを各デバイス画像にはめ込む                 | 
| pem       | プッシュ通知用のプロファイルを自動生成したり更新する             | 
| sigh      | プロビジョニングプロファイルの生成、更新、修復する              | 
| produce   | 新しいアプリをiTunes ConnectやDev Portalで作成する  | 
| cert      | 証明書の作成と管理をする                           | 
| spaceship | Apple Dev CenterやiTunes Connectにアクセスする | 
| pilot     | TestFlightのテスターを管理する                   | 
| boarding  | TestFlightのbetaテスターを招待する               | 
| gym       | アプリをビルドする                              | 
| match     | Gitを使って証明書とプロファイルを管理する                 | 
| scan      | iOSアプリ、Macアプリのテストを実行する                 | 

### Android

| アクション      | 説明                             | 
|------------|--------------------------------| 
| supply     | アプリ、メタデータをGoogle Playにアップロードする | 
| screengrab | 全デバイスを対象にアプリのスクリーンショット撮影を自動化する | 

## swiftlint
- https://qiita.com/nerd0geek1/items/9edad9a8b1d4c4051ab6
```bash
if which swiftlint >/dev/null; then
  swiftlint
else
  echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
fi
```

### .swiftlint.yml

```
# 無効にするルール
disabled_rules:
  - trailing_whitespace

# デフォルト無効で有効にするルール
opt_in_rules:
  - conditional_returns_on_newline
  - force_unwrapping
  - empty_count
#  - missing_docs
  - operator_usage_whitespace

# 対象のファイル・フォルダ
# デフォルトからフォルダ名を変更していない場合、プロジェクト名と同名のフォルダを指定すればいい
included:
  - {プロジェクト名}

# 対象外のファイル・フォルダ
# CocoaPodsでインストールしたライブラリは対象外とする
excluded:
  - Pods
  - vendor
  - Carthage
```

## Package Manager

| 操作            | CocoaPods       | Carthage           | Swift Package Manager           | 
|---------------|-----------------|--------------------|---------------------------------| 
| 基本コマンド        | pod             | carthage           | swift package                   | 
| インストール        | pod install     | carthage bootstrap | swift package resolve           | 
| アップデート確認      | pod outdated    | carthage outdated  | -                               | 
| アップデート        | pod update      | carthage update    | swift package update            | 
| パッケージの表示      | -               | -                  | swift package show-dependencies | 
| パッケージの検索      | pod search      | -                  | -                               | 
| 利用可能なパッケージの表示 | pod list        | -                  | -                               | 
| リセット          | pod deintegrate | -                  | swift package reset             | 


## make project

```
cat <<EOM >> .gitignore
# CocoaPods
Pods/
vendor/bundle

# Carthage
Carthage/Checkouts
Carthage/Build
EOM

cat <<EOM > Gemfile
source "https://rubygems.org"
# https://github.com/CocoaPods/CocoaPods/releases
gem 'cocoapods' , '1.6.0'
# 
gem 'fastlane'
EOM
bundle install --path vendor/bundle --binstubs vendor/bin

bundle exec fastlane init

# https://qiita.com/tkow/items/492c48b7ba787302b8cf

bundle exec pod setup
bundle exec pod init

touch Cartfile
cat <<EOM >> Cartfile
github "ReactiveX/RxSwift" ~> 4.0
EOM
charthage bootstrap --platform iOS
# 手動で project に追加
```



