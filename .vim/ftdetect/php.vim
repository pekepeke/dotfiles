autocmd BufNewFile,BufRead *.tpl
      \ if match(join(getline(1, 20), "\n"), '\({{\|{%\)') != -1
      \ | setl filetype=html.twig
      \ | else
      \ | setl filetype=html.smarty
      \ | endif

autocmd BufNewFile,BufRead *.phpm,*.inc setl filetype=php
autocmd BufNewFile,BufRead *.ctp,*.thtml setl filetype=php
