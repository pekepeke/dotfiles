let s:save_cpo = &cpo
set cpo&vim

let s:has_plugin_cache = {} " {{{1

let s:is_mac = has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

function! my#util#is_win() " {{{2
  return s:is_win
endfunction

function! my#util#is_mac() " {{{2
  return s:is_mac
endfunction

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

function! my#util#detect_crlf(text)
  return stridx(a:text, "\r\n") == -1 ?
        \ (stridx(a:text, "\n") == -1 ? "\r" : "\n")
        \ : "\r\n"
endfunction

function! my#util#split(text)
  return split(a:text, my#util#detect_crlf(a:text))
endfunction

function! my#util#newfile_with_text(path, text)
  exe 'new' a:path
  " exe "normal" "i".a:text
  call append(line('$'),
        \ type(a:text) == type([]) ? a:text : my#util#split(a:text))
  silent exe 'wincmd p'
endfunction

function! my#util#find_proj_dir() " {{{2
  if isdirectory(expand('%:p')) | return '' | endif
  let cdir = expand('%:p:h')
  let pjdir = ''
  if cdir == '' || !isdirectory(cdir) | return '' | endif
  "if stridx(cdir, '/.vim/') > 0 | return cdir | endif
  for d in ['.git', '.bzr', '.hg']
    let d = finddir(d, cdir . ';')
    if d != ''
      let pjdir = fnamemodify(d, ':p:h:h')
      break
    endif
  endfor
  if pjdir == ''
    for f in ['build.xml', 'pom.xml', 'prj.el',
          \ '.project', '.settings',
          \ 'Gruntfile.js', 'Jakefile', 'Cakefile',
          \ 'tiapp.xml', 'NAnt.build',
          \ 'Makefile', 'Rakefile',
          \ 'Gemfile', 'cpanfile',
          \ 'configure', 'tags', 'gtags',
          \ ]
      let f = findfile(f, cdir . ';')
      if f != ''
        let pjdir = fnamemodify(f, ':p:h')
        break
      endif
    endfor
  endif
  if pjdir == ''
    for d in ['src', 'lib', 'vendor', 'app']
      let d = finddir(d, cdir . ';')
      if d != ''
        let pjdir = fnamemodify(d, ':p:h:h')
        break
      endif
    endfor
  endif
  if pjdir != '' && isdirectory(pjdir)
    return pjdir
  endif
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


let s:rand = {}
function! s:rand.srand(...)
  if a:0 <= 0
    let self.seed = localtime()
  else
    let self.seed = a:1
  endif
  return self
endfunction

function! s:rand.next_seed()
  let self.seed = self.seed * 214013 + 2531011
  return (self.seed < 0 ? self.seed - 0x80000000 : self.seed) / 0x10000 % 0x8000
endfunction

function! s:rand.next_int(...)
 let num = self.next_seed()
 if a:0 <= 0
   return num
 endif
 let max = a:0 > 1 ? a:000[1] : a:000[0]
 let min = a:0 > 1 ? a:000[0] : 0
 return num % ((max + 1) - min) + min
endfunction

function! s:rand.select(list)
  return a:list[self.next_int(len(a:list) - 1)]
endfunction

let s:chars = {}
function! s:rand.characters()
  return s:chars
endfunction

function! s:chars._gen(start, num)
  return map(range(a:start, a:start + a:num), 'nr2char(v:val)')
endfunction

function! s:chars.char()
  return self._gen(0x20, 94)
endfunction

function! s:chars.alnum()
  let source = self.lower() + self.digit()
  let source = source + self.upper()
  return source
endfunction

function! s:chars.lower()
  return self._gen(0x61, 25)
endfunction

function! s:chars.digit()
  return self._gen(0x30, 9)
endfunction

function! s:chars.upper()
  return self._gen(0x41, 25)
endfunction

function! s:chars.glyph()
  let source = self._gen(0x21, 14) + self._gen(0x3A, 6)
  let source = source + self._gen(0x5B, 5)
  let source = source + self._gen(0x7B, 3)
  return source
endfunction

function! s:rand.string_from(list, len)
  let source = []
  for i in range(1, a:len)
    call add(source, self.select(a:list))
  endfor
  return join(source, "")
endfunction

function! s:rand.get_alnum(len)
  return self.string_from(s:chars.alnum(), a:len)
endfunction

function! s:rand.get_char(len)
  return self.string_from(s:chars.char(), a:len)
endfunction

function! s:rand.get_lower(len)
  return self.string_from(s:chars.lower(), a:len)
endfunction

function! s:rand.get_upper(len)
  return self.string_from(s:chars.upper(), a:len)
endfunction

function! s:rand.get_digit(len)
  return self.string_from(s:chars.digit(), a:len)
endfunction

function! s:rand.get_glyph(len)
  return self.string_from(s:chars.glyph(), a:len)
endfunction

function! s:rand.get_string(len)
  let source = s:chars.alnum() + s:chars.glyph()
  return self.string_from(source, a:len)
endfunction

function! my#util#random()
  let instance = copy(s:rand)
  return instance.srand()
endfunction

let &cpo = s:save_cpo
