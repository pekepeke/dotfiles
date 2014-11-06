# set/show value
/usr/libexec/PlistBuddy -c "Set :CFBundleSubversionRevision $revisionNumber" xxx.plist
buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" xxx.plist)
# set/show array
/usr/libexec/PlistBuddy -c "Set PreferenceSpecifiers:2:DefaultValue $productVersion" xxx.plist
/usr/libexec/PlistBuddy -c "Print PreferenceSpecifiers:2:DefaultValue" xxx.plist
