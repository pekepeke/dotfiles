command! -buffer -nargs=0 ReplaceStrings call s:replace_strings()

if exists('g:loaded_vimrc_local_{{_expr_:substitute(expand('%:p:h:t'), '-', '_', 'g')}}')
	finish
endif
let g:loaded_vimrc_local_{{_expr_:substitute(expand('%:p:h:t'), '-', '_', 'g')}} = 1

function! s:replace_strings()
  let pos = getpos('.')
  let kwd = @/
  " %s!hoge!fuga!g
  let @/ = kwd
  call setpos('.', pos)
endfunction
