## version 確認

jQuery.fn.jquery

## live/delegate/on

```javascript
// 1.7
$(document).on("click", "a", fn)
// 1.4.2
$("#foo").delegate("a", "click", fn)
// 1.3
$("a").live("click", fn)
```

## Deferred

```
function delayResolve() {
	var d = new $.Deferred;
	setTimeout(function() {
		console.log("resolve");
		d.resolve();
	}, 1000)
	return d.promise();
}
function delayReject() {
	var d = new $.Deferred;
	setTimeout(function() {
		console.log("reject");
		d.reject();
	}, 1000)
	return d.promise();
}
delayResolve()
	.done(successCallback)
	.fail(failCallBack);
delayReject().then(successCallback, failCallBack)

delayResolve()
	.then(delayResolve) // done/fail では戻り値を返却しないため chain には使用できない
	.then(delayResolve);

$.when(successCallback(), failCallBack())
	.done(successCallback);
```

## hover

```javascript
$(selector).hover(handlerIn, handlerOut)
$(selector).mouseenter(handlerIn).mouseleave(handlerOut);
```

## contains [>=1.4]

```
jQuery.contains( "対象のDOM要素" ,"含まれているか調べたいDOM要素" );
jQuery(el, '#hoge').length > 0
jQuery('#hoge').find(el).length > 0
```
