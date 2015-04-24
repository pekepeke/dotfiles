"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if &modifiable " && &fileformat == 'dos'
  setlocal fileformat=dos fileencoding=cp932
endif
setlocal dictionary=~/.vim/dict/vbscript.dict
setlocal dictionary+=~/.vim/dict/wsh.dict
setlocal comments=:'
setlocal commentstring='%s

let &cpo = s:save_cpo
