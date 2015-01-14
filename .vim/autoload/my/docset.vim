let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let s:is_mac = has('mac') || has('macunix') || has('gui_mac') || has('gui_macvim')
let s:dash_keywords = []
let s:zeal_keywords = []

" utils {{{1
function! s:docset_keywords_gather(root, is_dash) "{{{2
  let pattern = '*.docset/Contents/Info.plist'
  if a:is_dash
    let pattern = '*/' . pattern
  endif
  let plists = split(globpath(a:root,
        \ pattern), "\n")
  let keywords = []
  for plist in plists
    let buf = readfile(plist)
    let is_identifier = 0
    for line in buf
      if is_identifier
        call add(keywords, substitute(line, '\(\s\+\|</\?string>\)', '', 'g'))
        break
      endif
      if line =~? "CFBundleIdentifier"
        let is_identifier = 1
      endif
    endfor
  endfor
  return map(keywords, 'tolower(v:val)')
endfunction

function! s:zeal_query(word) "{{{2
  if s:is_mac
    let not_found = 1
    for bin in [$HOME . '/Applications/zeal.app/Contents/MacOS/zeal', '/Applications/zeal.app/Contents/MacOS/zeal']
      if executable(bin)
        call system(printf("%s --query %s &", bin, shellescape(a:word)))
        let not_found = 0
        break
      endif
    endfor
    if not_found
      echohl Error
      echomsg "command not found: zeal"
      echohl Normal
    endif
  else
    call system(printf("zeal --query %s &", shellescape(a:word)))
  endif
endfunction

function! s:zeal_word(...) "{{{2
  let word = len(a:000) == 0 ?
  \ input('Zeal search: ',
  \ expand('<cword>'), 'customlist,s:zeal_complete') : a:1
  return word
endfunction

function! s:dash_word(...) "{{{2
  let word = len(a:000) == 0 ?
  \ input('Dash search: ', expand('<cword>'),
  \ 'customlist,my#docset#dash_complete') : a:1
  return word
endfunction

function! s:dash_query(word) "{{{2
  call system(printf("open dash://'%s'", a:word))
endfunction

function! s:keyword_with_filetype(func, word)
  let filetypes = reverse(split(&filetype, '\.'))
  for ft in filetypes
    let keywords = call(a:func, [ft, 1, 1])
    if len(keywords) <= 0
      next
    endif
    if len(filter(copy(keywords), 'v:val =~? ft . ":"')) > 0
      return ft . ":" . a:word
      break
    endif
    return keywords[0] . ":" . a:word
  endfor
  return a:word
endfunction

" public {{{1
function! my#docset#dash_complete(A, L, P) "{{{2
  if empty(s:dash_keywords)
    let s:dash_keywords =
    \ s:docset_keywords_gather(expand('~/Library/Application\ Support/Dash/DocSets/'), 1)
  endif
  if stridx(a:A, ":") != -1
    return []
  endif
  let matches = filter(copy(s:dash_keywords),'v:val =~? "^".a:A')
  return map(matches, 'v:val.":"')
endfunction

function! my#docset#dash(...) "{{{2
  let word = call('<SID>dash_word', a:000)
  call s:dash_word(word)
endfunction

function! my#docset#dash_with_filetype(...) "{{{2
  let word = call('<SID>dash_word', a:000)
  let word = s:keyword_with_filetype(function('my#docset#dash_complete'), word)
  call s:dash_word(word)
endfunction

function! my#docset#zeal(...) "{{{2
  let word = call('<SID>zeal_word', a:000)
  call s:zeal_query(word)
endfunction

function! my#docset#zeal_with_filetype(...) "{{{2
  let word = call('<SID>zeal_word', a:000)
  let word = s:keyword_with_filetype(function('my#docset#zeal_complete'), word)
  call s:zeal_query(word)
endfunction

function! my#docset#zeal_complete(A, L, P) "{{{2
  if empty(s:zeal_keywords)
    if s:is_mac
      let s:zeal_keywords =
        \ s:docset_keywords_gather(expand('~/Library/Application Support/zeal/docsets'), 0)
    else
      let s:zeal_keywords =
        \ s:docset_keywords_gather(expand('~/.local/share/zeal/docsets'), 0)
    endif
  endif
  if stridx(a:A, ":") != -1
    return []
  endif
  let matches = filter(copy(s:zeal_keywords),'v:val =~? "^".a:A')
  return map(matches, 'v:val.":"')
endfunction

function! my#docset#docset_cache_remove() "{{{2
  let s:dash_keywords = []
  let s:zeal_keywords = []
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
