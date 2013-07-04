let s:save_cpo = &cpo
set cpo&vim

" source define {{{1
let s:source = {
      \ 'name': '{{_name_}}',
      \ 'max_candidates': 200,
      \ }

function! s:source.on_init(args, context) "{{{2
endfunction

function! s:source.gather_candidates(args, context) "{{{2
  let lines = split('', '\n')
  return filter(map(lines, 's:create_candidate(v:val)'), 'len(v:val) > 0')
endfunction

" functions {{{1
function! s:create_candidate(val) "{{{2
  return {
        \ "word": a:val,
        \ "source": "{{_name_}}",
        \ "kind": "file",
        \ "action__path": a:val,
        \ "action__directory": unite#path2directory(a:val),
        \ }
endfunction

" register {{{1
function! unite#sources#{{_name_}}#define() "{{{2
  return s:source
endfunction


let &cpo = s:save_cpo
" __END__ {{{1
