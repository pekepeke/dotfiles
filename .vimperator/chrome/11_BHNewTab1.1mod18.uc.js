var BHNewTab = function(){
BHNewTab.METADATA = <><![CDATA[
// ==UserScript==
// @name           Bookmarks and History open in New Tab
// @include        main
// @include        chrome://browser/content/browser.xul
// @include        chrome://browser/content/bookmarks/bookmarksPanel.xul
// @include        chrome://browser/content/history/history-panel.xul
// @include        chrome://browser/content/places/places.xul
// @include        chrome://libraryinsidebar/content/sidebarPlacesOverlay.xul
// @description    ブックマークと履歴をクリックした時に新しいタブで開くようにしたり，開き方を変更したり．
// @compatibility  Firefox 3.0 3.1
// @version        1.1 mod18 2008/11/12 16:30 fixupにFxのデフォルト挙動のthird party servicesを使用できるように変更した
// ==/UserScript==
// @version        1.1 mod17 2008/11/12 uriが不正の時, 以降BHNewTab.FAKE_REFERRERのままになってしまう
// @version        1.1 mod16 2008/11/12 }が抜けてた ort
// @version        1.1 mod15 2008/11/12 BHNewTabはなぜかfixupしない仕様だったが, ロケーションバーだけfixupするように変更。
// @version        1.1 mod14 2008/10/22 ライブラリでエンターキーの場合およびサイドバーでShiftキーまたはCtrlキーを押しながらクリックした場合がそれぞれ動作しないのを修正。
// @version        1.1 mod13 2008/10/09 サイドバーに読み込むが機能しなくなっていたのを修正. javascriptとdataスキームはカレントに読み込むように修正
// @version        1.1 mod12 2008/10/09 ライブラリはダブルクリックにしないと, 元の機能と被ってしまうので修正.
// @version        1.1 mod11a 2008/10/08 Fx2は対象外とした。Libraryにも対応 by Alice0775
// @version        1.1 mod10 2008/10/04 ツールバーのカスタマイズ後に機能が有効とならないのを修正 By Alice0775
// @version        1.1 mod9 2008/10/03 Fx3.*で中クリック指定が機能しない, およびFx3.1b1prでエラー(mod8エンバグ)を修正, 定数等BHNewTabの配下にした By Alice0775
// @version        1.1 mod8 2008/09/26 11:00 For checked in Bug 337345 By Alice0775
// @version        1.1 mod7 2008/07/29 19:00 Fx3.02preでしか動作確認してないよ^^ By Alice0775
]]></>;
    // --- config ---
    BHNewTab.NWFLAG_XUL           = true;      // XUL ファイル(*.xul)を新しいウィンドウで
    BHNewTab.USE_ENTERKEY         = true;      // エンターキーを押した時も新しいタブで
    BHNewTab.USE_BLANK            = true;      // カレントタブが空白の時そのタブを使う
    BHNewTab.FAKE_REFERRER        = true;      // ロケーションバー入力時にリファラを偽装する
    BHNewTab.WINDOW_BACKGROUND    = true;      // ライブラリからurlを開いたとき, windowを前面にしない

    BHNewTab.TARGET_BOOKMARKS     = 'tabshifted';  // ブックマークを開く場所 (tab / tabshifted / current / window / save)
    BHNewTab.TARGET_HISTORY       = 'tabshifted';  // 履歴を開く場所
    BHNewTab.TARGET_OPENFOLDER    = 'tab';     // 「タブですべて開く」時に開く場所 (空白/null で機能の置き換えをしない)
    BHNewTab.TARGET_LOCATIONBAR   = 'tab';     // ロケーションバー入力時に開く場所 (空白/null で機能の置き換えをしない)
    BHNewTab.TARGET_HOMEBUTTON    = 'tab';     // ホームボタンクリック時に開く場所 (空白/null で機能の置き換えをしない)
    BHNewTab.TARGET_SEARCHBAR     = 'tab';     // サーチバー入力時に開く場所 (空白/null で機能の置き換えをしない)
    BHNewTab.KEYWORDS_IN_SEARCHBAR= true;      // サーチバーでキーワード検索を使う
    BHNewTab.TARGET_MIDCLICK      = 'tab';     // 中クリックの時の開く場所
    BHNewTab.TARGET_ALT           = 'save';    // ALT を押していた場合の開く場所
    BHNewTab.TARGET_SHIFT         = 'window';  // SHIFT を押していた場合の開く場所
    BHNewTab.TARGET_CTRL          = 'tab';     // CTRL を押していた場合の開く場所
    BHNewTab.TARGET_ALTSHIFT      = 'tab';     // ALT + SHIFT を押していた場合の開く場所
    BHNewTab.TARGET_ALTCTRL       = 'tab';     // ALT + CTRL を押していた場合の開く場所
    BHNewTab.TARGET_SHIFTCTRL     = 'tab';     // SHIFT + CTRL を押していた場合の開く場所
    BHNewTab.TARGET_ASC           = 'tab';     // ALT + SHIFT + CTRLを押していた場合の開く場所
    BHNewTab.TARGET_MID_ALT       = 'save';    // ALT を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_SHIFT     = 'window';    // SHIFT を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_CTRL      = 'tab';     // CTRL を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_ALTSHIFT  = 'current';   // ALT + SHIFT を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_ALTCTRL   = 'current';   // ALT + CTRL を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_SHIFTCTRL = 'current';   // SHIFT + CTRL を押していた場合の開く場所 (中クリック時)
    BHNewTab.TARGET_MID_ASC       = 'current';   // ALT + SHIFT + CTRLを押していた場合の開く場所 (中クリック時)
    var TRY_INTERVAL         = 30;      // 機能置き換えを実行するタイミング(ミリ秒)
    var TRY_LIMIT            = 50;      // 機能置き換えを試みる限界数
    // --- config ---

    var Cc  = Components.classes;
    var Ci  = Components.interfaces;
    var Cr  = Components.results;
    BHNewTab.FX3 = (Cc['@mozilla.org/xre/app-info;1'].getService(Ci.nsIXULAppInfo).version.substr(0,1) == 3);
    if (!BHNewTab.FX3)
      return;
    if('TM_init' in window)
      return;
    if('TreeStyleTabService' in window)
      return;

    BHNewTab.TARGET_DEFAULT = {bookmarks:BHNewTab.TARGET_BOOKMARKS,history:BHNewTab.TARGET_HISTORY,openfolder:BHNewTab.TARGET_OPENFOLDER,locationbar:BHNewTab.TARGET_LOCATIONBAR,homebutton:BHNewTab.TARGET_HOMEBUTTON,searchbar: BHNewTab.TARGET_SEARCHBAR};

    BHNewTab.fakeReferrer = false;

    // リファラを得る
    function getReferrer(url){ try{ return (BHNewTab.fakeReferrer) ? Cc['@mozilla.org/network/io-service;1'].getService(Ci.nsIIOService).newURI(url.replace(/[^/]+$/,''),null,null) : null; }catch(e){ return null; } }

    // URL のリストをカレントタブ + 新しいタブで開く．
    function openCurrent(url, post, allowThirdPartyFixup){
        var win = getTopWin();
        if ("isLockTab" in win.gBrowser &&
            win.gBrowser.isLockTab(win.gBrowser.selectedTab) && !/^\s*javascript:/.test(url[0])){
            win.gBrowser.loadOneTab(url[0], getReferrer(url[0]),null,post[0] || null,false, allowThirdPartyFixup || false);
        } else {
          win.loadURI(url[0], getReferrer(url[0]),post[0] || null, allowThirdPartyFixup || false);
        }
        for(let i = 1,max = url.length;i < max;++i){
          win.gBrowser.loadOneTab(url[i], getReferrer(url[i]),null,post[i] || null,false, allowThirdPartyFixup || false);
        }
    }

    // URL のリストを新しいタブで開く．
    function openTab(url, post, bg, allowThirdPartyFixup){
        var win = getTopWin();
        if (BHNewTab.USE_BLANK && win.content.window.document.URL == 'about:blank' &&
           !("isLockTab" in win.gBrowser &&
            win.gBrowser.isLockTab(win.gBrowser.selectedTab) && !/^\s*javascript:/.test(url[0])) ){
          openCurrent([url[0]],[post[0]], allowThirdPartyFixup);
        } else {
          win.gBrowser.loadOneTab(url[0], getReferrer(url[0]),null,post[0] || null, bg, allowThirdPartyFixup || false);
        }
        for(let i = 1, max = url.length;i < max;++i) {
          win.gBrowser.loadOneTab(url[i], getReferrer(url[i]),null,post[i] || null, true, allowThirdPartyFixup || false);
        }
    }

    // URL のリストを新しいウィンドウで開く．
    function openWindow(url, post, allowThirdPartyFixup){
        var win = getTopWin();
        win.open();
        win = getTopWin();
        win.loadURI(url, getReferrer(url[0]), post[0] || null, allowThirdPartyFixup || false);
        for (let i = 1,max = url.length;i < max;++i){
          win.gBrowser.loadOneTab(url[i], getReferrer(url[i]),null,post[i] || null,false, allowThirdPartyFixup || false);
        }
    }

    // URL のリストの指すファイルを保存．
    function saveURL(url){ for(let i = 0,max = url.length;i < max;++i) getTopWin().saveURL(url[i],null,null,true,null, getReferrer(url[i])); }

    // event オブジェクトからコンテンツを開く場所を得る．
    BHNewTab.getTarget = function getTarget(event,type){
        if(event && event.button == 1){
            switch(event.altKey | event.shiftKey << 1 | event.ctrlKey << 2){
              case 0 : return BHNewTab.TARGET_MIDCLICK;
              case 1 : return BHNewTab.TARGET_MID_ALT;
              case 2 : return BHNewTab.TARGET_MID_SHIFT;
              case 3 : return BHNewTab.TARGET_MID_ALTSHIFT;
              case 4 : return BHNewTab.TARGET_MID_CTRL;
              case 5 : return BHNewTab.TARGET_MID_ALTCTRL;
              case 6 : return BHNewTab.TARGET_MID_SHIFTCTRL;
              case 7 : return BHNewTab.TARGET_MID_ASC;
              default: return BHNewTab.TARGET_MIDCLICK;
            }
        }
        else{
            let def = BHNewTab.TARGET_DEFAULT[type] || 'current';
            if(!event) return def;
            switch(event.altKey | event.shiftKey << 1 | event.ctrlKey << 2){
              case 0 : return def;
              case 1 : return BHNewTab.TARGET_ALT;
              case 2 : return BHNewTab.TARGET_SHIFT;
              case 3 : return BHNewTab.TARGET_ALTSHIFT;
              case 4 : return BHNewTab.TARGET_CTRL;
              case 5 : return BHNewTab.TARGET_ALTCTRL;
              case 6 : return BHNewTab.TARGET_SHIFTCTRL;
              case 7 : return BHNewTab.TARGET_ASC;
              default: return def;
            }
        }
    }

    // 適切な場所にコンテンツを開く．
    BHNewTab.openInTarget = function openInTarget(url, event, type, post){
          if (/^(javascrtpt:|data:)/.test(url)){
            openUILinkIn(url.split('|')[0], 'current');
            return;
          }
          var allowThirdPartyFixup = 'locationbar' == type;

          switch(BHNewTab.getTarget(event,type)){
          case 'current'    : openCurrent(url.split('|'), post || [],        allowThirdPartyFixup); break;
          case 'tabshifted' : openTab(url.split('|'),     post || [], true,  allowThirdPartyFixup); break;
          case 'tab'        : openTab(url.split('|'),     post || [], false, allowThirdPartyFixup); break;
          case 'window'     : openWindow(url.split('|'),  post || [],        allowThirdPartyFixup); break;
          case 'save'       : saveURL(url.split('|')); break;
        }
    }

    // XUL ファイルか否か．
    BHNewTab.isXUL = function isXUL(url){ return (!/^javascript:/.test(url) && /[.]xul$/.test(url)); }

    // イベントを止める．
    BHNewTab.stopEvent = function stopEvent(event){ event.preventDefault(); event.stopPropagation(); }

    // いつでもクリックされたマウスのボタンを知る事ができるように，マウスイベントを監視して，ボタン情報を更新する．
    {
        let mouseButton = null;
        window.addEventListener('mousedown',function(event){ mouseButton = event.button; },false);
        window.addEventListener('mouseup',function(event){ mouseButton = event.button; setTimeout(function(){ mouseButton = null; },0); },false);
        BHNewTab.getMouseButton = function getMouseButton(){ return mouseButton; }
    }

    // サイドバーのブックマークと履歴のクリックとエンターキーのコールバック．
    BHNewTab.callbackBH = function callbackBH(event){

        if(event.type == 'click' && event.button == 2) return;
        if(event.type == 'keypress' && event.keyCode != KeyEvent.DOM_VK_RETURN) return;

        var tree = (event.type == 'keypress') ? event.originalTarget : event.originalTarget.parentNode; if(tree.localName != 'tree') return;
        //Library
        if (window.location.href == 'chrome://browser/content/places/places.xul' ||
            window.location.href == 'chrome://libraryinsidebar/content/sidebarPlacesOverlay.xul'){
          //if not right pane, do nothing.
          if (tree != document.getElementById('placeContent'))
            return;
          if (event.type == 'dblclick' || event.type == 'click' && event.button == 1) {
            var row = {}, col = {}, obj = {};
            tree.treeBoxObject.getCellAt(event.clientX, event.clientY, row, col, obj);
            if (row.value == -1) return;
            if(tree.treeBoxObject.view.isContainer(row.value)) return;
            tree.treeBoxObject.view.selection.select(row.value);
          } else if (!(event.type == 'keypress' && event.keyCode == KeyEvent.DOM_VK_RETURN)){
            return;
          }
        } else  if (event.type == 'click') {
          var row = {}, col = {}, obj = {};
          tree.treeBoxObject.getCellAt(event.clientX, event.clientY, row, col, obj);
          if (row.value == -1) return;
          if(tree.treeBoxObject.view.isContainer(row.value)) return;
          tree.treeBoxObject.view.selection.select(row.value);
        }

        var node = tree.controller._view.selectedNode; if(!node) return;
        var def  = (event.button != 1 && !event.shiftKey && !event.ctrlKey && !event.altKey);
        var url  = node.uri;

        if(tree.ownerDocument.defaultView.location ==
                 'chrome://browser/content/bookmarks/bookmarksPanel.xul'||
           tree.ownerDocument.defaultView.location ==
                 'chrome://browser/content/places/places.xul' ||
           tree.ownerDocument.defaultView.location ==
                 'chrome://libraryinsidebar/content/sidebarPlacesOverlay.xul'){
            if(def
               && PlacesUtils.annotations.
                  itemHasAnnotation(node.itemId,LOAD_IN_SIDEBAR_ANNO)){
              return;
            }
            var uri = PlacesUtils._uri(url);
            if (uri.schemeIs("javascript") || uri.schemeIs("data")){
              openUILinkIn(url, 'current');
            } else if(def && BHNewTab.NWFLAG_XUL && BHNewTab.isXUL(url)){
              getTopWin().open(url,'_blank',
              'chrome,extrachrome,menubar,resizable,scrollbars,status,toolbar,centerscreen');
            } else {
              BHNewTab.openInTarget(url,event,'bookmarks');
              if (getTopWin() != window && !BHNewTab.WINDOW_BACKGROUND){
                getTopWin().content.focus();
              }
            }
        }
        else {
          BHNewTab.openInTarget(url,event,'history');
        }
        BHNewTab.stopEvent(event);
    }

    // ブックマークツールバーとメニュー，履歴メニューのクリックとエンターキーのコールバック．
    BHNewTab.callbackBHMenu = function callbackBHMenu(event){
        /*event.button = */var button = BHNewTab.getMouseButton();
        if(!BHNewTab.USE_ENTERKEY && button == null) return;
        var entry = event.originalTarget;

        if (entry.node && PlacesUtils.nodeIsContainer(entry.node)){
          PlacesUIUtils.openContainerNodeInTabs(entry.node, event);
          BHNewTab.stopEvent(event);
          return;
        }
        var url   = entry.getAttribute('statustext') || ((entry.node) ? entry.node.uri : null); if(!url) return;

        var def   = (event.button != 1 && !event.shiftKey && !event.ctrlKey && !event.altKey);

        if(event.currentTarget.id != 'history-menu'){
            let node = entry.node;
            if(def && PlacesUtils.annotations.itemHasAnnotation(node.itemId,LOAD_IN_SIDEBAR_ANNO)) return;
            var uri = PlacesUtils._uri(url);
            if (uri.schemeIs("javascript") || uri.schemeIs("data")) openUILinkIn(url, 'current');
            else if(def && BHNewTab.NWFLAG_XUL && BHNewTab.isXUL(url)) window.open(url,'_blank','chrome,extrachrome,menubar,resizable,scrollbars,status,toolbar,centerscreen');
            else BHNewTab.openInTarget(url,event,'bookmarks');
        }
        else BHNewTab.openInTarget(url,event,'history');
        BHNewTab.stopEvent(event);
    }

    // 「タブですべて開く」置き換え．
    BHNewTab.replaceOpenFolder = function replaceOpenFolder(doc){
        var win = doc.defaultView;
        var el  = doc.getElementById('placesContext_openContainer:tabs');
        el.setAttribute('oncommand','this.run(event);');
        el.run = function(event){
            var _view = PlacesUIUtils.getViewForNode(doc.popupNode).controller._view;
            var node  = _view.selectedNode;
            if(_view.hasSingleSelection && PlacesUtils.nodeIsContainer(node)) PlacesUIUtils.openContainerNodeInTabs(_view.selectedNode,event);
            else{
                let urllist = [];
                let contents = PlacesUtils.getFolderContents(node.itemId, false, false).root;
                for (let i = 0; i < contents.childCount; ++i) {
                  let child = contents.getChild(i);
                  if (PlacesUtils.nodeIsURI(child))
                    urllist.push(child);
                }
                PlacesUIUtils.openURINodesInTabs(urllist,event);
            }
        };

        win.PlacesUIUtils.openURINodesInTabs = function(urllist,event){
            if(!this._confirmOpenInTabs(urllist.length)) return;
            var urls = [];
            for(let i = 0; i < urllist.length; i++){
              urls.push(urllist[i].uri);
            }
            BHNewTab.openInTarget(urls.join('|'),event,'openfolder');
        }
        win.PlacesUIUtils.openContainerNodeInTabs = function(node,event){
            var urllist = PlacesUtils.getURLsForContainerNode(node);
            this.openURINodesInTabs(urllist,event);
        }
    }

    BHNewTab.main = {
          callbackBookmarks : BHNewTab.callbackBH,
          callbackHistory   : BHNewTab.callbackBH,
          callbackBHMenu    : BHNewTab.callbackBHMenu,
          replaceOpenFolder : BHNewTab.replaceOpenFolder,
          bookmarksURL      : 'chrome://browser/content/bookmarks/bookmarksPanel.xul',
          historyURL        : 'chrome://browser/content/history/history-panel.xul',
          sidebarID         : 'sidebar',
          getMenuList       : function(){ return [document.getElementById('bookmarksBarContent'),document.getElementById('bookmarksMenuPopup'),document.getElementById('history-menu')]; }
    }


    // メインブロック
    {

        //Librayのブックマークと履歴の開き方を変更する．
        if (window.location.href == 'chrome://browser/content/places/places.xul' ||
            window.location.href == 'chrome://libraryinsidebar/content/sidebarPlacesOverlay.xul'){
            BHNewTab.main.replaceOpenFolder(document);
            window.addEventListener('dblclick',BHNewTab.main.callbackBookmarks,true);
            window.addEventListener('click',BHNewTab.main.callbackBookmarks,true);
            if(BHNewTab.USE_ENTERKEY) window.addEventListener('keypress',BHNewTab.main.callbackBookmarks,true);
        }
        // サイドバーのブックマークと履歴の開き方を変更する．
        if(window.location.href == BHNewTab.main.bookmarksURL){
            BHNewTab.main.replaceOpenFolder(document);
            window.addEventListener('click',BHNewTab.main.callbackBookmarks,true);
            if(BHNewTab.USE_ENTERKEY) window.addEventListener('keypress',BHNewTab.main.callbackBookmarks,true);
        }
        if(window.location.href == BHNewTab.main.historyURL){
            window.addEventListener('click',BHNewTab.main.callbackHistory,true);
            if(BHNewTab.USE_ENTERKEY) window.addEventListener('keypress',BHNewTab.main.callbackHistory,true);
        }

        //メインウインドウの開き方を変更する．
        if (window.location.href == 'chrome://browser/content/browser.xul'){
          // 「タブですべて開く」置き換え．
          if(BHNewTab.TARGET_OPENFOLDER) BHNewTab.main.replaceOpenFolder(document);

          // ロケーションバー決定時の機能置き換え．
          if (BHNewTab.TARGET_LOCATIONBAR) {
            if ("BrowserLoadURL" in window) {
              BrowserLoadURL = function(event,post){
                gBrowser.userTypedValue = content.window.document.URL;
                BHNewTab.fakeReferrer = BHNewTab.FAKE_REFERRER;
                BHNewTab.openInTarget(gURLBar.value, event, 'locationbar', [post]);
                BHNewTab.fakeReferrer = false;
                content.focus();
              };
            } else {
              gURLBar.handleCommand = function(aTriggeringEvent){
                if (aTriggeringEvent instanceof MouseEvent && aTriggeringEvent.button == 2)
                  return; // Do nothing for right clicks

                var [url, postData] = this._canonizeURL(aTriggeringEvent);
                if (!url)
                  return;

                this.value = url;
                gBrowser.userTypedValue = url;
                try {
                  addToUrlbarHistory(url);
                } catch (ex) {
                  // Things may go wrong when adding url to session history,
                  // but don't let that interfere with the loading of the url.
                  Cu.reportError(ex);
                }
                BHNewTab.fakeReferrer = BHNewTab.FAKE_REFERRER;
                BHNewTab.openInTarget(gURLBar.value, aTriggeringEvent,'locationbar',[postData]);
                BHNewTab.fakeReferrer = false;
                content.focus();
              };
            }
          }

          // ホームボタンクリック時の機能置き換え．
          if(BHNewTab.TARGET_HOMEBUTTON) BrowserHomeClick = function(event){
              if(event.button == 2) return;
              BHNewTab.openInTarget(gHomeButton.getHomePage(),event,'homebutton');
              content.focus();
          };
          if(BHNewTab.TARGET_HOMEBUTTON) BrowserGoHome = function(event){
              if(event.button == 2) return;
              BHNewTab.openInTarget(gHomeButton.getHomePage(),event,'homebutton');
          };

          // サーチバー入力時の機能置き換え．
          try{
              if (BHNewTab.FX3) {
                var searchBar = BrowserSearch.searchBar;
              } else {
                var searchBar = BrowserSearch.getSearchBar();
              };
              if(BHNewTab.TARGET_SEARCHBAR) {
                searchBar.handleSearchCommand = function(event){
                  var value = (this.getAttribute('empty') == 'true') ? '' : this._textbox.value;
                  if(value) this._textbox._formHistSvc.addEntry(this._textbox.getAttribute('autocompletesearchparam'),value);
                  if(BHNewTab.KEYWORDS_IN_SEARCHBAR) { //2008/07/08
                    var shortcutURL = null;
                    var aPostDataRef = {};
                    var offset = value.indexOf(" ");
                    if (offset > 0) {
                      shortcutURL = getShortcutOrURI(value, aPostDataRef);
                      if (shortcutURL && shortcutURL != value){
                        BHNewTab.openInTarget(shortcutURL,event,'searchbar',[aPostDataRef.value]);
                        content.focus();
                        return;
                      } else if (!shortcutURL){
                        return;
                      }
                    }
                  }
                  var submission = this.currentEngine.getSubmission(value,null);
                  if(!submission) return;
                  BHNewTab.openInTarget(submission.uri.spec,event,'searchbar',[submission.postData]);
                  content.focus();
                };
              } else {


              }
          }
          catch(e){}

          // ブックマークツールバーとメニュー，履歴メニューの開き方を変更する．
          let setOpener = function(){
              var menu = BHNewTab.main.getMenuList();
              if(!menu[0] || !menu[1] || !menu[2]) return false;
              for(let i = 0,max = menu.length;i < max;++i){ menu[i].addEventListener('command', BHNewTab.main.callbackBHMenu,true); }
              for(let i = 0,max = menu.length;i < max;++i){ menu[i].addEventListener('click', function(event){if (event.button==1)BHNewTab.main.callbackBHMenu(event);},true); }
              return true;
          };

          // 機能の置き換えを可能な限り試みる．
          let(timer,count = 0) timer = setInterval(function(){ if(++count > TRY_LIMIT || setOpener()) clearInterval(timer); }, TRY_INTERVAL);

          //ツールバーのカスタマイズ後も機能が有効になるように再定義
          BHNewTab.CustomizeToolbars =function(event){
              switch(event.type){
                case "DOMAttrModified":
                  if (event.attrName == "disabled" && !event.newValue){
                    var menu = BHNewTab.main.getMenuList();
                    if (!menu[0])
                      return;
                    menu[0].addEventListener('command', BHNewTab.main.callbackBHMenu,true);
                    menu[0].addEventListener('click', function(event){if (event.button==1)BHNewTab.main.callbackBHMenu(event);},true);
                  }
                  break;
              }
          }
          document.getElementById("cmd_CustomizeToolbars").
                   addEventListener("DOMAttrModified", BHNewTab.CustomizeToolbars, false);
        }
    }

};
BHNewTab();