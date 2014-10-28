if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_fragment_proj')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:unite_fragment_proj_filename = get(g:, 'unite_fragment_proj_filename', '.fragment_proj.txt')
let g:unite_fragment_proj_open = get(g:, 'unite_fragment_proj_open', "split")

command! -nargs=0 FragmentProjOpen call s:fragment_open()

function! fragment_proj#filename() "{{{2
  let filename = unite#util#path2project_directory(expand('%'))
    \ . "/" . g:unite_fragment_proj_filename
  return filename
endfunction

function! s:fragment_open()
  execute g:unite_fragment_proj_open fragment_proj#filename()
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_fragment_proj = 1

" vim: foldmethod=marker
