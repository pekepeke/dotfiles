scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal formatoptions-=r formatoptions-=o
" setlocal tabstop=2 shiftwidth=2 textwidth=0 expandtab

if !get(g:, 'ftplugin_yaml_after_loaded', 0)
  function! s:ftplugin_ansible_init() "{{{2
    if len(filter(getline(1, 10),
      \ 'v:val =~# "^\\s*-\\?\\s*\\(hosts\\|tasks\\|roles\\|include\\)\\s*:"'))
      let snippet = expand('~/.vim/snippets/ansible.snip')
      if filereadable(snippet) && exists(':NeoSnippetSource')
        execute 'NeoSnippetSource' snippet
      endif
    endif
  endfunction
  let g:ftplugin_yaml_after_loaded = 1
endif

call s:ftplugin_ansible_init()

let &cpo = s:save_cpo
