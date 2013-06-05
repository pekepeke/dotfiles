if exists('s:loaded')
  finish
endif
let s:loaded = 1
let s:basename = expand('<sfile>:h:t')
let s:dir = getcwd()
if fnamemodify(s:dir, ':h:t') ==# s:basename
  let &rtp = s:dir . ',' . &rtp . ',' . s:dir . '/after'

  augroup vimrc-local-dev-plugin
    execute 'autocmd SourcePre */' . s:basename . '/*/plugin/*.vim'
    \       'unlet! g:loaded_{expand("<afile>:p:r:s?.*/plugin/??:gs?[/\\\\]?_?")}'
  augroup END
endif

