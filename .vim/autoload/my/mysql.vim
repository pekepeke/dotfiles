let s:save_cpo = &cpo
set cpo&vim

function! my#mysql#to_tsv() range " {{{1
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    let s = substitute(s, '^[+\-]\+$', '', 'g')
    let s = substitute(s, '^|\s\+\|\s\+|$', '', 'g')
    let s = substitute(s, '\s\+|\s\+', "\t", 'g')
    call setline(line, s)
  endfor
endfunction "}}}

let &cpo = s:save_cpo
