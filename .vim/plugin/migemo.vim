" vim:set ts=8 sts=2 sw=2 tw=0:
"
" migemo.vim
"   Direct search for Japanese with Romaji --- Migemo support script.
"
" Maintainer:  MURAOKA Taro <koron@tka.att.ne.jp>
" Modified:    Yasuhiro Matsumoto <mattn_jp@hotmail.com>
" Last Change: 03-Nov-2010.

" Japanese Description:

if exists('plugin_migemo_disable')
  finish
endif

function! s:SearchDict()
  let path = $VIM . ',' . &runtimepath
  let dict = globpath(path, "dict/migemo-dict")
  if dict == ''
    let dict = globpath(path, "migemo-dict")
  endif
  if dict == ''
    let dict = '/usr/local/share/migemo/'.&encoding.'/migemo-dict'
    if !filereadable(dict)
      let dict = ''
    endif
  endif
  return matchstr(dict, "^[^\<NL>]*")
endfunction

if has('migemo')
  if &migemodict == '' || !filereadable(&migemodict)
    let &migemodict = s:SearchDict()
  endif

  " ƒeƒXƒg
  function! s:SearchChar(dir)
    let input = nr2char(getchar())
    let pat = migemo(input)
    call search('\%(\%#.\{-\}\)\@<='.pat)
    noh
  endfunction
  nnoremap <Leader>f :call <SID>SearchChar(0)<CR>
else
  " non-builtin version
  let g:migemodict = s:SearchDict()
  command! -nargs=* Migemo :call <SID>MigemoSearch(<q-args>)
  nnoremap <silent> <leader>mi :call <SID>MigemoSearch('')<cr>

  function! s:MigemoSearch(word)
    if executable('cmigemo') != ''
      let retval = a:word != '' ? a:word : input('MIGEMO:')
      if retval == ''
        return
      endif
      if has('iconv') && $HOMEDRIVE != ''
        let retval = iconv(retval, 'cp932', 'euc-jp')
      elseif &encoding != 'euc-jp'
        let retval = iconv(retval, &encoding, 'euc-jp')
      endif
      "let retval = system('cmigemo -v -w "'.retval.'" -d "'.g:migemodict.'"')
      let retval = system('cmigemo -v -w '.retval.' -d "'.g:migemodict.'"')
      if retval == ''
        return
      endif
    elseif executable('migemo') != ''
      if filereadable(g:migemodict.'.idx')
        let retval = a:word != '' ? a:word : input('MIGEMO:')
        if retval == ''
          return
        endif
        let retval = system('echo "'.retval.'" | migemo -t egrep -d "'.g:migemodict.'"')
        if retval == ''
          return
        endif
    if retval[strlen(retval)-1] == "\n"
      let retval = strpart(retval, 0, strlen(retval)-1)
    endif
      else
        echohl ErrorMsg
        echo 'Error: migemo dictionary have no index'
        echohl None
        return
      endif
    else
      echohl ErrorMsg
      echo 'Error: cmigemo or migemo is not installed'
      echohl None
      return
    endif
    if has('iconv') && $HOMEDRIVE != ''
      let retval = iconv(retval, 'euc-jp', 'cp932')
    elseif &encoding != 'euc-jp'
      let retval = iconv(retval, 'euc-jp', &encoding)
    endif
  
    let @/ = retval
    let v:errmsg = ''
    silent! normal n
    if v:errmsg != ''
      echohl ErrorMsg
      echo v:errmsg
      echohl None
    endif
  endfunction
endif
