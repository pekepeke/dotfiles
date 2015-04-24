"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal dictionary=~/.vim/dict/html.dict
setlocal dictionary+=~/.vim/dict/css.dict
setlocal noexpandtab tabstop=2 shiftwidth=2 textwidth=0
setlocal matchpairs+=<:>

let &cpo = s:save_cpo
