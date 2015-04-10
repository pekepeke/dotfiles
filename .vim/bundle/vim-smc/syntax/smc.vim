if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

setlocal iskeyword+=%

syntax keyword smcKeywords %class
syntax keyword smcKeywords %start
syntax keyword smcKeywords %package
syntax keyword smcKeywords %map
syntax keyword smcKeywords %include
" syn keyword smcOperator contained skipwhite eq ne

syntax cluster smcCommon contains=smcComment,smcCommentBlock

syntax region smcComment start=+//+ end=+$+
syntax region smcCommentBlock start=+%{+ end=+}%+
syntax match smcStartEnd /%%/ contained
syntax region smcSequenceBlock start=+%%+ end=+%%+ contains=smcStartEnd,smcStateRegion,@smcCommon
syntax region smcStateRegion start=+[a-zA-Z0-9_]\+\s*{+ end=+}+ contains=smcStartEnd,smcState contained
syntax match smcState /[a-zA-Z0-9_]\+/ contained nextgroup=smcEventRegion contains=@smcCommon skipwhite
syntax region smcEventRegion start=+{+ end=+}+ contains=smcTransition,@smcCommon contained
syntax match smcTransition /\w\+/ nextgroup=smcNextState contained skipwhite
syntax match smcNextState /\w\+/ nextgroup=smcStatementsRegion contained skipwhite

syntax match smcFunction /\w\+()/ contained
syntax cluster smcGrammer contains=smcFunction

syntax region smcStatementsRegion start=+{+ end=+}+ contains=@smcFunction,@smcCommon contained


hi def link smcKeywords Keyword
" hi def link smcOperator Special
hi def link smcStartEnd Define

hi def link smcComment Comment
hi def link smcCommentBlock Comment
hi def link smcNumber Number

hi def link smcState       Special
hi def link smcTransition  Conditional
hi def link smcNextState       Function
hi def link smcFunction  Statement
" hi def link smcXXX Function
" hi def link smcXXX String
" hi def link smcXXX Todo
" hi def link smcXXX Constant

set foldmethod=syntax

let b:current_syntax = "smc"

" vim: ts=4
