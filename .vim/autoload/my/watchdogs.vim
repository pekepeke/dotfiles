let s:save_cpo = &cpo
set cpo&vim

" s:wd_helper {{{1
let s:wd_helper = {}
function! s:wd_helper.find_by_names(...) "{{{2
  let ftype = a:0 > 0 ? a:1 : &filetype
  let names = []
  let default_name = ftype . "/watchdogs_checker"
  let default_type = ""
  if exists('g:quickrun_config[default_name]')
    call add(names, default_name)
    if exists('g:quickrun_config[default_name].type')
      call add(names, g:quickrun_config[default_name].type)
      let default_type = g:quickrun_config[default_name].type
    endif
  endif
  for name in keys(g:quickrun_config)
    if name == default_name || name == default_type
      continue
    endif
    if name =~? 'watchdogs_checker' && name =~? ftype
      call add(names, name)
    endif
  endfor
  return filter(names, '!empty(v:val)')
endfunction

function! s:wd_helper.show_config(...) "{{{2
  let names = call(self.find_by_names, a:000)
  let items = []
  if !empty(names)
    if exists(':PP')
      for name in names
        echo printf("let g:quickrun_config['%s']=", name)
        exe 'PP' 'g:quickrun_config["' . name . '"]'
      endfor
    else
      for name in names
        call add(items,
          \ printf("let g:quickrun_config['%s'] = %s",
          \ name, string(g:quickrun_config[name])))
      endfor
      echo join(items, "\n")
    endif
  endif
endfunction

" public {{{1
function! my#watchdogs#show_config(...)
  return call('<SID>wd_helper.show_config', a:000)
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
