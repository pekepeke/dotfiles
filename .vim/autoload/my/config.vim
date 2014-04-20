let s:save_cpo = &cpo
set cpo&vim

let s:type_s = type("")
let s:type_a = type([])

" functions {{{1
function! my#config#mkvars(names, val) "{{{2
  let val = type(a:val) == s:type_s ? string(a:val) : a:val
  let names = type(a:names) == s:type_a ? a:names : [a:names]
  for name in a:names
    if !exists(name)
      silent execute 'let' name '=' val
    endif
  endfor
endfunction

function! my#config#initialize_global_dict(prefix, names) "{{{2
  if type(a:prefix) == s:type_a
    let prefix = ""
    let names = a:prefix
  else
    let prefix = a:prefix
    let names = a:names
  endif
  for name in names
    if !exists('g:' . prefix . name)
      let g:[prefix . name] = {}
    endif
  endfor
endfunction

function! my#config#bulk_dict_variables(defines) "{{{2
  for var in a:defines
    for name in var.names
      let var.dict[name] = var.value
    endfor
  endfor
endfunction

" __END__ {{{1
let &cpo = s:save_cpo
