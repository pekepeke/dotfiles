"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/html.dict
setl dictionary+=~/.vim/dict/css.dict
setl noexpandtab tabstop=2 shiftwidth=2 textwidth=0
setlocal matchpairs+=<:>

let &cpo = s:save_cpo
