"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" {{{1
setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

function! s:my_ansible_init() "{{{2
  if len(filter(getline(1, 5), 'v:val =~# "^\\s*-\\s*hosts\\s*:"'))
    let snippet = expand('~/.vim/snippets/ansible.snip')
    if filereadable(snippet) && exists(':NeoSnippetSource')
      execute 'NeoSnippetSource' snippet
    endif
  endif
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
