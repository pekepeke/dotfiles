"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if &modifiable && &fileformat == 'dos'
  setlocal ff=dos fenc=cp932
endif
setlocal comments=:;
setlocal commentstring=;%s

let &cpo = s:save_cpo
