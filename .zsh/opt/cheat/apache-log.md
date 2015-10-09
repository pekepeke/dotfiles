
## parse log

```
### combined
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{print $6}'
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{sum[$6]+=1}; END { for (key in sum) { print key,  sum[key] }}'
| perl -ne 'print join("\t",  /^(.*?) (.*?) (.*?) \[(.*?)\] "(.*?)" (.*?) (.*?) "(.*?)" "(.*?)"/),  "\n"' | awk -F'\t' '{print $9}'
### common でも利用可能
| perl -pe 's/ (?:\[(.*?)\]|"(.*?)"|(\S*))/\t$1$2$3/g' | awk -F'\t' '{print $9}'

5 = uri
6 = status code
8 = referer
9 = ua

### ltsv
| perl -F'\t' -nale '%h=map{split/:/, $_, 2}@F;print"$h{time}\t$h{ua}"'
```

