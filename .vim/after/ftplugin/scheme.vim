let s:save_cpo = &cpo
set cpo&vim

" setl expandtab shiftwidth=2
setl dictionary=~/.vim/dict/scheme.dict
setl tabstop=2 shiftwidth=2 textwidth=0 expandtab

let &cpo = s:save_cpo
