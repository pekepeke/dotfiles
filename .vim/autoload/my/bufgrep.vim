let s:save_cpo = &cpo
set cpo&vim

function! s:bufgrep(args) " {{{4
  if !len(a:args) || strlen(a:args[0]) <= 1 | return | endif
  let args = a:args[0]
  let delim = args[0]
  if delim !=# '/'
    le v:errmsg= 'The delimiter `'.delim."` isn't available, please use `/`."
    echo v:errmsg
    return []
  endif
  let rxp ='^delim\([^delim\\]*\%(\\.[^delim\\]*\)*\)' .
        \      '\(delim.*\)\=$'
  let rxp=substitute(rxp, 'delim', delim, "g")
  let re = substitute(args, rxp, '\1', "")

  let s:buf = []
  silent execute 'g/'.re.'/call add(s:buf,  getline("."))'
  return s:buf
endfunction

function! my#bufgrep#yank(...) " {{{4
  let @+=join(s:bufgrep(a:000), "\n")
endfunction

function! my#bufgrep#enew(...) " {{{4
  let s=join(s:bufgrep(a:000), "\n")
  silent execute 'enew | setl buftype=nofile'
  silent exe 'normal i'.s
endfunction

"}}}

let &cpo = s:save_cpo
