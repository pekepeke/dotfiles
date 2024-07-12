vim.cmd([[
function! s:nop()
endfunction
command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif
command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>
command! -bar -nargs=+ Alias call <SID>nop()
command! -bar -nargs=+ LCAlias call <SID>nop()
]])
