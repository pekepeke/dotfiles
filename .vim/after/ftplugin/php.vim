scriptencoding utf-8

if !exists('g:loaded_php_ftplugin') " {{{1
  let g:loaded_php_ftplugin = 1

  "let g:php_folding = 1
  let g:php_sql_query = 1
  let g:php_baselib = 1
  let g:php_htmlInStrings = 1
  let g:php_noShortTags = 1
  let g:php_parent_error_close = 1
  let g:php_parent_error_open = 1
  "let g:php_sync_method = x

  let g:php_folding = 0
  " phpfolding.vim
  let g:DisableAutoPHPFolding = 1

  " let g:PHP_autoformatcomment=0
  "" php-doc.vim
  let g:pdv_cfg_Type = 'mixed'
  let g:pdv_cfg_Package = ""
  let g:pdv_cfg_Version = '$id$'
  if exists('g:author') && exists('g:email')
    let g:pdv_cfg_Author = g:author . ' <' . g:email . '>'
  else
    let g:pdv_cfg_Author = ''
  endif
  let g:pdv_cfg_Copyright = ""
  let g:pdv_cfg_License = 'PHP Version 3.0 {@link http://www.php.net/license/3_0.txt}'
endif " }}}

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=ro
" setl formatoptions-=o
" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setl includeexpr=substitute(v:fname,'^\\/','','')
setl path+=;/
setl iskeyword-=$ iskeyword-=\- iskeyword-=:

nnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
inoremap <buffer> <silent> [comment-doc] <Esc>:call PhpDocSingle()<CR>i
vnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>

if exists(':EnableFastPHPFolds')
  function! s:folding()
    exe "EnableFastPHPFolds"
    redraw!
  endfunction
  nnoremap <buffer> <silent> zz :call <SID>folding()<CR>
endif

inoremap <buffer><expr> [ smartchr#one_of('[', 'array(', '[[')
inoremap <buffer><expr> ] smartchr#one_of(']', ')', ']]')
inoremap <buffer><expr> \ smartchr#one_of('\', 'function ', '\\')
inoremap <buffer><expr> @ smartchr#one_of('@', '$this->', 'self::$', '@@')

let &cpo = s:save_cpo
