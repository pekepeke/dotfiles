"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal path+=.,/usr/include,/usr/local/include,/usr/lib/c++/v1

let &cpo = s:save_cpo
