let s:save_cpo = &cpo
set cpo&vim

let g:my_cheatsheets_dir = get(g:, 'my_cheatsheets_dir', "")

function! my#cheatsheet#complete(A, L, P) "{{{1
  let items = map(split(globpath(g:my_cheatsheets_dir, "/*"), "\n"), 'matchstr(v:val, "[^/]\\+$")')
  let matches = []
  for item in items
    "if item =~? '^' . a:A
    if item =~? a:A
      call add(matches, item)
    endif
  endfor
  return matches
endfunction " }}}
function! my#cheatsheet#open(fname) "{{{1
  let l:path = g:my_cheatsheets_dir . "/" . a:fname
  if !filereadable(l:path)
    let l:path = a:fname
  endif
  if my#util#is_win()
    silent exe '! start hh' l:path
  elseif my#util#is_mac()
    silent exe '! open' l:path
  else
    silent exe '!' l:path
  endif
endfunction " }}}

function! my#cheatsheet#load()
  command! -nargs=1 -complete=customlist,my#cheatsheet#complete CheatSheet call my#cheatsheet#open("<args>")
endfunction

let &cpo = s:save_cpo
