let s:save_cpo = &cpo
set cpo&vim

" static vars {{{1
let s:initialized = 0
let s:last_url = ""
let s:is_win = has('win32') || has('win64') || has('win32unix')
let s:is_mac = has('mac') || has('macunix') || has('gui_macvim')
let s:py_path = expand('<sfile>:p:h') . '/xdebug/debugger.py'

" vars {{{1
let g:xdebug_no_default_mappings = get(g:, 'xdebug_no_default_mappings', 0)
if !exists('g:debuggerPort')         " {{{2
  let g:debuggerPort = 9000
endif
if !exists('g:debuggerMaxChildren')  " {{{2
  let g:debuggerMaxChildren = 32
endif
if !exists('g:debuggerMaxData')      " {{{2
  let g:debuggerMaxData = 1024
endif
if !exists('g:debuggerMaxDepth')     " {{{2
  let g:debuggerMaxDepth = 1
endif
if !exists('g:debuggerMiniBufExpl')  " {{{2
  let g:debuggerMiniBufExpl = 0
endif
if !exists('g:debuggerTimeout')      " {{{2
  let g:debuggerTimeout = 5
endif
if !exists('g:debuggerDedicatedTab') " {{{2
  let g:debuggerDedicatedTab = 1
endif
if !exists('g:debuggerDebugMode')    " {{{2
  let g:debuggerDebugMode = 0
endif

" init function! {{{1
function! s:init()
  if !s:initialized
    execute 'pyfile' s:py_path

    hi DbgCurrent term=reverse ctermfg=White ctermbg=Red gui=reverse
    hi DbgBreakPt term=reverse ctermfg=White ctermbg=Green gui=reverse

    sign define current text=->  texthl=DbgCurrent linehl=DbgCurrent
    sign define breakpt text=B>  texthl=DbgBreakPt linehl=DbgBreakPt

    python debugger_init()
    let s:initialized = 1
  endif
endfunction

" public functions {{{1
function! xdebug#initialize() " {{{2
  call s:init()
endfunction

function! xdebug#start() " {{{2
  call s:init()
  " call s:define_default_mappings()
  python debugger_run()
endfunction

function! xdebug#stop() " {{{2
  call s:init()
  python debugger_run()
endfunction

function! xdebug#context() " {{{2
  call s:init()
  python debugger_context()
endfunction

function! xdebug#property() " {{{2
  call s:init()
  python debugger_property()
endfunction

function! xdebug#resize() " {{{2
  call s:init()
  python debugger_resize()
endfunction

function! xdebug#step_into() "{{{2
  python debugger_command('step_into')
endfunction

function! xdebug#step_over() "{{{2
  python debugger_command('step_over')
endfunction

function! xdebug#step_out() "{{{2
  python debugger_command('step_out')
endfunction

function! xdebug#break_point(...) " {{{2
  call s:init()
  if a:0 == 0
    python debugger_mark()
  else
    python debugger_mark(vim.eval('a:1'))
  endif
endfunction

function! xdebug#up() " {{{2
  call s:init()
  python debugger_up()
endfunction

function! xdebug#down() " {{{2
  call s:init()
  python debugger_down()
endfunction

function! xdebug#command(action) " {{{2
  call s:init()
  python debugger_command(vim.eval('a:action'))
endfunction

function! xdebug#watch_input(action) " {{{2
  call s:init()
  python debugger_watch_input(vim.eval('a:action'))
endfunction

function! xdebug#watch_input_var(action, var) " {{{2
  call s:init()
  python debugger_watch_input(vim.eval('a:action'), vim.eval('a:var'))
endfunction

function! xdebug#set_mappings() "{{{2
  call s:define_default_mappings()
endfunction

function! xdebug#open_url(...) " {{{2
  let url = a:0 ? a:1 : s:last_url
  if empty(url)
    echohl Error
    echohl "url not found"
    echohl Normal
    return
  endif
  let s:last_url = url
  silent call s:open_url(s:last_url)
  call xdebug#start()
endfunction

" static functions {{{1
function! s:shell(...) " {{{2
  " TODO escape
  " call call('system', map(a:000, 'shellescape(v:val)'))
  if s:is_win
    let args = ["start", '""']
  elseif s:is_mac
    let args = ["open"]
  else
    let args = ["firefox"]
  endif
  let args += a:000
  if !s:is_win && !s:is_mac
    let args += ['&']
  endif
  execute "!" join(args, " ")
endfunction

function! s:open_url(url) " {{{2
  let q = stridx(a:url, "?") == -1 ? "?" : "&"
  let url = a:url . q . 'XDEBUG_SESSION_START=vim_' . localtime()

  call s:shell( '"' . url . '"')
endfunction

function! s:define_default_mappings() " {{{2

  command! -buffer -nargs=? Bp call xdebug#break_point('<args>')
  command! -buffer -nargs=0 Up call xdebug#up()
  command! -buffer -nargs=0 Dn call xdebug#down()


  if g:xdebug_no_default_mappings
    silent doautocmd User PluginXdebugKeymapping
    return
  endif

  map      <silent><buffer> <F1>      <Plug>(xdebug-resize)
  map      <silent><buffer> <F2>      <Plug>(xdebug-step_into)
  map      <silent><buffer> <F3>      <Plug>(xdebug-step_over)
  map      <silent><buffer> <F4>      <Plug>(xdebug-step_out)
  map      <silent><buffer> <F5>      <Plug>(xdebug-start)
  map      <silent><buffer> <F6>      <Plug>(xdebug-stop)
  map      <silent><buffer> <F11>     <Plug>(xdebug-context)
  map      <silent><buffer> <F12>     <Plug>(xdebug-property)
  map      <silent><buffer> <F11>     :<C-u>python debugger_watch_input("context_get")<CR>A<CR>
  map      <silent><buffer> <F12>     :<C-u>python debugger_watch_input("property_get", '<cword>')<CR>A<CR>
  nnoremap <silent><buffer> <Leader>e :<C-u>python debugger_watch_input("eval")<CR>

  map <silent><buffer> <Leader>dr <Plug>(xdebug-resize)
  map <silent><buffer> <Leader>di <Plug>(xdebug-step_into)
  map <silent><buffer> <Leader>do <Plug>(xdebug-step_over)
  map <silent><buffer> <Leader>dt <Plug>(xdebug-step_out)

  " map      <silent><buffer> <F11>     <Plug>(xdebug-watch_context)
  " map      <silent><buffer> <F12>     <Plug>(xdebug-watch_property)
  " nnoremap <silent><buffer> <Leader>e <Plug>(xdebug-watch_eval)

  silent doautocmd User PluginXdebugKeymapping

endfunction

let &cpo = s:save_cpo
" __END__ {{{1
" vim:fdm=marker sw=2 ts=2 ft=vim expandtab:
