if v:version < 700
  echoerr "does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_csvutil')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:TsvToMdTable() range
  call csvutil#table#markdown#new().tabularize_from_tsv(a:firstline, a:lastline) 
endfunction
command! -range TsvToMdTable :<line1>,<line2>call <SID>TsvToMdTable()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_csvutil = 1

" vim: foldmethod=marker
