let s:save_cpo = &cpo
set cpo&vim

function! quickrun#hook#quickfixsigns_update#new()
  let hook = shabadou#make_hook_command({
        \ 'config': {
        \   'hook_command': ':QuickfixsignsEnable',
        \ }
        \ })
  return deepcopy(hook)
endfunction

let &cpo = s:save_cpo
