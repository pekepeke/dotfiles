" unite source for `repository files`
" LICENSE: MIT
" AUTHOR: pekepeke <pekepekesamurai@gmail.com>

let g:unite_repo_files_rule = {
      \   'git' : {
      \     'located' : '.git',
      \     'command' : 'git',
      \     'exec' : '%c ls-files --cached --others --exclude-standard',
      \   },
      \   'hg' : {
      \     'located' : '.hg',
      \     'command' : 'hg',
      \     'exec' : '%c manifest',
      \   },
      \   'bazaar' : {
      \     'located' : '.bzr',
      \     'command' : 'bzr',
      \     'exec' : '%c ls -R',
      \   },
      \   'svn' : {
      \     'located' : '.svn',
      \     'command' : 'svn',
      \     'exec' : '%c ls -R',
      \   },
      \   '_' : {
      \     'located' : '.',
      \     'command' : 'ag',
      \     'exec' : '%c -L --noheading --nocolor -a --nogroup --nopager',
      \     'use_system' : 1,
      \   },
      \   '__' : {
      \     'located' : '.',
      \     'command' : ['ack-grep', 'ack'],
      \     'exec' : '%c -f --no-heading --no-color -a --nogroup --nopager',
      \     'use_system' : 1,
      \   }
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

  for name in keys(g:unite_repo_files_rule)
    let item = g:unite_repo_files_rule[name]
    if s:has_located(root, item)
      let command = s:get_command(item)
      let is_use_system = s:is_use_system(item)
      break
    endif
  endfor

  if empty(command)
    let item = g:unite_repo_files_rule._
    if empty(item)
      let item = g:unite_repo_files_rule.__
    endif
    let command = s:get_commmand(item)
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

function! s:has_located(root, item)
  if !exists('a:item.located')
    return 0
  endif

  let t = a:root.'/'. a:item.located
  return isdirectory(t) || filereadable(t)
endfunction

function! s:get_command(item)
  let commands = type(a:item.command) == type([]) ? a:item.command : [a:item.command]
  for _cmd in commands
    if executable(_cmd)
      let command = _cmd
      break
    endif
  endfor
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

