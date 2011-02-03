" functions for edit
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

function! titanium#command#unite_utilizable() " {{{2
  if exists(':Unite') == 2 && !empty(unite#available_sources('fileline'))
    return 1
  endif
  return 0
endfunction

function! titanium#command#unite_completion() " {{{2
  silent exe 'Unite' 'fileline:' . titanium#get_keywordfile_path()
endfunction

function! titanium#command#help_utilizable() " {{{2
  if exists(':Ref') == 2
    let name = titanium#is_desktop() ? 'tidesktopref' : 'timobileref'
    for src in ref#available_source_names()
      if src ==# name | return 1 | endif
    endfor
  endif
  return 0
endfunction

function! titanium#command#help_open(...) " {{{2
  let l:keyword = a:0 > 0 ? a:1 : s:get_keyword()
  if l:keyword == ""
    call titanium#warn("keyword is not found")
  else
    if titanium#is_desktop()
      execute "Ref tidesktopref ".keyword
    else
      execute "Ref timobileref ".keyword
    endif
  endif
endfunction

function! s:get_keyword() " {{{2
  let l:isk = &l:iskeyword
  setlocal isk& isk+=- isk+=. isk+=:
  let l:kwd = expand('<cword>')
  let &l:iskeyword = isk
  return l:kwd
endfunction
