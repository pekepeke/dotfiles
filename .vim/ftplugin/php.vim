"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

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

setl noexpandtab

let &cpo = s:save_cpo
