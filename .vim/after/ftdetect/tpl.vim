function! s:detect_tpl()
  let s = join(getline(1, 20), "\n")
  for def in [
        \ {'pattern' : '\({{\|{%\)', 'ft' : 'html.twig'},
        \ {'pattern' : '{[^}]\+}', 'ft' : 'html.smarty'},
        \ ]
    if match(s, def.pattern) != -1 && &filetype != def.ft
      execute 'setlocal' 'filetype=' . def.ft
      return
    endif
  endfor
endfunction
autocmd BufNewFile,BufRead *.tpl call s:detect_tpl()
