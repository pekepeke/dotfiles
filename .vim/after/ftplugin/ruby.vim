scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim


setl formatoptions-=ro
setl dictionary=~/.vim/dict/ruby.dict
setl iskeyword+=@,$,?,!
setl iskeyword-=.,:
setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

" * ~ end block
nnoremap vab 0/end<CR>%V%0
" def ~ end block
nnoremap vam $?\%(.*#.*def\)\@!def<CR>%V%0
" class ~ end block
nnoremap vac $?\%(.*#.*class\)\@!class<CR>%V%0
" module ~ end block
nnoremap vaM $?\%(.*#.*module\)\@!module<CR>%V%0

vnoremap <buffer> [space]xa ! xmpfiler -a
vnoremap <buffer> [space]xs ! xmpfiler -s
vnoremap <buffer> [space]xm ! xmpfiler -m

function! s:if_string_smtchrloop(...)
  let sname = synIDattr(synID(line("."), col("."), 1), "name")
  if sname =~? 'rubyString' || sname =~? 'string' ||
        \ sname =~? 'rubyInterporation' || sname =~? 'rubyInterporationDelimiter'
    let Fn = function('smartchr#loop')
    return call(Fn, a:000)
  endif
  return a:000[0]
endfunction

inoremap <expr><buffer> # <SID>if_string_smtchrloop('#', '#{', '##')
" inoremap <expr><buffer> { smartchr#loop('{', '#{', '{{')
inoremap <expr><buffer> > smartchr#one_of('>', '=>', '>>')

let &cpo = s:save_cpo
