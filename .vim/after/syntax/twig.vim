"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if search('<\(div\|body\|html\|head\|script\|span\|p\|ul\|ol\|li\)', 'cnw')
  if exists('b:current_syntax')
    unlet b:current_syntax
  endif
  runtime! syntax/html.vim
  " unlet b:current_syntax
  setlocal commentstring={#<!--%s-->#}
endif

let &cpo = s:save_cpo
