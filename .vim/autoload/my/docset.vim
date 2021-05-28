let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let s:is_win = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac') || has('macunix') || has('gui_mac') || has('gui_macvim')
let s:dash_keywords = []
let s:zeal_keywords = []

" g:zeal_cmd
" g:zeal_docset_dir

" utils {{{1
function! s:get_zeal_docset_dir() "{{{2
  if exists('g:zeal_docset_dir')
    return g:zeal_docset_dir
  endif
  let candidates = []

  if s:is_mac
    let candidates = [
      \ expand('~/Library/Application Support/zeal/docsets'),
      \ expand('~/Library/Application\ Support/Dash/DocSets/'),
      \ ]
  endif
  if s:is_win
    let candidates = [
      \ expand('$APPDATA/Local/Silverlake Software LLC/Velocity/Docsets/Dash'),
      \ expand('$APPDATA/Local/Zeal/Zeal/docsets'),
      \ ]
  else
    let candidates = [ expand('~/.local/share/zeal/docsets') ]
  endif
  let filtered = filter(candidates, 'isdirectory(v:val)')
  return len(filtered) > 0 ? filtered[0] : ""
endfunction

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
  if exists('g:zeal_cmd')
    call system(printf("%s --query %s &", g:zeal_cmd, shellescape(a:word)))
    return
  endif
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
  elseif s:is_win
    let words = split(a:word, ":")
    if len(words) < 2
      let query = a:word
    else
      let query = "keys=" . remove(words, 0) . "&query=" . split(words, ":")
    endif
    call system(printf("dash-plugin://%s &"), query)
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

function! s:keyword_with_filetype(func, word) "{{{2
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
    let dir = s:get_zeal_docset_dir()
    if !empty(dir)
      let s:dash_keywords =
      \ s:docset_keywords_gather(dir, 1)
    endif
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
    let dir = s:get_zeal_docset_dir()
    if !empty(dir)
      let s:zeal_keywords =
        \ s:docset_keywords_gather(dir, 0)
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
