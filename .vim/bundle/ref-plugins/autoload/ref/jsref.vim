" A ref source for jsref
" Version: 0.2.0
" Author : walf443 <walf443 at gmail.com>
" Contributor : pekepeke <pekepekesamurai at gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ref_jsref_cmd') " {{{1
  let g:ref_jsref_cmd = executable("jsref") && exists('$JSREF_DOCROOT') 
        \ ? 'jsref' : ''
  " let g:ref_jsref_cmd = 'jsref'
endif

let s:source = {'name': 'jsref'} " {{{1

function! s:source.available() " {{{2
  return !empty(g:ref_jsref_cmd)
endfunction

function! s:source.get_body(query) " {{{2
  let query = a:query
  let cache = copy(s:cache('jsapi'))
  if query == ''
    return cache
  else
    let op = query =~# '[A-Z]' ? '#' : '?'
    if index(cache, query) == -1
      call filter(cache, 'v:val =~'.op.' query')
      if len(cache) == 1
        let query = cache[0]
      else
        return cache
      endif
    endif
  endif
  let res =  ref#system("jsref " . query).stdout
  return s:filter(res)
endfunction

function! s:filter(body) " {{{2
  " 目次に遭遇したときにjumpできるように置換してやる
  "  ex.) ● std >> deqeue >> push_back
  "   ->  -  std >> deqeue::push_back
  let res = substitute(a:body, "• \\([^\n]*\\) >> ", "- \\1::", "g")

  return res
endfunction

function! s:source.opened(query) " {{{2
  call s:syntax(a:query)
endfunction

function! s:source.complete(query) " {{{2
  let query = a:query

  let op = query =~# '[A-Z]' ? '#' : '?'
  return filter(copy(s:cache('jsapi')), 'v:val =~'.op.' query')
endfunction
function! s:source.leave() " {{{2
  syntax clear
endfunction

function! s:source.get_keyword() " {{{2
  let isk = &l:iskeyword
  setlocal isk& isk+=: isk+=.
  let kwd = expand('<cword>')
  if exists("b:ref_history_pos") && stridx(kwd, '.') < 0
    if match(kwd, "::") == -1
      let buf_name = b:ref_history[b:ref_history_pos][1]
      if stridx(buf_name, '.') >= 0
        let kwd = substitute(buf_name, '\.[a-z][^\.]*$', '', '') . "." . kwd
      else
        if match(buf_name, "stl::\\(.\\+\\)") == -1 " stl::vectorみたいなのだけうまくいかないので特別扱い
          let base_class = substitute(buf_name, "^\\([^:]\\+\\)::\\(.*\\)", "\\1", "")
        else
          let base_class = substitute(buf_name, "stl::\\(.\\+\\)", "\\1", "")
        endif
        if base_class != ""
          let kwd = base_class . "::" . kwd
        endif
      endif
    endif
  endif
  let &l:iskeyword = isk
  return kwd
endfunction

" functions. {{{1
function! s:syntax(query) " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-jsref'
    return
  endif
  syntax clear
  unlet! b:current_syntax

  syntax include @refJs syntax/javascript.vim
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+\n\(var\s\)\@=+ end=+^$+ contains=@refJs
  syntax region jsHereDoc    matchgroup=jsStringStartEnd start=+^\(.*\s=\s\)\@=+ end=+^$+ contains=@refJs

  syntax region jsrefKeyword  matchgroup=jsrefKeyword start=+^\(Summary$\|Syntax$\|Parameters$\|Description$\|Properties$\|Methods$\|Examples$\|See\sAlso$\)\@=+ end=+$+
  highlight def link jsrefKeyword Title

  let b:current_syntax = 'ref-jsref'
endfunction


function! s:gather_func(name)  "{{{2
  let docdir = $JSREF_DOCROOT
  let files = split(substitute(glob(docdir . '/**/*.html'), docdir.'/*', "", "g"), "\n")
  call filter(files, 'v:val =~ "^\\(Function\\|Global\\|Objects\\|Statements\\)"')
  call map(map(files, 'substitute(v:val, "/", ".", "g")'), 'substitute(v:val, "\\.html", "", "")')
  return files
endfunction


function! s:func(name)  "{{{2
  return function(matchstr(expand('<sfile>'), '<SNR>\d\+_\zefunc$') . a:name)
endfunction


function! s:cache(kind)  " {{{2
  return ref#cache('jsref', a:kind, s:func('gather_func'))
endfunction


function! ref#jsref#define() " {{{2
  return s:source
endfunction

call ref#register_detection('js', 'jsref')

let &cpo = s:save_cpo
unlet s:save_cpo

