
### query
```
curl -XGET 'http://localhost:9200/ldgourmet/restaurant/_search?pretty=true' -d '
{
  "query" : {
    "simple_query_string" : {
      "query": "目黒 とんき",
      "fields": ["_all"],
      "default_operator": "and"
    }
  }
}
'
 curl -XGET 'http://localhost:9200/ldgourmet/restaurant/_search?pretty=true' -d '
{
  "query" : {
    "simple_query_string" : {
      "query": "東京 ラーメン",
      "fields": ["name", "name_kana", "address"],
      "default_operator": "and"
    }
  },
  "sort" : [{ "access_count" : {"order" : "desc", "missing" : "_last"}}]
}
'
```

#### create index
```
curl -XPUT 'http://localhost:9200/twitter/' -d '
index :
    number_of_shards : 3 
    number_of_replicas : 2 
'
curl -XPUT 'http://localhost:9200/twitter/' -d '{
    "settings" : {
        "index" : {
            "number_of_shards" : 3,
            "number_of_replicas" : 2
        }
    }
}'
```

#### put mapping

```
curl -XPUT 'http://localhost:9200/twitter/_mapping/tweet' -d '
{
    "tweet" : {
        "properties" : {
            "message" : {"type" : "string", "store" : true }
        }
    }
}
'
```

### query - qiita.com/kieaiaarh/items/5ea4e8a188bd9814000d

#### カラム指定検索みたいな

```code:elasticsearch
 
{
  "query": { "match_all": {} },
  "_source": ["account_number", "balance"]
}'

```

`The match_all query is simply a search for all documents in the specified index.`
とあるが、実際には上記の通り先頭10件のみ出力される

#### SQLで言うところのLIMIT句的な
```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match_all": {} },
  "from": 10, # 11番目から
  "size": 10  # 20番目まで（件数指定）
}
```

`The from parameter (0-based)` デフォルトはZEROスタート

* 検索結果件数だけを見たい場合は、`size:0`にする

`size=0 to not show search hits because we only want to see the aggregation results in the response.`

#### ソート
```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match_all": {} },
  "sort": { "balance": { "order": "desc" } }
}'
```

account balanceで降順ソート

#### SQLで言うところのSELECT
```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match_all": {} },
  "_source": ["account_number", "balance"]
}'
```

`_source field in the search hits`
ということ。

#### SQLで言うところのWHERE的な
#####`match query`
* 単一条件指定

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match": { "account_number": 20 } }
}'
```

* LIKE的な

` returns all accounts containing the term "mill" in the address:`

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match": { "address": "mill" } }
}'
```

* 複数LIKE的な

`returns all accounts containing the term "mill" or "lane" in the address:`

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match": { "address": "mill lane" } } # mill or laneを含むもの 
}'
```

* 特定のフレーズを含む検索

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": { "match_phrase": { "address": "mill lane" } }
}'
```

* boo(lean) query
` returns all accounts containing "mill" and "lane" in the address:`

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": {
    "bool": {
      "must": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}'
```
※and条件みたいなもの` "mill" and "lane" `
※反対が`must_not`

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": {
    "bool": {
      "should": [
        { "match": { "address": "mill" } },
        { "match": { "address": "lane" } }
      ]
    }
  }
}'
```
※or条件みたいなもの ` "mill" or "lane" `

* `bool`句での複合条件指定

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": {
    "bool": {
      "must": [
        { "match": { "age": "40" } }
      ],
      "must_not": [
        { "match": { "state": "ID" } }
      ]
    }
  }
}'
```

` returns all accounts of anybody who is 40 years old but don’t live in ID(aho):`

#### score field
というものが、responseにあります。

`a numeric value that is a relative measure of how well the document matches the search query that we specified`

デフォルトのクエリでは検索クエリとのマッチ度を計算して、score フィールドに返している

#### Filters
` In cases where we do not need the relevance scores, Elasticsearch provides another query capability in the form of filters.`

##### メリット
1. スコアリング（検索クエリとのマッチ度計算）しないため、高速
2. キャッシュが効く

* `Filters do not score so they are faster to execute than queries` 
* `Filters can be cached in memory allowing repeated search executions to be significantly faster than queries`

##### 複合条件指定ができる
` the filtered query allows you to combine a query (like match_all, match, bool, etc.) together with a filter`


```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "query": {
    "filtered": {
      "query": { "match_all": {} },
      "filter": {
        "range": {
          "balance": {
            "gte": 20000,
            "lte": 30000
          }
        }
      }
    }
  }
}'
```

* query -> SELECT
* filter -> where

みたいなとこ。

#### aggregations(集約)
##### 合計

```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state"
      }
    }
  }
}'
```


`sorted by count descending (also default):` デフォルトは降順

SQLだと、
`SELECT state, COUNT(*) FROM bank GROUP BY state ORDER BY COUNT(*) DESC`

みたいな感じとのこと。

##### 平均
```
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
{
  "size": 0,
  "aggs": {
    "group_by_state": {
      "terms": {
        "field": "state"
      },
      "aggs": {
        "average_balance": {
          "avg": {
            "field": "balance"
          }
        }
      }
    }
  }
}'
```

#### Common option
REST APIで下記が使用可能

* `?pretty=true` # jsonでretrunされる（が、基本デバっグでのみ使うべし！）
* `?format=yaml` # yamlでreturnされる
* `?human=false` # 人間でもわかりやすいreturnをoffる（デフォルトはfalse)

##### response filtering
```
curl -XGET 'localhost:9200/_search?pretty&filter_path=took,hits.hits._id,hits.hits._score' # 返り値を絞りこむ
{
  "took" : 3,
  "hits" : {
    "hits" : [
      {
        "_id" : "3640",
        "_score" : 1.0
      },
      {
        "_id" : "3642",
        "_score" : 1.0
      }
    ]
  }
}
```
もちろん、ワイルドカードもあり
```
curl 'localhost:9200/_segments?pretty&filter_path=indices.**.version'
{
  "indices" : {
    "movies" : {
      "shards" : {
        "0" : [ {
          "segments" : {
            "_0" : {
              "version" : "5.2.0"
            }
          }
        } ],
        "2" : [ {
          "segments" : {
            "_0" : {
              "version" : "5.2.0"
            }
          }
        } ]
      }
    },
    "books" : {
      "shards" : {
        "0" : [ {
          "segments" : {
            "_0" : {
              "version" : "5.2.0"
            }
          }
        } ]
      }
    }
  }
}
```

##### _source
elasricsearchはrawデータを返す場合もありのことで、下記のようにして、必要最低限のソースのみに絞り込むとよい

```
curl -XGET 'localhost:9200/_search?pretty&filter_path=hits.hits._source&_source=title'
{
  "hits" : {
    "hits" : [ {
      "_source":{"title":"Book #2"}
    }, {
      "_source":{"title":"Book #1"}
    }, {
      "_source":{"title":"Book #3"}
    } ]
  }
}
```


