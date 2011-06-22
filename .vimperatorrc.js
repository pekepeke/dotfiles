// {{{ ==================== for firefox preferences ====================
// for browsing speed tuneup
//options.setPref('network.prefetch-next', true);// prefetch default true
options.setPref('network.http.pipelining', true);
options.setPref('network.http.pipelining.firstrequest', true);
options.setPref('network.http.pipelining.maxrequests', 8);
options.setPref('network.http.max-connections', 32);
options.setPref('network.http.max-connections-per-server', 24);
options.setPref('network.http.max-persistent-connections-per-proxy', 16);
options.setPref('network.http.max-persistent-connections-per-server', 8);
options.setPref('nglayout.initialpaint.delay', 500);
options.setPref('plugin.expose_full_path', true);
options.setPref('ui.submenuDelay', 0);
options.setPref('content.interrupt.parsing', true);
options.setPref('content.max.tokenizing.time', 2250000);
options.setPref('content.notify.backoffcount', 5);
options.setPref('content.notify.interval', 750000);
options.setPref('content.notify.ontimer', true);
options.setPref('content.switch.threshold', 750000);
options.setPref('content.maxtextrun', 8191);

options.setPref('mousewheel.withnokey.numlines', 5);// マウスのスクロール量
options.setPref('mousewheel.withnokey.sysnumlines', false);

options.setPref('browser.cache.memory.enable', true);
options.setPref('browser.cache.memory.capacity', 32768);
options.setPref('browser.cache.disk_cache_ssl', false);
//options.setPref('browser.cache.disk_cache_ssl', true);
//options.setPref('browser.cache.disk.enable', false);
options.setPref('browser.tabs.closeButtons', 2);                        // x ボタン off
options.setPref('browser.tabs.autoHide', false);
options.setPref('browser.tabs.tabMaxWidth', 120);
options.setPref('browser.tabs.tabMinWidth', 120);
options.setPref('browser.tabs.warnOnClose', false);
options.setPref('browser.tabs.loadDivertedInBackground', true);         // バックグラウンドでタブを開く
options.setPref('browser.link.open_newwindow.restriction', 0);          // window.open() もタブで開く
options.setPref('browser.display.show_image_placeholders', false);      // 代理画像アイコンoff
options.setPref('browser.history_expire_days_min', 3);                  // 履歴(最短保持期間)
options.setPref('browser.history_expire_days', 15);                     // 履歴(最長保持期間)
options.setPref('browser.sessionhistory.max_total_viewers', 3);         // 高速Back/Forward
options.setPref('browser.sessionstore.interval', 120000);               // セッションを保存する間隔。

options.setPref('browser.block.target_new_window', true);               // 新しいウィンドウを開かずに既存のウィンドウに新しいタブを開かせます。
options.setPref('browser.chrome.image_icons.max_size', 0);              // タブに差胸いるを作らない
options.setPref('browser.download.manager.showAlertOnComplete', false); // ダウンロードが終了しました off
options.setPref('browser.download.manager.closeWhenDone', true);
options.setPref('browser.download.manager.retention', 1);               // 完了したダウンロードとキャンセルされたダウンロードの履歴はアプリケーション終了時に削除
options.setPref('browser.download.manager.showWhenStarting', false);    // ダウンロードマネージャにフォーカス移さない
options.setPref('browser.download.manager.useWindow', false);           // ステータスバーに進捗状況表示
options.setPref('browser.download.manager.scanWhenDone', false);        // Virus Scan Off
options.setPref('browser.blink_allowed', false);                        // blinkタグ無効
options.setPref('browser.search.openintab', true);                      // 検索結果を新しいタブで開く
options.setPref('browser.enable_automatic_image_resizing', false);      // イメージを勝手にリサイズさせない
options.setPref('browser.xul.error_pages.enabled', true);
options.setPref('config.trim_on_minimize', true);                       // ウィンドウ最小化時にメモリshrink/Winのみ有効/でも、ディスクを使うことになるので、外した方がいいかも
options.setPref('layout.spellcheckDefault', 0);                         // spellcheck off
options.setPref('network.dns.disableIPv6', true);
options.setPref('dom.popup_maximum',2000);                              // popup数
options.setPref('extensions.getAddons.showPane',false);                 // おすすめアドオンいらない
options.setPref('security.dialog_enable_delay', 0);                     // addon installer delay
options.setPref('plugin.expose_full_path', true);
options.setPref('signed.applets.codebase_principal_support', true);
options.setPref('layout.spellcheckDefault', 2);
options.setPref('browser.chrome.toolbar_tips', false);
//options.setPref('general.useragent.locale','ja');
options.setPref('images.dither', 'false');//画像のディザを補正する

//http://kano.feena.jp/?firefox
options.setPref('layout.frames.force_resizability', true);          // フレームを常にリサイズ可能に
options.setPref('view_source.wrap_long_lines', true);               // ソースの表示で長い行を自動的に折り返す
options.setPref('nglayout.events.dipatchLeftClickOnly', true);      // 右クリックを禁止にさせない
options.setPref('dom.disable_window_open_feature.location', true);  // URLバー・スクロールバーは隠すの禁止
options.setPref('dom.disable_window_open_feature.scrollbars',true);

// disable accesskey
options.setPref('ui.key.generalAccessKey', 9);

// for debug vimperator
//options.setPref('extensions.liberator.loglevel', 1);
options.resetPref('extensions.liberator.loglevel');

// bartab like
options.setPref('browser.sessionstore.max_concurrent_tabs', 0);
// }}}

(function($LU) {
  // {{{ ==================== for os difference ====================
    options.store.set('editor',
      $LU.is_win() ?
      'C:\\\\Personal\\\\Apps\\\\Editor\\\\sakura\\\\sakura.exe'
      : ($LU.is_mac() ? 'mvim' : 'gvim -f'));
    if (!$LU.is_mac()) {
      var fmt = '%snoremap <C-%s> <C-v><C-%s>';
      'ca'.split('').forEach( function(c) liberator.execute($LU.sprintf(fmt, 'n', c, c)) );
      'azxcv'.split('').forEach(
        function(c) {
          liberator.execute($LU.sprintf(fmt, 'c', c, c));
          liberator.execute($LU.sprintf(fmt, 'i', c, c));
        }
      );
    }
  // }}}

  // {{{ ==================== add keybind ====================
  // \/ \n で検索(For GMail)
  mappings.addUserMap(
    [modes.NORMAL],
    ['<Leader>/'], 'Search forward for a pattern',
    function() {
      if (finder) finder.openPrompt(modes.SEARCH_FORWARD);
      else if (modules.search) modules.search.openSearchDialog(modes.SEARCH_FORWARD);
    }
  );
  mappings.addUserMap(
    [modes.NORMAL],
    ['<Leader>n'], 'Search forward for a pattern',
    function() {
      if (finder) finder.findAgain(false);
      else if (modules.search) modules.search.findAgain(false);
    }
  );

  // ,m で最大化／元のサイズ
  mappings.addUserMap(
    [modes.NORMAL],
    [',m'], 'toggle Maximize',
    function() window.windowState == window.STATE_MAXIMIZED ? window.restore() : window.maximize()
  );

  (function() {
    if ($LU.is_ff4()) return;

    // statusline の [+-] をわかりやすい位置にわかりやすく表示
    if (document.getElementById('liberator-statusline-field-history') == null){
      if (document.getElementById('liberator-statusline-field-tabcount') == null) return;
      var p = document.createElement('statusbarpanel');
      var l = document.getElementById('liberator-statusline-field-tabcount').cloneNode(false);
      l.setAttribute('id', 'liberator-statusline-field-history');
      l.setAttribute('value', ' ');
      p.appendChild(l);
      document.getElementById('status-bar').insertBefore(p, document.getElementById('liberator-statusline'));
      var setter = function() {
        var e = document.getElementById('liberator-statusline-field-history');
        var h = getWebNavigation().sessionHistory;
        h = (h.index > 0 ? '<' : ' ') + (h.index < h.count - 1 ? '>' : ' ');
        e.setAttribute('value', h);
      };
      setter();
      gBrowser.addEventListener('load', function() setter(), true);
      gBrowser.addEventListener('TabSelect', function() setter(), true);
    }
    // setting multiline-output size
    document.getElementById('liberator-multiline-output').parentNode.maxHeight = content.innerHeight/2 + 'px';
  })();

  // }}}

  // {{{ ==================== for custom commands ====================
  (function(){
    var closeMultiTabs = function(isCloseLeft){
      var pos = gBrowser.mCurrentTab._tPos;
      var start = isCloseLeft == true ? pos - 1 : gBrowser.mTabs.length - 1;
      var end  = isCloseLeft == true ? 0 : pos + 1;
      if (start - end < 0) return;
      for (var i = start; i >= end; i--) gBrowser.removeTab(gBrowser.mTabs[i]);
    };

    // ←のタブを全て閉じる
    commands.addUserCommand(['closelefttabs'], 'close left tabs', function() closeMultiTabs(true));
    // →のタブを全て閉じる
    commands.addUserCommand(['closerighttabs'], 'close right tabs', function() closeMultiTabs(false));

    [ [',,l', ':closerighttabs<CR>'],
      [',,h', ':closelefttabs<CR>'],
    ].forEach(function([key, cmd])
      mappings.addUserMap([modes.NORMAL], [key], cmd, function() liberator.execute(cmd) , {rhs:key, noremap: true})
    );

    // notification control
    function getItems()
      Array.map(gBrowser.mPanelContainer.selectedPanel
          .getElementsByTagName('notification'),
        function(n,i) {return { index : i, label : n.getAttribute('label'), element : n };}
      );

    commands.addUserCommand(['nno','noti[fy]'], 'push button notify message',
      function(args, modifiers){
        var arg = args.string || 0;
        var enable = !args.bang;

        var n = getItems().filter(function(n) n.index == arg);

        if (n.length<=0) return;
        var notify = n[0].element;

        if (enable) notify.getElementsByTagName('button').item(0).click();
        else notify.close();
      }, {
        bang: true,
        completer: function(filter, special)
        [0, getItems().map(function(n) [n.index, n.label])]
      });
  })();

  commands.addUserCommand(['debug','dbg'], 'setting for debug vimperator',
    function(args, modifiers) {
      if (args.bang) {
        services.get('debugger').off();
        liberator.execute('set verbose=1');
        options.setPref('javascript.options.strict', false);
        options.setPref('javascript.options.showInConsole', false);
        options.setPref('browser.dom.window.dump.enabled', false);
        options.resetPref('extensions.liberator.loglevel');
      } else {
        services.get('debugger').on();
        liberator.execute('set verbose=9');
        options.setPref('javascript.options.strict', true);
        options.setPref('javascript.options.showInConsole', true);
        options.setPref('browser.dom.window.dump.enabled', true);
        options.setPref('extensions.liberator.loglevel', 1);
      }
    }, {
      bang: true
    }
  );

  commands.addUserCommand(['gc','forcegc'], 'force exec garbage collection',
    function() Components.utils.forceGC() , {}
  );
  commands.addUserCommand(['vacuum'], 'vacuum sqlite', function() {
    var conn = Components.classes['@mozilla.org/browser/nav-history-service;1'].getService(Components.interfaces.nsPIPlacesDatabase).DBConnection;
    conn.executeSimpleSQL('vacuum');
    conn.executeSimpleSQL('reindex');
  } , {});
  // }}}

  // {{{ ==================== for userChrome.js/css ====================
  (function() {
    var source_list = null
    if ($LU.is_ff4()) {
      return;
      source_list = <>
        01_LocationbarNewTab2.uc.js
        11_left-dblclick-closetab.uc.js
        01_context-encoding-menu.uc.js
        11_open-tabs-next.uc.js
        11_Active-Left.uc.js
        40_patchViewSourceUtils.uc.js
        11_BHNewTab1.1mod18.uc.js
        40_viewLinkSource.uc.js
      </>.toString().split(/\s+/);
    }
    if (typeof liberator.plugins.userchrome == 'undefined') liberator.plugins.userchrome = {};
    else return;
  //  // xul ファイル読み込み用
  //  function loadXUL(file) {
  //      var regex = /\.uc\.xul$/i;
  //      if (regex.test(file.leafName)) {
  //          document.loadOverlay(Components.classes['@mozilla.org/network/io-service;1'].
  //              getService(Components.interfaces.nsIIOService).getProtocolHandler('file').
  //              QueryInterface(Components.interfaces.nsIFileProtocolHandler).getURLSpecFromFile(file), null);
  //      }
  //      //if (files.hasMoreElements()) setTimeout(loadXUL, 0, files);
  //  }
    try {
      ['chrome','css'].forEach( function(dirs) {
        var dir = io.getRuntimeDirectories(dirs)[0];
        var regex = /\.(js|vimp|css)$/i;
        io.File(dir).readDirectory(true).forEach(function(file) {
          if (source_list && !source_list.some(function(v) file.leafName.indexOf(v) != -1)) return;
          if (regex.test(file.path)) io.source(file.path, false);
          //              else loadXUL( file );
        });
      });
    } catch(e) { liberator.echoerr(e); }
  })();
  // }}}

  // {{{ ==================== for plugin ====================
  let (gv = liberator.globalVariables) {
    // {{{ plugin-loader
    //var vimpdir = $LU.is_win() ? '~/vimperator' : '~/.vimperator';
    	var vimpdir = '~/.vimperator';
    gv.plugin_loader_roots = [
      vimpdir + '/ex-plugin/',
      vimpdir + '/vimperator-plugins/',
      //'~/sources/vimperator/vimperator-plugins/',
    ];
    gv.plugin_loader_plugins = <>
      _libly
      applauncher
      auto_source
      commandBookmarklet
      cookie
      copy
      direct_bookmark
      encodingSwitcherCommand
      edit-vimperator-files
      epub-reader
      exopen
      feedSomeKeys_3
      history-search-backward
      ime_controller
      inspector
      jscompletition
      migemo_completion
      migemo_hint
      migemo-find
      multi_requester
      resizable_textarea
      sbmcommentsviewer
      scroll_div
      stella
      subscldr
      ldrize_cooperation
      uaSwitchLite
      walk-input
      xpcom_inspector
      httpheaders
      noscript
    </>.toString().split(/\s+/)
      .filter(function(n) !/^!/.test(n));

    if (!$LU.is_ff4()) {
      <>
        refcontrol
        autoproxychanger
        migemized_find
        migratestatusbar
      </>.toString().split(/\s+/).forEach(function(v) gv.plugin_loader_plugins.push(v));
    }
    //}}}

    // {{{ copy.js
    gv.copy_templates = [
      { label: 'titleAndURL',      value: '%TITLE% %URL%' },
      { label: 'title',                    value: '%TITLE%' },
      { label: 'hatena',               value: '[%URL%:title=%TITLE%]' },
      { label: 'hatenacite',       value: '>%URL%:title=%TITLE%>\n%SEL%\n<<' },
      { label: 'markdown',             value: '[%SEL%](%URL% "%TITLE%")' },
      { label: 'htmlblockquote', value: '<blockquote cite="%URL%" title="%TITLE%">%HTMLSEL%</blockquote>' },
      { label: 'tinyurl',              value: 'Get Tiny URL', custom: function() util.httpGet('http://tinyurl.com/api-create.php?url=' + encodeURIComponent(buffer.URL)).responseText },
        { label: 'allTabsURL',       value: '%URL% for All Tabs', custom: function(){
          var tabs = gBrowser.mTabs;
          var m='';
          for (var i=0, l=tabs.length; i<l; i++)
            m+=tabs[i].linkedBrowser.contentDocument.location.href + '\n';
          return m;
        }},
        { label: 'allTabsTitleAndURL', value: '%TITLE% %URL% for All Tabs', custom: function(){
          var tabs = gBrowser.mTabs;
          var m='';
          for (var i=0, l=tabs.length; i<l; i++)
            m+=tabs[i].linkedBrowser.contentDocument.title + '\t' + tabs[i].linkedBrowser.contentDocument.location.href + '\n';
          return m;
        }},
    ]; // }}}

    // multi_requester.js
    gv.multi_requester_default_sites = 'alc,goo'

    // refcontrol.js {{{
    gv.refcontrol_enabled = true;
    gv.refcontrol = {
      '@DEFAULT'       : '@FORGE',                // @NORMAL, @FORGE, '', url
      'tumblr.com'     : '@FORGE',
      'del.icio.us'    : '@NORMAL',
      'fc2.com'            : '',
      'itmedia.co.jp': '@FORGE',
      'uploader.jp'    : '@NORMAL',
      'megalodon.jp' : '@NORMAL',
      'livedoor.com' : '@NORMAL',
      'sourceforge.net'   : '@NORMAL',
      'vector.co.jp'      : '@NORMAL',
      'jude.change-vision.com'    : '@NORMAL',
      'www2.technobahn.com' : 'http://www.technobahn.com/',
    }; // }}}

    if (! $LU.is_ff4()) {
      // {{{ migrate.js
      gv.migrate_elements = [ {
        // star button of awesome bar
        id:      'star-button',
        dest:    'security-button',
        after: true,
      }, {
        // icon that show the existence of RSS and Atom on current page
        id:      'feed-button',
        dest:    'security-button',
        after: true,
      }, {
        // favicon of awesome bar
        id:      'page-proxy-stack',
        dest:    'liberator-statusline',
        after: false,
      },
      ];
      // }}}
    }

    // {{{ autochanger_proxy.js
    gv.autochanger_proxy_enabled = true;
    gv.autochanger_proxy_settings = [{
      name  : 'disable',
      usage : 'direct connection',
      proxy : {
      type  : 0,
      },
    }];
    if ($LU.is_win()) {
      gv.autochanger_proxy_settings.push( {
        name    : 'http',
        usage : 'localhost:8080',
        proxy :{
          type      : 1,
          http      : 'localhost',
          http_port : 8080,
        },
        url     : /http:\/\/www.nicovideo.jp/,
        run     : 'C:\\Personal\\Apps\\Internet\\NicoCacheNl\\NicoCacheGui.bat',
        args    : [],
      });
    }
    // }}}

    // applauncher.js {{{
    if ($LU.is_win()) {
      gv.applauncher_list = [
        [ 'Sleipnir', 'C:\\Personal\\Apps\\Internet\\sleipnir\\bin\\Sleipnir.exe', '%URL%'],
        [ 'Internet Explorer', 'C:\\Program Files\\Internet Explorer\\iexplore.exe', '%URL%'],
      ];
    } else if ($LU.is_mac()) {
      gv.applauncher_list = [
        ['safari', 'open', ['-a', '/Applications/Safari', '%URL%' ]],
        ['opera', 'open', ['-a', '/Applications/Opera', '%URL%' ]],
        ['google chrome', 'open', ['-a', '/Applications/Google\ Chrome', '%URL%' ]],
      ];
    } else if ($LU.is_unix()) {
      gv.applauncher_list = [
      ];
    } // }}}

    // {{{ exopen.js
    gv.exopen_templates = [
      {
      label: 'vimpnightly',
      value: 'http://code.google.com/p/vimperator-labs/downloads/list?can=1&q=label:project-vimperator',
        description: 'open vimperator nightly xpi page',
      newtab: true
    }, {
      label: 'vimplab',
      value: 'http://www.vimperator.org/vimperator',
        description: 'open vimperator trac page',
      newtab: true
    }, {
      label: 'vimpscript',
      value: 'http://code.google.com/p/vimperator-labs/issues/list?can=2&q=label%3Aproject-vimperator+label%3Atype-plugin',
        description: 'open vimperator trac script page',
      newtab: true
    }, {
      label: 'coderepos',
      value: 'http://coderepos.org/share/browser/lang/javascript/vimperator-plugins/trunk/',
        description: 'open coderepos vimperator-plugin page',
      newtab: true
    }, {
      label: 'sldr',
      value: 'subscribe feed to livedoor reader',
      custom: function(val, args){
        var url = buffer.URL;
        if (/https?:\/\/(\w+)\.g\.hatena\.ne\.jp/.test(url))
          url = 'http://pipes.yahoo.com/pipes/pipe.run?_id=TssmX7bb2xGYLar_l7okhQ&_render=rss&group_id=' + RegExp.$1;
        return 'http://reader.livedoor.com/subscribe/'+url;
      }
    }, {
      label: 'hatena',
      value: 'open hatena diary',
      custom: function(val, args){
        var url = buffer.URL;
        if (/https?:\/\/.+\.hatena\.ne\.jp\/(\w+)/.test(url))
          return 'http://d.hatena.ne.jp/'+RegExp.$1+'/';
          liberator.log(args.string);
        if (args.string.length > 0)
          return 'http://d.hatena.ne.jp/' + args.string + '/';
      }
    }, {
      label: 'hateb',
      value: 'open hatena bookmark',
      custom: function(val, args){
        var url = buffer.URL;
        if (/https?:\/\/.+\.hatena\.ne\.jp\/(\w+)/.test(url))
          return 'http://b.hatena.ne.jp/'+RegExp.$1+'/';
        if (args.string.length > 0)
          return 'http://b.hatena.ne.jp/' + args.string + '/';
        return 'http://b.hatena.ne.jp/entry/'+url;
      }
    }, {
      label: 'gyotaku',
      value: 'http://megalodon.jp/?url=%URL%',
        description: 'create web gyotaku'
    }, {
      label: 'sitonomy',
      value: 'http://www.sitonomy.com/?url=%URL%',
        description: 'analyze used library'
    }, {
      label: '2chdat',
      value: 'http://www.geocities.jp/mirrorhenkan/url0.html?u=%URL%',
        description: '2ch dat\u691C\u7D22'
    }, {
      label: 'webarchive',
      value: 'http://web.archive.org/web/*/%URL%'
    }, {
      label: 'googlecache',
      value: 'http://www.google.com/search?q=cache:%URL%'
    }, {
      label: 'qr',
      value: 'http://qrcode.jp/qr?q=%URL%',
      newtab: true
    }, {
      label: 'ping',
      value: 'http://www.dnsstuff.com/tools/ping.ch?ip=%URL%'
    }, {
      label: 'traceroute',
      value: 'http://www.dnsstuff.com/tools/tracert.ch?ip=%URL%'
    }, {
      label: 'whois',
      value: 'http://www.whois.net/whois.cgi2?d=%URL%'
    }];
    // }}}

    // {{{ uaSwitchLite.js
    gv.useragent_list = [
    {
        description: 'Internet Explorer 7 (Windows Vista)',
        useragent: 'Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)',
        appname: 'Microsoft Internet Explorer',
        appversion: '4.0 (compatible; MSIE 7.0; Windows NT 6.0)',
        platform: 'Win32',
    }, {
        description: 'Netscape 4.8 (Windows Vista)',
        useragent: 'Mozilla/4.8 [en] (Windows NT 6.0; U)',
        appname: 'Netscape',
        appversion: '4.8 [en] (Windows NT 6.0; U)',
        platform: 'Win32',
    }, {
        description: 'Opera 9.25 (Windows Vista)',
        useragent: 'Opera/9.25 (Windows NT 6.0; U; en)',
        appname: 'Opera',
        appversion: '9.25 (Windows NT 6.0; U; en)',
        platform: 'Win32',
    }, {
        description: 'Netscape 4.8 (Windows XP)',
        useragent: 'Mozilla/4.8 [en] (Windows NT 5.1; U)',
        appname: 'Netscape',
        appversion: '4.8 [en] (Windows NT 5.1; U)',
        platform: 'Win32',
    }, {
        description: 'Opera 8 (Windows XP)',
        useragent: 'Opera/8.02 (Windows NT 5.1; U; en)',
        appname: 'Opera',
        appversion: '8.02 (Windows NT 5.1; U; en)',
        platform: 'Win32',
    }, {
        useragent: 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
        description: 'Internet Explorer 6 (Windows XP)',
        appname: 'Microsoft Internet Explorer',
        appversion: '4.0 (compatible; MSIE 6.0; Windows NT 5.1)',
        platform: 'Win32',
    }, {
        description: 'iPhone',
        useragent: 'Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3',
        appname: 'Safari',
        appversion: 'Version/3.0 Mobile/1A543a Safari/419.3',
        platform: '(iPhone; U; CPU like Mac OS X; en)',
        vendor: 'Apple',
    }, {
        description: 'Internet Explorer (Mac OS X)',
        useragent: 'Mozilla/4.0 (compatible; MSIE 5.23; Mac_PowerPC)',
    }, {
        description: 'Safari (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; ja-jp) AppleWebKit/125.4 (KHTML, like Gecko) Safari/125.9',
    }, {
        description: 'iCab (Mac OS X)',
        useragent: 'Mozilla/4.5 (compatible; iCab 2.9.8; Macintosh; U; PPC; Mac OS X)',
    }, {
        description: 'Shiira (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; ja-jp) AppleWebKit/417.9 (KHTML, like Gecko) Shiira/1.2.1 Safari/125',
    }, {
        description: 'Camino (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.7.8) Gecko/20050427 Camino/0.8.4',
    }, {
        description: 'SunriseBrowser (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; Ja-jp) AppleWebKit/125.5.7 (KHTML, like Gecko) SunriseBrowser/0.798',
    }, {
        description: 'OmniWeb (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X; en-US) AppleWebKit/125.4 (KHTML, like Gecko, Safari) OmniWeb/v563.66',
    }, {
        description: 'Flock (Mac OS X)',
        useragent: 'Mozilla/5.0 (Macintosh; U; PPC Mac OS X Mach-O; en-US; rv:1.8.0.1) Gecko/20060217 Flock/0.5.11',
    }, {
        description: 'FOMA DoCoMo SH901iC',
        useragent: 'DoCoMo/2.0 SH901iC(c100;TB;W24H12)',
    }, {
        description: 'mova DoCoMo N503is',
        useragent: 'DoCoMo/1.0/N503is/c10',
    }, {
        description: 'EZweb (WAP 2.0/XHTML-MP対応機)',
        useragent: 'KDDI-KC31 UP.Browser/6.2.0.5 (GUI) MMP/2.0',
    }, {
        description: 'EZweb (HDML)',
        useragent: 'UP.Browser/3.04-TS14 UP.Link/3.4.4',
    }, {
        description: 'Vodafone live! (New 3G)',
        useragent: 'Vodafone/1.0/V802SE/SEJ001 Browser/SEMC-Browser/4.1 Profile/MIDP-2.0 Configuration/CLDC-1.1',
    }, {
        description: 'Vodafone live! (Old 3G)',
        useragent: 'J-PHONE/5.0/V801SA/SN123456789012345 SA/0001JP Profile/MIDP-1.0 Configuration/CLDC-1.0',
    }, {
        description: 'Air EDGE PHONE',
        useragent: 'Mozilla/3.0(DDIPOCKET;JRC/AH-J3001V,AH-J3002V/1.0/0100/c50)CNF/2.0',
    }, {
        description: 'H"',
        useragent: 'PDXGW/1.0 (TX=8;TY=6;GX=96;GY=64;C=G2;G=B2;GI=0)',
    }, {
        description: 'ASTEL',
        useragent: 'ASTEL/1.0/J-0511.00/c10/smel',
    }, {
        description: 'Google',
        useragent: 'Googlebot/2.1 (+http://www.google.com/bot.html)',
    }, {
        description: 'Yahoo!',
        useragent: 'Mozilla/5.0 (compatible; Yahoo! Slurp; http://help.yahoo.com/help/us/ysearch/slurp)',
    }, {
        description: 'MSN',
        useragent: 'msnbot/0.11 (+http://search.msn.com/msnbot.htm)',
    }]; // }}}
  } // }}}
})({
  is_win  : function() liberator.has('Win32'),
  is_mac  : function() liberator.has('MacUnix'),
  is_unix : function() liberator.has('Unix'),
  is_ff4  : function() liberator.version.indexOf('2.') != 0,
  sprintf : function() {
    var args = Array.prototype.slice.call(arguments, 0);
    return args.shift().replace(/%[s%]/g, function(c) {
      return c == '%%' ? '%' :args.shift();
    });
  }
});
/* {{{
// {{{ ==================== for ldr ====================
autocommands.add('DOMLoad' , 'http://reader\.livedoor\.com/reader/', function(arg){
  var w = gBrowser.mTabs[arg.tab-1].linkedBrowser.contentWindow.wrappedJSObject; //gBrowser.contentWindow.wrappedJSObject;
w.addEventListener('load', function(){
  // add susubscribe keybind
  w.Keybind.add('q', w.Control.unsubscribe);
}, false);
});
// }}}

// {{{ localkeymode.js
(function(){
  var hbControl = function(is_edit){
    var doc = content.window.document;
    var n = doc.evaluate(
      '//h3[contains(concat(" ",normalize-space(@class), " ")," current-element ")]'
      , doc, null , XPathResult.FIRST_ORDERED_NODE_TYPE, null);
      if (!n) return;
      var bmid = n.singleNodeValue.id.replace(/[^\-]+-/,'');
//  var paragraph = liberator.plugins.LDRizeCooperation.LDRize.getParagraphes();
//  var pos = paragraph.current.position + 1;
//  var doc = content.window.document;
//  var n = doc.evaluate('//descendant::h3[@class="entry"]['+pos+']', doc, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
//  if (!n) return;
//  var bmid = n.singleNodeValue.id.replace(/[^\-]+-/,'');

      var e = doc.createEvent('MouseEvents');
      e.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);

      var cn = doc.evaluate('//span[@class="bookmark-appender-cancel"]', doc, null, XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null);
      for (let i=0, l=cn.snapshotLength; i<l ; i++) cn.snapshotItem(i).dispatchEvent( e );

      var node = doc.getElementById('delete-'+bmid);
      if (!node) return;
      var target = is_edit ? node.nextElementSibling : node ;

      e.initMouseEvent('mouseover', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
      target.dispatchEvent( e );
      e.initMouseEvent('click', true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
      target.dispatchEvent( e );
  };

  liberator.globalVariables.localKeyMappings=[
    [ /www\.nicovideo\.jp\/watch\//, [
      ['p', ':stplay'],
      ['m', ':stmute'],
      ['z', ':stsize '],
      ['c', ':stcomment '],
      ['<Right>', ':stseek! +2'],
      ['<Left>', ':stseek! -2'],
      ['<C-Right>', ':stseek! +10'],
      ['<C-Left>', ':stseek! -10'],
      ['<Up>', ':stvolume! +5'],
      ['<Down>', ':stvolume! -5'],
      ['<C-Up>', ':stvolume! +10'],
      ['<C-Down>', ':stvolume! -10'],
      ['<Space>', ':stplay'],
  ]],
  [ /www\.nicovideo\.jp/, [
    ['nA', ':nnppushallvideos'],
    ['nc', ':nnpclear'],
    ['ng', ':nnpgetlist '],
    ['no', ':nnpplaynext '],
    ['np', ':nnppushthisvideo'],
  ]],
  [ /(www|jp)\.youtube\.com/, [
    ['p', ':stplay'],
    ['m', ':stmute'],
    ['z', ':stsize '],
    ['c', ':stcomment '],
    ['<Right>', ':stseek! +2'],
    ['<Left>', ':stseek! -2'],
    ['<C-Right>', ':stseek! +10'],
    ['<C-Left>', ':stseek! -10'],
    ['<Up>', ':stvolume! +5'],
    ['<Down>', ':stvolume! -5'],
    ['<C-Up>', ':stvolume! +10'],
    ['<C-Down>', ':stvolume! -10'],
    ['<Space>', ':stplay'],
  ]],
  [ 'jk-scroll', [
    ['j', '<C-d>'],
    ['k', '<C-u>'],
  ]],
  [ /b\.hatena\.ne\.jp/, [
    ['e', function() hbControl(true)],
    ['q', function() hbControl(false)],
  ]],
  ];
})();
// {{{ mouse_gestures.js
liberator.globalVariables.mousegesture_list = [
  ['L'    , 'Back', '#Browser:Back'],
  ['R'    , 'Forward', '#Browser:Forward'],
  ['RLR', 'Close Tab Or Window', '#cmd_close'],
  ['LD' , 'Stop Loading Page', '#Browser:Stop'],
  ['LR' , 'Undo Close Tab', '#History:UndoCloseTab'],
  ['DL' , 'Select Previous Tab' , function() gBrowser.tabContainer.advanceSelectedTab(-1, true) ],
  ['DR' , 'Select Next Tab' , function() gBrowser.tabContainer.advanceSelectedTab(+1, true) ],
  ['RU' , 'Scroll To Top', function() goDoCommand('cmd_scrollTop')],
  ['RD' , 'Scroll To Bottom', function() goDoCommand('cmd_scrollBottom')],
  ['D'    , 'Lock This Tab', function() gBrowser.lockTab(gBrowser.mCurrentTab)],
  ['LUD', 'Close Left Tabs', ':closelefttabs'],
  ['RUD', 'Close Right Tabs', ':closerighttabs'],
  ['U'    , 'Move To Upper Directory', 'gu', true],
  ['UD' , 'Add Bookmark', ':dialog addbookmark'],
]; //}}}

// }}}
 }}} */
// vim: set fdm=marker sw=2 ts=2 et:
