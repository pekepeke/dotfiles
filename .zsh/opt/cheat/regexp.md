```
// 全角 
	/[^\x01-\x7E]/
// 半角 
	/[\x01-\x7E]/
// 半角(制御コード除く)
	/[\x20-\x7f]/
// URL
	/http:\/\/[\w\d/%#$&?()~_.=+-]+/
```