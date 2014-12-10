scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=r formatoptions-=o
setl iskeyword+=@,$,?,!
setl iskeyword-=.,:
setl expandtab
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words .= '\<\(module\|class\|def\|until\|while\|begin\|do\|if\|unless\|case\)\>:'
      \ . '\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
" setl dictionary=~/.vim/dict/ruby.dict
" setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

" * ~ end block
" nnoremap vab 0/end<CR>%V%0
" def ~ end block
" nnoremap vam $?\%(.*#.*def\)\@!def<CR>%V%0
" class ~ end block
" nnoremap vac $?\%(.*#.*class\)\@!class<CR>%V%0
" module ~ end block
" nnoremap vaM $?\%(.*#.*module\)\@!module<CR>%V%0
" vnoremap <buffer> [space]xa ! xmpfiler -a
" vnoremap <buffer> [space]xs ! xmpfiler -s
" vnoremap <buffer> [space]xm ! xmpfiler -m

if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  inoremap <expr><buffer> #
        \ synchat#is('rubyString\|rubyInterporation\|rubyInterporationDelimiter')
        \ ? smartchr#loop('#', '#{', '##') : '#'
  " inoremap <expr><buffer> { smartchr#loop('{', '#{', '{{')
  inoremap <expr><buffer> > synchat#is('rubyString\|rubyInterporation\|rubyInterporationDelimiter')?
        \ '>' : smartchr#one_of('>', '=>', '>>')
endif

let &cpo = s:save_cpo
