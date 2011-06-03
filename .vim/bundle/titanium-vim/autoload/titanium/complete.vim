function! titanium#complete#words()
  let l:fpath = titanium#get_keywordfile_path()
  if !filereadable(l:fpath)
    return []
  endif
  return readfile(l:path)
endfunction

function! titanium#complete#methods(base) " {{{2
  if g:titanium_method_complete_disabled
    return []
  endif
  let l:fpath = titanium#get_keywordfile_path()
  if !filereadable(l:fpath)
    return []
  endif
  let l:list = map(
        \ filter(readfile(l:fpath), 'v:val =~ "'.a:base.'[^\\.]*($"'), 
        \ 'substitute(v:val, "^.*\\.\\([^\\.]\\+\\)$", "\\1", "")')
  let l:dict = {}
  for l:v in l:list
    let l:dict[l:v] = 1
  endfor

  return keys(l:dict)
endfunction


function! titanium#complete#titanium(base) " {{{2
  let l:fpath = titanium#get_keywordfile_path()
  " read keywords
  let l:keyword = substitute(l:kwd, "^Ti\\.", "Titanium.", "es")
  let l:keyword = substitute(l:keyword, "\\\.", "\\.", "eg")
  let l:list = readfile(l:fpath)

  " no namespace -> api full expand
  if stridx(l:keyword, ".") == -1 && g:titanium_complete_head == 0
    let l:matches = filter(l:list, 'v:val =~ "'.l:keyword.'"')
    if g:titanium_complete_short_style
      return map(l:matches, 'substitute(v:val, "^Titanium\\.", "Ti.", "e")')
    endif
    return l:matches
  endif

  "let l:matches = filter(l:list, 'v:val =~ "^'.l:keyword.'\\.\\?[^\\.]\\+$"')
  let l:matches = filter(l:list, 'v:val =~ "^'.l:keyword.'[^\\.]*$"')
  return map(l:matches, 'substitute(v:val, "^.\\+\\.\\([^\\.]*\\)$", "\\1", "e")')
endfunction


