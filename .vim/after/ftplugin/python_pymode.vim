"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

if !(exists('g:pymode_rope_regenerate_on_write') && exists('g:pymode_rope'))
  let &cpo = s:save_cpo
  unlet! s:save_cpo
  finish
endif
let g:vimrc_pymode_rope_project_dirprefixes =
  \ get(g:, 'vimrc_pymode_rope_project_dirprefixes', [])

function! s:detect_pymode_rope_dir()
  let dir = expand('%:p:h')
  if len(filter(copy(g:vimrc_pymode_rope_project_dirprefixes), 'stridx(dir, v:val)')) > 0
    let g:pymode_rope_regenerate_on_write = 1
  else
    let g:pymode_rope_regenerate_on_write = 0
endfunction

MyAutoCmd BufWritePost <buffer> call s:detect_pymode_rope_dir()

let &cpo = s:save_cpo
unlet! s:save_cpo
