let s:save_cpo = &cpo
set cpo&vim

setl iskeyword+=-,+
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <buffer> <expr> \ synchat#isnt_src()?'\':smartchr#one_of('\', 'function ', '\\')
endif

let s:save_cpo = &cpo
