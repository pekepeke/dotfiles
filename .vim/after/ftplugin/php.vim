" scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setlocal includeexpr=substitute(v:fname,'^\\/','','')
setlocal path+=;/

setlocal commentstring=//\ %s
" setlocal formatoptions-=r,o
setlocal formatoptions-=r,o
" setlocal iskeyword-=$,\-,:
setlocal iskeyword-=- iskeyword-=$ iskeyword-=:
setlocal expandtab shiftwidth=4 tabstop=4

" setlocal noexpandtab

nnoremap <buffer> <silent> [!comment-doc] :call PhpDocSingle()<CR>
vnoremap <buffer> <silent> [!comment-doc] :call PhpDocRange()<CR>

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
if get(g:vimrc_enabled_plugins, 'smartchr', 0)
  if get(b:, 'php53', 0)
    inoremap <buffer><expr> [ synchat#isnt_src()?'[':smartchr#one_of('[', 'array(', '[[')
    inoremap <buffer><expr> ] synchat#isnt_src()?']':smartchr#one_of(']', ')', ']]')
  endif
  inoremap <buffer><expr> \ synchat#isnt_src()?'\':smartchr#one_of('\', 'function', '\\')
  inoremap <buffer><expr> @ synchat#isnt_src()?'@':smartchr#one_of('@', '$this->', 'self::$', '@@')
  inoremap <buffer><expr> . synchat#isnt_src()?'.':smartchr#one_of('.', '->', '..')
  inoremap <buffer><expr> > synchat#isnt_src()?'>':smartchr#one_of('>', '=>', '>>')
endif

let &cpo = s:save_cpo
