let s:save_cpo = &cpo
set cpo&vim

let g:unite#sources#projectionist#files_start_insert
  \ = get(g:, 'unite#sources#projectionist#files_start_insert', 0)

" projectionist {{{1
let s:source = {
  \ 'name': 'projectionist',
  \ 'hooks': {},
  \ 'action_table': {'*': {}},
  \ }

function! s:source.gather_candidates(args, context) "{{{2
  if !s:is_available()
    call unite#print_source_error("projectionist is not available")
    return []
  endif
  let types = s:get_types()
  return map(types, 's:convert_type(v:val)')
endfunction

" projectionist/files {{{1
let s:files_source = {
  \ 'name': 'projectionist/files',
  \ 'hooks': {},
  \ 'action_table': {'*': {}},
  \ }

function! s:files_source.gather_candidates(args, context) "{{{2
  if !s:is_available()
    call unite#print_source_error("projectionist is not available")
    return []
  endif
  let type = get(a:context, 'custom_type', '')
  if empty(type)
    let type = unite#util#input("input type:", "",
      \ 'customlist,unite#sources#projectionist#type_complate')
  endif
  if empty(type)
    return []
  endif
  let dir = projectionist#path()
  let files = s:find_files_by_type(type)

  return map(files, 's:convert_file(v:val, dir)')
endfunction

" utilities {{{1
function! s:is_available() "{{{2
  return exists('b:projectionist')
endfunction

function! s:get_types() "{{{2
  let types = keys(projectionist#navigation_commands())
  return types
endfunction

function! s:convert_type(type) "{{{2
  return {
    \ 'word': a:type,
    \ 'kind': ['command'],
    \ 'action__command': s:files_command(a:type),
    \ 'action__type': ': ',
    \ }
endfunction

function! s:convert_file(file, dir) "{{{2
  let pat = substitute(a:dir, '[\.\*]', '\\\0', 'g')
  return {
  \ "word": substitute(a:file, a:dir, '', ''),
  \ "kind": ["file"],
  \ "action__path": a:file,
  \ "action__directory": a:dir
  \ }
endfunction

function! s:files_command(type) "{{{2
  let cmd = printf('Unite projectionist/files -custom-type=%s', a:type)
  if g:unite#sources#projectionist#files_start_insert
    let cmd .= " -start-insert"
  endif
  return cmd
endfunction

function! s:find_files_by_type(type) "{{{2
  let slash = projectionist#slash()
  let results = []

  let variants = get(projectionist#navigation_commands(), a:type, [])
  let s = "v:val[1] =~# '\\*\\*' ? v:val[1] : substitute(v:val[1], '\\*', '**/*', '')"
  for format in map(variants, 'v:val[0] . slash . ' . s)
    if format !~# '\*'
      continue
    endif

    let glob = substitute(format, '[^\/]*\ze\*\*[\/]\*', '', 'g')
    let results += split(glob(glob), "\n")
  endfor

  return results
endfunction

function! unite#sources#projectionist#type_complate(A, L, P) "{{{2
  let types = s:get_types()
  let matches = filter(copy(types),'v:val =~? "^".a:A')
  return matches
endfunction

" define source "{{{1
function! unite#sources#projectionist#define() "{{{2
  return [s:source, s:files_source]
endfunction

" call unite#define_source(s:source)
" call unite#define_source(s:files_source)

let &cpo = s:save_cpo
" __END__ {{{1
