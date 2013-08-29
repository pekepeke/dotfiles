let s:save_cpo = &cpo
set cpo&vim

" variables {{{1
let g:unite_docset_debug = 1
let g:unite_docset_debug = get(g:, 'unite_docset_debug', 0)

let g:unite_docset_docsetutil_command = get(g:, 'unite_docset_docsetutil_command', '/Applications/Xcode.app/Contents/Developer/usr/bin/docsetutil')
if !executable(g:unite_docset_docsetutil_command)
  let g:unite_docset_docsetutil_command = '/Developer/usr/bin/docsetutil'
endif
let g:unite_docset_search_option = get(g:, 'unite_docset_search_option', '-query "*" -skip-text')

if !exists('g:unite_docset_scan_directories')
  let g:unite_docset_scan_directories = [
        \ '~/Library/Developer/Shared/Documentation/DocSets/',
        \ '~/Library/Application\ Support/Dash/DocSets/*/',
        \ ]
endif
let g:unite_docset_files = get(g:, 'unite_docset_files', [])

" static variable {{{1
let s:unite_docset_sources = {}

" source {{{1
let s:source = {
      \ 'name' : 'docset',
      \ 'default_kind' : 'docset',
      \ }

" interfaces {{{1
function! s:source.on_init(args, context) "{{{2
  let s:buffer = {
        \ }
endfunction

function! s:source.gather_candidates(args, context) "{{{2
  let index_source = s:cache.get(self.__docset_name)
  if empty(index_source)
    let index_source = s:fetch_index(self.__docset_path)
    call s:cache.set(self.__docset_name, index_source)
  endif
  let indexes = s:parse_index(index_source)
  " call s:log(self.__docset_name . ':' . index_source)
  unlet index_source

  let candidates = []
  for key in keys(indexes)
    call add(candidates, s:create_candidate(self, key, indexes[key]))
  endfor
  unlet indexes
  if empty(candidates)
    call s:log("remove : " . self.__docset_name)
    call s:cache.delete(self.__docset_name)
  endif

  return candidates
endfunction

" some utils {{{1
function! s:create_candidate(source, key, path) "{{{2
  return {
        \ 'kind' : 'docset',
        \ 'word' : a:key,
        \ 'source' : a:source.name,
        \ 'action__name' : a:key,
        \ 'action__docset_path' : a:source.__docset_path,
        \ 'action__path' : a:path,
        \ }
endfunction

let s:cache = {} "{{{2

function! s:cache.lib() "{{{3
  if !exists('self._instance')
    let self._instance = unite#util#get_vital().import('System.Cache')
  endif

  return self._instance
endfunction

function! s:cache.dir() "{{{3
  let path = g:unite_data_directory . '/docset/'
  if !isdirectory(path)
    call mkdir(path)
  endif
  return path
endfunction

function! s:cache.set(name, list) "{{{3
  call self.lib().writefile(self.dir(), a:name, copy(a:list))
endfunction

function! s:cache.get(name) "{{{3
  return self.lib().readfile(self.dir(), a:name)
endfunction

function! s:cache.delete(name) "{{{3
  return self.lib().deletefile(self.dir(), a:name)
endfunction

function! s:scan_docset_directories() "{{{2
  let dirs = g:unite_docset_scan_directories
  for d in dirs
    call s:log("scan dir :" . d)
    let files = split(glob(d.'/*.docset'), "\n")
    if !empty(files)
      call s:docset_files(files)
    endif
  endfor
endfunction

function! s:docset_files(...) "{{{2
  let files = a:0 > 0 ? a:1 : g:unite_docset_files
  for f in files
    if isdirectory(f)
      let name = s:docsetname_by_path(f)
      call s:log("add docset :" . name . " - ". f)
      let s:unite_docset_sources[name] = f
    endif
  endfor
endfunction

function! s:fetch_index(docset_path) "{{{2
  let bin = fnamemodify(expand(g:unite_docset_docsetutil_command), ':p')
  let docset = fnamemodify(expand(a:docset_path), ':p')
  let command = printf('"%s" search "%s" %s', bin, docset, g:unite_docset_search_option)

  call s:log("system :" . command)
  let result = split(system(command), "\n")
  return result
endfunction

function! s:parse_index(result) "{{{2
  let docset_indexes = {}
  for line in a:result
    let kv = split(line, "   ")
    if 1 < len(kv)
      let key = s:normalize_keyword(kv[0])
      let docset_indexes[key]  = kv[1]
    endif
  endfor
  return docset_indexes
endfunction

function! s:docsetname_by_path(path) "{{{2
  let name = fnamemodify(a:path, ':t:r')
  let name = substitute(name, '^com\.apple\.adc\.documentation\.', '', '')
  let name = substitute(name , ' ', '_', 'g')
  return tolower(name)
endfunction

function! s:normalize_keyword(key) "{{{2
  return substitute(a:key, '^[^/]*\/[^/]*\/', '', '')
endfunction

function! s:create_sources() "{{{2
  call s:scan_docset_directories()
  call s:docset_files()
  let sources = []
  if empty(s:unite_docset_sources)
    return sources
  endif
  for key in keys(s:unite_docset_sources)
    let source = copy(s:source)
    let source.name = s:source.name . '/' . key
    let source.__docset_name = key
    let source.__docset_path = s:unite_docset_sources[key]
    call add(sources, source)
  endfor
  return sources
endfunction

function! s:log(...) "{{{2
  if !g:unite_docset_debug
    return
  endif
  if exists(':NeoBundle') && !neobundle#is_sourced('vimconsole.vim')
    NeoBundleSource vimconsole.vim
  endif
  if !exists(':VimConsoleOpen')
    return
  endif
  let args = copy(a:000)
  if empty(args)
    call vimconsole#log('docset/source')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> docset/source :" . args[0]
  call call('vimconsole#log', args)
endfunction


function! unite#sources#docset#define() "{{{1
  return executable(g:unite_docset_docsetutil_command) ? s:create_sources() : []
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
