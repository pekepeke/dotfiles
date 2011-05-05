" A ref source for cheat.gem
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim



" options. {{{1
if !exists('g:ref_cheat_cmd')  " {{{2
  let g:ref_cheat_cmd = executable('cheat') ? 'cheat' : ''
endif

let s:source = {'name': 'cheat'}  " {{{1

function! s:source.available()  " {{{2
  return !empty(g:ref_cheat_cmd)
endfunction



function! s:source.get_body(query)  " {{{2
  if empty(a:query)
    return join(s:cache(), "\n")
  endif

  let res = s:cheat(a:query)
  if res.stderr != ''
    throw matchstr(res.stderr, '^.\{-}\ze\n')
  endif

  let content = res.stdout
  if content =~ "^Error!:"
    throw content
  endif
  return content
endfunction



function! s:source.opened(query)  " {{{2
  "call s:syntax()
  1
endfunction



function! s:source.complete(query)  " {{{2
  let m = [] + s:cache()
  if !empty(a:query)
    call filter(m, 'v:val =~ ".*' . a:query . '.*"')
  endif
  return m
endfunction




function! s:source.get_keyword()  " {{{2
  let isk = &l:isk
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:isk = isk

  let items = s:source.complete(kwd)
  if len(items) > 0
    return len(items) == 1 ? items[0] : kwd
  endif

  return ""
endfunction



" functions. {{{1
function! s:gather_func(name)  "{{{2
  let res = s:cheat("sheets")
  let m = split(res.stdout, "\n")
  return map(m[1:], 'substitute(v:val, " ", "", "g")')
endfunction

function! s:func(name)  "{{{2
  return function(matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunc$') . a:name)
endfunction

function! s:cache() " {{{2
  return ref#cache('cheat', 'sheets', s:func('gather_func'))
endfunction

function! s:cheat(args)  " {{{2
  return ref#system(ref#to_list(g:ref_cheat_cmd) + ref#to_list(a:args))
endfunction



function! ref#cheat#define()  " {{{2
  return copy(s:source)
endfunction

"call ref#register_detection('', '')  " {{{1



let &cpo = s:save_cpo
unlet s:save_cpo
