  let bufname = "__X__"
  let bufnum = bufnr(bufname)
  if bufnum == -1
    execute 'new' bufname
  else
    let winnum = bufwinnr(bufnum)
    if winnum != -1 && winnr() != winnum
      execute winnum . "wincmd w"
    else
      silent execute 'split +buffer' bufname
    endif
  endif

