(function() {
  var mItem = document.createElement("menuitem");
  mItem.id = "context-viewlinksource";
  mItem.setAttribute("label", "View Link Source");
  mItem.setAttribute("accesskey", "V");
  mItem.setAttribute("oncommand", "viewLinkSource()");
  mItem.setAttribute("onclick", "viewLinkSource(event)");

  var contextViewSource = document.getElementById("context-viewsource");
  contextViewSource.parentNode.insertBefore(mItem, contextViewSource.nextSibling);

  window.setTimeout(function() {
    contextViewSource.parentNode.addEventListener("popupshowing", function(event) {
      var schemes = "https?|ftp|file|data|resource|chrome|about|jar";
      var regScheme = new RegExp(schemes, "i");
      var isLinkViewable = regScheme.test(gContextMenu.linkProtocol);
      gContextMenu.showItem("context-viewlinksource", gContextMenu.onLink && isLinkViewable);
    }, false);
  });
})();


function viewLinkSource(aEvent) {
  try {
    gPrefService.getBoolPref("view_source.tab.loadInNewTab");
  } catch(ex) {
    gPrefService.setBoolPref("view_source.tab.loadInNewTab", true);
  }

  try {
    gPrefService.getBoolPref("view_source.tab.loadInBackground");
  } catch(ex) {
    gPrefService.setBoolPref("view_source.tab.loadInBackground", false);
  }

  var url = gContextMenu.linkURL;

  if(aEvent) {
    aEvent.stopPropagation();
    switch(aEvent.button) {
      case 1: //middle click
        if(gPrefService.getBoolPref("view_source.tab.loadInNewTab")) {
          var newTab = gBrowser.addTab("view-source:" + url); //view source in new tab
          if(!gPrefService.getBoolPref("view_source.tab.loadInBackground"))
            gBrowser.selectedTab = newTab;  //focus new tab
        } else loadURI("view-source:" + url);   //view source in current tab
        break;
      case 2: //right click
        openWebPanel(url, "view-source:" + url); //view source in sidebar
        break;
    }
    closeMenus(aEvent.target);
  } else {
    if(typeof gViewSourceUtils == 'object') //if Bon Echo
      ViewSourceOfURL(url);
    else
      BrowserViewSourceOfURL(url);
  }
}

