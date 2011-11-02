let s:save_cpo = &cpo
set cpo&vim

function! my#rename#exec(path) " {{{3
  if !my#rename#can()
    echohl ErrorMsg
    echomsg "Error : can't rename buffer"
    echohl Normal
    return
  endif
  let path = a:path
  if my#rename#is_relative(a:path)
    let path = expand("%:p:h") . "/" . path
  endif
  exe "f" path | call delete(expand('#')) | w
endfunction

function! my#rename#is_relative(path)
  return stridx(a:path, "/") < 0 || stridx(a:path, "\\")
endfunction

function! my#rename#can()
  return !empty(expand('%'))
endfunction

function! my#rename#complete(A, L, P)
  echo "HO"
  if !my#rename#can()
    return []
  endif
  if !my#rename#is_relative(a:A)
    return []
  end
  let files = split(globpath(expand("%:p:h"), "*"), "\n")
  let items = map(files, 'matchstr(v:val, "[^/]\\+$")')
  let matches = []
  for item in items
    if item =~? '^' . a:A
      call add(matches, item)
    endif
  endfor
  echoerr "UF"
  return matches
endfunction "}}}


let &cpo = s:save_cpo
