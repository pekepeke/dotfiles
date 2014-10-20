# arch を確認
lipo -info [path_for_binary]
xcrun lipo -info [path_for_binary]

# .a を結合
lipo -create libAbesi_dev.a libAbesi_sim.a -output libAbesi.a
# .a を分解
lipo -thin armv7 AWSiOSSDK -output AWSiOSSDK_armv7
# .a の中の .o を検索
ar -t AWSiOSSDK_armv7|grep SBJson
# 特定の .o を削除
ar -dv AWSiOSSDK_armv7 SBJsonParser.o SBJsonWriter.o

# universal binary の build について
# http://qiita.com/fizzco/items/8f3fbc744e591ba8dffe

