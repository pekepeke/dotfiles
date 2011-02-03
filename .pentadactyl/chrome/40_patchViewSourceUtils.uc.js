// ==UserScript==
// @name           patchViewSourceUtils.uc.js
// @namespace      http://space.geocities.yahoo.co.jp/gl/alice0775
// @description    ドキュメントタイトルが日本語の場合に外部エディタによるソース表示ができるように
// @include        main
// @compatibility  Firefox 2.0 3.0 3.1
// @author         Alice0775
// @version        LastMod 2008/10/21 00:00 3.1b2pre(thanks 音吉)
// ==/UserScript==
// @version        2007/12/22 13:00 ローカルファイルにも対応?
// @version        2007/12/22 00:00
// @Note           大雑把にパッチしただけなので, たぶんwindowsでのみ動作
// @Note           Bug 408923 – View source with an external editor doesn't works with a web page with a ' in title and UTF-8 encoding, editor is opened but file is not found
(function(){
  var func = gViewSourceUtils.viewSourceProgressListener.onStateChange.toString();
  func = func.replace(
    'this.editor.run(false, [this.file.path], 1);',
    'this.editor.run(false, [ucjs_patch_convertFileName(this.file.path)], 1);'
  );
  //Fx3.1b2pre
  func = func.replace(
    'editorArgs.push(this.file.path);',
    'editorArgs.push(ucjs_patch_convertFileName(this.file.path));'
  );
  eval("gViewSourceUtils.viewSourceProgressListener.onStateChange = " + func);

  eval("gViewSourceUtils.openInExternalEditor = " + gViewSourceUtils.openInExternalEditor.toString().replace(
  'editor.run(false, [path], 1);',
  'editor.run(false, [ucjs_patch_convertFileName(path)], 1);'
  ));
  function ucjs_patch_convertFileName(fileName){
    var UI = Components.classes['@mozilla.org/intl/scriptableunicodeconverter'].createInstance(Components.interfaces.nsIScriptableUnicodeConverter);

    var platform = window.navigator.platform.toLowerCase();
    if(platform.indexOf('win') > -1){
      UI.charset = 'Shift_JIS';
    }else{
      UI.charset =  'UTF-8';
    }
    return UI.ConvertFromUnicode(fileName);
  }
})();