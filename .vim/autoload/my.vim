let s:save_cpo = &cpo
set cpo&vim

let s:is_mac = has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

function! my#is_win() " {{{2
  return s:is_win
endfunction "}}}

function! my#is_mac() " {{{2
  return s:is_mac
endfunction

function! my#output_to_buffer(bufname, text_list) " {{{2
  let l:bufnum = bufnr(a:bufname)
  if l:bufnum == -1
    exe 'new '.a:bufname
    " edit +setlocal\ bufhidden=hide\ buftype=nofile\ noswapfile\ buflisted
    setlocal bufhidden=hide buftype=nofile noswapfile buflisted
  else
    let l:winnum = bufwinnr(l:bufnum)
    if l:winnum != -1
      if winnr() != l:winnum
        exe l:winnum . 'wincmd w'
      endif
    else
      silent exe 'split +buffer'.a:bufname
    endif
  endif
  "silent exe 'normal GI'.a:text."\n"
  call append(line('$'),
        \ type(a:text_list) == type([])
        \ ? a:text_list : split(a:text_list, "\n"))
  "setlocal bufhidden=hide buftype=nofile noswapfile buflisted
  silent exe 'wincmd p'
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
