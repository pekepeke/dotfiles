let s:save_cpo = &cpo
set cpo&vim

let s:is_mac = has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

function! d#is_win()
  return s:is_win
endfunction

function! d#is_mac()
  return s:is_mac
endfunction

function! d#is_linux()
  return has('linux')
endfunction

function! d#is_installed(name)
  let plug = dpp#get(a:name)
  return !empty(plug)
  endfunction

let &cpo = s:save_cpo
