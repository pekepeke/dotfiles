let s:save_cpo = &cpo
set cpo&vim
let g:unite_projectionist#edit_method = get(g:, 'unite_projectionist#edit_method', 'split')

function! unite_projectionist#edit() "{{{1
  let fpath = ""
  if exists('b:projectionist') && !empty(b:projectionist)
    let fpath = get(keys(b:projectionist), 0, "") . "/" . ".projections.json"
  endif
  if empty(fpath)
    let fpath =
      \ unite#util#path2project_directory(expand('%:p')) . "/" . ".projections.json"
    if !filereadable(fpath)
      let fpath = input( ".projections.json" . " :", fpath)
    endif
  endif

  if !empty(fpath)
    execute g:unite_projectionist#edit_method fpath
  endif
endfunction

let &cpo = s:save_cpo
