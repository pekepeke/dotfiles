augroup filetypedetect
  " 定義されているのが動かない…謎
  au! BufRead,BufNewFile Jakefile setfiletype javascript
  au! BufRead,BufNewFile Cakefile setfiletype coffee
  au! BufRead,BufNewFile *.coffee setfiletype coffee
  au! BufRead,BufNewFile *.jade setfiletype jade
  au! BufRead,BufNewFile *.less setfiletype less
augroup END

