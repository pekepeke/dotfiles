if exists('g:loaded_vimrc_local_{{_expr_:expand('%:p:h:t')}}')
	finish
endif
let g:loaded_vimrc_local_{{_expr_:expand('%:p:h:t')}} = 1

