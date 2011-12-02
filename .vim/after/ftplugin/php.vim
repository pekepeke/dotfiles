scriptencoding utf-8

if !exists('g:loaded_php_ftplugin') " {{{1
  let g:loaded_php_ftplugin = 1

  "let php_folding = 1
  let php_sql_query = 1
  let php_baselib = 1
  let php_htmlInStrings = 1
  let php_noShortTags = 1
  let php_parent_error_close = 1
  let php_parent_error_open = 1
  "let php_sync_method = x

  "" php-doc.vim
  let g:pdv_cfg_Type = 'mixed'
  let g:pdv_cfg_Package = ""
  let g:pdv_cfg_Version = '$id$'
  let g:pdv_cfg_Author = g:author . ' <' . g:email . '>'
  let g:pdv_cfg_Copyright = ""
  let g:pdv_cfg_License = 'PHP Version 3.0 {@link http://www.php.net/license/3_0.txt}'
endif " }}}

let php_folding = 0
function! s:folding()
  if &foldmethod == "manual" 
    exe "EnableFastPHPFolds" 
  endif
  redraw!
endfunction
nnoremap <buffer> <silent> zz :call <SID>folding()<CR>

let s:save_cpo = &cpo
set cpo&vim

setl formatoptions-=ro

nnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>
inoremap <buffer> <silent> [comment-doc] <Esc>:call PhpDocSingle()<CR>i
vnoremap <buffer> <silent> [comment-doc] :call PhpDocSingle()<CR>

nnoremap <buffer> <silent> <C-K> :Ref phpmanual<CR>

" function! s:last_char() " {{{1
  " return matchstr(getline('.'), '.', col('.')-2)
" endfunction

" function! s:php_smart_bracket(last_char) " {{{1
  " if a:last_char == '['
    " return "\<BS>("
  " elseif a:last_char =~ '\w\|]'
    " return '['
  " else
    " return 'array('
  " endif
" endfunction " }}}
" inoremap <buffer><expr> [ <SID>php_smart_bracket(<SID>last_char())
inoremap <buffer><expr> [ smartchr#one_of('[', 'array(', '[[')
inoremap <buffer><expr> ] smartchr#one_of(']', ')', ']]')
inoremap <buffer><expr> \ smartchr#one_of('\', 'function ', '\\')

let &cpo = s:save_cpo
