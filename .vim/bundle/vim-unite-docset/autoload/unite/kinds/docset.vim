let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let g:unite_docset_debug = get(g:, 'unite_docset_debug', 0)

let g:unite_docset_open_command = get(g:, 'unite_docset_open_command', ':!open "file://%s"')
let g:unite_docset_w3m_command = get(g:, 'unite_docset_w3m_open_command', 'W3m local %s')
let g:unite_docset_w3m_split_command = get(g:, 'unite_docset_w3m_open_command', 'W3mSplit local %s')
let g:unite_docset_default_w3m = get(g:, 'unite_docset_default_w3m', 'w3m_split')

" static variables {{{1
let s:has_w3m = exists(':W3m')
let s:kind = {
      \ 'name' : 'docset',
      \ 'default_action' : s:has_w3m ? g:unite_docset_default_w3m : 'open',
      \ 'parents' : ['file'],
      \ 'action_table' : {},
      \ 'alias_table' : {},
      \ }

" open_action {{{2
let s:kind.action_table.open = {
      \ 'description' : '',
      \ 'is_selectable' : 0,
      \ 'is_quit' : 1,
      \ 'is_invalidate_cache' : 0,
      \ 'is_listed' : 1,
      \ }

function! s:kind.action_table.open.func(candidate) "{{{3
  let path = s:get_path(a:candidate, 0 <= match(g:unite_docset_open_command, '^:?!'))
  let cmd = printf(g:unite_docset_open_command, path)
  call s:log(cmd)
  execute cmd
endfunction

" w3m_actions {{{2
if s:has_w3m
  " w3m {{{3
  let s:kind.action_table.w3m = {
        \ 'description' : '',
        \ 'is_selectable' : 0,
        \ 'is_quit' : 1,
        \ 'is_invalidate_cache' : 0,
        \ 'is_listed' : 1,
        \ }

  function! s:kind.action_table.w3m.func(candidate) "{{{4
    let path = s:get_path(a:candidate, 1)
    let cmd = printf(g:unite_docset_w3m_command, path)
    call s:log(cmd)
    execute cmd
  endfunction

  " w3m_split {{{3
  let s:kind.action_table.w3m_split = {
        \ 'description' : '',
        \ 'is_selectable' : 0,
        \ 'is_quit' : 1,
        \ 'is_invalidate_cache' : 0,
        \ 'is_listed' : 1,
        \ }

  function! s:kind.action_table.w3m_split.func(candidate) "{{{4
    let path = s:get_path(a:candidate, 1)
    let cmd = printf(g:unite_docset_w3m_split_command, path)
    call s:log(cmd)
    execute cmd
  endfunction
endif

" utils {{{1
function! s:get_path(candidate, is_escape) "{{{2
  let path = fnamemodify(expand(a:candidate.action__docset_path .
        \ '/Contents/Resources/Documents/' . a:candidate.action__path), ':p')
  let path = substitute(path, '//', '/', 'g')
  if a:is_escape
    if stridx(path, '(') != -1 && stridx(path, '(') != -1
      let path = escape(path, '%#()')
      let path = escape(path, '\')
    else
      let path = substitute(path, '#.*$', '', '')
    endif
  endif
  return path
endfunction

function! s:log(...) "{{{2
  if !g:unite_docset_debug
    return
  endif
  if exists(':NeoBundle') && !neobundle#is_sourced('vimconsole.vim')
    NeoBundleSource vimconsole.vim
  endif
  if !exists(':VimConsoleOpen')
    return
  endif
  let args = copy(a:000)
  if empty(args)
    call vimconsole#log('docset/kind')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> docset/kind :" . args[0]
  call call('vimconsole#log', args)
endfunction

function! unite#kinds#docset#define() "{{{1
  return s:kind
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
