//タブの左ダブルクリックでタブを閉じる 
gBrowser.tabContainer.addEventListener("dblclick", function(event){
  if (event.button != 0) return;
  var aTarget = event.originalTarget;
  while ( aTarget && aTarget instanceof XULElement && aTarget.localName !='tab') {
    aTarget = aTarget.parentNode;
  }
  if ( !aTarget || aTarget.localName !='tab') return;
  gBrowser.removeTab(aTarget);
}, false);
