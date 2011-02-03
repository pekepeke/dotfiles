" titanium complete
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if !exists('g:titanium_complete_head') " {{{2
  let g:titanium_complete_head = 0
endif

if !exists('g:titanium_complete_short_style') " {{{2
  let g:titanium_complete_short_style = 1
endif

if !exists('g:titanium_method_complete_disabled') " {{{2
  let g:titanium_method_complete_disabled = 1
endif

function! titanium#titaniumcomplete#enable_omnifunc() " {{{2
  " XXX (--;;;
  if &omnifunc !~ 'titanium#titaniumcomplete#Complete'
    let b:original_omnifunc=&omnifunc
  endif
  setl omnifunc=titanium#titaniumcomplete#Complete
endfunction

function! titanium#titaniumcomplete#Complete(findstart, base) " {{{2
  if a:findstart
    " XXX --;;
    if b:original_omnifunc != ''
      return call(function(b:original_omnifunc), [a:findstart, a:base])
    else
      let cur_word = strpart(getline('.'), 0, col('.') - 1)
      return match(cur_word, '\w*$')
    endif
  endif
  let l:matches = s:complete_titanium(a:base)
  if empty(l:matches)
    if b:original_omnifunc != ''
      return extend(
            \ call(function(b:original_omnifunc), [a:findstart, a:base]),
            \ s:convert_matches(s:complete_titanium_methods(a:base)))
    else
      return s:convert_matches(s:complete_titanium_methods(a:base))
    endif
  endif
  return s:convert_matches(l:matches)
endfunction

function! s:complete_titanium_methods(base) " {{{2
  if g:titanium_method_complete_disabled
    return []
  endif
  let l:fpath = titanium#get_keywordfile_path()
  if !filereadable(l:fpath)
    return []
  endif
  let l:list = map(
        \ filter(readfile(l:fpath), 'v:val =~ "'.a:base.'[^\\.]*($"'), 
        \ 'substitute(v:val, "^.*\\.\\([^\\.]\\+\\)$", "\\1", "")')
  let l:dict = {}
  for l:v in l:list
    let l:dict[l:v] = 1
  endfor

  return keys(l:dict)
endfunction

function! s:convert_matches(matches) " {{{2
  return map(a:matches, '{ "word" : v:val, "kind" : <SID>get_kind(v:val)}')
endfunction

function! s:get_kind(s) " {{{2
  if a:s =~ '($'
    return "m"
  elseif a:s =~ '(^|\.)[A-Z_]\+'
    return "p"
  else
    return "c"
  endif
endfunction

function! s:complete_titanium(base) " {{{2
  let l:fpath = titanium#get_keywordfile_path()
  if !filereadable(l:fpath)
    return []
  endif
  let l:kwd = s:get_keyword_prefix().a:base
  if l:kwd == ""
    return []
  endif
  " read keywords
  let l:keyword = substitute(l:kwd, "^Ti\\.", "Titanium.", "es")
  let l:keyword = substitute(l:keyword, "\\\.", "\\.", "eg")
  let l:list = readfile(l:fpath)

  " no namespace -> api full expand
  if stridx(l:keyword, ".") == -1 && g:titanium_complete_head == 0
    let l:matches = filter(l:list, 'v:val =~ "'.l:keyword.'"')
    if g:titanium_complete_short_style
      return map(l:matches, 'substitute(v:val, "^Titanium\\.", "Ti.", "e")')
    endif
    return l:matches
  endif

  "let l:matches = filter(l:list, 'v:val =~ "^'.l:keyword.'\\.\\?[^\\.]\\+$"')
  let l:matches = filter(l:list, 'v:val =~ "^'.l:keyword.'[^\\.]*$"')
  return map(l:matches, 'substitute(v:val, "^.\\+\\.\\([^\\.]*\\)$", "\\1", "e")')
endfunction

function! s:get_keyword_prefix() " {{{2
  let l:line = getline(".")
  if l:line == ""
    return ""
  endif

  let l:cur_pos = col(".") + 1
  let l:line = matchstr(strpart(line, 0, l:cur_pos), '[0-9a-zA-Z_\.]\+$')
  return strpart(l:line, 0, strridx(l:line, '.')+1)
  " let l:pos = strridx(l:line, " ", l:cur_pos)
  " let l:kwd = strpart(l:line, (l:pos == -1 ? 0 : l:pos+1), l:cur_pos - (l:pos+1))
  " return l:kwd
endfunction



