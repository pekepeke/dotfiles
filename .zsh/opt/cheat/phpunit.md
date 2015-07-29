PHPUnit
=======

## annotation
- @covers Class::method
- @expectedException \RuntimeException
- @expectedExceptionCode 30
- @expectedExceptionMessage message
- @expectedExceptionMessageRegExp /argument \w+/
- @requires [condition]
	- 共通の事前条件を満たさない時にスキップできる
	- https://phpunit.de/manual/current/ja/incomplete-and-skipped-tests.html#incomplete-and-skipped-tests.requires.tables.api
- @runTestsInSeparateProcesses
	- テストクラス内のすべてのテストケースを個別のPHPプロセスで実行するよう指示する。(class に対するコメント)
- @runInSeparateProcesses
	- テストケースを個別のPHPプロセスで実行するよう指示する。

## mixed is ...
|メソッド|意味|
|:-----|:---|
|`assertNull($var)`|`$varがNULLである`|
|`assertEquals($val1, $val2)`|`$val1が$val2と等しい`|
|`assertSame($val1, $val2)`|`$val1と$val2が型も含めて等しい`|
|`assertInternalType($type, $val)`|`$valの型名が$typeである`|
※InternalTypeで一致する可能性のある型名
http://apigen.juzna.cz/doc/sebastianbergmann/phpunit/class-PHPUnit_Framework_Constraint_IsType.html

- `\PHPUnit_Framework_Constraint_IsType::TYPE_ARRAY`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_BOOL`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_FLOAT`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_INT`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_NULL`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_NUMERIC`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_OBJECT`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_RESOURCE`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_STRING`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_SCALAR`
- `\PHPUnit_Framework_Constraint_IsType::TYPE_CALLABLE`

## number is ...
|メソッド|意味|
|:-----|:---|
|`assertGreaterThan($expect, $var)`|`$expect < $var が成立する`|
|`assertGreaterThanOrEqual($expect, $var)`|`$expect <= $var が成立する`|
|`assertLessThan($expect, $var)`|`$expect > $var が成立する`|
|`assertLessThanOrEqual($expect, $var)`|`$expect >= $var が成立する`|

## string is ...
|メソッド|意味|
|:-----|:---|
|`assertJsonStringEqualsJsonString($str1, $str2)`|`$str1と$str2がjsonとして等しい`|
|`assertRegExp($ptn, $str)`|`$strが正規表現$ptnにマッチする`|



## boolean is ...
|メソッド|意味|
|:-----|:---|
|`assertTrue($var)`|`$varがTRUEである`|
|`assertFalse($var)`|`$varがFALSEである`|


## array is ...
|メソッド|意味|
|:-----|:---|
|`assertArrayHasKey($key, $array)`|`配列$arrayにキー$keyが存在する`|
|`assertContains($val, $array)`|`配列$arrayに値$valが存在する`|
|`assertContainsOnly($type, $array)`|`配列$arrayの値の型がすべて$typeである`|
|`assertCount($count, $array)`|`配列$arrayの値の数が$countである`|
|`assertEmpty($array)`|`配列$arrayが空である`|

## object/class is ...
|メソッド|意味|
|:-----|:---|
|`assertObjectHasAttribute($attr, $object)`|`オブジェクト$objectにプロパティ変数$attrが存在する`|
|`assertClassHasAttribute($attr, $class)`|`クラス名$classにプロパティ変数$attrが存在する`|
|`assertClassHasStaticAttribute($attr, $class)`|`クラス名$classに静的プロパティ変数$attrが存在する`|
|`assertInstanceOf($class, $instance)`|`$instanceがクラス名$classのインスタンスである`|

## file is ...
|メソッド|意味|
|:-----|:---|
|`assertFileExists($file)`|`$fileが存在する`|
|`assertFileEquals($file1, $file2)`|`$file1と$file2の内容が等しい`|
|`assertJsonFileEqualsJsonFile($file1, $file2)`|`$file1と$file2の内容がjsonとして等しい`|
|`assertJsonStringEqualsJsonFile($file1, $json)`|`$file1の内容と$jsonがjsonとして等しい`|
