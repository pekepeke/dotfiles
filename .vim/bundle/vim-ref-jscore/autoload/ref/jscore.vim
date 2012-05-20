" A ref source for JavaScript Core documentation.
" Version: 0.0.1
" Author : hikaruworld
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

" config. {{{1
if !exists('g:ref_jscore_path') " {{{2
  let g:ref_jscore_path = ''
endif

if !exists('g:ref_jscore_cmd') " {{{2
  let g:ref_jscore_cmd =
  \ executable('elinks') ? 'elinks -dump -no-numbering -no-references %s' :
  \ executable('w3m') ? 'w3m -dump %s' :
  \ executable('links') ? 'links -dump %s' :
  \ executable('lynx') ? 'lynx -dump -nonumbers %s' :
  \ ''
endif



let s:source = {'name': 'jscore'} " {{{1

function! s:source.available() " {{{2
  return (isdirectory(g:ref_jscore_path) || s:isURL(g:ref_jscore_path))
      \ && len(g:ref_jscore_cmd)
endfunction



function! s:source.get_body(query) " {{{2
  let pre = g:ref_jscore_path . '/'
  if s:isURL(g:ref_jscore_path)
    " FOR URL
    let name = substitute(a:query, 'Core', 'Global_Objects', '')
  else
    " FOR LOCAL PATH
    let name = a:query . '.html' 
  endif
  let file = pre . name
  if filereadable(file) || s:isURL(file) 
    return s:execute(file)
  endif

  throw 'no match: ' . a:query . '|' . file
endfunction



function! s:source.opened(query) " {{{2
  call s:syntax()
endfunction



function! s:source.complete(query) " {{{2
  let list = []
  for item in filter(copy(s:cache()), 'v:val =~# a:query')
    let temp = substitute(item, '.html', '', '')
    call add(list, temp)
  endfor
  if list != []
    return list
  endif
  return []
endfunction



function! s:source.get_keyword() " {{{2
  let isk = &l:isk
  setlocal isk& isk+=. isk+=$
  let kwd = expand('<cword>')
  let &l:isk = isk
  let kwd = substitute(kwd, '^\.', '', '')
  return kwd
endfunction



" functions. {{{1
function! s:syntax() " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-jscore'
    return
  endif

  syntax clear

  let b:current_syntax = 'ref-jscore'
endfunction



function! s:execute(file) "{{{2
  if type(g:ref_jscore_cmd) == type('')
    let cmd = split(g:ref_jscore_cmd, '\s\+')
  elseif type(g:ref_jscore_cmd) == type([])
    let cmd = copy(g:ref_jscore_cmd)
  else
    return ''
  endif

  let file = escape(a:file, '\')
  let res = ref#system(map(cmd, 'substitute(v:val, "%s", file, "g")')).stdout
  if &termencoding != '' && &termencoding !=# &encoding
    let converted = iconv(res, &termencoding, &encoding)
    if converted != ''
      let res = converted
    endif
  endif
  return res
endfunction



function! s:gather_func(name) "{{{2
  let list = glob(g:ref_jscore_path . '/*')
  return map(split(list, "\n"),
        \ 'substitute(v:val, "\\v".g:ref_jscore_path."/", "", "")')
endfunction


function! s:func(name) "{{{2
  return function(matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunc$') . a:name)
endfunction



function! s:cache() " {{{2
  return ref#cache('jscore', 'function', s:func('gather_func'))
endfunction



function! ref#jscore#define() " {{{2
  return s:source
endfunction
call ref#register_detection('javascript', 'jscore', 'append')


function! s:isURL(path)
  return stridx(g:ref_jscore_path, 'http://') == 0
      \ || stridx(g:ref_jscore_path, 'https://') == 0
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
