if v:version < 700 " {{{1
  echoerr 'does not work this version of Vim(' . v:version . ')'
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
silent! map <unique> <Plug>(xdebug-resize)         :<C-u>call xdebug#resize()<CR>
silent! map <unique> <Plug>(xdebug-step_into)      :<C-u>call xdebug#step_into()<CR>
silent! map <unique> <Plug>(xdebug-step_over)      :<C-u>call xdebug#step_over()<CR>
silent! map <unique> <Plug>(xdebug-step_out)       :<C-u>call xdebug#step_out()<CR>
silent! map <unique> <Plug>(xdebug-start)          :<C-u>call xdebug#start()<CR>
silent! map <unique> <Plug>(xdebug-stop)           :<C-u>call xdebug#stop()<CR>
silent! map <unique> <Plug>(xdebug-context)        :<C-u>call xdebug#context()<CR>
silent! map <unique> <Plug>(xdebug-property)       :<C-u>call xdebug#property()<CR>
silent! map <unique> <Plug>(xdebug-break_point)    :<C-u>call xdebug#up()<CR>
silent! map <unique> <Plug>(xdebug-up)             :<C-u>call xdebug#up()<CR>
silent! map <unique> <Plug>(xdebug-down)           :<C-u>call xdebug#down()<CR>

" noremap <unique> <Plug>(xdebug-watch_context)  :<C-u>call xdebug#watch_input('context_get')<CR>A<CR>
" noremap <unique> <Plug>(xdebug-watch_property) :<C-u>call xdebug#watch_input_var('property_get', '<cWORD>')<CR>A<CR>
" noremap <unique> <Plug>(xdebug-watch_eval)     :<C-u>call xdebug#watch_input('eval')<CR>A

command! -nargs=0 Xdebug       call xdebug#start()
command! -nargs=? XdebugOpen   call xdebug#open_url('<args>')
command! -nargs=? XdebugBp     call xdebug#break_point('<args>')


let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ {{{1
" vim: foldmethod=marker
