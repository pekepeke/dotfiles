let s:save_cpo = &cpo
set cpo&vim

let g:my_chm_dir = get(g:, 'my_chm_dir', "")
let g:my_chm_command = get(g:, 'my_chm_command', "")

function! my#chm#complete(A, L, P) " {{{1
  let items = map(split(globpath(g:my_chm_dir, "/*.chm"), "\n"), 'matchstr(v:val, "[^/]\\+$")')
  if my#util#is_win()
    call add(items, 'ntcmds.chm')
  endif
  let matches = []
  for item in items
    if item =~? '^' . a:A
      call add(matches, item)
    endif
  endfor
  return matches
endfunction

function! my#chm#open(fname) " {{{1
  let l:chm_path = g:my_chm_dir . "/" . a:fname
  if !filereadable(l:chm_path)
    let l:chm_path = a:fname
  endif
  if my#util#is_win()
    silent exe '! start hh' l:chm_path
  else
    silent exe "!" g:my_chm_command l:chm_path
  endif
endfunction

function! my#chm#load() " {{{1
  command! -nargs=1 -complete=customlist,my#chm#complete Chm call my#chm#open("<args>")
endfunction

" }}}

let &cpo = s:save_cpo
