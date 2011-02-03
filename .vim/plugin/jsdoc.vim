
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
let s:save_cpo = &cpo
set cpo&vim

function! s:generate_func_comment(line) "{{{
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
    let prefix = matchstr(a:line, '^\s*')
    let comments = [ prefix.g:js_cfg_comment_head ]
    call add(comments, g:js_cfg_comment_line1.func_name)
    for param in params
      call add(comments, g:js_cfg_comment_linen.'@param {'.g:js_cfg_default_param_type.'} '.param)
    endfor
    call add(comments, g:js_cfg_comment_linen.'@returns {'.g:js_cfg_default_return_type.'}')
    call add(comments, g:js_cfg_comment_tail)
    return join(comments, "\n".prefix)
  endif
endfunction "}}}

function! JsDoc() "{{{
  let l:paste = &paste
  let &paste = 1
  let l:line = getline('.')
  let l:comment_line = line('.') - 1

  let l:comments = s:generate_func_comment(l:line)
  if l:comments != ''
    exe 'norm! ' . l:comment_line . 'G$'
    exe 'norm! o'.l:comments
  endif
  let &paste = l:paste
  return l:comments
endfunction "}}}

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_jsdoc = 1

" vim: foldmethod=marker
