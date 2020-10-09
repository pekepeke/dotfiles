## Tips
### Shortcut
#### Workspace Organization
1. Hide / Show Navigation Area : ⌘+0
2. Hide/Show Debugging Area : ⌘+⇧+Y
3. Hide/Show Utility Area : ⌘+⌥+ 0
4. Split screen/open Assistant Editor in the Editor Area : ⌘ +⌥ + ⏎
5. Opens a new tab above the navigator, editor & utility areas : ⌘ + T
6. Close the current tab : ⌘ + W

#### Code Formatting & Beautification
1. Confirms the auto-completion suggestion : ⇥ OR ⌃ + /
2. Comment or Uncomment : ⌘ + /
3. Re-indent the whole function: ⌃ + I
4. Hides / expands a class or method body :⌥+⌘+⇢ OR ⌥+⌘+⇠
5. Auto documentation : ⌘ +⌥ + /

#### Debugging
1. Add and Remove breakpoints : ⌘ + \
2. Disable/Enable all breakpoints : ⌘ + Y

#### Building
1. Build : ⌘ + B
2. Run & Build if necessary :⌘ + R
3. Stop the current build/run/testing : ⌘ + .
4. Run tests & Build if necessary: ⌘ + U
5. Clean : ⌘ + K
6. Clean All files and build folder : ⇧ + ⌘ + K
7. Profile (Instruments): ⌘ + I
8. Choose scheme : ⌃ + 0
9. Choose Destination : ⌃ + ⇧ + 0
10. Re-run the last run tests : ⇧ + ⌘ + ⌥ + G

#### 
1. Jump to a line : ⌘ + L
2. Left panel tabs switch : ⌘ + (1–7)
3. Right panel tabs switch :⌘ +⌥ + 1-6
4. Search for lines of text in your files : ⌘+⇧+F
5. Quick find/open : ⇧ + ⌘ + O

#### Simulator
1. Copy current screen : ⌃ + ⌘+ C
2. Take Screenshot : ⌘ + S
3. Go to Home :⇧+ ⌘ + H
4. Shake Gesture : ⌃ + ⌘+ Z
5. Toggle software keyboard : ⌘ + K

### シミュレータのフォントがおかしい件を修正する
- [Edit scheme]-[Run ???.app]を表示し、[Arguments Passed On Launch]に以下の値を追加。

```
-AppleLanguages (ja)
```

### 関連するディレクトリ


```
# DeveloperのArchiveの履歴
sudo rm -rf ~/Library/Developer/Xcode/Archives
# シミュレーターに過去に入れたアプリ
sudo rm -rf ~/Library/Developer/Xcode/DerivedData
# iOSのDevice
sudo rm -rf ~/Library/Developer/Xcode/iOS\ DeviceSupport/6.0*
# Simulator のログ
sudo rm -rf ~/Library/Logs/iOS\ Simulator
# キャッシュ
sudo rm -rf ~/Library/Caches
```


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


## コマンドライン
### binary の結合

```
# arch を確認
lipo -info [path_for_binary]
xcrun lipo -info [path_for_binary]

# .a を結合
lipo -create libAbesi_dev.a libAbesi_sim.a -output libAbesi.a
# .a を分解
lipo -thin armv7 AWSiOSSDK -output AWSiOSSDK_armv7
# .a の中の .o を検索
ar -t AWSiOSSDK_armv7 | grep SBJson
# 特定の .o を削除
ar -dv AWSiOSSDK_armv7 SBJsonParser.o SBJsonWriter.o

# universal binary の build について
# http://qiita.com/fizzco/items/8f3fbc744e591ba8dffe
```

## plist 編集

```
# PlistBuddy read
PlistBuddy  -c "Print CFBundleShortVersionString"  /path/to/plilst
# PlistBuddy write
 -c "Set :CFBundleShortVersionString 1.0.0" /path/to/plilst
# by xpath
xpath App-Info.plist "/plist/dict/key[.='CFBundleVersion']/following-sibling::*[1]/text()"
python -c "from lxml.etree import parse; from sys import stdin; print '\n'.join(parse(stdin).xpath('/plist/dict/key[.=\"CFBundleVersion\"]/following-sibling::*[1]/text()'))"
```

## コマンドラインビルド

```
# command line tool の install
xcode-select --install
# command line tool の設定確認
xcode-select --print-path

# command line tool の切り替え
sudo xcode-select -switch /Applications/Xcode5.1.1/Xcode.app

# SDK の表示
xcodebuild -showsdks
# configuration, target の確認
xcodebuild -list
xcodebuild -list -project <your_project_name>.xcodeproj

# build
xcodebuild -configuration Release -sdk macosx10.10
xcodebuild -scheme [cheme] build
xcodebuild -target [target] -xcconfig [file.xcconfig]
# run test
xcodebuild test -scheme MyMacApp -destination 'platform=OS X, arch=x86_64'
xcodebuild test -scheme MyiOSApp -destination 'platform=iOS,id=998058a1c30d845d0dcec81cd6b901650a0d701c'
xcodebuild test -scheme MyiOSApp -destination 'platform=iOS,name=iPod touch'
xcodebuild test -scheme MyiOSApp -destination 'platform=iOS Simulator,name=iPad'
xcodebuild test -scheme MyiOSApp -destination 'platform=iOS Simulator,name=iPhone Retina (4-inch 64-bit),OS=7.1'

# show uuid
system_profiler SPUSBDataType | sed -n -E -e '/(iPhone|iPad)/,/Serial/s/ *Serial Number: *(.+)/\1/p'
system_profiler SPUSBDataType | sed -n -e '/iPad/,/Serial/p' -e '/iPhone/,/Serial/p'
system_profiler SPUSBDataType | sed -n -E -e '/(iPad|iPhone)/,/Serial/s/ *Serial Number: *(.+)/\1 \2/p'

```
