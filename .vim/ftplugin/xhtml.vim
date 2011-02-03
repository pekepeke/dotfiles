scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

runtime! ftplugin/html.vim

let &cpo = s:save_cpo
