autocmd BufNewFile,BufRead *.tpl
      \ if match(join(getline(1, 20), "\n"), '\({\s*\$\|{\s*\w\+\s*}\)') != -1
      \ | setl filetype=html.smarty
      \ | else
      \ | setl filetype=html.twig
      \ | endif

autocmd BufNewFile,BufRead *.phpm,*.inc setl filetype=php
autocmd BufNewFile,BufRead *.ctp,*.thtml setl filetype=php
