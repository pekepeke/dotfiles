let s:has_plugin_cache = {} " {{{1

function! my#util#has_plugin(name) " {{{2
  if ! has_key(s:has_plugin_cache, a:name)
    let s:has_plugin_cache[a:name] = globpath(&rtp, 'plugin/'.a:name.'.vim') != ''
  endif
  return s:has_plugin_cache[a:name]
endfunction

function! my#util#mkdir(path) " {{{2
  if !isdirectory(a:path)
    call mkdir(a:path, "p")
  endif
endfunction

function! my#util#copy(fromfp, tofp) " {{{2
  let fdat = readfile(a:fromfp, "b")
  call writefile(fdat, a:tofp, "b")
endfunction

function! my#util#output_to_buffer(bufname, text_list) " {{{2
  let l:bufnum = bufnr(a:bufname)
  if l:bufnum == -1
    exe 'new '.a:bufname
    edit +setl\ bufhidden=hide\ buftype=nofile\ noswapfile\ buflisted
  else
    let l:winnum = bufwinnr(l:bufnum)
    if l:winnum != -1
      if winnr() != l:winnum
        exe l:winnum . 'wincmd w'
      endif
    else
      silent exe 'split +buffer'.a:bufname
    endif
  endif
  "silent exe 'normal GI'.a:text."\n"
  call append(line('$'),
        \ type(a:text_list) == type([]) 
        \ ? a:text_list : split(a:text_list, "\n"))
  "setl bufhidden=hide buftype=nofile noswapfile buflisted
  silent exe 'wincmd p'
endfunction

function! my#util#find_proj_dir() " {{{2
  if isdirectory(expand('%:p')) | return '' | endif
  let cdir = expand('%:p:h')
  let pjdir = ''
  if cdir == '' || !isdirectory(cdir) | return '' | endif
  if stridx(cdir, '/.vim/') > 0 | return cdir | endif
  for d in ['.git', '.bzr', '.hg']
    let d = finddir(d, cdir . ';')
    if d != ''
      let pjdir = fnamemodify(d, ':p:h:h')
      break
    endif
  endfor
  if pjdir == ''
    for f in ['tiapp.xml', 'build.xml', 'prj.el', '.project', 'pom.xml', 'Makefile', 'configure', 'Rakefile', 'NAnt.build', 'tags', 'gtags']
      let f = findfile(f, cdir . ';')
      if f != ''
        let pjdir = fnamemodify(f, ':p:h')
        break
      endif
    endfor
  endif
  if pjdir != '' && isdirectory(pjdir) | return pjdir | endif
  return cdir
  " let proj_dirs = ['.git', 'app', 'apps', 'build']
  " if isdirectory(cdir)
    " let pdir = cdir
    " for idx in range(3)
      " for proj_dir in proj_dirs
        " if isdirectory(pdir.'/'.proj_dir)
          " return pdir
        " endif
      " endfor
      " let pdir = fnamemodify(pdir, ':p:h:h')
      " if pdir == '/' || pdir =~ '.:/'
        " break
      " endif
    " endfor
    " return cdir
  " endif
endfunction

function! my#util#vars(names, val) " {{{2
  let val = type(a:val) == type('') ? string(a:val) : a:val
  if type(a:names) == type([])
    for name in a:names
      if !exists(name) | silent execute 'let' name '=' val | endif
    endfor
  else
    if !exists(a:names) | silent execute 'let' a:names '=' val | endif
  endif
endfunction

function! my#util#benchmark() " {{{2
  let bm = {}
  function! bm.show(times, res)
    echo printf("*** %d ***", a:times)
    for n in keys(a:res)
      let elapsed = a:res[n]['e']
      echo printf("%-20s : %d.%d", n, elapsed[0], elapsed[1])
    endfor
  endfunction

  function! bm.exec_eval(...) 
    let res = {}
    let argv = copy(a:000)
    let times = a:1
    call remove(argv, 0)
    for f in argv
      let res[f] = {}
      let res[f]['s'] = reltime()

      for i in range(1, times)
        call eval(f)
      endfor

      let res[f]['e'] = reltime(res[f]['s'])
    endfor
    call self.show(times, res)
  endfunction

  function! bm.exec(...)
    let res = {}
    let argv = copy(a:000)
    let times = a:1
    call remove(argv, 0)
    for f in argv
      let args = has_key(f, 'args') ? f.args : []
      let n = has_key(f, 'name') ? f.name : f.caller
      let res[n] = {}
      let res[n]['s'] = reltime()
      for i in range(1, times)
        call call(f.caller, args)
      endfor
      let res[n]['e'] = reltime(res[n]['s'])
    endfor
    call self.show(times, res)
  endfunction
  return copy(bm)
endfunction

