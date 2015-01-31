let s:save_cpo = &cpo
set cpo&vim

" autocmd {{{1
augroup plugin-jqplay
  autocmd!
augroup END

" functions {{{1
let s:jqplay_prev_input = []
let s:jqplay_prev_query = []

function! s:is_empty(arr)
  let s = substitute(join(a:arr, ""), '^\s*|\s*$', '', 'g')
  return empty(s)
endfunction

function! s:exec_jqplay() "{{{2
  let outputbufnr = s:find_jqplay_output_bufnr()
  if !outputbufnr
    echohl Error
    echomsg "buffer not found : __JQ_RESULT__"
    echohl None
    return
  endif
  let input = getbufline("__JQ_JSON__", 1, "$")
  let query = getbufline("__JQ_QUERY__", 1, "$")
  if s:is_empty(input) || s:is_empty(query)
    return
  endif
  if input == s:jqplay_prev_input &&
    \ query == s:jqplay_prev_query
    return
  endif
  let s:jqplay_prev_input = input
  let s:jqplay_prev_query = query

  let infname = tempname()
  call writefile(input, infname)
  let str = substitute(join(query, "\n"), '["\\]', '\\\0', 'g')
  unlet query input
  let output = system(printf('jq %s "%s" %s',
    \ g:jqplay_opt, str, infname))
  execute outputbufnr."wincmd w"
  % delete _
  call append(1, split(output, "\n"))
  wincmd p
  call delete(infname)
endfunction

function! s:find_jqplay_output_bufnr() "{{{2
  let tabnr = tabpagenr()
  let bufnrs = filter(tabpagebuflist(tabnr), 'bufname(v:val) == "__JQ_RESULT__"')
  if len(bufnrs) <= 0
    return 0
  endif
  return bufnrs[0]
endfunction

function! s:find_jqplay_tabnr() "{{{2
  for i in range(tabpagenr('$'))
    let names = map(tabpagebuflist(i + 1), 'bufname(v:val)')
    if len(filter(names, 'v:val == "__JQ_JSON__"')) > 0
      return i+1
    endif
  endfor
  return 0
endfunction

function! s:init_jqplay_buffer() "{{{2
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  autocmd! plugin-jqplay * <buffer>
  command! -buffer JQPlayQuit call jqplay#quit()
endfunction

function! s:create_jqplay_buffer() "{{{2
  tabnew
  edit __JQ_JSON__
  call s:init_jqplay_buffer()
  autocmd plugin-jqplay InsertLeave,CursorHold,CursorHoldI  <buffer> call s:exec_jqplay()
  split
  edit __JQ_RESULT__
  call s:init_jqplay_buffer()
  wincmd p
  vsplit
  edit __JQ_QUERY__
  call s:init_jqplay_buffer()
  autocmd plugin-jqplay InsertLeave,CursorHold,CursorHoldI  <buffer> call s:exec_jqplay()
endfunction

" interfaces {{{1
function! jqplay#open() "{{{2
  let tabnr = s:find_jqplay_tabnr()
  if tabnr
    execute 'normal!' tabnr.'gt'
    return
  endif

  call s:create_jqplay_buffer()
endfunction

function! jqplay#quit() "{{{2
  bdelete! __JQ_RESULT__
  bdelete! __JQ_QUERY__
  bdelete! __JQ_JSON__
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
