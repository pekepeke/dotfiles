let s:save_cpo = &cpo
set cpo&vim

" public interface {{{1
function! openbrowser#vundle#open() "{{{2
  let line = getline('.')
  let sel = s:parse_line(line)
  let sel = substitute(sel, '^\%(github\|gh\|git@github\.com\):\(.\+\)', 'https://github.com/\1', '')
  let sel = substitute(sel, '^\%(bitbucket\|bb\):\(.\+\)', 'https://bitbucket.org/\1', '')
  let sel = substitute(sel, '^gist:\(.\+\)', 'https://gist.github.com/\1', '')
  let sel = substitute(sel, '^git://', 'https://', '')
  if empty(sel)
    if g:openbrowser_vundle_fallback
      normal "gx"
    else
      echohl Error
      echomsg "plugin not found :" . line
      echohl Normal
    endif
    return
  endif
  if sel =~ '^https\?://'
    call openbrowser#open(sel)
  elseif sel =~ '/'
    call openbrowser#open('https://github.com/'.sel)
  else
    call openbrowser#open('https://github.com/vim-scripts/'.sel)
  endif
endfunction

" private interface {{{1
function! s:parse_line(line) "{{{2
  if a:line !~# '\s*\(Vundle\|NeoBundle\)'
    call s:log("abort line : %s", a:line)
    return ""
  endif
  let q = '["' . "'" . ']'
  let s = matchstr(a:line, q. '[a-zA-Z0-9\._\-/]\+' . q)
  call s:log(string(q. '[a-zA-Z0-9_\-\./]*' . q))
  let package = substitute(s, '\(' . q . '\|\.git' . q . '\?$\)', '', 'g')
  call s:log(package)

  return package
endfunction

function! s:log(...) " {{{2
  if !g:openbrowser_vundle_debug
    return
  endif
  if exists(':NeoBundle') && !neobundle#is_sourced('vimconsole.vim')
    NeoBundleSource vimconsole.vim
  endif
  let args = copy(a:000)
  if empty(args)
    vimconsole#log('gf_vundle')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> gf_vundle : " . args[0]
  call call('vimconsole#log', args)
endfunction


let &cpo = s:save_cpo "{{{2
unlet s:save_cpo
" vim: foldmethod=marker
" __END__ {{{1
