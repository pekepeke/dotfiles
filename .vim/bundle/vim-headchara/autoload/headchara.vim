let s:save_cpo = &cpo
set cpo&vim

" function!

function! s:re(chars)
  let re = s:escape(a:chars)
  return '^\(\s*\)\(\('.re.'\)*\) \{,1}'
endfunction

function! s:re_at_toggle(chars)
  let re = s:escape(a:chars)
  return '^\(\s*\)\(\('.re.'\)\+\) \{,1}'
endfunction

function! s:escape(ch)
  return substitute(a:ch, '\([\./\[\]\?\*+\-\!\@\{\}\\<>]\)', '\\\1', 'g')
endfunction

function! headchara#insert(ch)
  let mode = mode()
  if mode ==# 'v' || mode ==# 'V'
    let re = s:re(a:ch)
    let s = substitute(a:ch, '/', '\\/', '')
    return ":".'s/' . re . '/\1'.s.'\2 /&ge'."\<CR>:nohlsearch\<CR>"
  endif
  return a:ch
endfunction


function! headchara#toggle(ch)
  let mode = mode()
  if mode ==# 'v' || mode ==# 'V'
    let re = s:re_at_toggle(a:ch)
    let line = getline(line('.'))
    if matchstr(line, re) == ''
      return headchara#insert(a:ch)
    else
      return headchara#remove(a:ch)
    endif
  endif
  return a:ch
endfunction

function! headchara#remove(ch)
  let mode = mode()
  if mode ==# 'v' || mode ==# 'V'
    let re = s:re(a:ch)
    let s = substitute(a:ch, '/', '\\/', '')
    return ":".'s/'.re.'/\1/ge'."\<CR>:nohlsearch\<CR>"
  endif
  return a:ch
endfunction

let &cpo = s:save_cpo
