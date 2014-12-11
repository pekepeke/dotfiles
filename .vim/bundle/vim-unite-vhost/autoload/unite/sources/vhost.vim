let s:save_cpo = &cpo
set cpo&vim

" utils {{{1
function! s:extract(val) "{{{2
  let items = split(a:val, ' \+')
  let name = get(items, 0, "")
  if len(items) > 0
    call remove(items, 0)
  endif
  let path = join(items, " ")
  return {"name":name, "path":path}
endfunction

function! s:candidate_file(val) "{{{2
    " \ "word": a:val.name,
  return {
    \ "word": a:val.path,
    \ "source": "vhost/fqdn",
    \ "kind": "file",
    \ "action__path": a:val.path,
    \ "action__directory": unite#path2directory(a:val.path),
    \ }
endfunction

function! s:candidate_directory(val) "{{{2
  return {
    \ "word": a:val.path,
    \ "source": "vhost/docroot",
    \ "kind": "directory",
    \ "action__path": a:val.path,
    \ "action__directory": a:val.path,
    \ }
endfunction

" vhost/docroot {{{1
let s:source = {
  \ 'name': 'vhost/docroot',
  \ 'max_candidates': 200,
  \ 'hooks': {},
  \ }

function! s:source.gather_candidates(args, context) "{{{2
  let candidates = filter(map(
    \ split(system('vhost list --docroot'), "\n"), 's:extract(v:val)'),
    \ '!empty(v:val.path)')
  return map(candidates, 's:candidate_directory(v:val)')
endfunction

" vhost/fqdn {{{1
let s:fqdn_source = {
  \ 'name': 'vhost/fqdn',
  \ 'max_candidates': 200,
  \ 'hooks': {},
  \ }

function! s:fqdn_source.gather_candidates(args, context) "{{{2
  let candidates = filter(map(
    \ split(system('vhost list --fqdn'), "\n"), 's:extract(v:val)'),
    \ '!empty(v:val.path)')
  return map(candidates, 's:candidate_file(v:val)')
endfunction

function! unite#sources#vhost#define() "{{{1
  return [s:source, s:fqdn_source]
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
