" A ref source for nodejs doc
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

" config. {{{1
if !exists('g:ref_nodejsdoc_dir')
  let g:ref_nodejsdoc_dir = ''
endif

let s:source = {'name': 'nodejs'} " {{{1

function! s:source.available() " {{{2
  return isdirectory(g:ref_nodejsdoc_dir)
endfunction

function! s:source.get_body(query) " {{{2
  let query = stridx(a:query, '.') != -1 ? split(a:query, '\.')[0] : a:query
  let targets = self.complete(query)

  let cnt = len(targets)
  if cnt == 0
    throw printf("%s is not found", a:query)
  elseif cnt == 1 || len(filter(targets, 'v:val == ' . string(query)))
    let path = printf("%s/api/%s.markdown", g:ref_nodejsdoc_dir, targets[0])
    return join(readfile(path), "\n")
  else
    return join(targets, "\n")
  endif
endfunction

function! s:source.opened(query) " {{{2
  call s:syntax(a:query)
  let queries = split(a:query, '\.')
  if len(queries) > 1
    call search('^#\+ '.a:query)
  endif
endfunction

function! s:source.leave() " {{{2
  syntax clear
endfunction

function! s:source.complete(query) " {{{2
  let docdir = g:ref_nodejsdoc_dir
  let files = split(
        \ substitute(
        \ globpath(docdir."/api",  "**.markdown"),
        \ docdir.'/api/\|\.markdown', '', 'g'),
        \ "\n")
  let query = a:query
  "let targets = filter(map(files, 'substitute(v:val, path . "/api/", "", "")'), 'v:val =~ query.".*"')
  let targets = empty(query) ? files : filter(files, 'v:val =~ query')
  return targets
endfunction

function! s:source.get_keyword() " {{{2
  let isk = &l:iskeyword
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:iskeyword = isk

  return kwd
endfunction

" functions. {{{1
function! s:syntax(query) " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-nodejs'
    return
  endif
  syntax clear

  " FIXME
  ru! syntax/markdown.vim
  let b:current_syntax = 'ref-nodejs'

  " unlet! b:current_syntax

  " "syntax include @refNodejs syntax/javascript.vim
  " syntax include @refNodejs syntax/markdown.vim

  " let b:current_syntax = 'ref-nodejs'
endfunction

function! ref#nodejs#define() " {{{2
  return s:source
endfunction

call ref#register_detection('javascript', 'nodejs')

let &cpo = s:save_cpo
unlet s:save_cpo

