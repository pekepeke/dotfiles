let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/dosbatch.dict
setl ff=dos fenc=cp932

let &cpo = s:save_cpo
