let s:save_cpo = &cpo
set cpo&vim

if !exists('g:synchat#plain_patterns')
  let g:synchat#plain_patterns = {}
endif
if !exists('g:synchat#plain_patterns._')
  let g:synchat#plain_patterns._ = 'String\|Comment\|None'
endif

function! synchat#is(pattern) "{{{2
  let syntax = synstack(line('.'), col('.'))
  let name = empty(syntax) ? '' : synIDattr(syntax[-1], "name")
  return name =~# a:pattern
endfunction

function! synchat#is_str() "{{{2
  return synchat#is(s:get_pattern())
endfunction

function! synchat#isnt_str() "{{{2
  return synchat#is(s:get_pattern())
endfunction

function! s:get_pattern() "{{{2
  return get(g:, 'synchat#plain_patterns.'.&filetype,
        \ g:synchat#plain_patterns._)
endfunction

" deprecated
function! synchat#is_src() "{{{2
  return !synchat#is(s:get_pattern())
endfunction

function! synchat#isnt_src() "{{{2
  return synchat#is(s:get_pattern())
endfunction


let &cpo = s:save_cpo
