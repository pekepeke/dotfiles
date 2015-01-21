## 依存関係のチェック

```
# 依存関係表示
otool -L /opt/local/lib/libpango-1.0.0.dylib
# id表示
otool -D /opt/local/lib/libpango-1.0.0.dylib
# 書き換え対象のみ抽出する例
otool -L /opt/local/lib/libpango-1.0.0.dylib | egrep -v "$(otool -D $_)" | egrep -v "/(usr/lib|System)" | grep -o "/.*dylib"
```

## パスの書き換え

```
install_name_tool -change /opt/local/lib/libgobject-2.0.0.dylib \
"@executable_path/lib/libgobject-2.0.0.dylib" \
/opt/local/lib/libpango-1.0.0.dylib
```

