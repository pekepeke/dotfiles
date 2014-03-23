function! s:detect_tpl()
  for def in [
  \ {'pattern' : '\({{\|{%\)', 'ft' : 'jinja'},
  \ {'pattern' : '{/\?[^}]\+}', 'ft' : 'smarty'},
  \ ]

    if search(def.pattern, 'cnw') && &filetype != def.ft
      execute 'setlocal' 'filetype=' . def.ft
      return
    endif
  endfor
endfunction

autocmd BufNewFile,BufRead *.tpl call s:detect_tpl()

