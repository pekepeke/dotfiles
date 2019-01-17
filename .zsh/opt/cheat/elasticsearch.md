## ElasticSearchについて

### Analyzer(分析の流れ)
テキスト -> char filter -> tokenizer -> token filter -> トークン化されたテキスト
#### char filter
テキストになにかしらの処理をする。例、HTMLタグを削除する。

#### tokenizer
char filterで処理されたテキストをトークン化する。例、形態素解析、N-gram

#### token filter
tokenizerでトークン化された単語(トークン)になにかしらの処理をする。


### Char filter
#### icu_normalizer
文字の正規化、大文字を小文字に統一したり、①を1にしたりする。設定はデフォルのまま。
ICU Analysis Pluginを入れる必要があります。
また、char filterで正規化をするため、filterでcjk_width、lowercaseを使用しません。

#### html_strip
HTMLタグを削除する。

#### kuromoji_iteration_mark (Type : CharFilter)
日本語の々、ヽ、ゝ などの踊り字をノーマライズ

```
        analyzer:
            kanji_iteration_mark:
                type: kuromoji_iteration_mark
                normalize_kanji: true
                normalize_kana: false
            kana_iteration_mark:
                type: kuromoji_iteration_mark
                normalize_kanji: false
                normalize_kana: true
```

### Analyzer
kuromoji (Type : Analyzer)
各種 tokenizer、fokenfilter を組合せるための analyzer

### Tokenizer
#### kuromoji_tokenizer
日本語形態素解析器

##### mode について
- mode : normal
このモードは、単語は分割されません。
“関西国際空港” ⇒ “関西国際空港”
“アブラカタブラ” ⇒ “アブラカタブラ”
- mode : search
このモードは、最小単位の単語の分割された単語と同義語として長い単語の両方を含みます。
“関西国際空港” ⇒ “関西” “関西国際空港” “国際” “空港”
“アブラカタブラ” ⇒ “アブラカタブラ”
- mode : extended
このモードは、未知の単語をユニグラム（1文字単位）に分割します。
“関西国際空港” ⇒ “関西” “国際” “空港”
“アブラカタブラ” ⇒ “ア” “ブ” “ラ” “カ” “タ” “ブ” “ラ”

### Token filter
#### cjk_width
全角記号を半角に統一したり、全角英数字を半角に統一したり、半角カタカナを全角に統一する為のフィルター
```
        analyzer:
            normalize:
                tokenizer: whitespace
                filter: [cjk_width]
```

#### lowercase
英字の大文字を小文字に変換する為のフィルター

```
        analyzer:
            lowercase:
                tokenizer: whitespace
                filter: [lowercase]
```

#### synonym
同義語を展開する為のフィルター
※Synonym Token Filter を日本語と一緒に使用する場合は、辞書の内容もトークナイザーの仕様にあわせて単語を分割して登録しておく必要がある
○：tokyo, 首都␣圏, 東京␣都 ※ ␣は半角スペース
×：tokyo, 首都圏, 東京都

```
        filter:
            synonym_dict:
                type: synonym
                synonyms_path: analysis/synonym.txt
        analyzer:
            synonym:
                tokenizer: standard
                filter: [synonym_dict]
```

#### stopword_dict
任意の単語を除外する為のフィルター

```
    analysis:
        stopword_dict:
            type: stop
            stopwords_path: analysis/stopword.txt
    analyzer:
        stopword:
            tokenizer: standard
            filter: [lowercase, stopword_dict]
```

#### kuromoji_baseform
動詞、形容詞を原型に戻す。インデックス、クエリともに適応される。
”飲み放題” と言う単語を”飲む”でもマッチさせたい場合に使用する。
例、「美しく」を「美しい」に変換する。

#### kuromoji_part_of_speech
特定の品詞を削除する。インデックス、クエリともに適応される。設定はデフォルトのまま。

#### kuromoji_readingform (Type : TokenFilter)
カタカナまたは、ローマ字読みに変換

```
        filter:
            romaji:
                type: kuromoji_readingform
                use_romaji: true
            katakana:
                type: kuromoji_readingform
                use_romaji: false
```

#### kuromoji_stemmer
カタカナの末尾の伸ばし棒を削除する。インデックスからもクエリされる。例、「コンピューター」を「コンピュータ」に変換する。


### from http://code46.hatenablog.com/entry/2014/01/21/115620
- /_plugin/head/

```
curl -XPOST localhost:9200/ldgourmet -d @mapping.json
```

#### mapping.json
```
{
  "settings": {
    "analysis": {
      "analyzer": {
        "ngram_analyzer": {
          "tokenizer": "ngram_tokenizer"
        }
      },
      "tokenizer": {
        "ngram_tokenizer": {
          "type": "nGram",
          "min_gram": "2",
          "max_gram": "3",
          "token_chars": [
            "letter",
            "digit"
          ]
        }
      }
    }
  },
  "mappings": {
    "restaurant": {
      "properties": {
        "restaurant_id": {
          "type": "integer"
        },
        "name": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "name_alphabet": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "name_kana": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "address": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "description": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "purpose": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "category": {
          "type": "string",
          "analyzer": "whitespace"
        },
        "photo_count": {
          "type": "integer"
        },
        "menu_count": {
          "type": "integer"
        },
        "access_count": {
          "type": "integer"
        },
        "closed": {
          "type": "boolean"
        },
        "location": {
          "type": "geo_point",
          "store": "yes"
        }
      }
    },
    "rating": {
      "properties": {
        "rating_id": {
          "type": "integer"
        },
        "total": {
          "type": "integer"
        },
        "food": {
          "type": "integer"
        },
        "service": {
          "type": "integer"
        },
        "atmosphere": {
          "type": "integer"
        },
        "cost_performance": {
          "type": "integer"
        },
        "title": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "body": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        },
        "purpose": {
          "type": "string",
          "analyzer": "ngram_analyzer"
        }
      }
    }
  }
}
```

### reindex

```
curl -XPOST localhost:9200/_reindex?pretty -d'{
  "source": {
    "index": "src"
  },
  "dest": {
    "index": "dest"
  }
}'
```
