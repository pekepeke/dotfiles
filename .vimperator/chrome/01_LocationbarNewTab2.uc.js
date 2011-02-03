// open in New Tab from location bar
BrowserLoadURL = function(event,post){
    gBrowser.userTypedValue = content.window.document.URL;
    if((event && event.altKey) ||
       gURLBar.value.match(/^javascript:/) ||
       gBrowser.userTypedValue == 'about:blank'){
      loadURI(gURLBar.value,null,post,true);
    }else{
        _content.focus();
        gBrowser.loadOneTab(gURLBar.value,null,null,post,false,true);
    }
}
