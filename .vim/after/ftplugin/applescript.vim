"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


inoremap <buffer> <S-CR> ￢<CR>

if !exists('g:did_load_ftplugin_after_applescript')
  function! RunAppleScript(...)
    let fpath = a:0 <= 0 ? expand("%:p") : a:1
    execute '!osascript' 
          \ . "-e 'on run {sourcefile}'"
          \ . "-e '  tell application \"AppleScript Runner\"'"
          \ . "-e '    do script sourcefile'"
          \ . "-e '  end tell'"
          \ . "-e 'end run'" fpath
  endfunction
  let g:did_load_ftplugin_after_applescript=1
endif

let &cpo = s:save_cpo
