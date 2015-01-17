let s:save_cpo = &cpo
set cpo&vim

" {{{1
function! my#unite#buffer_rename(...) " {{{2
  let unite = unite#variables#current_unite()
  if !exists('unite["buffer_name"]')
    echohl Error
    echomsg "not found: buffer name"
    echohl Normal
    return
  endif
  let bufname = a:0 > 0 && !empty(a:1)
        \ ? a:1 : input("new buffer name:", unite["buffer_name"])
  if !empty(bufname)
    let unite["buffer_name"] = bufname
  endif
endfunction

function! my#unite#edit_file_by_filetype(bang, ...) " {{{2
    let cmd = "Unite " . join(
      \ map(copy(a:000), 'my#unite#edit_file_by_filetype(a:bang, v:val)'), " ")
    execute cmd
endfunction

function! my#unite#edit_file_by_filetype(band, dir) "{{{2
  let dir = substitute(a:dir . "/", '/\+$', '/', "") . &filetype
  if !empty(a:bang) || !isdirectory(dir)
    let dir = a:dir
  endif
  return printf("file:%s file/new:%s", dir, dir)
endfunction

function! my#unite#ref_callable(...) " {{{2
  let kwd = ""
  if a:0 > 0
    let isk = &l:isk
    setlocal isk& isk+=- isk+=. isk+=:
    let kwd = expand('<cword>')
    let &l:isk = isk
  endif
  let name = ref#detect()
  let names = type(name) == s:type_s ? [name] : name
  unlet name

  let completable = keys(filter(ref#available_sources(), 'exists("v:val.complete")'))
  let sources = filter(names, 'index(completable, v:val) != -1')
  unlet names

  if !empty(sources)
    let source = join(map(sources, '"ref/".v:val'), ' ')
    execute printf('Unite -default-action=below -input=%s %s', kwd, source)
  else
    echohl Error
    echomsg "Not Found : ref source"
    echohl Normal
  endif
  unlet kwd completable sources source
endfunction

function! my#unite#ref_filetype() " {{{2
  let ft = &ft
  let names = []

  let isk = &l:isk
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:isk = isk

  let types = ref#detect()
  if s:type_s == type(types)
    unlet types
    let types = ['man']
  endif
  let types = filter(types, 'type(ref#available_sources(v:val)) == s:type_h')
  if !empty(types)
    execute 'Unite' '-default-action=below' '-input='.kwd join(map(types, '"ref/".v:val'), ' ')
  else
    echohl Error
    echomsg "Not Found : ref source"
    echohl Normal
  endif
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
