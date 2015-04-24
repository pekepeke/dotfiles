"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=s1:<#,mb:#,ex:#>,:#
setlocal commentstring=#%s

let &cpo = s:save_cpo
