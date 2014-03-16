if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_gf_sass')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" http://hail2u.net/blog/software/vim-sass-goto-file.html
function! gf#sass#find()
  if &filetype !=? "sass" && &filetype != "scss"
    return 0
  endif
  let cfile = expand('<cfile>')
  let path = findfile(cfile)

  if empty(path)
    let path = findfile(substitute(cfile, '\%(.*/\|^\)\zs', '_', ''))
  endif

  if empty(path)
    let path = finddir(cfile)
  endif

  if empty(path)
    return 0
  endif

  return path
endfunction

call gf#user#extend('gf#sass#find', 1000)

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_gf_sass = 1

" vim: foldmethod=marker
