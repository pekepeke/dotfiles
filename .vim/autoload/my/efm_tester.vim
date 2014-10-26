let s:save_cpo = &cpo
set cpo&vim

function! my#efm_tester#exec(msg) "{{{3
  let org_efm = &g:errorformat
  try
    let &g:errorformat = g:efm_tester_fmt
    cgetexpr a:msg
    if !empty(g:efm_tester_after_execute)
      execute g:efm_tester_after_execute
    endif
  finally
    let &g:errorformat = org_efm
  endtry
endfunction " }}}

function! my#efm_tester#eval_text(count, l1, l2, text) "{{{3
  if a:count == 0 && empty(a:text)
    let msg = join(getline(1, '$'), "\n")
  else
    let msg = a:count == 0 ? a:text : join(getline(a:l1, a:l2), "\n")
  endif
  call my#efm_tester#exec(msg)
endfunction " }}}

function! my#efm_tester#set_format(count, l1, l2, text) "{{{
  let s = a:count == 0 ? a:text : join(getline(a:l1, a:l2), "\n")
  if empty(fmt)
    echo "set g:efm_tester_fmt=" . string(fmt)
    let g:efm_tester_fmt = fmt
  else
    echo "g:efm_tester_fmt=" . string(g:efm_tester_fmt)
  endif
endfunction "}}}

let &cpo = s:save_cpo
