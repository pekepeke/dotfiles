let s:save_cpo = &cpo
set cpo&vim

" {{{1
function! csvutil#csv_reader() "{{{2
  return csvutil#reader#new()
endfunction

function! csvutil#tsv_reader() "{{{2
  return csvutil#reader#tsv_new()
endfunction

function! csvutil#csv_writer() "{{{2
  return csvutil#writer#new()
endfunction

function! csvutil#tsv_writer() "{{{2
  return csvutil#writer#tsv_new()
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
