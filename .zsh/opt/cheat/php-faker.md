
@see https://qiita.com/tosite0345/items/1d47961947a6770053af
## プロパティチートシート

|戻り値の型      |変数名   |日本語訳   |実例   |
|--------------|------|----|----|
| string       | name | 名 | Dr. Nova Romaguera DVM | 
| string       | firstName | ファーストネーム | Ara | 
| string       | firstNameMale | ファーストネーム（男性） | Sonny | 
| string       | firstNameFemale | ファーストネーム（女性） | Cathryn | 
| string       | lastName | 苗字 | Carter | 
| string       | title | 敬称 | Miss | 
| string       | titleMale | 敬称（男性） | Dr. | 
| string       | titleFemale | 敬称（女性） | Dr. | 
| string       | citySuffix | 都市接頭辞 | port | 
| string       | streetSuffix | ストリート接頭辞 | Harbors | 
| string       | buildingNumber | 建物番号 | 611 | 
| string       | city | 都市名 | Maymietown | 
| string       | streetName | ストリート名 | Tamara Island | 
| string       | streetAddress | 住所（県より下から？） | 7302 Olson Terrace Suite 409 | 
| string       | postcode | 郵便番号 | 84857 | 
| string       | address | 住所（県から全て？） | 284 Dicki Ports Suite 992 West Kevenport, HI 17690-8028 | 
| string       | country | 国 | Sierra Leone | 
| float        | latitude | 緯度 | 57.091455 | 
| float        | longitude | 経度 | 95.512512 | 
| string       | ean13 | EAN-13（バーコード） | 4757842760420 | 
| string       | ean8 | EAN-8 | 24934060 | 
| string       | isbn13 | ISBN-13（書籍コード） | 9786957525803 | 
| string       | isbn10 | ISBN-10 | 7953440733 | 
| string       | phoneNumber | 電話番号 | +1-832-333-7325 | 
| string       | company | 会社 | Johnston LLC | 
| string       | companySuffix | 会社接尾辞 | Ltd | 
| string       | jobTitle | 職名 | History Teacher | 
| string       | creditCardType                 | クレジットカード種類 | MasterCard | 
| string       | creditCardNumber               | クレジットカード番号 | 4916146807378620 | 
| DateTime     | creditCardExpirationDate       | クレジットカード有効期限 | "date": "2017-10-26 22:00:33.000000"<br>"timezone_type": 3<br>"timezone": "Asia/Tokyo" |
| string       | creditCardExpirationDateString | クレジットカード有効期限（日付文字列） | 08/19 | 
| array        | creditCardDetails | クレジットカード詳細 | "type" => "Visa",<br>"number" => "4485071238445701",<br>"expirationDate" => "10/17",<br>"name" => "Conner Greenholt", |
| string       | bankAccountNumber | 銀行口座番号 | 15217633371 | 
| string       | swiftBicNumber | SWIFTコード（銀行コード） | KFMAOAVNOAJ | 
| string       | vat | VAT（付加価値税？） | （エラー） | 
| string       | word | ワード | dolore | 
| string|array | words | 言葉 | 0 => "odit",<br>1 => "quibusdam",<br>2 => "ipsam", |
| string       | sentence | 文 | Et sapiente omnis beatae eligendi. | 
| string|array | sentences | 文章 | 0 => "Et quo molestiae occaecati voluptatibus at exercitationem.",<br>1 => "Quas sint eaque exercitationem natus voluptates ipsum quaerat.",<br>2 => "Nostrum adipisci sequi corporis incidunt minus nisi nemo.", |
| string       | paragraph | 段落（単行） | Aut occaecati aliquid est porro necessitatibus molestias. Inventore qui magnam accusamus quos aliquam molestiae provident nihil. Minus ut non laboriosam fugit. | 
| string|array | paragraphs | 段落（複数行） | 0 => "Dicta eaque et vel. Cumque delectus a nisi molestiae perspiciatis molestias. Dolorem debitis dignissimos veniam et modi sit.",<br>1 => "Rerum rerum et et cum quis. Aspernatur accusantium quasi iusto iure iusto. Nihil cupiditate voluptatem omnis qui. Natus odio omnis quis dolorum. Magni ea autem aliquam cupiditate dolorum accusantium dolore.",<br> 2 => "Porro et voluptas dolores saepe. Quis et sequi voluptatem provident eos. Reiciendis ea quibusdam accusantium eos adipisci sapiente. Illo vitae quia repudiandae voluptatem reprehenderit minus ut error.", |
| string       | text | テキスト | Rem illum et aut mollitia. Velit perspiciatis dolore vel sed et sequi reiciendis. Quibusdam libero debitis enim aut. | 
| string       | email | Eメール | victor50<span>@</span>hotmail.com | 
| string       | safeEmail | 安全な電子メール（存在しない） | mallory27<span>@</span>example.com | 
| string       | freeEmail | 無料の電子メール（場合によっては存在する） | kaela.deckow<span>@</span>gmail.com | 
| string       | companyEmail | 会社の電子メール | cswift<span>@</span>osinski.com | 
| string       | freeEmailDomain | 無料の電子メールドメイン（存在する） | hotmail.com | 
| string       | safeEmailDomain | 安全な電子メールドメイン（存在しない） | example.org | 
| string       | userName | ユーザー名 | raoul68 | 
| string       | password | パスワード | PVqg5V!{/6MWHzg/FLe] | 
| string       | domainName | ドメイン名 | runolfsdottir.net | 
| string       | domainWord | ドメインワード | grady | 
| string       | tld | トップレベルドメイン | com | 
| string       | url | URL | http\://olson.info/ | 
| string       | slug | スラグ | possimus-ut-quia-consequatur-officia | 
| string       | ipv4 | IPv4 | 105.81.125.129 | 
| string       | ipv6 | IPv6 | ef5a:ef5c:a6c4:bc44:8433:b1b2:d265:b886 | 
| string       | localIpv4 | ローカルなIPv4 | 10.55.156.47 | 
| string       | macAddress | Macアドレス | A6:95:18:97:0F:EE | 
| int          | unixTime | UNIX時間 | 477897933 | 
| DateTime     | dateTime | 日付時刻 | "date": "1977-01-12 18:33:31.000000"<br>"timezone_type": 3<br>"timezone": "Asia/Tokyo" |
| DateTime     | dateTimeAD | 日付時刻（西暦紀元） | "date: 1856-02-08 01:29:08.000000<br>"timezone_type: 3<br>"timezone": "Asia/Tokyo" |
| string       | iso8601 | ISO8601 | 1971-04-30T10:19:35+0900 | 
| DateTime     | dateTimeThisCentury | 日付時刻（今の世紀） | "date: 1944-03-07 04:07:04.000000<br>"timezone_type: 3<br>"timezone": "Asia/Tokyo" |
| DateTime     | dateTimeThisDecade | 日付時刻（直近１０年内） | "date: 2015-11-25 15:30:00.000000<br>"timezone_type: 3<br>"timezone": "Asia/Tokyo" |
| DateTime     | dateTimeThisYear | 日付時刻（今年） | "date: 2016-12-13 17:21:21.000000<br>"timezone_type: 3<br>"timezone": "Asia/Tokyo" |
| DateTime     | dateTimeThisMonth | 日付時刻（今月） | "date: 2017-09-25 10:40:14.000000<br>"timezone_type: 3<br>"timezone": "Asia/Tokyo" |
| string       | amPm | 午前・午後 | pm | 
| int          | dayOfMonth | 日 | 18 | 
| int          | dayOfWeek | 曜日 | Saturday | 
| int          | month | 月 | 11 | 
| string       | monthName | 月名 | July | 
| int          | year | 年 | 1981 | 
| int          | century | 世紀 | III | 
| string       | timezone | タイムゾーン | America/Caracas | 
| string       | md5 | MD5 | a1726594f03a11892b5697b710fe23d8 | 
| string       | sha1 | SHA-1 | 708259c55f1d4aabbaf4a142cea2ede36c142c7f | 
| string       | sha256 | SHA-256 | 1054fe8d2367cbbcfcc7d35c05a2fa497885bcf10c91785dcc1ecc1f25142f80 | 
| string       | locale | 場所 | hu_HU | 
| string       | countryCode | 国コード | MX | 
| string       | countryISOAlpha3 | 国（ISO alpha-3基準？） | SAU | 
| string       | languageCode | 言語コード | ng | 
| string       | currencyCode | 通貨コード | ZWL | 
| boolean      | boolean | ブール値 | true | 
| int          | randomDigit | ランダムな桁 | 8 | 
| int          | randomDigitNotNull | ランダムな桁（Null以外） | 2 | 
| string       | randomLetter | ランダム文字 | p | 
| string       | randomAscii | ランダムアスキー | = | 
| string       | macProcessor | MACプロセッサ | Intel | 
| string       | linuxProcessor | LINUXプロセッサ | x86_64 | 
| string       | userAgent | ユーザーエージェント | Opera/9.52 (Windows NT 6.0; sl-SI) Presto/2.11.177 Version/10.00 | 
| string       | chrome | Chrome | Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/5330 (KHTML, like Gecko) Chrome/37.0.831.0 Mobile Safari/5330 | 
| string       | firefox | FireFox | Mozilla/5.0 (X11; Linux i686; rv:5.0) Gecko/20160719 Firefox/37.0 | 
| string       | safari | Safari | Mozilla/5.0 (iPad; CPU OS 7_1_1 like Mac OS X; en-US) AppleWebKit/532.19.5 (KHTML, like Gecko) Version/4.0.5 Mobile/8B116 Safari/6532.19.5 | 
| string       | opera | Opera | Opera/9.15 (X11; Linux i686; en-US) Presto/2.8.273 Version/12.00 | 
| string       | internetExplorer | InternetExplorer | Mozilla/5.0 (compatible; MSIE 5.0; Windows NT 4.0; Trident/5.1) | 
| string       | windowsPlatformToken | Windowsプラットフォームトークン | Windows NT 5.01 | 
| string       | macPlatformToken | MACプラットフォームトークン | Macintosh; U; Intel Mac OS X 10_7_8 | 
| string       | linuxPlatformToken | LINUXプラットフォームトークン | X11; Linux x86_64 | 
| string       | uuid | UUID | da624486-709e-3720-81e4-f9dc3a302f99 | 
| string       | mimeType | MIMEタイプ | video/x-fli | 
| string       | fileExtension | 拡張子ファイル | ims | 
| string       | hexColor | 16進数カラーコード | #b17501 | 
| string       | safeHexColor | セーフカラー16進数コード | #00dd77 | 
| string       | rgbColor | RGBカラー | 205244170 | 
| array        | rgbColorAsArray | RGBカラー（配列） | 0 => 88,<br>1 => 114,<br>2 => 163, |
| string       | rgbCssColor | RGB（CSS） | rgb(102,225,202) | 
| string       | safeColorName | セーフカラー名 | white | 
| string       | colorName | カラー名 | AliceBlue | 

##メソッドチートシート

 |戻り値の型   |メソッド名 |引数 |翻訳 |
-|-----------|----|------|------|
 | string            | name | string \$gender = null | 名前 | 
 | string            | firstName | string \$gender = null | ファーストネーム | 
 | string            | title | string \$gender = null | 敬称 | 
 | string            | creditCardNumber | \$type = null,<br> \$formatted = false,<br> \$separator = '-' | クレジットカード番号 | 
 | string            | iban | \$countryCode = null,<br> \$prefix = '',<br><br> \$length = null | IBANコード（インターネットバンキングコード） | 
 | string or array     | words | \$nb = 3,<br> \$asText = false | 言葉 | 
 | string            | sentence | \$nbWords = 6,<br> \$variableNbWords = true | 文 | 
 | string or array     | sentences | \$nb = 3,<br> \$asText = false | 文章 | 
 | string            | paragraph | \$nbSentences = 3,<br> \$variableNbSentences = true | 段落（単行） | 
 | string or array     | paragraphs | \$nb = 3,<br> \$asText = false | 段落（複数行） | 
 | string            | text | \$maxNbChars = 200 | テキスト | 
 | string            | realText | \$maxNbChars = 200,<br> \$indexSize = 2 | リアルテキスト | 
 | string            | password | \$minLength = 6,<br> \$maxLength = 20 | パースワード | 
 | string            | slug | \$nbWords = 6,<br> \$variableNbWords = true | スラグ | 
 | string            | amPm | \$max = 'now' | 午前午後 | 
 | string            | date | \$format = 'Y-m-d',<br> \$max = 'now' | 日付 | 
 | string            | dayOfMonth | \$max = 'now' | 日 | 
 | string            | dayOfWeek | \$max = 'now' | 曜日 | 
 | string            | iso8601 | \$max = 'now' | ISO8601 | 
 | string            | month | \$max = 'now' | 月 | 
 | string            | monthName | \$max = 'now' | 月名 | 
 | string            | time | \$format = 'H:i:s',<br> \$max = 'now' | 時間 | 
 | string            | unixTime | \$max = 'now' | UNIX時間 | 
 | string            | year | \$max = 'now' | 年 | 
 | DateTime          | dateTime | \$max = 'now',<br> \$timezone = null | 日付時刻 | 
 | DateTime          | dateTimeAd | \$max = 'now',<br> \$timezone = null | 日付時刻（西暦紀元） | 
 | DateTime          | dateTimeBetween | \$startDate = '-30 years',<br> \$endDate = 'now' | 日付時刻（指定した範囲） | 
 | DateTime          | dateTimeInInterval | \$date = '-30 years',<br> \$interval = '+5 days',<br> \$timezone = null | 日付間隔 | 
 | DateTime          | dateTimeThisCentury | \$max = 'now',<br> \$timezone = null | 日付時刻（今の世紀） | 
 | DateTime          | dateTimeThisDecade | \$max = 'now',<br> \$timezone = null | 日付時刻（直近１０年内） | 
 | DateTime          | dateTimeThisYear | \$max = 'now',<br> \$timezone = null | 日付時刻（今年） | 
 | DateTime          | dateTimeThisMonth | \$max = 'now',<br> \$timezone = null | 日付時刻（今月） | 
 | boolean           | boolean | \$chanceOfGettingTrue = 50 | ブール値 | 
 | int               | randomNumber | \$nbDigits = null,<br> \$strict = false | 乱数 | 
 | int or string or null | randomKey | array \$array = array | ランダムキー | 
 | int               | numberBetween | \$min = 0,<br> \$max = 2147483647 | 数字（指定した範囲） | 
 | float             | randomFloat | \$nbMaxDecimals = null,<br> \$min = 0,<br> \$max = null | ランダムフロート | 
 | mixed             | randomElement | array \$array = ['a', 'b', 'c'] | ランダム要素（単行） | 
 | array             | randomElements | array \$array = ['a', 'b', 'c'],<br> \$count = 1,<br> \$allowDuplicates = false | ランダム要素（複数行） | 
 | array or string     | shuffle | \$arg = '' | シャッフル | 
 | array             | shuffleArray | array \$array = [] | シャッフル配列 | 
 | string            | shuffleString | \$string = '',<br> \$encoding = 'UTF-8' | シャッフル文字列 | 
 | string            | numerify | \$string = '###' | 数える | 
 | string            | lexify | \$string = '????' | レキシシック | 
 | string            | bothify | \$string = '## ??' | 両立 | 
 | string            | asciify | \$string = '****' | 上昇する | 
 | string            | regexify | \$regex = '' | 再正規化する | 
 | string            | toLower | \$string = '' | 小文字へ | 
 | string            | toUpper | \$string = '' | 大文字へ | 
 | Generator         | optional | \$weight = 0.5,<br> \$default = null | 任意の | 
 | Generator         | unique | \$reset = false,<br> \$maxRetries = 10000 | ユニークな | 
 | Generator         | valid | \$validator = null,<br> \$maxRetries = 10000 | 有効な | 
 | integer           | biasedNumberBetween | \$min = 0,<br> \$max = 100,<br> \$function = 'sqrt' | 偏った番号 | 
 | string            | file | \$sourceDirectory = '/tmp',<br> \$targetDirectory = '/tmp',<br> \$fullPath = true | ファイル | 
 | string            | imageUrl | \$width = 640,<br> \$height = 480,<br> \$category = null,<br> \$randomize = true,<br> \$word = null,<br> \$gray = false | 画像URL | 
 | string            | image | \$dir = null,<br> \$width = 640,<br> \$height = 480,<br> \$category = null,<br> \$fullPath = true,<br> \$randomize = true,<br> \$word = null | 画像 | 
 | string            | randomHtml | \$maxDepth = 4,<br> \$maxWidth = 4 | ランダムHTML | 
