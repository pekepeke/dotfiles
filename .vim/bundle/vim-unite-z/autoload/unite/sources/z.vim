" unite source for `z`
" LICENSE: MIT
" AUTHOR: pekepeke <pekepekesamurai@gmail.com>

let g:unite_z_path = get(g:, 'unite_z_path', expand('~/.z'))

let s:source = {
      \   'name': 'z',
      \   'default_kind' : 'directory',
      \ }

function! s:source.on_init(args, context)
  let s:buffer = {
        \ }
endfunction


function! s:source.gather_candidates(args, context)
  let entries = readfile(g:unite_z_path)

  let entries = filter(map(entries, 's:get_path(v:val)'), 'len(v:val) > 0')
  return map(filter(entries, 'isdirectory(v:val)'), 's:create_candidate(v:val)')
endfunction


function! s:create_candidate(dir_path)
  return unite#sources#file#create_file_dict(a:dir_path, 0)
endfunction

function! s:get_path(line)
  let items = split(a:line, '|')
  return items[0]
endfunction


function! unite#sources#z#define()
  return filereadable(g:unite_z_path) ? [s:source] : []
endfunction

