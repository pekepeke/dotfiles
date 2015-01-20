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

