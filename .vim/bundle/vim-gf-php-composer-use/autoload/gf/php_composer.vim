let s:save_cpo = &cpo
set cpo&vim

let g:gf#php_composer#max_line = get(g:, 'gf#php_composer#max_line', 0)
let s:bin = expand('<sfile>:p:h') . '/../../lib/get_module_path.php'

function! gf#php_composer#find()
  if !s:is_filetype_applicable()
    return 0
  endif
  let composer_path = s:find_composer_json()
  if composer_path == ''
    return 0
  endif
  let fqcns = s:find_fqcns()
  if empty(fqcns)
    return 0
  endif

  " call s:log("fqcns:" . fqcns[0])
  let command = printf('%s %s %s',
    \ s:bin, composer_path, substitute(join(fqcns, " "), '\', '\\\\', 'g'))
  call s:log(command)
  let files = split(system(command), "\n")
  if empty(files)
    return 0
  endif
  return {
    \ 'path': files[0],
    \ 'line': 1,
    \ 'col': 0,
    \ }
endfunction

function! s:is_filetype_applicable()
  let fts = split(&filetype, '\.')
  return len(filter(fts, 'v:val =~# "php"')) > 0
endfunction

function! s:find_composer_json()
  let cdir = expand('%:p:h')
  let f = 'composer.lock'
  let composer = findfile(f, cdir . ';')
  if composer != ''
    let cdir = fnamemodify(composer, ':p:h:h')
    let root_composer = findfile(f, cdir . ';')
    if root_composer != ''
      let composer = root_composer
    endif
  endif
  return substitute(composer, '\.lock$', '.json', '')
endfunction

function! s:find_fqcns()
  let class = s:get_class_from_line()
  " call s:log("d:" .class)
  if empty(class)
    return []
  elseif class =~# '^\'
    return [class[1:]]
  endif

  let endline = g:gf#php_composer#max_line
  if endline <= 0
    let endline = line('$')
  endif
  let ns = map(filter(getline(0, endline),
    \ 'v:val =~# "\\(use\\|namespace\\)\\s\\+\\([[:alnum:]\\\\_]\\+\\)[^,]*;"'),
    \ 's:parse_line(v:val)')

  if empty(ns)
    return []
  endif
  let filtered = filter(copy(ns),
    \ 'stridx(class, v:val.as) == 0 '
    \ . '|| stridx(class, v:val.as) == (strlen(class) - strlen(v:val.as))')
  if len(filtered) > 0
    return map(filtered, 'v:val.class')
  endif

  let namespace = filter(ns, 'v:val.is_ns')
  " call s:log("namespace:" . len(namespace))
  " call s:log("namespace:" . namespace[0].class)
  if len(namespace) > 0
    return [namespace[0].class . '\' . class]
  endif

  return []
endfunction

function! s:get_class_from_line()
  for re in [
    \ '\s*\(use\|new\)\s\+\([[:alnum:]\\_]\+\)\s*\(\s*as\s\+\w\+\)\?;',
    \ '\(\s*\)\?\([[:alnum:]\\_]\+\)::',
    \ ]
    let m = matchlist(getline('.'), re)
    if !empty(m)
      if m[1] =~# 'use'
        return '\' . m[2]
      endif
      return m[2]
    endif
  endfor

  let word = ""
  try
    let org_iskeyword = &iskeyword
    setlocal iskeyword+=\\
    let word = expand('<cword>')
  catch /.*/
  finally
    let &l:iskeyword = org_iskeyword
  endtry
  if !empty(word)
    return word
  endif

endfunction

function! s:parse_line(line)
  let m = matchlist(a:line,
    \ '\(use\|namespace\)\s\+\([[:alnum:]\\_]\+\)\(\s\+as\s\+\([[:alnum:]_]\+\)\)\?\s*;')
  if empty(m)
    call s:log('s:parse_line: not found pattern - ' . a:line)
    return { 'class': '', 'as': '', 'is_ns': 0 }
  endif
  let is_ns = (m[1]) == 'namespace'
  return {
    \ 'class': m[2],
    \ 'as': empty(m[4]) ? matchstr(m[2], '[^\\]\+$') : m[4],
    \ 'is_ns': is_ns,
    \ }
endfunction

function! s:log(msg)
  " call vimconsole#log(a:msg)
endfunction

let &cpo = s:save_cpo
