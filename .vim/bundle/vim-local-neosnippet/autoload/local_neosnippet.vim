let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let g:local_neosnippet#filename = get(g:, 'local_neosnippet#filename', ".&filetype.snip")
let g:local_neosnippet#edit_method = get(g:, 'local_neosnippet#edit_method', "split")

" util functions {{{1
function! s:snippet_edit()
  if exists('b:local_neosnippet_current_snip')
    execute g:local_neosnippet#edit_method b:local_neosnippet_current_snip
  endif
endfunction

" public functions {{{1
function! local_neosnippet#source(basedir)
  let filename = a:basedir . "/" . substitute(g:local_neosnippet#filename, '&filetype', &filetype, "")
  if filereadable(filename)
    execute 'NeoSnippetSource' filename
  endif
  let b:local_neosnippet_current_snip = filename
  command! -buffer LocalNeoSnippetEdit call s:snippet_edit()
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
