" scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setlocal comments=s1:/*,mb:*,ex:*/,://,:#
setlocal commentstring=//\ %s

" http://hail2u.net/blog/software/only-one-line-life-changing-vimrc-setting.html
setlocal includeexpr=substitute(v:fname,'^\\/','','')
setlocal path+=;/

" setlocal formatoptions-=r formatoptions-=o
" setlocal iskeyword-=$,\-,:
setlocal iskeyword-=- iskeyword-=$ iskeyword-=:
setlocal expandtab shiftwidth=4 tabstop=4

let b:vimrc_php_auto_setoption = 0
if !exists('*VimrcPhpAutoSetoption')
  function! VimrcPhpAutoSetoption()
    if synIDattr(synID(line("."), col(".") - 1, 1), "name") =~ '^php\(Doc\|Comment.\)'
      if b:vimrc_php_auto_setoption == 0
        setlocal formatoptions+=r formatoptions+=o
        let b:vimrc_php_auto_setoption = 1
      endif
    else
      if b:vimrc_php_auto_setoption == 1
        setlocal formatoptions-=r formatoptions-=o
        let b:vimrc_php_auto_setoption = 0
      endif
    endif
  endfunction
endif
MyAutoCmd CursorMoved,CursorMovedI <buffer> call VimrcPhpAutoSetoption()

" setlocal formatoptions-=r formatoptions-=o
" setlocal noexpandtab

" nnoremap <buffer> <silent> [!comment-doc] :call PhpDocSingle()<CR>
" vnoremap <buffer> <silent> [!comment-doc] :call PhpDocRange()<CR>
nnoremap <buffer> <silent> [!comment-doc] :call pdv#DocumentCurrentLine()<CR>
vnoremap <buffer> <silent> [!comment-doc] :call pdv#DocumentCurrentLine()<CR>

let s:function = '\(abstract\s\+\|final\s\+\|private\s\+\|protected\s\+\|public\s\+\|static\s\+\)*function'
let s:class = '\(abstract\s\+\|final\s\+\)*class'
let s:interface = 'interface'
let s:section = '\(.*\%#\)\@!\_^\s*\zs\('.s:function.'\|'.s:class.'\|'.s:interface.'\)'
function! s:search(reverse)
  let op = (a:reverse ? '?' : '/')
  let saved = @/
  silent! execute op.s:section.op
  silent! execute 'nohlsearch'
  let @/ = saved
endfunction

nnoremap <buffer><silent> [[ :<C-u>call <SID>search(1)<CR>
nnoremap <buffer><silent> ]] :<C-u>call <SID>search(0)<CR>
onoremap <buffer><silent> [[ :<C-u>call <SID>search(1)<CR>
onoremap <buffer><silent> ]] :<C-u>call <SID>search(0)<CR>

if exists(':EnableFastPHPFolds')
  function! s:folding()
    exe "EnableFastPHPFolds"
    redraw!
  endfunction
  nnoremap <buffer> <silent> zz :call <SID>folding()<CR>
endif


" if neobundle#is_installed('PIV') && neobundle#is_installed('neocomplcache')
"   inoremap <buffer><expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
" endif

let &cpo = s:save_cpo
