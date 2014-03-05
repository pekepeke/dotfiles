if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_sudden_death')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:sudden_death(lines)
  let w = max(map(copy(a:lines), 'strdisplaywidth(v:val) / 2 + 1'))
  let str = join(map(copy(a:lines), 'printf("＞ %-".w."s ＜", v:val)'), "\n")
  return "＿" . repeat("人", w) . "＿" . "\n"
  \ . str . "\n"
  \ . "￣" . repeat("^Y", w) . "￣"
endfunction

function! s:sudden_death_range() range
  let is_online = a:firstline == a:lastline
  let lines = getline(a:firstline, a:lastline)
  let s = s:sudden_death(lines)
  if is_online
    execute 'normal!' 'o'.s
  else
    execute 'normal!' 'gv"_xo'.s
  endif
endfunction

command! -range SuddenDeath <line1>,<line2>call s:sudden_death_range()

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_sudden_death = 1

" vim: foldmethod=marker
