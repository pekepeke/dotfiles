"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" load once {{{
if !exists('g:loaded_java_ftplugin')
  let g:loaded_java_ftplugin=1

  let java_highlight_all=1
  let java_highlight_debug=1
  let java_highlight_functions="style"
  let java_allow_cpp_keywords=1
  let g:loaded_java_ftplugin = 1
endif

let b:match_words = &matchpairs . ',\<try\>:\<catch\>:\<finally\>'

let &cpo = s:save_cpo
