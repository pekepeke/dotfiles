"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl comments=--
setl commentstring=--\ %s

let &cpo = s:save_cpo