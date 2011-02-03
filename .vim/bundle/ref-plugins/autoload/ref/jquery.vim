" A ref source for jquery.
" Version: 0.2.0
" Author : hokaccha <k.hokamura@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ref_jquery_start_linenumber')
  let g:ref_jquery_start_linenumber = 25
endif

if !exists('g:ref_jquery_cmd')
  let g:ref_jquery_cmd =
  \ executable('elinks') ? 'elinks -dump -no-numbering -no-references %s' :
  \ executable('w3m')    ? 'w3m -dump %s' :
  \ executable('links')  ? 'links -dump %s' :
  \ executable('lynx')   ? 'lynx -dump -nonumbers %s' :
  \ ''
endif

if !exists('g:ref_jquery_encoding')
  let g:ref_jquery_encoding = &termencoding
endif

if !exists('g:ref_jquery_use_cache')
  let g:ref_jquery_use_cache = 0
endif



let s:source = {'name': 'jquery'}

function! s:source.available()
  return !empty(g:ref_jquery_cmd)
endfunction

function! s:source.get_body(query)
  if type(g:ref_jquery_cmd) == type('')
    let cmd = split(g:ref_jquery_cmd, '\s\+')
  elseif type(g:ref_jquery_cmd) == type([])
    let cmd = copy(g:ref_jquery_cmd)
  else
    return ''
  endif

  let str = substitute(a:query, '\$', 'jQuery', '')
  let url = 'http://api.jquery.com/' . str . '/'
  call map(cmd, 'substitute(v:val, "%s", url, "g")')
  if g:ref_jquery_use_cache
    let expr = 'ref#system(' . string(cmd) . ').stdout'
    let res = join(ref#cache('jquery', a:query, expr), "\n")
  else
    let res = ref#system(cmd).stdout
  endif
  return s:iconv(res, g:ref_jquery_encoding, &encoding)
endfunction

function! s:source.opened(query)
  execute "normal! ".g:ref_jquery_start_linenumber."z\<CR>"
  call s:syntax(a:query)
endfunction

function! s:source.leave()
  syntax clear
endfunction




function! s:syntax(query)
  if exists('b:current_syntax') && b:current_syntax == 'ref-jquery'
    return
  endif

  syntax clear
  let str = escape(substitute(a:query, '\s\+', '\\_s\\+', 'g'), '"')
  if str =~# '^[[:print:][:space:]]\+$'
    let str = '\<' . str . '\>'
  endif
  execute 'syntax match refJqueryKeyword "\c'.str.'"'
  highlight default link refJqueryKeyword Special
endfunction


" iconv() wrapper for safety.
function! s:iconv(expr, from, to)
  if a:from == '' || a:to == '' || a:from ==# a:to
    return a:expr
  endif
  let result = iconv(a:expr, a:from, a:to)
  return result != '' ? result : a:expr
endfunction

function! ref#jquery#define()
  return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
