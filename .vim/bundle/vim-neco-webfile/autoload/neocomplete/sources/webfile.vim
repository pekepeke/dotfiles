let s:save_cpo = &cpo
set cpo&vim

let g:neco_webfile_debug = 0
let g:neco_webfile_ignore_filetypes = get(g:, 'neco_webfile_ignore_filetypes', 1)
let g:neco_webfile_filetypes = get(g:, 'neco_webfile_filetypes', [
\ 'php', 'smarty', 'twig',
\ 'haml', 'jade', 'eruby',
\ 'markdown', 'textile',
\ 'html', 'javascript',
\ 'coffee',
\ 'css', 'sass', 'scss', 'stylus', 'less',
\ ])
let s:source = {
\ 'name' : 'webfile',
\ 'kind' : 'manual',
\ 'mark' : '[F]',
\ 'rank' : 15,
\ 'sorters' : 'sorter_filename',
\ 'converters' : ['converter_remove_overlap', 'converter_abbr'],
\ 'is_volatile' : 1,
\}

function! s:source.get_complete_position(context) "{{{
  let filetype = neocomplete#get_context_filetype()
  if filetype ==# 'vimshell' || filetype ==# 'unite' || filetype ==# 'int-ssh'
    return -1
  endif

  if !g:neco_webfile_ignore_filetypes
    \ && len(filter(copy(g:neco_webfile_filetypes), 'v:val ==# filetype')) <= 0
    return -1
  endif

  " Filename pattern.
  let pattern = neocomplete#get_keyword_pattern_end('filename', self.name)
  " call s:log("pattern = ".pattern)
  let [complete_pos, complete_str] =
        \ neocomplete#match_word(a:context.input, pattern)

  let s = a:context.input[0:complete_pos]
  let q_cnt = strlen(s) - strlen(substitute(s, "['\"]", '', "g"))
  " call s:log("s = ".q_cnt)
  " call s:log("str = ".complete_str)
  if q_cnt % 2
  elseif (complete_str =~ '//' ||
        \ (neocomplete#is_auto_complete() &&
        \    (complete_str !~ '/' || len(complete_str) <
        \          g:neocomplete#auto_completion_start_length ||
        \     complete_str =~#
        \          '\\[^ ;*?[]"={}'']\|\.\.\+$\|/c\%[ygdrive/]$')))
    " Not filename pattern.
    " call s:log("Not filename pattern")
    return -1
  endif

  if neocomplete#is_sources_complete() && complete_pos < 0
    let complete_pos = len(a:context.input)
  endif

  if complete_str =~ '/'
    let complete_pos += strridx(complete_str, '/') + 1
  endif
  " call s:log("complete_pos = ".complete_pos)

  return complete_pos
endfunction"}}}

function! s:source.gather_candidates(context) "{{{
  let pattern = neocomplete#get_keyword_pattern_end(
        \ 'filename', self.name)
  let [complete_pos, complete_str] =
        \ neocomplete#match_word(a:context.input, pattern)

  if !exists("b:neco_webfile")
    let b:neco_webfile = s:detect_project()
  endif
  call s:log("gather : str = ".complete_str)
  call s:log("gather : input = ".a:context.input)
  let targets = s:guess_directories(b:neco_webfile.app, a:context.input)
  let curdir = substitute(expand('%:p:h'), '\\', '/', 'g')
  if curdir != getcwd()
    \ && len(filter(targets, 'v:val == curdir')) <= 0
    let targets += [curdir]
  endif
  " call s:log("gather : targets = ".join(targets, ", "))
  let files = s:get_glob_files(complete_str, targets)
  return files
endfunction"}}}

function! s:get_glob_files(complete_str, paths) "{{{
  let path = join(map(a:paths,
  \ 'substitute(v:val, "\\.\\%(,\\|$\\)\\|,,", "", "g")'), ",")

  let complete_str = neocomplete#util#substitute_path_separator(
        \ substitute(a:complete_str, '\\\(.\)', '\1', 'g'))
  let complete_str = substitute(complete_str, '[^/.]\+$', '', '')

  let glob = (complete_str !~ '\*$')?
        \ complete_str . '*' : complete_str

  call s:log("path:%s, str:%s, glob:%s", path, complete_str, glob)

  try
    let globs = globpath(path, glob, 1)
  catch
    return []
  endtry

  let files = split(substitute(globs, '\\', '/', 'g'), '\n')

  call filter(files, 'v:val !~ "/\\.\\.\\?$"')

  let files = map(
  \ files, "{
  \    'word' : fnamemodify(v:val, ':t'),
  \    'action__is_directory' : isdirectory(v:val),
  \    'kind' : (isdirectory(v:val) ? 'dir' : 'file'),
  \ }")

  let candidates = map(files, 's:make_candidates(v:val)')

  return candidates
endfunction " }}}"

function! s:make_candidates(dict) "{{{
  let abbr = a:dict.word
  if a:dict.action__is_directory && a:dict.word !~ '/$'
    let abbr .= '/'
    if g:neocomplete#enable_auto_delimiter
      let a:dict.word .= '/'
    endif
  endif
  let a:dict.abbr = abbr

  " Escape word.
  let a:dict.word = escape(a:dict.word, ' ;*?[]"={}''')
  return a:dict
endfunction "}}}

function! s:guess_directories(app, line) "{{{
  let dirs = s:directory_candidates(a:line)
  " call s:log(string(dirs))
  let dirs = map(dirs,
        \ 'substitute(a:app."/".v:val, "/\\+", "/", "g")')
  let dirs = filter(dirs, 'isdirectory(v:val)')
  return dirs
endfunction " }}}"

function! s:directory_candidates(line)
  if a:line =~? "<\(script\|img\|style\)"
    return [""]
  elseif a:line =~? "image"
    return ["img", "images"]
  elseif a:line =~? "javascript"
    return ["js", "scripts", "javascripts"]
  elseif a:line =~? "css"
    return ["css", "styles", "stylesheets"]
  endif
  return [""]
endfunction " }}}"

function! s:detect_project() "{{{
  let root = s:find_project_root()
  let app = root
  let guess_candidates = [
  \ "app", "public", "static", "webroot", "src"
  \ ]
  for name in guess_candidates
    if isdirectory(app . "/" . name)
      let app = app . "/" . name
    endif
  endfor
  return {
  \ 'root': root,
  \ 'app': app,
  \ }
endfunction " }}}

function! s:find_project_root() "{{{
  if isdirectory(expand('%:p'))
    return ''
  endif
  let cdir = expand('%:p:h')
  let pjdir = ''
  if cdir == '' || !isdirectory(cdir)
    return ''
  endif
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
      \ 'Makefile', 'Rakefile',
      \ 'Gruntfile.js', 'Gruntfile.coffee',
      \ 'package.json', 'composer.json',
      \ 'Jakefile', 'Cakefile',
      \ 'tiapp.xml', 'NAnt.build',
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

  if pjdir != '' && pjdir != '/' && isdirectory(pjdir)
    return pjdir
  endif
  return cdir
endfunction "}}}

function! s:log(...)"{{{
  if !g:neco_webfile_debug
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
    call vimconsole#log('webfile')
    return
  endif
  let args[0] = strftime("%Y/%m/%d %T") . "> webfile " . args[0]
  call call('vimconsole#log', args)
endfunction"}}}

function! neocomplete#sources#webfile#define() "{{{
  return s:source
endfunction"}}}

" if g:neco_webfile_debug
  " call neocomplete#define_source(s:source)
" endif
let &cpo = s:save_cpo
