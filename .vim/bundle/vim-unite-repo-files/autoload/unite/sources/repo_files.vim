" unite source for ``
" LICENSE:
" AUTHOR:

let s:commands = {
      \   'git' : {
      \     'spot' : '.git',
      \     'command' : 'git',
      \     'exec' : '%c ls-files --cached --others --exclude-standard',
      \   },
      \   'svn' : {
      \     'spot' : '.svn',
      \     'command' : 'svn',
      \     'exec' : '%c ls -R',
      \   },
      \   'hg' : {
      \     'spot' : '.hg',
      \     'command' : 'hg',
      \     'exec' : 'hg manifest',
      \   },
      \   '_' : {
      \     'spot' : '.',
      \     'command' : 'ack-grep',
      \     'fallback' : 'ack',
      \     'exec' : '%c -f --no-heading --no-color -a --nogroup --nopager',
      \     'use_system' : 1,
      \   },
      \ }

let s:source = {
\   'name': 'repo_files',
\ }

function! s:source.on_init(args, context)
  let s:buffer = {
        \ }
endfunction

function! s:create_candidate(val, root)
  return {
        \   "word": a:val,
        \   "source": "repo_files",
        \   "kind": "file",
        \   "action__path": a:val,
        \   "action__directory": a:root
        \ }
endfunction

function! s:source.gather_candidates(args, context)
  let root = unite#util#path2project_directory(expand('%'))

  let command = ""
  let is_use_system = 0

  for name in keys(s:commands)
    let item = s:commands[name]
    if s:has_spot(root, item)
      let command = s:command(item)
      let is_use_system = s:is_use_system(item)
      break
    endif
  endfor

  if empty(command)
    let item = s:commands._
    let command = s:commmand(item)
    let is_use_system = s:is_use_system(item)
  endif

  if empty(command)
    call unite#util#print_error('Not a repository.')
    return []
  endif

  let cwd = getcwd()

  lcd `=root`
  let result = is_use_system ? system(command) : unite#util#system(command)
  lcd `=cwd`

  if is_use_system || unite#util#get_last_status() == 0
    let lines = split(result, '\r\n\|\r\|\n')
    return filter(map(lines, 's:create_candidate(v:val, root)'), 'len(v:val) > 0')
  endif

  call unite#util#print_error(printf('can not exec command : %s', command))
  return []
endfunction

function! s:has_spot(root, item)
  if !exists('a:item.spot')
    return 0
  endif

  let t = a:root.'/'. a:item.spot
  return isdirectory(t) || filereadable(t)
endfunction

function! s:command(item)
  if executable(a:item.command)
    let command = a:item.command
  elseif exists('a:item.fallback') && executable(a:item.fallback)
    let command = a:item.fallback
  endif
  if exists('command')
    return substitute(a:item.exec, '%c', command, '')
  endif
  return ''
endfunction

function! s:is_use_system(item)
  return exists('a:item.use_system') && a:item.use_system
endfunction

function! unite#sources#repo_files#define()
  return [s:source]
endfunction

