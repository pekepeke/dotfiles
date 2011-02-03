scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


setl ff=dos fenc=cp932

setl dictionary=~/.vim/dict/vbscript.dict
setl dictionary+=~/.vim/dict/wsh.dict


let &cpo = s:save_cpo
