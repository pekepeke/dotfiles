if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_jqplay')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:jqplay_opt = get(g:, "jqplay_opt", "")

command! JQPlay call jqplay#open()

let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_jqplay = 1
" vim: foldmethod=marker
