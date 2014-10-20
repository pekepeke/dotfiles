## Major番号.Minor番号.Patch番号[-pre release][+build meta]
1.0.0[-pre release][+build meta]

- Major番号：後方互換性がない変更の時にインクリメントする番号です。
- Minor番号：後方互換性がある変更の時にインクリメントする番号です。
- Patch番号：バグ修正の時にインクリメントする番号です。
- pre release: alpha, beta,RC 等。付与されている場合、通常バージョンよりも低いバージョン扱いとなる。
- build meta : ビルドメタデータ。バージョンの大小に影響を与えない

## 比較演算子
### Gemfile

```ruby
gem "hoge", "2.1.8"      # 2.1.8のみ使う
gem "hoge", "~> 2.1"     # 2.1.0以上3.0.0未満の最新のものを使用
gem "hoge", "~> 2.1.8"   # 2.1.8以上2.2.0未満の最新のものを使用
gem "hoge"               # 最新に追従
gem "hoge", ">= 2.1.3"   # 2.1.3以上の最新のものを使う
```

### npm(package.json)
- "version"             : version との完全一致
- ">version"            : version より大きい
- ">=version            : version 以上
- "<version             : version より小さい
- "<=version            : version 以下
- "~version "           : version"と近しいもの。(http://liberty-technology.biz/PublicItems/npm/misc/semver.html)
- "1.2.x"               : 1.2.0, 1.2.1, 等. 1.3.0 は対象外
- "http://..."          : URLで依存性を参照
- "*"                   : 全バージョン
- ""                    : (空文字) *と同等
- "version1 - version2" : >=version1 <=version2 と同等
- "range1 || range2"    : range1 もしくは range2
- "git..."              : Git URLで依存性を参照
- "user/repo"           : See 'GitHub 参照


