scriptencoding utf-8

if !exists('g:loaded_java_ftplugin')
  let g:loaded_java_ftplugin=1

  let java_highlight_all=1
  let java_highlight_functions="style"
  let java_allow_cpp_keywords=1
endif

let s:save_cpo = &cpo
set cpo&vim

setlocal iskeyword+=@-@
setlocal makeprg=javac\ %

nnoremap [comment-doc] :call JCommentWriter()<CR>

let &cpo = s:save_cpo
