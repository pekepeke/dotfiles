let s:save_cpo = &cpo
set cpo&vim

" source define [files] {{{1
let s:source = {
      \ 'name': 'neobundle/vimfiles',
      \ 'max_candidates': 200,
      \ 'hooks': {},
      \ }

let g:unite_neobundle_cache_path_prefix = $VIM_CACHE . "/unite_neobundle_vimfiles_"

function! s:source.on_init(args, context) "{{{2
endfunction

function! s:source.gather_candidates(args, context) "{{{2
  let bundles = neobundle#config#get_neobundles()
  let files = s:read_cache(bundles, "vimfiles")
  if empty(files)
    let paths = map(bundles, 'v:val.path')
    let paths = map(paths, 'join(s:expand_rtp(v:val), ",")')
    let files = split(globpath(join(paths, ","), '**/*.vim'), "\n")
    call s:write_cache(bundles, files, "vimfiles")
  endif
  return filter(map(files, 's:create_candidate(v:val)'), 'len(v:val) > 0')
endfunction

" source define [runtimefiles] {{{1
let s:rtp_source = {
      \ 'name': 'neobundle/rtpvimfiles',
      \ 'max_candidates': 200,
      \ }

function! s:rtp_source.on_init(args, context) "{{{2
endfunction

function! s:rtp_source.gather_candidates(args, context) "{{{2
  let neobundles = neobundle#config#get_neobundles()
  let lines = s:read_cache(neobundles, "rtpvimfiles")
  if empty(lines)
    let bundles = filter(neobundles, '!v:val.sourced')
    let paths = map(map(bundles, 'v:val.path'), 'join(s:expand_rtp(v:val), ",")')
    let rtp = &rtp . "," . join(paths, ",")
    let lines = split(globpath(rtp, '**/*.vim'), '\n')
    call s:write_cache(neobundles, lines, "rtpvimfiles")
  endif
  return filter(map(lines, 's:create_candidate(v:val)'), 'len(v:val) > 0')
endfunction

" functions {{{1
function! s:write_cache(bundles, files, source_name) "{{{2
  let path = g:unite_neobundle_cache_path_prefix . a:source_name . ".txt"
  call writefile([len(a:bundles)] + copy(a:files), path)
endfunction

function! s:read_cache(bundles, source_name) "{{{2
  let path = g:unite_neobundle_cache_path_prefix . a:source_name . ".txt"
  if filereadable(path)
    let files = readfile(path)
    let items = remove(files, 0, 0)
    if items[0] == len(a:bundles)
      return files
    endif
  endif
  return []
endfunction

function! s:create_candidate(val) "{{{2
  return {
        \ "word": a:val,
        \ "source": "neobundle/vimfiles",
        \ "kind": "file",
        \ "action__path": a:val,
        \ "action__directory": unite#path2directory(a:val),
        \ }
endfunction

function! s:expand_rtp(path) "{{{2
  return map([
        \ 'after', 'autoload', 'plugin', 'colors', 'compiler',
        \ 'ftdetect', 'indent', 'keymap', 'macros', 'syntax'
        \ ], 'a:path . "/" . v:val')
endfunction

" register {{{1
function! unite#sources#neobundle_vimfiles#define() "{{{2
  return [s:source, s:rtp_source]
endfunction



let &cpo = s:save_cpo
" __END__ {{{1
