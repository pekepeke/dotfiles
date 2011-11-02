let s:save_cpo = &cpo
set cpo&vim

function! my#padding#number(...) range "{{{2
  let fmt = a:0 > 0 ? a:1 : '%d. '
  " try format
  try
    call printf(fmt, 0)
  catch
    echohl ErrorMsg
    echon v:exception . "\n"
    echohl Normal
    return 0
  endtry
  for line in range(a:firstline, a:lastline)
    call setline(line, substitute(getline(line),
          \ '^\(\s*\)', '\1'.printf(fmt, line - a:firstline + 1), ''))
  endfor
  redraw!
endfunction

function! my#padding#string(...) range "{{{2
  let str = len(a:000) > 0 ? a:000[0] : '- '
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    if s != ''
      call setline(line, substitute(s, '^\(\s*\)', '\1'.str, ''))
    endif
  endfor
  redraw!
endfunction

function! my#padding#sprintf(...) range " {{{2
  let fmt = len(a:000) > 0 ? a:000[0] : '%'
  try
    call printf(fmt, "")
  catch
    echohl ErrorMsg
    echon v:exception . "\n"
    echohl Normal
    return 0
  endtry
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    if s != ''
      call setline(line, matchstr(s, '^\s*').printf(fmt, substitute(s, '^\s*', '', '')))
    endif
  endfor
  redraw!
endfunction
" }}}

let &cpo = s:save_cpo
