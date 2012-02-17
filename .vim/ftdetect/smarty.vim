autocmd! BufNewFile,BufRead *.tpl
      \ if match(join(getline(1, 20), "\n"), "{$|{[a-zA-Z]+}") != -1
      \ | setfiletype smarty
      \ | else
      \ | setfiletype twig
      \ | endif

