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

