function! s:log(...)
  if !g:{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}_debug
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
    call vimconsole#log('{{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}}')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> {{_expr_:substitute(expand('%:p:t:r'), '-', '_', 'g')}} " . args[0]
  call call('vimconsole#log', args)
endfunction
