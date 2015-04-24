"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal dictionary=~/.vim/dict/dosbatch.dict
setlocal noexpandtab
setlocal comments=:REM\ ,
setlocal commentstring=REM\ %s

if &modifiable " && &fileformat == 'dos'
  setlocal fileformat=dos fileencoding=cp932
endif

let &cpo = s:save_cpo
