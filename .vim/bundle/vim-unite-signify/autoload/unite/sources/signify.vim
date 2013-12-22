let s:save_cpo = &cpo
set cpo&vim

let g:unite_source_signify_maxline = get(g:, 'unite_source_signify_maxline', 3)

" call unite#undef_source('signify')

function! unite#sources#signify#define() "{{{
  return s:source_signify
endfunction "}}}

" signify source. "{{{
let s:source_signify = {
      \ 'name' : 'signify',
      \ 'hooks' : {},
      \ 'max_candidates': 100,
      \ 'default_kind' : 'jump_list',
      \ 'matchers' : 'matcher_regexp',
      \ }

function! s:source_signify.hooks.on_init(args, context) "{{{
  call s:on_init(a:args, a:context)
endfunction"}}}

function! s:source_signify.gather_candidates(args, context) "{{{
  let bufnr = a:context.source__bufnr
  let sy = getbufvar(bufnr, "sy")
  let candidates = []
  if exists('sy.hunks')
    for hunk in sy.hunks
      let len = hunk.end - hunk.start
      " call s:log("len=%d, buf=%d", len, bufnr)
      " call s:log("start=%d, end=%d", hunk.start, hunk.end)
      if len <= 0
        let len = 1
      elseif len > g:unite_source_signify_maxline
        let len = g:unite_source_signify_maxline
      endif
      let lines = getbufline(bufnr, hunk.start, hunk.start + len)
      call add(candidates,
            \ s:create_candidate(a:context, hunk.start, hunk.end, lines))
    endfor
  endif

  let lfmt = '%' . strlen(a:context.source__maxline) . 'd'
  let a:context.source__format =
        \ lfmt . '-' . lfmt . ': %s'

  return candidates
endfunction"}}}

function! s:source_signify.source__converter(candidates, context) "{{{
  return s:converter(a:candidates, a:context)
endfunction"}}}

let s:source_signify.converters = [s:source_signify.source__converter]
"}}}

" Misc. "{{{
function! s:on_init(args, context) "{{{
  let a:context.source__path = unite#util#substitute_path_separator(
        \ (&buftype =~ 'nofile') ? expand('%:p') : bufname('%'))
  let a:context.source__bufnr = bufnr('%')
  let a:context.source__maxline = line('$')
endfunction"}}}

function! s:create_candidate(context, start, end, lines) "{{{
  let word = empty(a:lines) ? "" : a:lines[0]
  " call s:log("line=".string(a:lines))
  return {
        \ 'word': word,
        \ 'is_multiline': 1,
        \ 'action__line' : a:start,
        \ 'action__start': a:start,
        \ 'action__end': a:end,
        \ 'action__path': a:context.source__path,
        \ 'action__text': join(a:lines, "\n"),
        \ }
endfunction "}}}

function! s:converter(candidates, context) "{{{
  for item in a:candidates
    let item.abbr = printf(a:context.source__format,
          \ item.action__start, item.action__end,
          \ item.action__text)
  endfor
  return a:candidates
endfunction "}}}

function! s:log(...)
  call call('vimconsole#log', a:000)
endfunction

let &cpo = s:save_cpo
" vim: foldmethod=marker
" __END__ {{{1
