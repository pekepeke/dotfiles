let s:save_cpo = &cpo
set cpo&vim

let g:my_preview_browser_cmd = get(g:, 'my_browserpreview_cmd', "")

function! my#ui#relative_copy(dst) "{{{2
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
  let cmd = my#util#is_win() ? 'copy' : 'cp'
  execute '!' cmd fpath dpath
endfunction "}}}

function! my#ui#complete_encodings(A, L, P) "{{{2
  let encodings = ['utf-8', 'sjis', 'euc-jp', 'iso-2022-jp']
  let matches = []

  for encoding in encodings
    if encoding =~? '^' . a:A
      call add(matches, encoding)
    endif
  endfor

  return matches
endfunction 

function! my#ui#cmd_capture(q_args) "{{{2
  redir => output
  silent execute a:q_args
  redir END
  let output = substitute(output, '^\n\+', '', '')

  belowright new

  silent file `=printf('[Capture: %s]', a:q_args)`
  setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
  call setline(1, split(output, '\n'))
endfunction

function! my#ui#indent_whole_buffer() " {{{2
  let l:p = getpos(".")
  normal gg=G
  call setpos(".", l:p)
endfunction "}}}

function! my#ui#launch_browser(appname) "{{{2
  let path = ""
  if a:appname == "ie"
    if my#util#is_win()
      let path = ' start '.expand('$ProgramFiles/Internet Explorer/iexplore.exe')
    endif
  elseif a:appname == "firefox"
    if my#util#is_win()
      let path = ' start '.expand('$ProgramFiles/Firefox/firefox.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Firefox/firefox.exe')
      endif
    elseif my#util#is_mac()
      let path = 'open -a "Firefox"'
    else
      let path = 'firefox'
    endif
  elseif a:appname == "opera"
    if my#util#is_win()
      let path = ' start '.expand('$ProgramFiles/Opera/Opera.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Opera/Opera.exe')
      endif
    elseif my#util#is_mac()
      let path = 'open -a "Opera"'
    else
      let path = 'opera'
    endif
  elseif a:appname == "chrome"
    if my#util#is_win()
      let path = ' start ' . expand('$LOCALAPPDATA/Google/Chrome/Application/chrome.exe')
    elseif my#util#is_mac()
      let path = 'open -a "Google Chrome"'
    else
      let path = 'google-chrome'
    endif
  elseif a:appname == "safari"
    if my#util#is_win()
      let path = ' start '.expand('$ProgramFiles/Safari/safari.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Safari/safari.exe')
      endif
    elseif my#util#is_mac()
      let path = 'open -a "Safari"'
    else
    endif
  endif
  if len(path) > 0
    silent execute "!" path expand("%:p")
  endif
endfunction "}}}

function! my#ui#preview_browser() range "{{{4
  if !exists('g:my_preview_browser_cmd')
    echoerr "command not found."
    return
  endif
  let cmd = g:my_preview_browser_cmd
  if ! &modified && &buftype != 'nofile'
    let fpath = expand('%:p')
    silent execute "!" cmd fpath
    redraw!
    return
  endif
  let lines = a:firstline == a:lastline 
        \ ? getline(1, "$") : getline(a:firstline, a:lastline)
  "let lines = a:lines
  if empty(lines)
    echo "empty buffer : stop execute!!"
    return
  endif

  let fpath = tempname() . '.html'
  call writefile(lines, fpath)
  silent execute "!" cmd fpath
  " FIXME いい方法はないものか？
  silent execute "sleep 2"
  if filewritable(fpath) | call delete(fpath) | endif
  redraw!
endfunction 


let &cpo = s:save_cpo
