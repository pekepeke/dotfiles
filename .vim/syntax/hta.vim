if version < 600
	syntax clear
elseif exists("b:current_syntax")
	finish
endif

runtime! syntax/html.vim

let b:current_syntax = "hta"

" vim: set ts=4
