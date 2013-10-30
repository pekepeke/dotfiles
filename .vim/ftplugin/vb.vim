"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if &modifiable " && &fileformat == 'dos'
  setl fileformat=dos fileencoding=cp932
endif
setl dictionary=~/.vim/dict/vbscript.dict
setl dictionary+=~/.vim/dict/wsh.dict
setl comments=:'
setl commentstring='%s

let &cpo = s:save_cpo
