autocmd! BufNewFile,BufRead *.tpl
      \ if match(join(getline(1, 20), "\n"), "{$|{[a-zA-Z]+}") != -1
      \ | setl filetype=html.smarty
      \ | else
      \ | setl filetype=html.twig
      \ | endif

autocmd BufNewFile,BufRead *.ctp,*.thtml set filetype=php
