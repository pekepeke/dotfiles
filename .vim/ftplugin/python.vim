"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab
if exists('g:loaded_python_ftplugin')
  "syntax highlight
  let python_highlight_all=1

  let g:loaded_python_ftplugin=1
endif


let &cpo = s:save_cpo