let s:save_cpo = &cpo
set cpo&vim

let b:surround_{char2nr('-')} = "<% \r %>"
let b:surround_{char2nr('=')} = "<%= \r %>"
let b:surround_{char2nr('#')} = "<%# \r %>"
let b:surround_{char2nr('h')} = "<%= h \r %>"
let b:surround_{char2nr('e')} = "<% \r %>\n<% end %>"

let &cpo = s:save_cpo
