let s:save_cpo = &cpo
set cpo&vim

function! s:set_ft(ft) " {{{
  if &ft != a:ft
    execute 'setfiletype' a:ft
  endif
endfunction "}}}

function! s:detect_ft_html() " {{{
  let n = 1
  let lines = []
  while n < 10 && n < line("$")
    let a_line = getline(n)
    if a_line =~ '{%\|{{\|{#'
      call s:set_ft('htmldjango')
      return
    elseif a_line =~ '<?php\s\+'
      call s:set_ft('php')
      return
    endif
    call add(lines, a_line)
    let n = n + 1
  endwhile

  for a_line in lines
    if a_line =~ '\<DTD\s\+XHTML\s'
      call s:set_ft('xhtml')
      return
    endif
  endfor

  call s:set_ft('html')
endfunction "}}}
call s:detect_ft_html()

let &cpo = s:save_cpo
