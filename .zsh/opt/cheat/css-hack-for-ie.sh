## CSS hack for ie

```css
selector {
  background-color: red;     /* ハックなし */
  background-color: green\9; /* IE10以下 */
  *background-color: blue;   /* IE7以下 */
  _background-color: yellow; /* IE6 */
}
selector:not(:target) {
  background-color: black\9; /* IE9, 10 */
}
@media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
  selector:not(:target) {
    background-color: purple\9; /* IE10（\9なしでIE11にも適用） */
  }
}
```

## meta

```html
<meta http-equiv="X-UA-Compatible" content="IE=6; IE=9">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />        # Quirks or IE9
<meta http-equiv="X-UA-Compatible" content="IE=edge" />              # always latest
```

