"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab
if exists(':NeoSnippetSource')
  NeoSnippetSource ~/.vim/snippets/sh.snip
endif

let &cpo = s:save_cpo
