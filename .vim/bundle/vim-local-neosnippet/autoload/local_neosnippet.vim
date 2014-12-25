let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let g:local_neosnippet#filename = get(g:, 'local_neosnippet#filename', '.&filetype.snip')
let g:local_neosnippet#edit_method = get(g:, 'local_neosnippet#edit_method', "split")

" util functions {{{1
function! s:snippet_edit() "{{{2
  if exists('b:local_neosnippet_current_snip')
    execute g:local_neosnippet#edit_method b:local_neosnippet_current_snip
  endif
endfunction

function! s:snippet_filename(basedir, ft) "{{{2
  return a:basedir . '/' .
    \ substitute(g:local_neosnippet#filename, '&filetype', a:ft, "")
endfunction

function! s:snippet_source(basedir, ft) "{{{2
  let f = s:snippet_filename(a:basedir, a:ft)
  if filereadable(f)
    execute 'NeoSnippetSource' f
    if empty(b:local_neosnippet_current_snip)
      let b:local_neosnippet_current_snip = f
    endif
  endif
endfunction

" public functions {{{1
function! local_neosnippet#source(basedir) "{{{2
  let b:local_neosnippet_current_snip = ''
  let filetypes = [&filetype]
  let splitted = split(&filetype, '\.')
  if len(splitted) > 1
    let filetypes += reverse(splitted)
  endif
  call map(reverse(filetypes), 's:snippet_source(a:basedir, v:val)')
  if empty(b:local_neosnippet_current_snip)
    let b:local_neosnippet_current_snip = s:snippet_filename(a:basedir, &filetype)
  endif
  command! -buffer LocalNeoSnippetEdit call s:snippet_edit()
  execute printf('command! -buffer LocalNeoSnippetReload'
        \ . " call local_neosnippet#source('%s')", a:basedir)
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
