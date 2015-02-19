## version 確認

jQuery.fn.jquery

## live/delegate/on

```javascript
// 1.3
$("a").live("click", fn)
// 1.4.2
$("#foo").delegate("a", "click", fn)
// 1.7
$(document).on("click", "a", fn)
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
