let s:save_cpo = &cpo
set cpo&vim


function! unite#sources#fragment_proj#define() "{{{1
  return s:source
endfunction

" util functions {{{1
function! s:get_candidates(filename) "{{{2
  if !filereadable(a:filename)
    return []
  endif

  let modified = getftime(a:filename)
  if exists('s:candidates[a:filename]')
    if s:candidates[a:filename].modified >= modified
      return s:candidates[a:filename].fragments
    endif
  endif
  let fragments = []
  let lines = readfile(a:filename)
  let buf = []
  let name = ""

  for line in lines
    let m = matchlist(line, '!---*\s*\(.*\)$')
    if empty(m)
      " call vimconsole#log("empty:".line)
      call add(buf, line)
    elseif len(m) > 0
      if !empty(buf)
        call add(fragments, {
          \ "name": name,
          \ "body": join(buf, "\n"),
          \ })
      endif
      let name = m[1]
      let buf = []
      " call vimconsole#log("match:".line."-".m[1])
    endif
  endfor

  if !empty(buf)
    call add(fragments, {
      \ "name": name,
      \ "body": join(buf, "\n"),
      \ })
  endif

  if empty(fragments)
    return []
  endif

  let s:candidates[a:filename] = {
    \ 'modified': modified,
    \ 'fragments': fragments,
    \ }
  return fragments
endfunction

function! s:make_candidate(val) "{{{2
  return {
    \ 'word' : a:val.body,
    \ 'abbr' : printf('%-3s - %s', a:val.name,
    \     substitute(a:val.body, '\n', '^@', 'g')),
    \ 'is_multiline' : 1,
    \ }
endfunction

" source {{{1
let s:source = {
      \ 'name' : 'fragment_proj',
      \ 'default_action' : 'yank',
      \ 'description' : "candidates from project's fragment",
      \ 'action_table' : {},
      \ 'default_kind' : 'word',
      \}
let s:candidates = {}

function! s:source.gather_candidates(args, context) "{{{2
  let filename = fragment_proj#filename()
  let candidates = s:get_candidates(filename)

  return map(copy(candidates), 's:make_candidate(v:val)')
endfunction

" Actions "{{{1
" let s:source.action_table.edit = {
"       \ 'description' : 'edit',
"       \ 'is_invalidate_cache' : 1,
"       \ 'is_quit' : 0,
"       \ 'is_selectable' : 1,
"       \ }
" function! s:source.action_table.edit.func(candidates) "{{{2
"   for candidate in a:candidates
"   endfor
" endfunction

let &cpo = s:save_cpo
" __END__ "{{{1
