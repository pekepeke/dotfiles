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
  call s:clear_stored_variables()
  let custom_path = get(a:context, 'custom_path', '')
  if !empty(custom_path)
    call s:save_variables()
    call ProjectionistDetect(custom_path)
  endif
  let is_available = s:is_available()
  if !is_available
    call ProjectionistDetect(expand('%'))
  endif

  if !s:is_available()
    if !empty(custom_path)
      call s:restore_variables()
    elseif !is_available
      call s:clear_stored_variables()
    endif
    call unite#print_source_error("projectionist is not available", "projectionist")
    return []
  endif
  let types = s:get_types()

  if !empty(custom_path)
    call s:restore_variables()
  elseif !is_available
    call s:clear_stored_variables()
  endif
  return map(types, 's:convert_type(v:val)')
endfunction

" projectionist/files {{{1
let s:files_source = {
  \ 'name': 'projectionist/files',
  \ 'hooks': {},
  \ 'action_table': {'*': {}},
  \ }

function! s:files_source.gather_candidates(args, context) "{{{2
  call s:clear_stored_variables()
  let custom_path = get(a:context, 'custom_path', '')
  if !empty(custom_path)
    call s:save_variables()
    call ProjectionistDetect(custom_path)
  endif
  let is_available = s:is_available()
  if !is_available
    call ProjectionistDetect(expand('%'))
  endif

  if !s:is_available()
    call unite#print_source_error("projectionist is not available", "projectionist")
    if !empty(custom_path)
      call s:restore_variables()
    elseif !is_available
      call s:clear_stored_variables()
    endif
    return []
  endif
  let types = split(get(a:context, 'custom_type', ''), ",")
  let types += a:args

  if empty(types)
    let types = split(unite#util#input("input type:", "",
      \ 'customlist,unite#sources#projectionist#type_complate'), ",")
  endif

  if empty(types)
    if !empty(custom_path)
      call s:restore_variables()
    elseif !is_available
      call s:clear_stored_variables()
    endif
    return []
  endif
  let dir = projectionist#path()
  let files = []
  for t in types
    let files += s:find_files_by_type(t)
  endfor

  if !empty(custom_path)
    call s:restore_variables()
  elseif !is_available
    call s:clear_stored_variables()
  endif
  let dir_pattern = s:escape_pattern(dir)
  return map(files, 's:convert_file(v:val, dir, dir_pattern)')
endfunction

" utilities {{{1
function! s:is_available() "{{{2
  return exists('b:projectionist') && !empty(b:projectionist)
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

function! s:convert_file(file, dir, dir_pattern) "{{{2
  return {
  \ "word": substitute(substitute(a:file, a:dir_pattern, '', ''), '^[/\\]', '', ''),
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
  let s = "(v:val[1] =~# '\\*\\*' ? v:val[1] : substitute(v:val[1], '\\*', '**/*', ''))"
  for format in map(variants, 'v:val[0] . slash . ' . s)
    if format !~# '\*'
      continue
    endif

    let glob = substitute(format, '[^\/]*\ze\*\*[\/]\*', '', 'g')
    let results += split(glob(glob), "\n")
  endfor

  return results
endfunction

function! s:escape_pattern(s) "{{{2
  return substitute(a:s, '[\.\*]', '\\\0', 'g')
endfunction

function! s:save_variables() "{{{2
  if exists('b:projectionist')
    let s:saved_projectionist = b:projectionist
  endif
  if exists('b:projectionist_file')
    let s:saved_projectionist_file = b:projectionist_file
  endif
endfunction

function! s:restore_variables() "{{{2
  if exists('s:saved_projectionist')
    let b:projectionist = s:saved_projectionist
  endif
  if exists('s:saved_projectionist_file')
    let b:projectionist_file = s:saved_projectionist_file
  endif
  call s:clear_stored_variables()
endfunction

function! s:clear_stored_variables() "{{{2
  unlet! s:saved_projectionist
  unlet! s:saved_projectionist_file
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

if expand("%:p") == expand("<sfile>:p")
  call unite#define_source(s:source)
  call unite#define_source(s:files_source)
endif

let &cpo = s:save_cpo
" __END__ {{{1
