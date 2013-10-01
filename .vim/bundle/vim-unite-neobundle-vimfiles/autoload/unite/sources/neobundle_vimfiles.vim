let s:save_cpo = &cpo
set cpo&vim

" source define [files] {{{1
let s:source = {
\ 'name': 'neobundle/vimfiles',
\ 'max_candidates': 200,
\ 'hooks': {},
\ }

let g:unite_neobundle_vimfiles_prefix =
\ get(g:, 'unite_neobundle_vimfiles_prefix',  'neobundle_vimfiles_')

function! s:source.on_init(args, context) "{{{2
endfunction

function! s:source.gather_candidates(args, context) "{{{2
  let neobundles = neobundle#config#get_neobundles()
  let bundles = s:gather(neobundles)
  let entries = []
  for bundle in neobundles
    let name = bundle.name
    if bundle.sourced
      let entries += bundles[name].entries
    endif
  endfor
  return filter(map(entries, 's:create_candidate(v:val)'), 'len(v:val) > 0')
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
  let bundles = s:gather(neobundles)
  let entries = []
  for bundle in neobundles
    let name = bundle.name
    if bundle.sourced
      let entries += bundles[name].entries
    endif
  endfor
  let rtp = s:gather_rtp(neobundles)
  let entries = rtp.entries + entries
  " let entries += split(globpath(&rtp, '**/*.vim'), '\n')
  return filter(map(entries, 's:create_candidate(v:val)'), 'len(v:val) > 0')
endfunction

" functions {{{1
function! s:gather(neobundles) "{{{2
  let bundles = s:read_bundles(a:neobundles)
  let cached = s:read_file("pluginfiles")

  let updated = 0

  for name in keys(bundles)
    if !exists('cached[name]')
          \ || bundles[name].time <= 0
          \ || bundles[name].time > cached[name].time
      let bundles[name].entries = s:make_entires(bundles[name].source)
      let updated = updated + 1
    else
      let bundles[name].entries = cached[name].entries
    endif
    unlet bundles[name].source
  endfor
  if updated > 0
    call s:write_file(bundles, "pluginfiles")
  endif
  return bundles
endfunction

function! s:gather_rtp(neobundles) "{{{2
  let bundle = {
        \ 'name': 'rtp',
        \ 'time': localtime(),
        \ }
  let cached = s:read_file("rtpfiles")

  if !exists('cached.time') || bundle.time > cached.time
    let hash = {}
    for plug in a:neobundles
      let hash[plug.path] = 1
      let hash[plug.path . '/after'] = 1
    endfor
    let rtp = join(filter(split(&rtp, ','), '!exists("hash[v:val]")'), ",")
    let bundle.entries = split(globpath(rtp, '**/*.vim'), '\n')
    let bundle.time += 60 * 60 *24 * 7
    call s:write_file(bundle, "rtpfiles")
  else
    return cached
  endif
  return bundle
endfunction

function! s:write_file(bundles, source_name) "{{{2
  let path = g:unite_data_directory . "/" .
        \ g:unite_neobundle_vimfiles_prefix. a:source_name . ".json"
  call writefile([string(a:bundles)], path)
endfunction

function! s:read_file(source_name) "{{{2
  let path = g:unite_data_directory . "/" .
        \ g:unite_neobundle_vimfiles_prefix. a:source_name . ".json"
  if filereadable(path)
    let data = eval(join(readfile(path), ""))
    return data
  endif
  return {}
endfunction

function! s:make_entires(bundle) "{{{2
  let paths = s:expand_rtp(a:bundle.path)
  let files = split(globpath(join(paths, ","), '**/*.vim'), "\n")
  return files
endfunction

function! s:read_bundles(neobundles) "{{{2
  let neobundles = a:neobundles
  let bundle = neobundles[0]
  let bundles = {}
  for bundle in neobundles
    let time = 0
    for fmt in ["%s/.git/HEAD", "%s/.svn/entries"]
      let HEAD = printf(fmt, bundle.path)
      if filereadable(HEAD)
        let time = getftime(HEAD)
        break
      endif
    endfor
    let bundles[bundle.name] = {
          \ 'time' : time,
          \ 'entries' : [],
          \ 'source' : bundle,
          \ }
  endfor
  return bundles
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
