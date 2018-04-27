var evt = document.createEvent("HTMLEvents");
evt.initEvent("blur",  false,  true);
target.dispatchEvent(evt);

var evt = new CustomEvent('blur')
target.dispatchEvent(evt);

var evt = new FocusEvent('blur')
target.dispatchEvent(evt);
