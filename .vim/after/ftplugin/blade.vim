"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=s:{{--,m:\ ,e:--}}
setlocal commentstring={{--%s--}}
let b:match_skip = 's:comment\|string'

let &cpo = s:save_cpo
