" A ref source for HTML4 documentation.
" Version: 0.0.1
" Author : hikaruworld
" License: MIT License

let s:save_cpo = &cpo
set cpo&vim

" config. {{{1
if !exists('g:ref_html_path') " {{{2
  let g:ref_html_path = ''
endif

if !exists('g:ref_html_cmd') " {{{2
  let g:ref_html_cmd =
  \ executable('elinks') ? 'elinks -dump -no-numbering -no-references %s' :
  \ executable('w3m') ? 'w3m -dump %s' :
  \ executable('links') ? 'links -dump %s' :
  \ executable('lynx') ? 'lynx -dump -nonumbers %s' :
  \ ''
endif



let s:source = {'name': 'html'} " {{{1

function! s:source.available() " {{{2
  return isdirectory(g:ref_html_path) &&
  \ len(g:ref_html_cmd)
endfunction



function! s:source.get_body(query) " {{{2
  let pre = g:ref_html_path . '/'

  " let file = pre . a:query . '.index.html'
  let file = pre . a:query . '.html'
  if filereadable(file)
    return s:execute(file)
  endif

  throw 'no match: ' . a:query
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
  if exists('b:current_syntax') && b:current_syntax == 'ref-html'
    return
  endif

  syntax clear

  let b:current_syntax = 'ref-html'
endfunction



function! s:execute(file) "{{{2
  if type(g:ref_html_cmd) == type('')
    let cmd = split(g:ref_html_cmd, '\s\+')
  elseif type(g:ref_html_cmd) == type([])
    let cmd = copy(g:ref_html_cmd)
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
  let list = glob(g:ref_html_path . '/*')
  return map(split(list, "\n"),
        \ 'substitute(v:val, "\\v".g:ref_html_path."/", "", "")')
endfunction


function! s:func(name) "{{{2
  return function(matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunc$') . a:name)
endfunction



function! s:cache() " {{{2
  return ref#cache('html', 'function', s:func('gather_func'))
endfunction



function! ref#html#define() " {{{2
  return s:source
endfunction
call ref#register_detection('html', 'html', 'append')



let &cpo = s:save_cpo
unlet s:save_cpo
