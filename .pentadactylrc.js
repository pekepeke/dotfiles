// ==================== for firefox preferences ====================
// for browsing speed tuneup
//prefs.set('network.prefetch-next', true);// prefetch default true
prefs.set('network.http.pipelining', true);
prefs.set('network.http.pipelining.firstrequest', true);
prefs.set('network.http.pipelining.maxrequests', 8);
prefs.set('network.http.max-connections', 32);
prefs.set('network.http.max-connections-per-server', 24);
prefs.set('network.http.max-persistent-connections-per-proxy', 16);
prefs.set('network.http.max-persistent-connections-per-server', 8);
prefs.set('nglayout.initialpaint.delay', 500);
prefs.set('plugin.expose_full_path', true);
prefs.set('ui.submenuDelay', 0);
prefs.set('content.interrupt.parsing', true);
prefs.set('content.max.tokenizing.time', 2250000);
prefs.set('content.notify.backoffcount', 5);
prefs.set('content.notify.interval', 750000);
prefs.set('content.notify.ontimer', true);
prefs.set('content.switch.threshold', 750000);
prefs.set('content.maxtextrun', 8191);

prefs.set('mousewheel.withnokey.numlines', 5);// マウスのスクロール量
prefs.set('mousewheel.withnokey.sysnumlines', false);

prefs.set('browser.cache.memory.enable', true);
prefs.set('browser.cache.memory.capacity', 32768);
prefs.set('browser.cache.disk_cache_ssl', false);
//prefs.set('browser.cache.disk_cache_ssl', true);
//prefs.set('browser.cache.disk.enable', false);
prefs.set('browser.tabs.closeButtons', 2);//x ボタン off
prefs.set('browser.tabs.autoHide', false);
prefs.set('browser.tabs.tabMaxWidth', 120);
prefs.set('browser.tabs.tabMinWidth', 120);
prefs.set('browser.tabs.warnOnClose', false);
prefs.set('browser.tabs.loadDivertedInBackground', true);// バックグラウンドでタブを開く
prefs.set('browser.link.open_newwindow.restriction', 0);// window.open() もタブで開く
prefs.set('browser.display.show_image_placeholders', false);//代理画像アイコンoff
prefs.set('browser.history_expire_days_min', 3); //履歴(最短保持期間)
prefs.set('browser.history_expire_days', 15); //履歴(最長保持期間)
prefs.set('browser.sessionhistory.max_total_viewers', 3); // 高速Back/Forward
prefs.set('browser.sessionstore.interval', 120000); // セッションを保存する間隔。

prefs.set('browser.block.target_new_window', true);//新しいウィンドウを開かずに既存のウィンドウに新しいタブを開かせます。
prefs.set('browser.chrome.image_icons.max_size', 0);// タブに差胸いるを作らない
prefs.set('browser.download.manager.showAlertOnComplete', false);//ダウンロードが終了しました off
prefs.set('browser.download.manager.closeWhenDone', true);
prefs.set('browser.download.manager.retention', 1);// 完了したダウンロードとキャンセルされたダウンロードの履歴はアプリケーション終了時に削除
prefs.set('browser.download.manager.showWhenStarting', false);// ダウンロードマネージャにフォーカス移さない
prefs.set('browser.download.manager.useWindow', false);// ステータスバーに進捗状況表示
prefs.set('browser.download.manager.scanWhenDone', false);// Virus Scan Off
prefs.set('browser.blink_allowed', false);// blinkタグ無効
prefs.set('browser.search.openintab', true);// 検索結果を新しいタブで開く
prefs.set('browser.enable_automatic_image_resizing', false);// イメージを勝手にリサイズさせない
prefs.set('browser.xul.error_pages.enabled', true);
prefs.set('config.trim_on_minimize', true); // ウィンドウ最小化時にメモリshrink/Winのみ有効/でも、ディスクを使うことになるので、外した方がいいかも
prefs.set('layout.spellcheckDefault', 0); // spellcheck off
prefs.set('network.dns.disableIPv6', true);
prefs.set('dom.popup_maximum',2000);// popup数
prefs.set('extensions.getAddons.showPane',false);// おすすめアドオンいらない
prefs.set('security.dialog_enable_delay', 0);// addon installer delay
prefs.set('plugin.expose_full_path', true);
prefs.set('signed.applets.codebase_principal_support', true);
prefs.set('layout.spellcheckDefault', 2);
prefs.set('browser.chrome.toolbar_tips', false);
//prefs.set('general.useragent.locale','ja');
prefs.set('images.dither', 'false');//画像のディザを補正する

//http://kano.feena.jp/?firefox
prefs.set('layout.frames.force_resizability', true);//フレームを常にリサイズ可能に
prefs.set('view_source.wrap_long_lines', true);//ソースの表示で長い行を自動的に折り返す
prefs.set('nglayout.events.dipatchLeftClickOnly', true);// 右クリックを禁止にさせない
prefs.set('dom.disable_window_open_feature.location', true);// URLバー・スクロールバーは隠すの禁止
prefs.set('dom.disable_window_open_feature.scrollbars',true);

// disable accesskey
prefs.set('ui.key.generalAccessKey', 9);

// for debug vimperator
//prefs.set('extensions.liberator.loglevel', 1);
prefs.reset('extensions.liberator.loglevel');

// ==================== for os difference ====================
new function() {
	var dispatcher = function(config, callback) {
		for (var os_type in config)
			if (liberator.has(os_type))
				callback.call(null, config[os_type] );
	};
	dispatcher({
		'Win32': [['editor', 'C:\\\\Personal\\\\Apps\\\\Editor\\\\sakura\\\\sakura.exe']],
		'MacUnix' : [],
		'Unix' : [['editor', 'gvim']],
	}, function(matrix) {
		matrix.forEach( function([key, val] ) options.store.set(key, val) );
	});
	var remap_conf = {
		'Win32' : [
			"nnoremap <C-c> <C-v><C-c>",
			"nnoremap <C-a> <C-v><C-a>",
			"cnoremap <C-a> <C-v><C-a>",
			"cnoremap <C-z> <C-v><C-z>",
			"cnoremap <C-x> <C-v><C-x>",
			"cnoremap <C-c> <C-v><C-c>",
			"cnoremap <C-v> <C-v><C-v>",
			"inoremap <C-a> <C-v><C-a>",
			"inoremap <C-z> <C-v><C-z>",
			"inoremap <C-x> <C-v><C-x>",
			"inoremap <C-c> <C-v><C-c>",
			"inoremap <C-v> <C-v><C-v>",
		],
		'MacUnix' : [
			"cnoremap <M-a> <C-v><M-a>",
			"cnoremap <M-z> <C-v><M-z>",
			"cnoremap <M-x> <C-v><M-x>",
			"cnoremap <M-c> <C-v><M-c>",
			"cnoremap <M-v> <C-v><M-v>",
			"inoremap <M-a> <C-v><M-a>",
			"inoremap <M-z> <C-v><M-z>",
			"inoremap <M-x> <C-v><M-x>",
			"inoremap <M-c> <C-v><M-c>",
			"inoremap <M-v> <C-v><M-v>",
		],
	};
	remap_conf['Unix'] = remap_conf['Win32'];
	dispatcher(remap_conf, function(cmds) {
		cmds.forEach( function(s, m) liberator.execute(s, m, true) );
	});
};

// ==================== add keybind ====================
// \/ \n で検索(For GMail)
mappings.addUserMap([modes.NORMAL],
	['<Leader>/'], 'Search forward for a pattern',
	function() { modules.search.openSearchDialog(modes.SEARCH_FORWARD);}
);
mappings.addUserMap([modes.NORMAL],
	['<Leader>n'], 'Search forward for a pattern',
	function() { modules.search.findAgain(false);}
);

// ,m で最大化／元のサイズ
mappings.addUserMap([modes.NORMAL],
	[',m'], 'toggle Maximize',
	function() { window.windowState == window.STATE_MAXIMIZED ? window.restore() : window.maximize();}
);


// コマンドラインC-xでURL補完 -- http://mattn.kaoriya.net/software/firefox/vimperator/20080804213818.htm
mappings.addUserMap([modes.COMMAND_LINE], ['<C-y>'],
	'insert current URL to command line',
	function () {
		var cmd = commandline.command();
		if (!cmd.match(/ $/)) cmd += ' ';
		commandline.open(':', cmd+buffer.URL);
});

// statusline の [+-] をわかりやすい位置にわかりやすく表示
(function() {
	if (document.getElementById('liberator-statusline-field-history') == null){
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
})();

//http://d.hatena.ne.jp/nokturnalmortum/20081117#1226922779
//let (cmd = mappings.getDefault(modes.NORMAL, 'd'))
//	let (action = cmd.action)
//		cmd.action = function (count)
//			(count >= 0 ?	 action.apply(this, arguments) : gBrowser.removeTab(gBrowser.mCurrentTab));//gBrowser.closeTab(gBrowser.mCurrentTab));

// setting multiline-output size
document.getElementById('liberator-multiline-output').parentNode.maxHeight = content.innerHeight/2 + 'px';

// ==================== for custom commands ====================
(function(){
	var closeMultiTabs = function(isCloseLeft){
		var pos = gBrowser.mCurrentTab._tPos;
		var start = isCloseLeft == true ? pos - 1 : gBrowser.mTabs.length - 1;
		var end	 = isCloseLeft == true ? 0 : pos + 1;
		if (start - end < 0) return;
		for (var i = start; i >= end; i--) gBrowser.removeTab(gBrowser.mTabs[i]);
	};

	// ←のタブを全て閉じる
	commands.addUserCommand(['closelefttabs'], 'close left tabs', function() closeMultiTabs(true));
	// →のタブを全て閉じる
	commands.addUserCommand(['closerighttabs'], 'close right tabs', function() closeMultiTabs(false));

	var sbox = document.getElementById('sidebar-box');
	if (sbox.getAttribute('collapsed')) sbox.setAttribute('collapsed', false);
	var sbar = commands.get('sbar');
	// サイドバーを開く・閉じる
	commands.addUserCommand(['tsbar','togglesideb[ar]'], 'toggle show/close side bar',
		function(args) {
			var arg = args.string.replace(/^\s|\s$/g,'');
			if (arg) {
				liberator.execute([':sbar ',args].join(''));//,'<CR>'
			} else {
				var sbox = document.getElementById('sidebar-box');
				toggleSidebar(sbox.getAttribute('sidebarcommand'));// if(sidebarBox.hidden);
				//sbox.setAttribute('collapsed', sbox.getAttribute('collapsed') != 'true');
			}
		},{
			completer: sbar.completer
	});

	[ [',,l', ':closerighttabs<CR>'],
		[',,h', ':closelefttabs<CR>'],
	].forEach(function([key, cmd])
		mappings.addUserMap([modes.NORMAL], [key], cmd, function() liberator.execute(cmd) , {rhs:key, noremap: true})
	);
})();

(function(){
function getItems()
	Array.map(gBrowser.mPanelContainer.selectedPanel
		.getElementsByTagName('notification'),
	function(n,i) {return { index : i, label : n.getAttribute('label'), element : n };});

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
			prefs.reset('extensions.liberator.loglevel');
		} else {
			services.get('debugger').on();
			liberator.execute('set verbose=9');
			prefs.set('extensions.liberator.loglevel', 1);
		}
	}, {
		bang: true
	}
);

commands.addUserCommand(['gc','forcegc'], 'force exec garbage collection', function() Components.utils.forceGC() , {});
commands.addUserCommand(['vacuum'], 'vacuum sqlite', function() {
	var conn = Components.classes['@mozilla.org/browser/nav-history-service;1'].getService(Components.interfaces.nsPIPlacesDatabase).DBConnection;
	conn.executeSimpleSQL('vacuum');
	conn.executeSimpleSQL('reindex');
} , {});

// ==================== for userChrome.js/css ====================
(function() {
	if (typeof liberator.plugins.userchrome == 'undefined') liberator.plugins.userchrome = {};
	else return;
//	// xul ファイル読み込み用
//	function loadXUL(file) {
//		var regex = /\.uc\.xul$/i;
//		if (regex.test(file.leafName)) {
//			document.loadOverlay(Components.classes['@mozilla.org/network/io-service;1'].
//				getService(Components.interfaces.nsIIOService).getProtocolHandler('file').
//				QueryInterface(Components.interfaces.nsIFileProtocolHandler).getURLSpecFromFile(file), null);
//		}
//		//if (files.hasMoreElements()) setTimeout(loadXUL, 0, files);
//	}
	try {
		['chrome','css'].forEach( function(dirs){
			var dir = io.getRuntimeDirectories(dirs)[0];
			var regex = /\.(js|vimp|css)$/i;
			io.File(dir).readDirectory(true).forEach(function(file) {
				if (regex.test(file.path)) io.source(file.path, false);
//				else loadXUL( file );
			});
		});
	} catch(e) { liberator.echoerr(e); }
})();

// ==================== for ldr ====================
autocommands.add('DOMLoad' , 'http://reader\.livedoor\.com/reader/', function(arg){
	var w = gBrowser.mTabs[arg.tab-1].linkedBrowser.contentWindow.wrappedJSObject; //gBrowser.contentWindow.wrappedJSObject;
	w.addEventListener('load', function(){
		// add susubscribe keybind
		w.Keybind.add('q', w.Control.unsubscribe);
	}, false);
});

// ==================== for plugin ====================
// copy.js
liberator.globalVariables.copy_templates = [
	{ label: 'titleAndURL',		 value: '%TITLE% %URL%' },
	{ label: 'title',					 value: '%TITLE%' },
	{ label: 'hatena',				 value: '[%URL%:title=%TITLE%]' },
	{ label: 'hatenacite',		 value: '>%URL%:title=%TITLE%>\n%SEL%\n<<' },
	{ label: 'markdown',			 value: '[%SEL%](%URL% "%TITLE%")' },
	{ label: 'htmlblockquote', value: '<blockquote cite="%URL%" title="%TITLE%">%HTMLSEL%</blockquote>' },
	{ label: 'tinyurl',				 value: 'Get Tiny URL', custom: function() util.httpGet('http://tinyurl.com/api-create.php?url=' + encodeURIComponent(buffer.URL)).responseText },
	{ label: 'allTabsURL',		 value: '%URL% for All Tabs', custom: function(){
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
];

// multi_requester.js
liberator.globalVariables.multi_requester_default_sites = 'alc,goo'

// auto_word_select.js
liberator.registerObserver('enter', function() {
	mappings.addUserMap(
		[modes.AUTO_WORD_SELECT],
		['s'],
		'Translate selected word by multi_requester.js.',
		function() {
			// FIXME:
			// A present mode is preserved in the stack beforehand by the push() method
			// because it doesn't return to AUTO_WORD_SELECT mode before that when
			// returning from the OUTPUT_MULTILINE mode.
			modes.push(modes.AUTO_WORD_SELECT, null, true);

			var selText = content.getSelection().toString();
			var pattern = /[a-zA-Z]+/;
			selText = pattern.test(selText) ? pattern.exec(selText) : selText;
			liberator.execute(':mr alc ' + selText);
	});
	// goto next link
	mappings.addUserMap(
		[modes.AUTO_WORD_SELECT, modes.CARET],
		['f'],
		'Follow link',
		function() {
			let selection = content.getSelection();
			if (selection.rangeCount == 0)
				return;
			let link = extractLink(getContainerNode(selection), selection);
			if (link)
				buffer.followLink(link, liberator.CURRENT_TAB);
			else
				liberator.echoerr("Link item doesn't exists.");
	});
	function extractLink(node, selection) {
		if (node.tagName == 'A')
			return node;
		for each (let i in node.getElementsByTagName('a'))
			if (selection.containsNode(i, true))
				return i;
		return null;
	}
});

// refcontrol.js
liberator.globalVariables.refcontrol_enabled = true;
liberator.globalVariables.refcontrol = {
	'@DEFAULT'		 : '@FORGE',				// @NORMAL, @FORGE, '', url
	'tumblr.com'	 : '@FORGE',
	'del.icio.us'	 : '@NORMAL',
	'fc2.com'			 : '',
	'itmedia.co.jp': '@FORGE',
	'uploader.jp'	 : '@NORMAL',
	'megalodon.jp' : '@NORMAL',
	'livedoor.com' : '@NORMAL',
	'sourceforge.net'	: '@NORMAL',
	'vector.co.jp'		: '@NORMAL',
	'jude.change-vision.com'	: '@NORMAL',
	'www2.technobahn.com' : 'http://www.technobahn.com/',
};

// localkeymode.js
(function(){
var hbControl = function(is_edit){
	var doc = content.window.document;
	var n = doc.evaluate('//h3[contains(concat(" ",normalize-space(@class), " ")," current-element ")]'
			, doc, null , XPathResult.FIRST_ORDERED_NODE_TYPE, null);
	if (!n) return;
	var bmid = n.singleNodeValue.id.replace(/[^\-]+-/,'');
//	var paragraph = liberator.plugins.LDRizeCooperation.LDRize.getParagraphes();
//	var pos = paragraph.current.position + 1;
//	var doc = content.window.document;
//	var n = doc.evaluate('//descendant::h3[@class="entry"]['+pos+']', doc, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null);
//	if (!n) return;
//	var bmid = n.singleNodeValue.id.replace(/[^\-]+-/,'');

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
//	['', [
//		['', ''],
//	]],
];
})();

// autochanger_proxy.js
liberator.globalVariables.autochanger_proxy_enabled = true;
liberator.globalVariables.autochanger_proxy_settings = [{
		name	: 'disable',
		usage : 'direct connection',
		proxy :{
			type			:0,
		},
	},{
		name	: 'http',
		usage : 'localhost:8080',
		proxy :{
			type			: 1,
			http			: 'localhost',
			http_port : 8080,
		},
		url		: /http:\/\/www.nicovideo.jp/,
		run		: 'C:\\Personal\\Apps\\Internet\\NicoCacheNl\\NicoCacheGui.bat',
		args	: [],
	}
];

// applauncher.js
liberator.globalVariables.applauncher_list = [
	[ 'Sleipnir', 'C:\\Personal\\Apps\\Internet\\sleipnir\\bin\\Sleipnir.exe', '%URL%'],
	[ 'Internet Explorer', 'C:\\Program Files\\Internet Explorer\\iexplore.exe', '%URL%'],
];

// migrate.js
liberator.globalVariables.migrate_elements = [ {
		// star button of awesome bar
		id:		 'star-button',
		dest:	 'security-button',
		after: true,
	}, {
		// icon that show the existence of RSS and Atom on current page
		id:		 'feed-button',
		dest:	 'security-button',
		after: true,
	}, {
		// favicon of awesome bar
		id:		 'page-proxy-stack',
		dest:	 'liberator-statusline',
		after: false,
	},
];

// exopen.js
liberator.globalVariables.exopen_templates = [
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
	}
];

// mouse_gestures.js
liberator.globalVariables.mousegesture_list = [
	['L'	, 'Back', '#Browser:Back'],
	['R'	, 'Forward', '#Browser:Forward'],
	['RLR', 'Close Tab Or Window', '#cmd_close'],
	['LD' , 'Stop Loading Page', '#Browser:Stop'],
	['LR' , 'Undo Close Tab', '#History:UndoCloseTab'],
	['DL' , 'Select Previous Tab' , function() gBrowser.tabContainer.advanceSelectedTab(-1, true) ],
	['DR' , 'Select Next Tab' , function() gBrowser.tabContainer.advanceSelectedTab(+1, true) ],
	['RU' , 'Scroll To Top', function() goDoCommand('cmd_scrollTop')],
	['RD' , 'Scroll To Bottom', function() goDoCommand('cmd_scrollBottom')],
	['D'	, 'Lock This Tab', function() gBrowser.lockTab(gBrowser.mCurrentTab)],
	['LUD', 'Close Left Tabs', ':closelefttabs'],
	['RUD', 'Close Right Tabs', ':closerighttabs'],
	['U'	, 'Move To Upper Directory', 'gu', true],
	['UD' , 'Add Bookmark', ':dialog addbookmark'],
];

// uaSwitchLite.js
liberator.globalVariables.useragent_list = [
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
}];

