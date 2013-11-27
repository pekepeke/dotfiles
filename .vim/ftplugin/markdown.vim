"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal comments=s1:<!--,ex:--> commentstring=<!--%s-->
setlocal noexpandtab
setlocal spell

let &cpo = s:save_cpo
