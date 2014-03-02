let s:save_cpo = &cpo
set cpo&vim

" functions {{{1
function! my#command#rename(path) "{{{2
  let path = empty(a:path) ? input("dest : ", expand("%:p"), "file") : a:path
  if !empty(path)
    exe "f" path | call delete(expand('#')) | w
  endif
endfunction

function! my#command#relative_copy(dst) "{{{2
  let fpath = expand('%')
  if !filereadable(fpath)
    echo 'file is cannot readable'
    "return
  endif
  let dpath = stridx(a:dst, '/') < 0 ? expand('%:p:h').'/'.a:dst : a:dst
  if filereadable(dpath)
    let res = input('dpath is already exists. overwrite ? [y/n]:')
    if res !=? 'y' | return | endif
    " echo 'dpath is already exists. overwrite?[y/n]'
    " let ch = getchar()
    " if nr2char(ch) !=? "y" | return | endif
  endif
  let cmd = my#is_win() ? 'copy' : 'cp'
  execute '!' cmd fpath dpath
endfunction "}}}
function! my#command#complete_encodings(A, L, P) "{{{2
  let encodings = ['utf-8', 'sjis', 'euc-jp', 'iso-2022-jp']
  let matches = []

  for encoding in encodings
    if encoding =~? '^' . a:A
      call add(matches, encoding)
    endif
  endfor

  return matches
endfunction


function! my#command#openbrowser_range(f1, f2) "{{{2
  if a:f1 > 0 && a:f2 > 0
    let lines = getline(a:firstline, a:lastline)
    let fpath = tempname() . '.html'
    call writefile(lines, fpath)
    execute OpenBrowser fpath
    " TODO : find the best way...
    silent execute "sleep 2"
    if filewritable(fpath)
      call delete(fpath)
    endif
    redraw!
  elseif !&modified && &buftype != 'nofile'
    let fpath = expand('%:p')
    execute 'OpenBrowser' fpath
    return
  endif
endfunction "}}}

let &cpo = s:save_cpo
" __END__ {{{1
