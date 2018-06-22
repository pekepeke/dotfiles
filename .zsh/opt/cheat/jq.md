```
cat json | jq .
cat json | jq ".[], .[]?, .[2], .[10:15]"
cat json | jq ".name | length"
cat json | jq ". | keys"
cat json | jq "select( .name == "hoge" and .val >= 35 )"
cat json | jq "map( .+1 )"
cat json | jq 'if . == 0 then "zero" elif . == 1 then "one" else "many" end'
cat json | jq '"The input was \(.)"'
```

```
## https://qiita.com/takeshinoda@github/items/2dec7a72930ec1f658af
# 値の列挙
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq '.items[].name'
# ダブルクォート消し
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq -r '.items[].name'
# フィルタ
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
 | jq -r '.items[] | .name'
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq '.items[] | { name: .name, yen: .price }'
# 集計
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq '[.items[].price] | add'
# map
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq '.items | map({ name: .name, yen: .price })'
# reduce
echo '{"items":[{"item_id":1,"name":"すてきな雑貨","price":2500},{"item_id":2,"name":"格好いい置物","price":4500}]}' \
| jq 'reduce .items[] as $item (0; . + $item.price)'

# カンマは区切り文字じゃ無くて、フィルタの入力を分けるもの
echo '{"key1": "val1", "key2": "val2"}' \
| jq '[.key1, .key2]'
echo '{"key1": "val1", "key2": "val2"}' \
| jq '[.key1, (keys | map(.))]'

# from_entries - Key/Valueをオブジェクトに変換
echo '[{"Key": "tagkey", "Value": "value"},{"Key": "tagkey2", "Value": "value２"}]' \
| jq 'from_entries'

# csvで出力
cat json \
| jq -r '.items[] | [.item_id, .name, .price] | @csv'
```
