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

function! my#config#system(cmd) "{{{2
  let bundle = VimrcScope().bundle
  if bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(a:cmd)
  else
    execute "!" a:cmd
  endif
endfunction

function! my#config#system_with_lcd(cmd, ...) "{{{2
  let dir = empty(a:000) ? "" : a:1

  if empty(dir)
    let dir = input("cd : ", getcwd(), "dir")
  endif
  if empty(dir)
    return
  endif
  let cwd = getcwd()

  execute 'lcd' dir
  call my#config#system(cmd)
  execute 'lcd' cwd
endfunction

function! my#config#exec_ctags(path) "{{{2
  let path = a:path
  let options = ' --exclude=".git"'
  if &filetype != 'javascript'
    let options .= ' --exclude="*.js"'
  elseif &filetype != 'coffee'
    let options .= ' --exclude="*.coffee"'
  endif
  let ctags_cmd = "ctags -R"
  if empty(path)
    " let path = input("input base dir : ", expand('%:p:h'))
    let path = input("cd : ", getcwd(), "dir")
  endif
  if empty(path)
    return
  endif
  let cwd = getcwd()
  if !empty(a:path) && isdirectory(a:path)
    execute 'lcd' a:path
  endif

  let bundle = VimrcScope().bundle
  if bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(ctags_cmd)
  else
    execute "!" ctags_cmd
    if bundle.is_installed('neocomplcache.vim')
      NeoComplCacheCachingTags
    elseif bundle.is_installed('neocomplete.vim')
      NeoCompleteTagMakeCache
    endif
  endif
  if !empty(a:path) && isdirectory(a:path)
    execute 'lcd' cwd
  endif
endfunction

function! my#config#toggle_option(opt) "{{{2
  exe "setl inv".a:opt
  let sts = eval('&'.a:opt)
  echo printf("set %s : %s", a:opt, sts ? "ON" : "OFF")
endfunction
let &cpo = s:save_cpo
" __END__ {{{1
