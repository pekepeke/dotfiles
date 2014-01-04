if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_gitlogviewer')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

" gitlogviewer {{{1
function! s:git_log_viewer(commit) "{{{
  " vnew
  new
  setl buftype=nofile
  setl buflisted
  "VimProcRead git log -u 'HEAD@{1}..HEAD' --reverse
  let commit = empty(a:commit) ? 'ORIG_HEAD..HEAD' : a:commit . ' -n 1'
  execute 'VimProcRead git log -u ' commit
  " set filetype=git-log.git-diff
  set filetype=git
  setl foldmethod=expr
  " setl foldexpr=getline(v:lnum)!~'^commit'
  setlocal foldexpr=GitLogViewerFoldExpr(v:lnum)
  setlocal foldtext=GitLogViewerFoldText()
endfunction "}}}

function! GitLogViewerFoldExpr(lnum) "{{{
  let line = getline(a:lnum)
  let next_line = getline(a:lnum)
  if line =~ '^commit'
    return '>1'
  elseif next_line =~ '^commit'
    return '<1'
  elseif line =~ '^diff'
    return '>2'
  elseif next_line =~ '^diff'
    return '<2'
  endif
  return '='
endfunction "}}}

" git log表示時の折りたたみ用
function! GitLogViewerFoldText() "{{{
  let month_map = {
  \ 'Jan' : '01',
  \ 'Feb' : '02',
  \ 'Mar' : '03',
  \ 'Apr' : '04',
  \ 'May' : '05',
  \ 'Jun' : '06',
  \ 'Jul' : '07',
  \ 'Aug' : '08',
  \ 'Sep' : '09',
  \ 'Oct' : '10',
  \ 'Nov' : '11',
  \ 'Dec' : '12',
  \ }

  if getline(v:foldstart) !~ '^commit'
    return getline(v:foldstart)
  endif

  if getline(v:foldstart + 1) =~ '^Author:'
    let author_lnum = v:foldstart + 1
  elseif getline(v:foldstart + 2) =~ '^Author:'
    " commitの次の行がMerge:の場合があるので
    let author_lnum = v:foldstart + 2
  else
    " commitの下2行がどちらもAuthor:で始まらなければ諦めて終了
    return getline(v:foldstart)
  endif

  let date_lnum = author_lnum + 1
  let message_lnum = date_lnum + 2

  let author = matchstr(getline(author_lnum), '^Author: \zs.*\ze <.\{-}>')
  let date = matchlist(getline(date_lnum), ' \(\a\{3}\) \(\d\{1,2}\) \(\d\{2}:\d\{2}:\d\{2}\) \(\d\{4}\)')
  let message = getline(message_lnum)

  let month = date[1]
  let day = printf('%02s', date[2])
  let time = date[3]
  let year = date[4]

  let datestr = join([year, month_map[month], day], '-')

  return join([datestr, time, author, message], ' ')
endfunction "}}}

" Git Diff -> The file {{{1
function! s:sgodiff() "{{{
  let [maybe, fname] = s:latest_fname()
  if maybe ==# 'nothing'
    echoerr 'failed to find the filename'
    return
  endif

  let [maybe, linenum] = s:latest_linenum()
  if maybe ==# 'nothing'
    echoerr 'failed to find the linenum'
    return
  endif

  " execute "vnew" fname
  execute "new" fname
  execute linenum
  execute "normal! z\<Cr>"
endfunction "}}}

function! s:vimrc_init_sgodiff() "{{{
  nnoremap <silent><buffer> <C-d> :<C-u>call s:sgodiff()<Cr>
  nnoremap <silent><buffer> <CR> :<C-u>call s:sgodiff()<Cr>
endfunction "}}}

function! s:latest_fname() "{{{
  for i in reverse(range(1, line('.')))
    let line = getline(i)
    if line =~ '^+++ '
      return ['just', substitute(line[4:], '^b\/\|\t.*$', '', 'b')]
    endif
  endfor
  return ['nothing', '']
endfunction "}}}

function! s:latest_linenum() "{{{
  for i in reverse(range(1, line('.')))
    let line = getline(i)
    if line =~ '^@@ '
      let a = matchlist(line, '^@@ -.\{-},.\{-} +\(.\{-}\),')
      if exists('a[1]')
        return ['just', a[1]]
      endif
    endif
  endfor
  return ['nothing', '']
endfunction "}}}

command! -nargs=? GitLogViewer call s:git_log_viewer(<q-args>)

augroup plugin-gitlogviewer-sgodiff
  autocmd!
  autocmd FileType git-diff call s:vimrc_init_sgodiff()
  autocmd FileType git-log.git-diff call s:vimrc_init_sgodiff()
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_gitlogviewer = 1

" vim: foldmethod=marker
" __END__ {{{1
