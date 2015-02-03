command! -buffer -nargs ReplaceStrings call s:replace_strings()

if exists('g:loaded_vimrc_local_{{_expr_:substitute(expand('%:p:h:t'), '-', '_', 'g')}}')
	finish
endif
let g:loaded_vimrc_local_{{_expr_:substitute(expand('%:p:h:t'), '-', '_', 'g')}} = 1

function! s:replace_strings()
  " %s!hoge!fuga!g
endfunction
