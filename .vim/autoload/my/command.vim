let s:save_cpo = &cpo
set cpo&vim

" functions {{{1
let s:ctags_job = 0
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

function! my#command#system(cmd) "{{{2
  let bundle = VimrcScope().bundle
  if bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(a:cmd)
  else
    execute "!" a:cmd
  endif
endfunction

function! my#command#system_with_lcd(cmd, ...) "{{{2
  let dir = empty(a:000) ? "" : a:1

  if empty(dir)
    let dir = input("cd : ", getcwd(), "dir")
  endif
  if empty(dir)
    return
  endif
  let cwd = getcwd()

  execute 'lcd' dir
  call my#command#system(cmd)
  execute 'lcd' cwd
endfunction

function! my#command#exec_ctags(...) "{{{2
  if !filereadable("tags")
    return
  endif
  if !empty(s:ctags_job)
    echomsg 'ctags running...'
    return 0
  endif
  call s:purge_ctags()

  if a:0 > 0
    if type([]) == a:000[0])
      let langmap = join(remove(a:000, 0), ',')
    elseif a:000[0] !~ '^-'
      let langmap = remove(a:000, 0)
    endif
  endif
  if (empty(langmap))
    let langmap=&filetype
  endif
  let ctags_cmds = ["ctags"]
  call extend(ctags_cmds, a:000)
  let langmap = type([]) == a:langmap ? join(a:langmap, ',') : a:langmap
  call add(ctags_cmds, "--languages=".langmap)

  if has('job')
    let s:ctags_job = job_start(join(ctags_cmds, ' '), {'callback': 's:ctags_callback'})
  elseif bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(join(ctags_cmds, " "))
  else
    execute "!" join(ctags_cmds, " ")
    call s:ctags_callback(1, 1)
  endif
endfunction

function! my#command#ctags_with_path(path) "{{{2
  let path = a:path
  let ctags_cmds = ["ctags", "-R"]

  if !empty(s:ctags_job)
    echomsg 'ctags running...'
    return 0
  endif
  call s:purge_ctags()

  if &filetype
    call add(ctags_cmds, "--input-encoding-" . split(&filetype, '\.')[0] . "=" . &encoding)
    call add (ctags_cmds, '--languages=' . &filetype)
  endif
  " call add(ctags_cmds, '--exclude=".git"')
  " if &filetype != 'javascript'
  "   call add(ctags_cmds, '--exclude="*.js"')
  " endif
  " if &filetype != 'coffee'
  "   call add(ctags_cmds, '--exclude="*.coffee"')
  " endif
  " if &filetype != 'html'
  "   call add(ctags_cmds, '--exclude="*.html"')
  " endif
  " call add(ctags_cmds, '--exclude="*.json"')
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
  if has('job')
    let s:ctags_job = job_start(join(ctags_cmds, ' '), {'callback': 's:ctags_callback'})
  elseif bundle.is_installed('vimproc.vim')
    call vimproc#system_bg(join(ctags_cmds, " "))
  else
    execute "!" join(ctags_cmds, " ")
    call s:ctags_callback(1, 1)
  endif
  if !empty(a:path) && isdirectory(a:path)
    execute 'lcd' cwd
  endif
endfunction

function! my#command#toggle_option(opt) "{{{2
  exe "setlocal inv".a:opt
  let sts = eval('&'.a:opt)
  echo printf("set %s : %s", a:opt, sts ? "ON" : "OFF")
endfunction

function! my#command#coding_style_complete(A, L, P) "{{{2
  return filter(keys(g:vimrc_coding_styles),'v:val =~? "^".a:A')
endfunction

function! my#command#coding_style(bang, arg) "{{{2
  if empty(a:arg)
    return
  endif
  let expr = a:bang ? "set" : "setlocal"
  execute expr a:arg
endfunction

function! my#command#remove_html_comment() "{{{2
  %s@<!--\_.\{-}-->@@g
endfunction

function! s:ctags_callback(ch, msg)
  let s:ctags_job = 0
  let bundle = VimrcScope().bundle
  if bundle.is_installed('neocomplcache.vim')
    NeoComplCacheCachingTags
  elseif bundle.is_installed('neocomplete.vim')
    NeoCompleteTagMakeCache
  endif
endfunction

function! s:purge_ctags() "{{{2
  if !s:is_avairable_ctags()
    let tags = filter(tagfiles(), 'v:val !~ "^/"')
    call map(tags, 'delete(v:val)')
  endif
endfunction

function! s:is_avairable_ctags() "{{{2
  try
    call taglist('dummy')
  catch /^Vim\%(\a\+)\)\=:E431/
    return 0
  endtry
  return 1
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
