let s:save_cpo = &cpo
set cpo&vim

if !filereadable(expand('%'))
  setl ff=dos fenc=cp932
endif

let &cpo = s:save_cpo
