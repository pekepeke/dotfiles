if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=-

syn match <+FILENAME_NOEXT+>Comment	"^\s*!.*$"
hi def link <+FILENAME_NOEXT+>Comment Comment

syn match <+FILENAME_NOEXT+> /\<\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\.\(25[0-5]\|2[0-4][0-9]\|[01]\?[0-9][0-9]\?\)\>/
hi def link <+FILENAME_NOEXT+> Number
" Identifier, String

syn keyword <+FILENAME_NOEXT+>Keywords contained skipwhite host any
syn keyword <+FILENAME_NOEXT+>Operator contained skipwhite eq ne
hi def link <+FILENAME_NOEXT+>Keywords Keyword
hi def link <+FILENAME_NOEXT+>Operator Special

set foldmethod=syntax

let b:current_syntax = "<+FILENAME_NOEXT+>"

" vim: ts=4
