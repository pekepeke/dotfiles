" File:    sonictemplate.vim
" Author:  kmnk <kmnknmk+vim@gmail.com>
" Contributor: pekepeke<pekepekesamurai+vim@gmail.com>
" Version: 0.1.0
" License: BSD style license

let s:save_cpo = &cpo
set cpo&vim

function! unite#kinds#sonictemplate#define() "{{{1
  return s:kind
endfunction

" kind {{{1
let s:kind = {
      \ 'name' : 'sonictemplate',
      \ 'default_action' : 'insert',
      \ 'parents' : ['file'],
      \ 'action_table' : {},
      \ 'alias_table' : {},
      \}

" action_table.insert "{{{1
let s:kind.action_table.insert = {
      \ 'description' : 'insert this template',
      \ 'is_selectable' : 0,
      \ 'is_quit' : 1,
      \ 'is_invalidate_cache' : 0,
      \ 'is_listed' : 1,
      \}

function! s:kind.action_table.insert.func(candidate) "{{{2
  call sonictemplate#apply(
\   a:candidate.word,
\   a:candidate.action__mode,
\ )
endfunction

" local functions {{{1

" __END__ {{{1
let &cpo = s:save_cpo
unlet s:save_cpo

