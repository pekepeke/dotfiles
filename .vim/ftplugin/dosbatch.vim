"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl dictionary=~/.vim/dict/dosbatch.dict
setl noexpandtab
setl comments=:REM\ ,
setl commentstring=REM\ %s

if &modifiable " && &fileformat == 'dos'
  setl fileformat=dos fileencoding=cp932
endif

let &cpo = s:save_cpo
