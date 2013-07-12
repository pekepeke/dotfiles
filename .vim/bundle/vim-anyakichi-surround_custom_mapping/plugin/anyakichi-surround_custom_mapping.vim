if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_anyakichi_surround_custom_mapping')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:surround_custom_mapping = get(g:, 'surround_custom_mapping', {})

function! s:surround_map(scope)
  if a:scope != 'g' && empty(&filetype)
    return
  endif
  let dict = a:scope == 'g' ? '_' : &filetype
  if !has_key(g:surround_custom_mapping, dict)
    return
  endif
  let current = a:scope . ':surround_objects'
  if !exists(current)
    execute printf('let %s=g:surround_custom_mapping.%s', current, dict)
  else
    execute printf('call extend(%s, g:surround_custom_mapping.%s)', current, dict)
  endif
endfunction

augroup anyakichi-surround_custom_mapping "{{{1
  autocmd!
  autocmd VimEnter * call s:surround_map('g')
  autocmd FileType * call s:surround_map('b')
augroup END

let g:loaded_anyakichi_surround_custom_mapping = 1
let &cpo = s:save_cpo
unlet s:save_cpo


" vim: foldmethod=marker
" __END__{{{1
