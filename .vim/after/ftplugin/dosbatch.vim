let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/dosbatch.dict
if &modifiable
  setl ff=dos fenc=cp932
endif

let &cpo = s:save_cpo
