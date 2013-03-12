let s:save_cpo = &cpo
set cpo&vim

" function{{{1
function! operator#{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}#exec(motion_wise) "{{{2
 let [reg_0, lines] = s:read_op(a:motion_wise)
  if empty(lines)
    return
  endif
  let s = join(map(lines, {{_cursor_}}), "\n")
  call s:replace_op(a:motion_wise, s, reg_0)
endfunction

" util functions {{{1
function! s:read_op(motion_wise) "{{{2
  let reg_0 = [@0, getregtype('0')]
  let vc = s:get_visual_command(a:motion_wise)
  execute 'normal!' '`[' . vc . '`]"0y'
  let lines = split(@0, "\n")
  return [reg_0, lines]
endfunction

function! s:replace_op(motion_wise, s, reg_0) "{{{2
  let reg_0 = a:reg_0
  let vc = s:get_visual_command(a:motion_wise)
  let @0 = a:s
  execute 'normal!' '`[' .vc. '`]"0P`['
  call setreg('0', reg_0[0], reg_0[1])
endfunction

function! s:get_visual_command(motion_wise) "{{{2
  if a:motion_wise ==# 'char'
    return 'v'
  elseif a:motion_wise ==# 'line'
    return 'V'
  elseif a:motion_wise ==# 'block'
    return "\<C-v>"
  endif
  echoerr 'E1: Invalid wise name:' string(a:motion_wise)
  return 'v' " fallback
endfunction

" __END__ {{{1
let &cpo = s:save_cpo
