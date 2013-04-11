let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let g:jsdoc_max_function_line = get(g:, 'jsdoc_max_function_line', 5)
let g:jsdoc_start_str = get(g:, 'jsdoc_start_str', '/**')
let g:jsdoc_head_str1 = get(g:, 'jsdoc_head_str1', ' * ')
let g:jsdoc_head_strn = get(g:, 'jsdoc_head_strn', ' * ')
let g:jsdoc_tail_str = get(g:, 'jsdoc_tail_str', ' */')
let g:jsdoc_default_param_type = get(g:, 'jsdoc_default_param_type', 'Object')
let g:jsdoc_default_return_type = get(g:, 'jsdoc_default_return_type', 'Object')

let g:jsdoc_funcname_re = get(g:, 'jsdoc_funcname_re', '\([a-zA-Z0-9$_\.]\+\)')
let g:jsdoc_params_re = get(g:, 'jsdoc_params_re', '\(([^)]*)\)')
let g:jsdoc_function_re = get(g:, 'jsdoc_function_re', join([
      \   '\s*\(',
      \   g:jsdoc_funcname_re,
      \   '\s*[:=]\s*function\s*',
      \   g:jsdoc_params_re,
      \   '\|function\s*',
      \   g:jsdoc_funcname_re,
      \   '\s*',
      \   g:jsdoc_params_re,
      \   '\)',
      \ ], ""))


" public interfaces {{{1
function! jsdoc#insert() "{{{2
  let pos = line('.')
  let insert_pos = pos - 1
  let tail_re = escape(g:jsdoc_tail_str, '*\\.')
  if getline(insert_pos) =~# tail_re
    return
  endif

  let save_paste = &paste
  let &paste = 1

  let lines = []
  for i in range(0, (g:jsdoc_max_function_line > 0 ? g:jsdoc_max_function_line : 1) - 1)
    call add(lines, getline(pos + i))
  endfor

  let comment = s:generate_function_comment(join(lines, ""))
  if comment != ''
    execute 'normal! ' . insert_pos . 'G$'
    execute 'normal! o' . comment
  endif
  let &paste = save_paste
endfunction


" functions {{{1
function! s:generate_function_comment(line) "{{{2
  let matches = matchlist(a:line, g:jsdoc_function_re)
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
    let comment = [ indent.g:jsdoc_start_str ]
    call add(comment, s:mk_line_head("%s", func_name))
    call add(comment, s:mk_line(""))
    for param in params
      call add(comment, s:mk_line("@param {%s} %s", g:jsdoc_default_param_type, param))
    endfor
    call add(comment, s:mk_line("@name %s", func_name))
    call add(comment, s:mk_line("@function"))
    call add(comment, s:mk_line("@return {%s}", g:jsdoc_default_return_type))
    call add(comment, g:jsdoc_tail_str)
    return join(comment, "\n" . indent)
  endif
endfunction

function! s:mk_line_head(...) "{{{2
  let s = a:0 == 1 ? a:1 : call("printf", a:000)
  return g:jsdoc_head_str1 . s
endfunction

function! s:mk_line(...) "{{{2
  let s = a:0 == 1 ? a:1 : call("printf", a:000)
  return g:jsdoc_head_strn . s
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
" __END__ {{{1
