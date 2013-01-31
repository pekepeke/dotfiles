scriptencoding utf-8

if !exists('g:loaded_java_ftplugin')
  let g:loaded_java_ftplugin=1

  let java_highlight_all=1
  let java_highlight_debug=1
  let java_highlight_functions="style"
  let java_allow_cpp_keywords=1
endif

let s:save_cpo = &cpo
set cpo&vim

setlocal iskeyword+=@-@
setlocal makeprg=javac\ %

nnoremap [comment-doc] :call JCommentWriter()<CR>

if !exists('b:java_android_detected')
  let b:java_android_detected = 1

  " http://d.hatena.ne.jp/shimobayashi/20110327/1301232380
  " https://github.com/anddam/android-javacomplete
  " https://github.com/bpowell/vim-android/blob/master/findAndroidManifest/after/ftplugin/java.vim
  " if 'AndroidManifest.xml'
endif

let &cpo = s:save_cpo
