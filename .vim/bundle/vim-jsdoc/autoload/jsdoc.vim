let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
if !exists('g:js_cfg_comment_head') | let g:js_cfg_comment_head = '/**' | endif
if !exists('g:js_cfg_comment_line1') | let g:js_cfg_comment_line1 = ' * ' | endif
if !exists('g:js_cfg_comment_linen') | let g:js_cfg_comment_linen = ' * ' | endif
if !exists('g:js_cfg_comment_tail') | let g:js_cfg_comment_tail = ' */' | endif

if !exists('g:js_cfg_default_param_type') | let g:js_cfg_default_param_type = 'Object' | endif
if !exists('g:js_cfg_default_return_type') | let g:js_cfg_default_return_type = 'Object' | endif

if !exists('g:js_re_funcname') | let g:js_re_funcname = '\([a-zA-Z0-9$_\.]\+\)' | endif
if !exists('g:js_re_funcparams') | let g:js_re_funcparams = '\(([^)]*)\)' | endif
if !exists('g:js_re_func')
  let g:js_re_func = '\s*\('.g:js_re_funcname.'\s*[:=]\s*function\s*'.g:js_re_funcparams.'\|function\s*'.g:js_re_funcname.'\s*'.g:js_re_funcparams.'\)'
endif

" public interfaces {{{1
function! jsdoc#insert() "{{{2
  let org_paste = &paste
  let &paste = 1
  let line = getline('.')
  let comment_line = line('.') - 1

  let comments = s:generate_function_comment(l:line)
  if comments != ''
    execute 'normal! ' . comment_line . 'G$'
    execute 'normal! o' . comments
  endif
  let &paste = org_paste
endfunction


" functions {{{1
function! s:generate_function_comment(line) "{{{2
  let matches = matchlist(a:line, g:js_re_func)
  let n = len(matches)
  let i = 0
  let func_name = ''
  let params = []
  while i < n
    if i > 1
      if stridx(matches[i], '(') == 0
        let params = split(substitute(matches[i], '\s\+\|(\|)', '', 'g'), ',')
      elseif matches[i] != '' && matches[i] !~ '^\s*$'
        let func_name = matches[i]
      endif
    endif
    let i+=1
  endwhile
  if func_name != ''
    let indent = matchstr(a:line, '^\s*')
    let comments = [ indent.g:js_cfg_comment_head ]
    call add(comments, s:mk_line_head("%s", func_name))
    call add(comments, s:mk_line(""))
    for param in params
      call add(comments, s:mk_line("@param {%s} %s", g:js_cfg_default_param_type, param))
    endfor
    call add(comments, s:mk_line("@name %s", func_name))
    call add(comments, s:mk_line("@function"))
    call add(comments, s:mk_line("@return {%s}", g:js_cfg_default_return_type))
    call add(comments, g:js_cfg_comment_tail)
    return join(comments, "\n" . indent)
  endif
endfunction

function! s:mk_line_head(...) "{{{2
  let s = a:0 == 1 ? a:1 : call("printf", a:000)
  return g:js_cfg_comment_line1 . s
endfunction

function! s:mk_line(...) "{{{2
  let s = a:0 == 1 ? a:1 : call("printf", a:000)
  return g:js_cfg_comment_linen . s
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
" __END__ {{{1
