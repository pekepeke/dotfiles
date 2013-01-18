" indent_cr.vim
" OriginalAuthor: acustodioo <http://github.com/acustodioo>
" Reformer:       pekepeke
" License: GPL

let s:save_cpo = &cpo
set cpo&vim

let s:pairs = [
      \ ['[\{\[\(]','[\)\]\}]'],
      \ ['<[^>]*>', '</[^>]*>'],
      \ ['<?\(php\)\?','?>'],
      \ ['<%', '%>'],
      \ ['\[[^\]]*\]', '\[/[^\]]*\]'],
      \ ['<\!--\(\[[^\]]*\]>\)\?', '\(<\!\[[^\]]*\]\)\?-->'],
      \ ['\(#\)\?{[^\}]*\}', '\(#\)\?{[^\}]*\}'],
      \ ['{{[^}]*}}', '{{[^}]*}}'],
      \ ]

function! indent_cr#enter()

  let getline = getline('.')
  let col = col('.') - 1

  let getline_right = substitute(
        \ strpart(getline, col, col('$')),
        \ '^[ ]*', '', ''
        \ )

  if getline_right == ""
    return "\<CR>"
  endif

  for pair in s:pairs
    if matchstr(getline_right, '^' . pair[1]) != ""
      let found = 1
      break
    endif
  endfor

  if !exists('found')
    return "\<CR>"
  endif

  let getline_left = substitute(
        \ strpart(getline, 0, col),
        \ '[ ]*$', '', ''
        \ )

  if matchstr(getline_left, pair[0] . '$') == ""
    return "\<CR>"
  endif

  let line = line('.')
  let indent = substitute(getline_left, '^\([ |\t]*\).*$', '\1', '')

  silent call setline(line, getline_left)
  silent call append(line, indent . getline_right)

  return "\<ESC>\<Down>\O"
endf


let &cpo = s:save_cpo
