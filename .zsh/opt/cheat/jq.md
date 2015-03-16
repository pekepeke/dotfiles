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
