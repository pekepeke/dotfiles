"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/dosbatch.dict
setl noexpandtab
setl commentstring=REM\ %s

if &modifiable && &fileformat == 'dos'
  setl ff=dos fenc=cp932
endif

let &cpo = s:save_cpo
