let s:save_cpo = &cpo
set cpo&vim

scriptencoding utf-8

let g:unite_watchdogs_config_selected_prefix =
\ get(g:, "unite_watchdogs_config_selected_prefix", "> ")
let g:unite_watchdogs_config_default_action =
\ get(g:, 'unite_watchdogs_config_default_action', 'execute')
" 'set_local_watchdogs_config'

function! s:watchdogs_config_all()
  return filter(copy(get(g:, "quickrun_config", {})),
    \ "v:key =~# '^watchdogs_checker/' && v:key !~# '/_$'")
endfunction

function! s:watchdogs_config_type_filetype(filetype)
  return get(get(s:watchdogs_config_all(),
  \ a:filetype . "/watchdogs_checker", {}), "type", a:filetype)
endfunction

function! s:watchdogs_config_type_bufnr(bufnr)
  let filetype = getbufvar(a:bufnr, "&filetype")
  let watchdogs_config = getbufvar(a:bufnr, "quickrun_config")
  return empty(watchdogs_config)
\   ? s:watchdogs_config_type_filetype(filetype)
\   : get(watchdogs_config, "type", s:watchdogs_config_type_filetype(filetype))
endfunction


function! s:config_type(...)
  let bufnr = a:0 && type(a:1) == type(0) ? a:1 : bufnr("%")
  return a:0 && type(a:1) == type("")
\   ? s:watchdogs_config_type_filetype(a:1)
\   : s:watchdogs_config_type_bufnr(bufnr)
endfunction

let s:sorter = {'filetype': ''}
function! s:sorter.new()
  return deepcopy(self)
endfunction

function! s:sorter.sort(lhs, rhs)
  let has_lhs = (stridx(a:lhs.action__config, filetype) != -1)
    \ || (stridx(a:lhs.action__val_command, filetype) != -1)
  let has_rhs = (stridx(a:rhs.action__config, filetype) != -1)
    \ || (stridx(a:rhs.action__val_command, filetype) != -1)
  return has_lhs - has_rhs
endfunction

function! s:gather_candidates(args, context)
  let bufnr = get(get(b:, "unite", {}), "prev_bufnr", bufnr("%"))
  let filetype   = getbufvar(bufnr, "&filetype")
  " let sort = s:sorter.new()
  " let sort.filetype = filetype
  let cmds = s:watchdogs_config_all()

  let prefix = g:unite_watchdogs_config_selected_prefix
  let prefix_space = repeat(" ", strdisplaywidth(prefix))
  let now_type = s:config_type()
  " return sort(sort(values(map(cmds, '{
  return sort(values(map(cmds, '{
  \   "abbr"           : v:key == now_type ? (prefix . v:key) : (prefix_space . v:key),
  \   "word"           : v:key,
  \   "kind" : "command",
  \   "action__config" : v:key,
  \   "action__val_command" : get(v:val, "command", ""),
  \   "action__filetype" : filetype,
  \   "action__command" : ":WatchdogsRun " . v:key,
  \ }')))
  " \ }'))), 'sort.sort')
endfunction


function! unite#sources#watchdogs_config#define()
  return s:source
endfunction


let s:source = {
  \ "name" : "watchdogs_config",
  \ 'description' : 'quickrun select filetype config',
  \ "default_action" : g:unite_watchdogs_config_default_action,
  \ "action_table" : {
  \   "set_global_watchdogs_config" : {
  \     "description" : "let g:quickrun_config.watchdogs_checker/{filetype} =",
  \     "is_selectable" : 0,
  \   },
  \   "set_local_watchdogs_config" : {
  \     "description" : "let b:watchdogs_config.type =",
  \     "is_selectable" : 0,
  \   },
  \ },
  \}

function! s:source.action_table.set_global_watchdogs_config.func(candidates)
  let filetype = a:candidates.action__filetype
  let field = filetype . "/watchdogs_checker"

  if !exists("g:quickrun_config")
    let g:quickrun_config = {}
  endif
  if !exists("g:quickrun_config.".field)
    let g:quickrun_config[field] = {}
  endif

  let g:quickrun_config[field] = a:candidates.action__config
endfunction

function! s:source.action_table.set_local_watchdogs_config.func(candidates)
  let bufnr = get(get(b:, "unite", {}), "prev_bufnr", bufnr("%"))
  call setbufvar(bufnr, "watchdogs_checker_type", a:candidates.action__config)
endfunction


function! s:source.gather_candidates(args, context)
  return s:gather_candidates(a:args, a:context)
endfunction

let &cpo = s:save_cpo
