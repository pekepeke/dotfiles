"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab
setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
if exists('g:loaded_python_ftplugin')
  "syntax highlight
  let python_highlight_all=1

  let g:loaded_python_ftplugin=1
endif
nmap <silent> [!comment-doc] <Plug>(pydocstring)

let &cpo = s:save_cpo
