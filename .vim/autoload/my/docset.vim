let s:save_cpo = &cpo
set cpo&vim

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

function! my#docset#dash(...) "{{{2
  let word = len(a:000) == 0 ?
  \ input('Dash search: ', expand('<cword>'),
  \ 'customlist,my#docset#dash_complete') : a:1
  call system(printf("open dash://'%s'", word))
endfunction

" variables {{{1
let s:dash_keywords = []
let s:zeal_keywords = []
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

function! my#docset#zeal(...) "{{{2
  let word = len(a:000) == 0 ?
  \ input('Zeal search: ',
  \ expand('<cword>'), 'customlist,'.s:SID().'zeal_complete') : a:1
  if s:is_mac
    call system(printf("/Applications/zeal.app/Contents/MacOS/zeal --query %s &", shellescape(word)))
  else
    call system(printf("zeal --query %s &", shellescape(word)))
  endif
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

function! my#docset#docset_cache_remove() {{{2
  let s:dash_keywords = []
  let s:zeal_keywords = []
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
