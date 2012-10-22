let s:save_cpo = &cpo
set cpo&vim

" static vars {{{1
let s:initialized = 0
let s:last_url = ""
let s:is_win = has('win32') || has('win64') || has('win32unix')
let s:is_mac = has('mac') || has('macunix') || has('gui_macvim')

" vars {{{1
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
    let g:debuggerTimeout = 10
endif
if !exists('g:debuggerDedicatedTab') " {{{2
    let g:debuggerDedicatedTab = 1
endif
if !exists('g:debuggerDebugMode')    " {{{2
    let g:debuggerDebugMode = 0
endif

let g:xdebug_no_default_mappings = get(g:, 'xdebug_no_default_mappings', 0)

" init function {{{1
function s:init()
  if !s:initialized
    let py_path = expand('<sfile>:p:h') . '/xdebug/debugger.py'
    execute 'pyfile' py_path

    hi DbgCurrent term=reverse ctermfg=White ctermbg=Red gui=reverse
    hi DbgBreakPt term=reverse ctermfg=White ctermbg=Green gui=reverse

    if has('sign')
      sign define current text=->  texthl=DbgCurrent linehl=DbgCurrent
      sign define breakpt text=B>  texthl=DbgBreakPt linehl=DbgBreakPt
    endif

    python debugger_init()
  endif
endfunction

" public functions {{{1
function xdebug#initialize() " {{{2
  call s:init()
endfunction

function xdebug#start() " {{{2
  call s:init()
  call s:define_default_mappings()
  python debugger_run()
endfunction

function xdebug#stop() " {{{2
  call s:init()
  python debugger_run()
endfunction

function xdebug#resize() " {{{2
  call s:init()
  python debugger_resize()
endfunction

function xdebug#context() " {{{2
  call s:init()
  python debugger_context()
endfunction

function xdebug#context() " {{{2
  call s:init()
  python debugger_context()
endfunction

function xdebug#property() " {{{2
  call s:init()
  python debugger_property()
endfunction

function xdebug#break_point(...) " {{{2
  call s:init()
  if a:0 == 0
    python debugger_mark()
  else
    python debugger_mark(a:1)
  endif
endfunction

function xdebug#up() " {{{2
  call s:init()
  python debugger_up()
endfunction

function xdebug#down() " {{{2
  call s:init()
  python debugger_down()
endfunction

function xdebug#command(action) " {{{2
  call s:init()
  python debugger_command(a:action)
endfunction

function xdebug#watch_input(action) " {{{2
  call s:init()
  python debugger_watch_input(a:action)
endfunction

function xdebug#watch_input_var(action, var) " {{{2
  call s:init()
  python debugger_watch_input(a:action, a:var)
endfunction

function xdebug#open_url(...) " {{{2
  let url = a:0 ? a:1 : s:last_url
  if empty(url)
    echohl Error
    echohl "url not found"
    echohl Normal
    return
  endif
  let s:last_url = url
  call s:open_url(s:last_url)
endfunction

" static function {{{1
function s:shell(...) " {{{2
  " TODO escape
  " call call('system', map(a:000, 'shellescape(v:val)'))
  if s:is_win
    let args = ["start", '""']
  elseif s:is_mac
    let args = ["open"]
  else
    let args = ["firefox"]
  endif
  let args = args + a:000
  if !s:is_win && !s:is_mac
    let args = args + ['&']
  endif
  call call('system', join(args, " "))
endif

function s:open_url(url) " {{{2
  let q = stridx(a:url, "?") == -1 ? "&" : "?"
  let url = a:url . q . 'XDEBUG_SESSION_START=vim_' . localtime()

  call s:shell(url)
endfunction

function s:define_default_mappings() " {{{2
  if exists('b:xdebug_mapped')
    return
  endif

  command! -buffer -nargs=? Bp call xdebug#break_point('<args>')
  command! -buffer -nargs=0 Up call xdebug#up()
  command! -buffer -nargs=0 Dn call xdebug#down()
  command! -buffer -nargs=? XdebugOpen call xdebug#open('<args>')

  let b:xdebug_mapped=1

  if g:xdebug_no_default_mappings
    silent doautocmd User PluginXdebugKeymapping
    return
  endif

  " TODO change keymaps
  map      <buffer> <F1>      <Plug>(xdebug-resize)
  map      <buffer> <F2>      <Plug>(xdebug-step_into)
  map      <buffer> <F3>      <Plug>(xdebug-step_over)
  map      <buffer> <F4>      <Plug>(xdebug-step_out)
  map      <buffer> <F5>      <Plug>(xdebug-start)
  map      <buffer> <F6>      <Plug>(xdebug-stop)
  map      <buffer> <F11>     <Plug>(xdebug-context)
  map      <buffer> <F12>     <Plug>(xdebug-property)
  map      <buffer> <F11>     <Plug>(xdebug-watch_context)
  map      <buffer> <F12>     <Plug>(xdebug-watch_property)
  nnoremap <buffer> <Leader>e <Plug>(xdebug-watch_eval)

  silent doautocmd User PluginXdebugKeymapping
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
" vim:fdm=marker sw=2 ts=2 ft=vim expandtab:
