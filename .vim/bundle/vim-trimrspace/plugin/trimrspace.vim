if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_trimrspace')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" var 
" ext(default), ignore, filetype, ignore_filetype
let g:trimrspace_method = get(g:, 'trimrspace_method', 'ext')
let g:trimrspace_targets = get(g:, 'trimrspace_targets', [])

augroup trimrspace-augroup
  autocmd!
  autocmd BufWritePre * call trimrspace#exec()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_trimrspace = 1

" vim: foldmethod=marker
