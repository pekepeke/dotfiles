scriptencoding utf-8

let s:save_cpo = &cpo
set cpo&vim

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setl includeexpr=substitute(v:fname,'^\\/','','')
setl path+=;/

" setl formatoptions-=r,o
" setl iskeyword-=$,\-,:
setl formatoptions-=r,o iskeyword-=- iskeyword-=$ iskeyword-=:

" setl noexpandtab

nnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
vnoremap <buffer> <silent> [comment-doc] :call PhpDocRange()<CR>

if exists(':EnableFastPHPFolds')
  function! s:folding()
    exe "EnableFastPHPFolds"
    redraw!
  endfunction
  nnoremap <buffer> <silent> zz :call <SID>folding()<CR>
endif


" if neobundle#is_installed('PIV') && neobundle#is_installed('neocomplcache')
"   inoremap <buffer><expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
" endif
inoremap <buffer><expr> [ smartchr#one_of('[', 'array(', '[[')
inoremap <buffer><expr> ] smartchr#one_of(']', ')', ']]')
inoremap <buffer><expr> \ smartchr#one_of('\', 'function', '\\')
inoremap <buffer><expr> @ smartchr#one_of('@', '$this->', 'self::$', '@@')
inoremap <buffer><expr> . smartchr#one_of('.', '->', '..')
inoremap <buffer><expr> > smartchr#one_of('>', '=>', '>>')

let &cpo = s:save_cpo
