let s:save_cpo = &cpo
set cpo&vim

function! operator#splitline#do(motion_wise) "{{{2
  let ch = nr2char(getchar())
  if ch !~# '[!-~]'
    return
  endif
  let visual_command = operator#user#visual_command_from_wise_name(a:motion_wise)
  let reg_save = getreg('z', 1)
  let regtype_save = getregtype('z')
  let sel_save = &l:selection
  let &l:selection = "inclusive"

  execute 'normal!' '`['.visual_command.'`]"zy'
  let str = join(split(@z, ch), ch . "\n")
  call setreg('z', str, visual_command)
  execute 'normal!' '`['.visual_command.'`]"zP'
  normal! gv=

  let &l:selection = sel_save
  call setreg('z', reg_save, regtype_save)
endfunction

function! s:visual_command_from_wise_name(wise_name) "{{{2
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
