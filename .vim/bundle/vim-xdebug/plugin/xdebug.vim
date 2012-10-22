if v:version < 700 " {{{1
  echoerr "does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_xdebug')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:loaded_xdebug = 1

if !has('python')
  finish
endif

" mappings {{{1
noremap <Plug>(xdebug-resize)         :<C-u>call xdebug#resize()<CR>
noremap <Plug>(xdebug-step_into)      :<C-u>call xdebug#step_into()<CR>
noremap <Plug>(xdebug-step_over)      :<C-u>call xdebug#step_over()<CR>
noremap <Plug>(xdebug-step_out)       :<C-u>call xdebug#step_out()<CR>
noremap <Plug>(xdebug-start)          :<C-u>call xdebug#start()<CR>
noremap <Plug>(xdebug-stop)           :<C-u>call xdebug#stop()<CR>
noremap <Plug>(xdebug-context)        :<C-u>call xdebug#context()<CR>
noremap <Plug>(xdebug-property)       :<C-u>call xdebug#property()<CR>
noremap <Plug>(xdebug-watch_context)  :<C-u>call xdebug#watch_input('context_get')<CR>A<CR>
noremap <Plug>(xdebug-watch_property) :<C-u>call xdebug#watch_input('property_get', '<cWORD>')<CR>A<CR>
noremap <Plug>(xdebug-watch_eval)     :<C-u>call xdebug#watch_input('eval')<CR>A
noremap <Plug>(xdebug-break_point)    :<C-u>call xdebug#up()<CR>
noremap <Plug>(xdebug-up)             :<C-u>call xdebug#up()<CR>
noremap <Plug>(xdebug-down)           :<C-u>call xdebug#down()<CR>

command! -nargs=0 Xdebug call xdebug#start()

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ {{{1
" vim: foldmethod=marker
