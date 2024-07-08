"                                 ___           ___           ___
"      ___            ___        /  /\         /  /\         /  /\
"     /  /\          /__/\      /  /::|       /  /::\       /  /::\
"    /  /:/          \__\:\    /  /:|:|      /  /:/\:\     /  /:/\:\
"   /  /:/           /  /::\  /  /:/|:|__   /  /::\ \:\   /  /:/  \:\
"  /__/:/  ___    __/  /:/\/ /__/:/_|::::\ /__/:/\:\_\:\ /__/:/ \  \:\
"  |  |:| /  /\  /__/\/:/~~  \__\/  /~~/:/ \__\/~|::\/:/ \  \:\  \__\/
"  |  |:|/  /:/  \  \::/           /  /:/     |  |:|::/   \  \:\
"  |__|:|__/:/    \  \:\          /  /:/      |  |:|\/     \  \:\
"   \__\::::/      \__\/         /__/:/       |__|:|~       \  \:\
"       ~~~~                     \__\/         \__\|         \__\/
" init setup {{{1
let $VIM_CACHE = $HOME . '/.cache/vim'
let $VIM_REFDOC = $HOME . '/.local/share/vim/docs'

" defun macros {{{2
augroup vimrc-myautocmd
  autocmd!
augroup END
command! -bang -nargs=* MyAutoCmd autocmd<bang> vimrc-myautocmd <args>
command! -nargs=* Lazy autocmd vimrc-myautocmd VimEnter * <args>

if has('patch-7.3.970')
  " Lazy set regexpengine=0
  command! -nargs=0 ReEngineNFA set regexpengine=0
  command! -nargs=0 ReEngineOLD set regexpengine=1
endif

" platform detection {{{2
let s:is_win = has('win16') || has('win32') || has('win64')
let s:is_mac = has('mac') || has('macunix') || has('gui_mac') || has('gui_macvim')
" || (executable('uname') && system('uname') =~? '^darwin')
let s:type_s = type('')
let s:type_a = type([])
let s:type_h = type({})
let s:exec_make = executable('make') || executable('nmake')
let s:exec_xbuild = executable('MSBuild.exe') || executable('xbuild')
let s:exec_npm = executable('npm')
let s:exec_go = executable('go')
let s:exec_ruby = executable('ruby')
let s:exec_java = executable('java')
let s:exec_php = executable('php')

function! VimrcScope()
  return s:
endfunction

function! s:nop(...) "{{{3
endfunction

function! s:SID() "{{{3
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! s:path_push(...) "{{{3
  let sep = s:is_win && !has('cygwin') ? ';' : ':'
  let pathes = s:is_win ? map(copy(a:000), 'substitute(v:val, "/", "\\", "g")') : a:000
  let $PATH .= sep . join(pathes, sep)
endfunction

function! s:mkdir(path) "{{{3
  if !isdirectory(a:path)
    call mkdir(a:path, "p")
  endif
endfunction

let g:vimrc_enabled_features = {} "{{{3
function! s:set_features_flag(feature)
  let g:vimrc_enabled_features[a:feature] = 1
endfunction
function! s:feature(feature)
  return get(g:vimrc_enabled_features, a:feature, 0)
endfunction

call map(split($VIMRC_ENABLES), 's:set_features_flag(v:val)')

command! -bar -nargs=+ Alias call <SID>nop()
command! -bar -nargs=+ LCAlias call <SID>nop()

" reset settings & restore runtimepath {{{2
" let s:configured_runtimepath = &runtimepath
set guioptions+=T guioptions-=m guioptions-=M

set runtimepath^=$HOME/.vim
set runtimepath+=$HOME/.vim/after

" reset os env {{{2
if s:is_win
  if !exists('$VCVARSALL')
    let s:save_ssl = &shellslash
    set noshellslash
    if exists('$VS120COMNTOOLS')
      let $VCVARSALL = shellescape($VS120COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS110COMNTOOLS')
      let $VCVARSALL = shellescape($VS110COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS100COMNTOOLS')
      let $VCVARSALL = shellescape($VS100COMNTOOLS . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS90COMNTOOLS')
      let $VCVARSALL = shellescape($VS90COMNTOOLS  . '..\..\VC\vcvarsall.bat')
    elseif exists('$VS80COMNTOOLS')
      let $VCVARSALL = shellescape($VS80COMNTOOLS  . '..\..\VC\vcvarsall.bat')
    endif
    let &shellslash = s:save_ssl
    unlet s:save_ssl
  endif
  let $HOME=substitute($HOME, '\\', '/', 'ge')
  function! s:cmd_init()
    set shell=$COMSPEC
    set shellcmdflag=/c
    set shellpipe=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 CmdEnable call s:cmd_init()

  function! s:ps_init()
    set shell=powershell\ -NoLogo\ -NoProfile\ -NonInteractive
    " TODO shellslash
    set shellcmdflag=-command
    set shellpipe=>%s\ 2>&1
    set shellxquote=\"
  endfunction

  function! s:nyacus_init()
    " Use NYAOS.
    set shell=nyacus.exe
    set shellcmdflag=-e
    if executable('tee') | set shellpipe=\|&\ tee | endif
    set shellredir=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 NyacusEnable call s:nyacus_init()

  function! s:sh_init()
    set shell=bash.exe
    set shellcmdflag=--login\ -c
    if executable('tee') | set shellpipe=\|&\ tee | endif
    set shellredir=>%s\ 2>&1
    set shellxquote=\"
  endfunction
  command! -nargs=0 ShEnable call s:sh_init()

  " if !empty($MSYSTEM)
  " if executable('nyacus')
  " if exists('$HISTFILE')
  if exists('$CYGWIN') || exists('$MSYSTEM')
    call s:sh_init()
  " elseif exists('$PSMODULEPATH')
  "   call s:ps_init()
  else
    call s:cmd_init()
  endif
else
  if empty($SHELL)
    set shell=sh shellredir=>%s\ 1>&1
  elseif stridx($SHELL, " ") != -1
    execute 'set shell='.strpart($SHELL, 0, stridx($SHELL, " "))
  endif
  let $PAGER='less'
  if s:is_mac
    function! s:python_path(ver)
      let ver = a:ver == 2 ? "" : a:ver
      let paths = split(glob("/usr/local/Cellar/python".ver."/*/Frameworks/Python.framework/Versions/*/Python"), "\n")
      if len(paths) > 0
        return paths[-1]
      endif
    endfunction
    " ycm
    " let $PYTHON_DLL = s:python_path(2)
    let $PYTHON3_DLL = s:python_path(3)
  endif
endif

" basic settings {{{1
" encodings {{{2
" if s:is_win && (!has('win32unix'))
"   set encoding=cp932
"   set termencoding=cp932
" else
set encoding=utf-8
set termencoding=utf-8
" endif
scriptencoding utf-8
set fileencoding=utf-8
set fileformat=unix
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp
set fileencodings+=cp932
set fileformats=unix,dos,mac
set synmaxcol=1000

set display=lastline
function! s:fake_unnamed_clipboard(event) "{{{3
  if a:event ==# 'FocusGained'
    if strlen(@+) > 1 && @" !=# @+
      let @" = @+
    endif
  elseif a:event ==# 'FocusLost'
    if strlen(@") > 1
      let @+ = @"
    endif
  endif
endfunction " }}}
command! -nargs=0 ClipReceive call s:fake_unnamed_clipboard('FocusGained')
command! -nargs=0 ClipSend call s:fake_unnamed_clipboard('FocusLost')
command! -nargs=0 CS ClipSend
command! -nargs=0 CR ClipReceive
MyAutoCmd FocusGained * silent call s:fake_unnamed_clipboard('FocusGained')
MyAutoCmd FocusLost * silent call s:fake_unnamed_clipboard('FocusLost')

function! s:clip_on(bang)
  if a:bang
    set clipboard=
  else
    set clipboard=unnamed
    if has('unnamedplus')
      set clipboard+=unnamedplus
    endif
  endif
endfunction
command! -nargs=0 -bang ClipOn call s:clip_on(<bang>0)

set nospell
if has('patch-7.4.088')
  set spelllang=en_us,cjk
else
  set spelllang=en_us
endif
set spellfile=~/.vim/spell/spellfile.utf-8.add
set noautochdir
set shellslash
set directory=$VIM_CACHE,/var/tmp,/tmp
set viminfo& viminfo+=!
set viminfo+=n$VIM_CACHE/viminfo.txt
call s:mkdir($VIM_CACHE)

" Use vsplit mode http://qiita.com/kefir_/items/c725731d33de4d8fb096
if has("vim_starting") && !has('gui_running') && has('vertsplit')
  function! s:enable_vsplit_mode()
    " enable origin mode and left/right margins
    let &t_CS = "y"
    let &t_ti = &t_ti . "\e[?6;69h"
    let &t_te = "\e[?6;69l\e[999H" . &t_te
    let &t_CV = "\e[%i%p1%d;%p2%ds"
    call writefile([ "\e[?6;69h" ], "/dev/tty", "a")
  endfunction

  " old vim does not ignore CPR
  map <special> <Esc>[3;9R <Nop>

  " new vim can't handle CPR with direct mapping
  " map <expr> ^[[3;3R g:EnableVsplitMode()
  set t_F9=[3;3R

  map <expr> <t_F9> <SID>enable_vsplit_mode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

MyAutoCmd BufEnter,BufRead * call <SID>autochdir()
if !exists('g:my_lcd_autochdir')
  let g:my_lcd_autochdir = 1
endif
if !exists('s:my_autochdir_projects')
  let s:my_autochdir_projects = {}
endif

function! s:find_proj_dir() "{{{3
  if isdirectory(expand('%:p')) | return '' | endif
  let cdir = expand('%:p:h')
  let pjdir = ''
  if cdir == '' || !isdirectory(cdir) | return '' | endif
  if exists('s:my_autochdir_projects[cdir]')
    return s:my_autochdir_projects[cdir]
  endif
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
      \ '.project',
      \ 'Gruntfile.js', 'Gruntfile.coffee',
      \ 'Jakefile', 'Cakefile',
      \ 'tiapp.xml', 'NAnt.build',
      \ 'Makefile', 'Rakefile',
      \ 'Gemfile', 'cpanfile',
      \ 'package.json', 'composer.json',
      \ 'bower.json',
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
    for d in ['src', 'lib', 'node_modules', 'vendor', 'app']
      let d = finddir(d, cdir . ';')
      if d != ''
        let pjdir = fnamemodify(d, ':p:h:h')
        break
      endif
    endfor
  endif

  if pjdir != '' && pjdir != '/' && isdirectory(pjdir)
    let s:my_autochdir_projects[cdir] = pjdir
    return pjdir
  endif
  return cdir
endfunction

function! s:autochdir() "{{{3
  if expand('%') == '' && &buftype =~ 'nofile'
    return
  elseif g:my_lcd_autochdir
    let pjdir = s:find_proj_dir()
    if pjdir != '' && isdirectory(pjdir)
      execute 'lcd' fnameescape(pjdir)
    endif
  endif
endfunction

" diff {{{2
set diffopt& diffopt-=filler diffopt+=iwhite diffopt+=vertical
" if !s:feature('git_under1.8')
"   set diffexpr=GitDiffNormal()
"   function! GitDiffNormal()
"     let args=["git-diff-normal", '--diff-algorithm=histogram']
"     if &diffopt =~ "iwhite"
"       call add(args, '--ignore-all-space')
"     endif
"     let args += [v:fname_in, v:fname_new, '>', v:fname_out]
"     let cmd='!' . join(args, ' ')
"     silent execute cmd
"     redraw!
"   endfunction
" endif
if &diff
  set foldlevel=100
endif

" 表示周り {{{2
set lazyredraw ttyfast
set scrolloff=10000000         " 中央に表示
set sidescrolloff=999
set number                     " 行番号の表示
set ruler

set nowrap     " 折り返しなし
set nrformats-=octal
set modeline
set modelines=10

set mouse=nch                  " use mouse normal/command/help
" set mouse=a
" set mouse=nv
set nomousefocus
set mousehide
set timeoutlen=1000
set ttimeoutlen=100
set updatetime=200

set pumheight=10
set showmatch
set matchtime=1
set showcmd
set showfulltag
set backspace=indent,eol,start
set nolinebreak
set textwidth=1000
set formatoptions& formatoptions+=mM
set whichwrap=b,s,h,l,<,>,[,]
if exists('&colorcolumn') | set colorcolumn=+1 | endif
set splitbelow                 " 横分割は下に
set splitright                 " 縦分割は右に
set switchbuf=useopen          " 再利用
set title
set sessionoptions-=options

set hidden                     " 編集中でも他のファイルを開けるように
set sidescroll=5
if s:is_mac
  set visualbell
else
  set novisualbell
endif
set noerrorbells t_vb=
" http://superuser.com/questions/195794/gnu-screen-shift-tab-issue
set t_kB=[Z

set noequalalways
set langmenu=none
set helplang=ja,en
set keywordprg=":help"
set foldmethod=marker
" http://d.hatena.ne.jp/thinca/20110523/1306080318
augroup vimrc-foldmethod-expr
  autocmd!
  autocmd InsertEnter * if &l:foldmethod ==# 'expr'
  \ |   let b:foldinfo = [&l:foldmethod, &l:foldexpr]
  \ |   setlocal foldmethod=manual foldexpr=0
  \ | endif
  autocmd InsertLeave * if exists('b:foldinfo')
  \ |   let [&l:foldmethod, &l:foldexpr] = b:foldinfo
  \ |   unlet b:foldinfo
  \ | endif
augroup END

" タブ文字の設定 {{{2
set autoindent nosmartindent nocindent " インデント設定
if has('linebreak') && has('patch-7.4.338')
  set breakindent
endif
set list
if s:is_mac
  " set showbreak=↓
  let &showbreak='+ '
else
  " set showbreak=↓
  let &showbreak='+++ '
endif
set listchars=tab:^\ ,trail:~,nbsp:%,extends:>,precedes:<
set smarttab             " インテリジェンスなタブ入力
set noexpandtab
"set softtabstop=4 tabstop=4 shiftwidth=4
set softtabstop=0 tabstop=4 shiftwidth=4

if exists('&ambiwidth')
  set ambiwidth=double
endif " }}}

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

"set wm=2
if has('winaltkeys')
  set winaltkeys=no
endif
set pastetoggle=<F10>
MyAutoCmd InsertLeave * if &paste | set nopaste | endif

" 検索周り {{{2
set ignorecase smartcase wrapscan
set infercase
set incsearch hlsearch
set virtualedit+=block         " 矩形の virtualedit 許可

" バックアップ {{{2
set nobackup               " バックアップとか自分で
"set backup
set noswapfile
set nowritebackup
set autoread                   " 更新があったファイルを自動で読み直し
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*.tmp,crontab.*
set backupdir=$VIM_CACHE/vim-backups
set viewdir=$VIM_CACHE/vim-views
call s:mkdir(&backupdir)
call s:mkdir(&viewdir)
if has('persistent_undo')
  set undodir=$VIM_CACHE/vim-undo
  call s:mkdir(&undodir)
  set undofile
endif


" 補完 {{{2
set wildmenu                                 " 補完候補を表示する
set wildmode=list:longest,list:full          " zsh like complete
set wildchar=<tab>
set wildignore+=*.o,*.obj,*.rbc,*.dll,*.exe
set wildignore+=*.out,*.aux
set wildignore+=.git,.svn
set wildignore+=.DS_Store
set wildignore+=*.spl
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.so,*.sw?
set wildignore+=*.luac,*.jar,*.pyc,.class
set completeopt=menuone
set complete=.,w,b,u,t,i,k

" for migemo {{{2
if has('kaoriya') && has('migemo')
  set migemo
  if filereadable('/usr/local/share/migemo/utf-8/migemo-dict')
    set migemodict=/usr/local/share/migemo/utf-8/migemo-dict
  endif
endif

" color settings "{{{1
if !has('gui_running')
  let s:t_Co=&t_Co
  set t_Co=256
  MyAutoCmd VimLeave * let &l:t_Co=s:t_Co
elseif !exists('$WONT_256COLOR')
  set t_Co=256
endif
set background=dark

function! s:highlights_add() "{{{2
  " highlight DiffAdd cterm=bold ctermfg=22 ctermbg=121 guibg=121
  " highlight DiffDelete cterm=bold ctermfg=52 ctermbg=242
  " highlight DiffText cterm=bold ctermfg=227 ctermbg=30
  " highlight DiffChange cterm=bold ctermfg=124 ctermbg=30

  highlight MatchParen ctermbg=cyan ctermfg=darkred guibg=cyan guifg=darkred
  highlight NonText term=underline ctermfg=darkgray guifg=darkgray
  highlight SpecialKey term=underline ctermfg=darkgray guifg=darkgray
  " highlight link IdeographicSpace Error
  highlight IdeographicSpace term=underline ctermbg=darkgreen guibg=darkgreen
  " highlight link TrailingSpaces Error
  highlight TrailingSpaces ctermbg=darkgray guibg=#222222
  " highlight clear CursorLine
  " highlight CursorLine gui=underline term=underline cterm=underline
  " highlight CursorLine ctermbg=black guibg=black
  highlight link VimShellError WarningMsg
  highlight qf_error_ucurl term=underline cterm=underline ctermfg=darkred ctermbg=none gui=undercurl guisp=red
  " http://qiita.com/kenjiskywalker/items/6ccaf6fb8f1f139230e6
  if has('gui_running') && (has('multi_byte_ime') || has('xim'))
    " highlight Cursor guifg=NONE guibg=White
    highlight CursorIM guifg=NONE guibg=DarkRed
  endif
endfunction

function! s:syntaxes_add() "{{{2
  syntax match IdeographicSpace /　/ display containedin=ALL
  syntax match TrailingSpaces /\s\+$/ display containedin=ALL
endfunction

function! s:gui_colorscheme_init()
  " colorscheme vividchalk
  call s:syntaxes_add()
  call s:highlights_add()
  if !s:is_win && !s:is_mac && executable('xdotool')
    " call system('xdotool search --onlyvisible --class gvim windowactivate; xdotool getactivewindow windowmove x 0; xdotool search --onlyvisible --class gnome-terminal windowactivate')
    call system('xdotool getactivewindow windowmove x 0;')
  endif
endfunction

augroup vimrc-color-init "{{{2
  autocmd!

  autocmd ColorScheme * call s:highlights_add()
  autocmd Syntax * call s:syntaxes_add()
  autocmd Syntax eruby highlight link erubyRubyDelim Label

  " カーソル行 http://d.hatena.ne.jp/thinca/20090530/1243615055
  autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
  autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
  autocmd WinEnter * call s:auto_cursorline('WinEnter')
  autocmd WinLeave * call s:auto_cursorline('WinLeave')

  let s:cursorline_lock = 0
  function! s:auto_cursorline(event) "{{{3
    if a:event ==# 'WinEnter'
      setlocal cursorline
      let s:cursorline_lock = 2
    elseif a:event ==# 'WinLeave'
      setlocal nocursorline
    elseif a:event ==# 'CursorMoved'
      if s:cursorline_lock
        if 1 < s:cursorline_lock
          let s:cursorline_lock = 1
        else
          setlocal nocursorline
          let s:cursorline_lock = 0
        endif
      endif
    elseif a:event ==# 'CursorHold'
      setlocal cursorline
      let s:cursorline_lock = 1
    endif
  endfunction "}}}3

augroup END


" vundle {{{1
" setup {{{2

" dpp
" let denops#debug = 1
" let denops#trace = 1
let g:denops_server_addr = '127.0.0.1:32123'
let s:dpp_base = expand('~/.cache/dpp')

" Set dpp source path (required)
let s:denops_src = s:dpp_base.'/repos/github.com/vim-denops/denops.vim'
" let s:dpp_src = '~/.cache/dpp/repos/github.com/Shougo/dpp.vim'
let s:dpp_src_base = s:dpp_base.'/repos/github.com/Shougo'
let s:dpp_repos = [
  \ 'dpp.vim',
  \ 'dpp-ext-toml',
  \ 'dpp-ext-lazy',
  \ 'dpp-ext-installer',
  \ 'dpp-ext-local',
  \ 'dpp-protocol-git',
  \ ]

" Set dpp runtime path (required)
" execute 'set runtimepath^=' .. s:dpp_src
for repo in s:dpp_repos
  execute 'set runtimepath^=' .. s:dpp_src_base.'/'.repo
endfor
execute 'set runtimepath^=' .. s:denops_src

if dpp#min#load_state(s:dpp_base)
  " NOTE: dpp#make_state() requires denops.vim
  autocmd User DenopsReady
  \ call dpp#make_state(s:dpp_base, $HOME.'/.vim/dpp.ts')
endif
command! -narg=0 DenopsCacheReload call denops#cache#update(#{reload: v:true})
command! -narg=0 DppEditStartup execute 'edit' g:dpp#_base_path.'/'.(has('gui_running') ? 'gvim' : has('nvim') ? 'nvim' : 'vim').'/startup.vim'
command! -narg=0 DppMakeState call dpp#make_state(s:dpp_base, $HOME.'/.vim/dpp.ts')
command! -narg=0 DppClearState call dpp#clear_state((has('gui_running')?'gvim':has('nvim')?'nvim':'vim'))
command! -narg=0 DppInstall call dpp#async_ext_action('installer', 'install')
command! -narg=0 DppUpdate call dpp#async_ext_action('installer', 'update')
command! -narg=0 DppRecache call dpp#async_ext_action('installer', 'recache')
if !isdirectory(s:denops_src)
  function! s:vimrc_install_dpp()
    let cwd = getcwd()
    call mkdir(s:dpp_src_base, 'p')
    execute 'lcd' s:dpp_src_base
    for repo in s:dpp_repos
      call system(printf('git clone https://github.com/Shougo/%s', repo))
    endfor
    call mkdir(s:denops_src, 'p')
    execute 'lcd' s:denops_src.'/..'
    call system('git clone https://github.com/vim-denops/denops.vim')

    execute 'lcd' cwd
    echo 'finish'
  endfunction
  command! -narg=0 DppCoreInit call s:vimrc_install_dpp()
else
  function! s:vimrc_update_dpp()
    let cwd = getcwd()
    for repo in s:dpp_repos
      execute 'lcd' s:dpp_src_base.'/'.repo
      echo system('git pull')
    endfor
    call mkdir(s:denops_src, 'p')
    execute 'lcd' s:denops_src
    echo system('git pull')
    execute 'lcd' cwd
    echo 'finish'
  endfunction
  command! -narg=0 DppCoreUpdate call s:vimrc_update_dpp()
endif

let s:bundle = {'vimrc_installed':[]}
function! s:bundle.tap(bundle) " {{{
  let self.tapped = dpp#get(a:bundle)
  return self.is_installed(a:bundle)
endfunction " }}}

function! s:bundle.get(bundle) "{{{
  return dpp#get(a:bundle)
endfunction "}}}

function! s:bundle.config(config, ...) " {{{
  if a:0 >= 2
    call neobundle#config(a:config, a:1)
    return
  endif
  if exists("self.tapped") && self.tapped != {}
    call neobundle#config(self.tapped.name, a:config)
  endif
endfunction " }}}

function! s:bundle.untap() " {{{
  if exists('self.tapped')
    unlet s:bundle.tapped
  endif
endfunction " }}}

function! s:bundle.is_sourced(name) "{{{
  " TODO
  let plug = self.get(a:name)
  return !empty(plug)
endfunction "}}}

function! s:bundle.is_installed(name) "{{{
  " TODO
  let plug = self.get(a:name)
  return !empty(plug)
endfunction "}}}

if has('vim_starting')
  " configure for runtimepath {{{1
  " MyAutoCmd BufWritePost *vimrc,*gvimrc NeoBundleClearCache

  filetype plugin indent on
  if has('syntax')
    syntax enable
  endif

  " etc settings {{{2
  if filereadable(expand('~/.vimrc.personal'))
    execute 'source' expand('~/.vimrc.personal')
  endif
  if isdirectory(expand('~/.vim/bin/'))
    call s:path_push(expand('~/.vim/bin/'))
  endif
  if s:is_win
    let dotnets = sort(split(globpath($WINDIR . '/Microsoft.NET/Framework/', 'v*'), "\n"))
    if !empty(dotnets)
      call s:path_push(dotnets[-1])
    endif
    unlet dotnets
  elseif s:is_mac && $PATH !~# "/usr/local/"
    call s:path_push("/usr/local/bin", $HOME."/bin", $HOME."/bin/macosx")
  endif
  function! s:log(...)
    if s:bundle.is_installed('vimconsole.vim')
      call call('vimconsole#log', a:000)
    endif
  endfunction
endif
" }}}

" colorscheme {{{1
if has('gui_running')
  autocmd vimrc-color-init GUIEnter *
        \ colorscheme vividchalk | call <SID>gui_colorscheme_init()
elseif &t_Co == 256 || s:is_win
  colorscheme hybrid
else
  " colorscheme wombat
  colorscheme desert
endif

" statusline {{{1
set laststatus=2  " ステータス表示用変数
let s:status_generator = { 'cfi':s:bundle.is_installed('current-func-info.vim') }
function! s:status_generator.get_line() "{{{3
  let s = ''

  let s .= '%<'
  let s .= '%f ' " filename
  let s .= '%m' " modified flag
  let s .= '%r' " readonly flag
  let s .= '%h' " help flag
  let s .= '%w' " preview flag
  if self.cfi
    let s .= '> %{cfi#format("%s()","")}'
  endif
  let s .= '%='
  let s .= '[%{&l:fenc}]'
  let s .= '[%{&l:ff}] %{&l:ft} '
  let s .= '< L%l:%c%V ' " current line status
  let s .= '%8P'

  return s
endfunction "}}}3
function! VimrcStatusLine()
  return s:status_generator.get_line()
endfunction
set statusline=%!VimrcStatusLine()

" for filetypes {{{1
" shebang {{{2
if !s:is_win
  MyAutoCmd BufWritePost *
        \ if getline(1) =~ "^#!"
        \ | exe "silent !chmod +x %"
        \ | endif
endif
" auto mkdir {{{2
MyAutoCmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
function! s:auto_mkdir(dir, force)
  if !isdirectory(a:dir) && (a:force ||
      \ input(printf('"%s" does not exist. Create? [y/N]', a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

" etc hacks {{{2
" http://d.hatena.ne.jp/uasi/20110523/1306079612
if s:is_mac
  MyAutoCmd BufWritePost *.txt call <SID>set_utf8_attr(escape(expand("<afile>"), "*[]?{}' "))
  function! s:set_utf8_attr(file)
    let is_utf8 = &fileencoding == "utf-8" || (&fileencoding == "" && &encoding == "utf-8")
    if s:is_mac && is_utf8
      call system("xattr -w com.apple.TextEncoding 'utf-8;134217984' \"".a:file."\"")
    endif
  endfunction
endif

MyAutoCmd BufReadPost *
\   if &modifiable && !search('[^\x00-\x7F]', 'cnw')
\ |   setlocal fileencoding=
\ | endif

" http://vim-users.jp/2009/10/hack84/
MyAutoCmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
MyAutoCmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor

" setfiletype {{{2
" alias
MyAutoCmd FileType js set filetype=javascript
MyAutoCmd FileType rb set filetype=ruby
MyAutoCmd FileType pl set filetype=perl
MyAutoCmd FileType py set filetype=python
MyAutoCmd FileType md set filetype=markdown
MyAutoCmd FileType docker set filetype=dockerfile
" MyAutoCmd BufNewFile,BufRead *.sql set filetype=mysql
MyAutoCmd BufNewFile,BufRead *.io set filetype=io
MyAutoCmd BufNewFile,BufRead *.command set filetype=sh

MyAutoCmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
  \ | exe "normal! g`\""
  \ | endif

function! s:vimrc_cmdwin_init() "{{{3
  noremap <buffer><nowait> q :q<CR>
  noremap <buffer> <Esc> :q<CR>
  inoremap <buffer><expr> kk col('.') == 1 ? '<Esc>k' : 'kk'
  inoremap <buffer><expr> <BS> col('.') == 1 ? '<Esc>:quit<CR>' : '<BS>'

  if g:vimrc_enabled_plugins.ambicmd
    imap <expr><buffer> <Space> <SID>ambicmd_expand("\<Space>", 'i', getcmdline())
    imap <expr><buffer> <CR> <SID>ambicmd_expand("\<CR>", 'i', getcmdline())
  endif
  startinsert!
endfunction " }}}
MyAutoCmd CmdwinEnter * call s:vimrc_cmdwin_init()

" vim -b : edit binary using xxd-format! "{{{3
augroup vimrc-binary
  autocmd!
  autocmd BufReadPre  *.bin let &bin=1
  autocmd BufReadPost *.bin if &bin | silent %!xxd -g 1
  autocmd BufReadPost *.bin set filetype=xxd | endif
  autocmd BufWritePre *.bin if &bin | %!xxd -r
  autocmd BufWritePre *.bin endif
  autocmd BufWritePost *.bin if &bin | silent %!xxd -g 1
  autocmd BufWritePost *.bin if &bin | setlocal nomodified | endif
augroup END

" some commands & altercmd {{{1
" some commands {{{2
command! -narg=0 SynReload syntax off <Bar> syntax enable
command! -nargs=? -complete=filetype Ctags call my#command#exec_ctags(<q-args>, '-R')
command! -nargs=? -complete=filetype CtagsUpdate call my#command#exec_ctags(<q-args>, '-R', '-a')
command! -nargs=? -complete=dir CtagsWithPath call my#command#ctags_with_path(<q-args>)
command! -nargs=? -complete=dir Gtags call my#command#system_with_lcd("gtags", <q-args>)
command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif
command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>


" mappings {{{1
" define common key-prefixes {{{2
noremap [!space] <Nop>
nnoremap g<Space> <Space>
vnoremap g<Space> <Space>
nmap <Space> [!space]
vmap <Space> [!space]

noremap [!edit] <Nop>
nmap <C-e> [!edit]
vmap <C-e> [!edit]

noremap [!comment-doc] <Nop>
map     ,c     [!comment-doc]

noremap [!t] <Nop>
nmap t [!t]
nnoremap <silent> [!t]e t
nnoremap <silent> [!t]2 t"
nnoremap <silent> [!t]7 t'
nnoremap <silent> [!t]8 t(
nnoremap <silent> [!t]9 t)
nnoremap <silent> [!t][ t[
nnoremap <silent> [!t]] t]

nnoremap q <Nop>
" nnoremap q: q:
" nnoremap q/ q/
" nnoremap q? q?
nnoremap Q q

" 行単位で移動 {{{2
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() !=# 'V') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() !=# 'V') ? 'gk' : 'k'

" disable danger keymaps {{{2
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
if $TERM =~ 'screen'
  map <C-z> <Nop>
endif

" useful keybinds {{{2
nnoremap gs :<C-u>setf<Space>
nmap Y y$

" http://vim-users.jp/2009/10/hack91/
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" indent whole buffer
nnoremap [!space]= call <SID>execute_motionless('normal! gg=G')

nnoremap <silent> [!t]n gt
nnoremap <silent> [!t]p gT
nnoremap <silent> [!t]h gT
nnoremap <silent> [!t]l gt
nnoremap <silent> [!t]c :<C-u>tabnew<CR>
nnoremap <silent> [!t]C :<C-u>tabnew %<CR>:normal! <C-o><CR>
nnoremap <silent> [!t]* :<C-u>tabedit %<CR>*
nnoremap <silent> [!t]# :<C-u>tabedit %<CR>#
nnoremap <silent> [!t]q :<C-u>tabclose<CR>

" redraw map
nmap <silent> sr :redraw!<CR>

" for gui
nnoremap <M-a> ggVG
nnoremap <M-v> P
vnoremap <M-c> y
vnoremap <M-x> x

" winmove & winsize {{{2
nnoremap <silent> <C-Left>  :wincmd h<CR>
nnoremap <silent> <C-Right> :wincmd l<CR>
nnoremap <silent> <C-Up>    :wincmd k<CR>
nnoremap <silent> <C-Down>  :wincmd j<CR>

nnoremap <silent> <S-Left>  :10wincmd ><CR>
nnoremap <silent> <S-Right> :10wincmd <<CR>
nnoremap <silent> <S-Up>    :10wincmd -<CR>
nnoremap <silent> <S-Down>  :10wincmd +<CR>

" win switch
for i in range(10)
  execute 'nnoremap <silent> <C-w>'.i '<C-w>t'.repeat('<C-w>w', (i+9)%10)
endfor
unlet i

nnoremap <C-w><C-n> :tabnext<CR>
nnoremap <C-w><C-p> :tabprev<CR>
nnoremap <C-w><C-c> :tabnew<CR>
" tmaps
tnoremap <C-w><C-n> <C-w>:tabnext<CR>
tnoremap <C-w><C-p> <C-w>:tabprev<CR>
tnoremap <C-w><C-c> <C-w>:tabnew<CR>
tnoremap <C-\><C-\> <C-\><C-n>
  " tnoremap <Esc> <C-\><C-n>

" grep
"function! s:set_grep(...) "{{{3
"  let retval = 0
"  for type in copy(a:000)
"    if type == "hw" && executable(type)
"      set grepprg=hw
"      set grepformat=%f:%l:%m
"      " set grepprg=jvgrep\ -n

"      let g:unite_source_grep_command = "hw"
"      " let g:unite_source_grep_default_opts = '-i --exclude "(\.git|\.svn|\.hg|\.bzr|tags|tmp)"'
"      let g:unite_source_grep_default_opts = '-i --no-group --no-color'
"      let g:unite_source_grep_recursive_opt = ''
"      return 1
"    elseif type == "jvgrep" && executable(type)
"      set grepprg=jvgrep
"      set grepformat=%f:%l:%m
"      " set grepprg=jvgrep\ -n

"      " #1159 のため動作しない
"      " let g:unite_source_grep_command = "jvgrep"
"      " " let g:unite_source_grep_default_opts = '-i --exclude "(\.git|\.svn|\.hg|\.bzr|tags|tmp)"'
"      " let g:unite_source_grep_default_opts = '-ir'
"      " let g:unite_source_grep_recursive_opt = '-R'
"      return 1
"    elseif type == "ag" && executable(type)
"      set grepprg=ag\ -S\ --nocolor\ --nogroup\ --nopager
"      set grepformat=%f:%l:%m
"      let g:ackprg="ag -i -S --nocolor --nogroup --column --nopager"

"      let g:unite_source_grep_command = 'ag'
"      " \ '--ignore-case -S --noheading --nocolor --nogroup --nopager',
"      let opts = [
"        \ '-i --vimgrep --hidden --noheading --nocolor --nogroup --nopager',
"        \ '--ignore ".hg"',
"        \ '--ignore ".git"',
"        \ '--ignore ".bzr"',
"        \ '--ignore ".svn"',
"        \ '--ignore "node_modules"',
"        \ ]
"      let g:unite_source_grep_default_opts = join(opts, " ")
"      let g:unite_source_grep_recursive_opt = ''
"      return 1
"    elseif type == "ack" && executable(type)
"      set grepprg=ack\ --smart-case\ -a\ --nocolor\ --nogroup\ --nopager
"      set grepformat=%f:%l:%m
"      let g:ackprg="ack -H --smart-case --nocolor --nogroup --column --nopager"
"      let g:unite_source_grep_command = 'ack'
"      let g:unite_source_grep_default_opts = '--smartcase --no-heading --nocolor --nogroup --nopager'
"      let g:unite_source_grep_recursive_opt = ''
"      return 1
"    elseif type == "ack-grep"  && executable(type)
"      set grepprg=ack-grep\ -a\ --nocolor\ --nogroup\ --nopager
"      set grepformat=%f:%l:%m

"      let g:ackprg="ack-grep -H --nocolor --nogroup --column --nopager"
"      let g:unite_source_grep_command = 'ack-grep'
"      let g:unite_source_grep_default_opts = '--no-heading --nocolor -a --nogroup --nopager'
"      let g:unite_source_grep_recursive_opt = ''
"      return 1
"    endif
"    if type == "grep"
"      let retval = 1
"      break
"    endif
"  endfor

"  set grepprg=grep\ -n\ $*\ /dev/null
"  "set grepprg=grep\ -n\ $*\ /dev/null\ --exclude\ \"\*\.svn\*\"

"  let g:unite_source_grep_command = 'grep'
"  let g:unite_source_grep_default_opts = '-iRHn'
"  let g:unite_source_grep_recursive_opt = ''
"  return retval
"endfunction

"command! -nargs=0 SetHw call s:set_grep("hw")
"command! -nargs=0 SetJvgrep call s:set_grep("jvgrep")
"command! -nargs=0 SetAck call s:set_grep("ack-grep")
"command! -nargs=0 SetAg call s:set_grep("ag")
"command! -nargs=0 SetPt call s:set_grep("pt")

let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'
" let Grep_Default_Filelist = '*' "join(split('* '.Grep_Skip_Files, ' '), ' --exclude=')
" if s:is_win || get(g:vimrc_enabled_features, 'jvgrep', 0)
"   call s:set_grep("jvgrep", "hw", "ag", "ack-grep")
" else
"   call s:set_grep("hw", "ag", "jvgrep", "ack-grep")
" endif

set grepprg=rg
set grepformat=%f:%l:%m

let g:unite_source_grep_command = "rg"
" let g:unite_source_grep_default_opts = '-i --exclude "(\.git|\.svn|\.hg|\.bzr|tags|tmp)"'
let g:unite_source_grep_default_opts = '-i --no-group --no-color'
let g:unite_source_grep_recursive_opt = ''

let Grep_Default_Options = '-i'
let Grep_OpenQuickfixWindow = 1

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|^tags$'
let MyGrepcmd_useropt = '--exclude="*\.\(svn\|git\|hg)*"'

" tags-and-searches {{{2
nnoremap [!t]r t

" [[, ]] {{{2
let g:square_brackets = {
  \ 'markdown' : ['^#', 'markdownHeadingDelimiter'],
  \ 'textile' : ['^*', 'txtListBullet\d'],
  \ 'html' : '<html\|<head\|<body\|<h\d',
  \ 'rst' : '^-\+\|^=\+',
  \ 'coffee' : '->\s*$\|^\s*class\s',
  \ 'git-log.git-diff' : '^@@\|^diff ',
  \ 'git' : '^@@\|^diff ',
  \ 'gitconfig' : '^\s*[',
  \ 'neosnippet' : '^snippet ',
  \ 'toml' : '^[',
  \ }
function! s:nmap_square_brackets() "{{{3
  if exists('g:square_brackets[&filetype]')
    if type(g:square_brackets[&filetype]) == s:type_a
      \ && len(g:square_brackets[&filetype]) >= 2
      let [pattern, syn] = g:square_brackets[&filetype]
      silent execute printf('nnoremap <silent><buffer> ]] ' .
            \ ':<C-u>call <SID>search_with_syntax(%s, %s, "")<CR>',
            \ string(pattern), string(syn))
      silent execute printf('nnoremap <silent><buffer> [[ ' .
            \ ':<C-u>call <SID>search_with_syntax(%s, %s, "b")<CR>',
            \ string(pattern), string(syn))
    else
      nnoremap <silent><buffer> ]] :<C-u>call search(g:square_brackets[&filetype], "W")<CR>
      nnoremap <silent><buffer> [[ :<C-u>call search(g:square_brackets[&filetype], "Wb")<CR>
    endif
  endif
endfunction

function! s:search_with_syntax(pattern,syn,flags) "{{{3
  normal! m'
  let i = 0
  let cnt = v:count ? v:count : 1
  while i < cnt
    let i = i + 1
    let line = line('.')
    let col  = col('.')
    let pos = search(a:pattern, 'W'.a:flags)
    while pos != 0
          \ && synIDattr(synID(line('.'), col('.'), 0),'name') !~# a:syn
      let pos = search(a:pattern, 'W'.a:flags)
    endwhile
    if pos == 0
      call cursor(line,col)
      return
    endif
  endwhile
endfunction

MyAutoCmd FileType * call s:nmap_square_brackets()

" maps {{{2
" nmaps {{{3
MyAutoCmd FileType help,ref,git-status,git-log nnoremap <buffer><nowait> q <C-w>c

function! s:execute_motionless(expr) "{{{4
  let wv = winsaveview()
  execute a:expr
  call winrestview(wv)
endfunction " }}}

if has('gui_running')
  function! s:set_transparency(op) "{{{4
    silent! execute 'set transparency'.(a:op =~# '^[-+=]' ? a:op : '=' . a:op)
    echo &transparency
  endfunction " }}}
  if s:is_mac
    function! s:activate_window(proc)
      silent call system(printf("osascript -e 'tell application \"%s\" to activate'&", a:proc))
    endfunction
    function! s:map_gui()
      nnoremap <D-Up>   :<C-u>call <SID>set_transparency('+=5')<CR>
      nnoremap <D-Down> :<C-u>call <SID>set_transparency('-=5')<CR>
      nnoremap <D-Right> :<C-u>call <SID>set_transparency(90)<CR>
      execute 'nnoremap <D-Left> :<C-u>call <SID>set_transparency(' . &transparency . ')<CR>'
      nnoremap <silent><D-i> :<C-u>call <SID>activate_window("iTerm")<CR>
      nnoremap <silent><D-u> :<C-u>call <SID>activate_window("Firefox")<CR>
    endfunction
    MyAutoCmd GUIEnter * call s:map_gui()
  elseif s:is_win
    function! s:map_gui()
      nnoremap <M-Up>   :<C-u>call <SID>set_transparency('+=5')<CR>
      nnoremap <M-Down> :<C-u>call <SID>set_transparency('-=5')<CR>
      nnoremap <M-Right> :<C-u>call <SID>set_transparency(230)<CR>
      nnoremap <M-Space> :<C-u>simalt ~<CR>
      nnoremap <M-x> :<C-u>simalt ~x<CR>
      nnoremap <M-r> :<C-u>simalt ~r<CR>
      nnoremap <M-s> :<C-u>simalt ~s<CR>
      execute 'nnoremap <A-Left> :<C-u>call <SID>set_transparency(' . &transparency . ')<CR>'
    endfunction
    MyAutoCmd GUIEnter * call s:map_gui()
  endif
endif
" win move
nnoremap [!space]. :source ~/.vimrc<CR>

nnoremap / :<C-u>nohlsearch<CR>/
nnoremap ? :<C-u>nohlsearch<CR>?

nnoremap [!space]/ :<C-u>nohlsearch<CR>
nnoremap [!space]w :<C-u>call my#command#toggle_option("wrap")<CR>
nnoremap [!space]n :<C-u>call my#command#toggle_option("relativenumber")<CR>

nnoremap [!space][ :<C-u>cprevious<CR>
nnoremap [!space]] :<C-u>cnext<CR>

nnoremap <C-w><Space> <C-w>p
nnoremap *  *N
nnoremap #  #n
nnoremap <C-w>*  <C-w>s*N
nnoremap <C-w>#  <C-w>s#n

" {{{4 http://vim-users.jp/2011/04/hack213/
let g:scrolloff = &scrolloff
set scrolloff=0
" Hack for <LeftMouse> not to adjust ('scrolloff') when single-clicking.
" Implement 'scrolloff' by auto-command to control the fire.
MyAutoCmd CursorMoved * call s:reinventing_scrolloff()
let s:last_lnum = -1
function! s:reinventing_scrolloff()
  if s:last_lnum > 0 && line('.') ==# s:last_lnum
    return
  endif
  let s:last_lnum = line('.')
  let winline     = winline()
  let winheight   = winheight(0)
  let middle      = winheight / 2
  let upside      = (winheight / winline) >= 2
  " If upside is true, add winlines to above the cursor.
  " If upside is false, add winlines to under the cursor.
  if upside
    let up_num = g:scrolloff - winline + 1
    let up_num = winline + up_num > middle ? middle - winline : up_num
    if up_num > 0
      execute 'normal!' up_num."\<C-y>"
    endif
  else
    let down_num = g:scrolloff - (winheight - winline)
    let down_num = winline - down_num < middle ? winline - middle : down_num
    if down_num > 0
      execute 'normal!' down_num."\<C-e>"
    endif
  endif
endfunction
nnoremap <silent> <LeftMouse>       <Esc>:set eventignore=all<CR><LeftMouse>:set eventignore=<CR>
nnoremap          <2-LeftMouse>     g*
nnoremap <silent> <ScrollWheelUp>   <Esc>:set eventignore=all<CR><ScrollWheelUp>:set eventignore=<CR>
nnoremap <silent> <ScrollWheelDown> <Esc>:set eventignore=all<CR><ScrollWheelDown>:set eventignore=<CR>

" imaps {{{3
inoremap <C-t> <C-v><Tab>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-d> <Delete>
inoremap <C-a> <Home>
inoremap <S-Insert> <C-r>+

" inoremap <C-]>a <Home>
" inoremap <C-]>e <End>
" inoremap <C-]>f <S-Right>
" inoremap <C-]>b <S-Left>
" inoremap <C-]>d <Delete>
" inoremap <C-]><C-a> <Home>
" inoremap <C-]><C-e> <End>
" inoremap <C-]><C-f> <S-Right>
" inoremap <C-]><C-b> <S-Left>
" inoremap <C-]><C-d> <Delete>

inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" cmaps {{{3
if s:bundle.is_installed('vim-emacscommandline')
  cnoremap <C-x><C-x> <C-r>=substitute(expand('%:p:h'), ' ', '\\v:val', 'e')<CR>/
  cnoremap <C-x><C-z> <C-r>=expand('%:p:r')<CR>
else
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-f> <Right>
  cnoremap <C-b> <Left>
  cnoremap <C-d> <Delete>
  cnoremap <C-x> <C-r>=substitute(expand('%:p:h'), ' ', '\\v:val', 'e')<CR>/
  cnoremap <C-z> <C-r>=expand('%:p:r')<CR>
  cnoremap <C-t> <C-\>e<SID>expand_filename()<CR>
  function! s:expand_filename()
    let c = getcmdline()
    let files = split(glob(c), "\n")
    if empty(files)
      return c
    endif
    return join(files, " ")
  endfunction
endif

cnoremap <Up> <C-p>
cnoremap <Down> <C-n>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

cnoremap <C-]>a <Home>
cnoremap <C-]>e <End>
"cnoremap <C-]>f <C-f>
cnoremap <C-]>f <S-Right>
cnoremap <C-]>b <S-Left>
cnoremap <C-]>d <Delete>
cnoremap <C-]>i <C-d>
cnoremap <C-]><C-a> <Home>
cnoremap <C-]><C-e> <End>
cnoremap <C-]><C-f> <S-Right>
cnoremap <C-]><C-b> <S-Left>
cnoremap <C-]><C-d> <Delete>
cnoremap <C-]><C-i> <C-d>
if !s:is_win && !s:is_mac
  cnoremap <S-Insert> <C-r>+
endif

" v+omap
onoremap aa a>
vnoremap aa a>
onoremap ia i>
vnoremap ia i>
onoremap ar a]
vnoremap ar a]
onoremap ir i]
vnoremap ir i]
onoremap ak a)
vnoremap ak a)
onoremap ik i)
vnoremap ik i)
vnoremap <C-a> <C-a>gv
vnoremap <C-x> <C-x>gv

" vmaps {{{3
vnoremap . :normal .<CR>
" vnoremap <Leader>te    :ExciteTranslate<CR>
vnoremap <Leader>tg    :Ginger<CR>
vnoremap <Leader>te    :Gte<CR>
vnoremap <Leader>tj    :Gtj<CR>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
"nnoremap : q:
xnoremap . :normal .<CR>
" from http://vim-users.jp/2011/04/hack214/
vnoremap ( t(
vnoremap ) t)
vnoremap ] t]
vnoremap [ t[
vnoremap "" t"
vnoremap ' t'
onoremap ( t(
onoremap ) t)
onoremap ] t]
onoremap [ t[
onoremap " t"
onoremap ' t'

" mouse {{{2
if s:is_mac
  nnoremap <MiddleMouse> <Nop>
  inoremap <MiddleMouse> <Nop>
  vnoremap <MiddleMouse> <Nop>
endif

" abbrev {{{1
iabbrev funciton function
iabbrev funcition function
iabbrev edn end
iabbrev retrun return
iabbrev sented sent
iabbrev sended sent
iabbrev setted set
iabbrev cosnt const
iabbrev scirpt script
iabbrev hlep help
iabbrev parcent percent
iabbrev persent percent
iabbrev parsent percent
iabbrev tilda tilde
iabbrev appropreate appropriate
iabbrev acknowledgment acknowledgement

" languages plugin {{{1
" html {{{2
let g:html_indent_script1="inc"
let g:html_indent_style1="inc"
let g:html_indent_inctags="html,body,head"
" let g:html_indent_autotags = "th,td,tr,tfoot,thead"

" perl {{{2
let g:perl_compiler_force_warnings = 0
let g:perl_extended_vars           = 1
let g:perl_include_pod             = 1
let g:perl_moose_stuff             = 1
let g:perl_no_scope_in_variables   = 1
let g:perl_no_sync_on_global_var   = 1
let g:perl_no_sync_on_sub          = 1
let g:perl_nofold_packages         = 1
let g:perl_pod_formatting          = 1
let g:perl_pod_spellcheck_headings = 1
let g:perl_string_as_statement     = 1
let g:perl_sync_dist               = 1000
let g:perl_want_scope_in_variables = 1
"let g:perl_fold = 1
"let g:perl_fold_blocks = 1

" php {{{2
let g:php_special_functions = 1
let g:php_alt_comparisons = 1
let g:php_alt_AssignByReference = 1
"let g:php_folding = 1
let g:php_folding = 0
let g:php_sql_query = 1
let g:php_baselib = 1
" let g:php_htmlInStrings = 1
let g:php_html_in_strings = 0
let g:php_noShortTags = 1
let g:php_parent_error_close = 1
let g:php_parent_error_open = 1
"let g:php_sync_method = x

" PHP-Indenting-for-VIm
let PHP_vintage_case_default_indent = 1
let PHP_autoformatcomment = 0
" phpfolding.vim
let g:DisableAutoPHPFolding = 1

"" php-doc.vim
" let g:pdv_cfg_php4always = 0
" let g:pdv_cfg_Type = 'mixed'
" let g:pdv_cfg_Package = ""
" let g:pdv_cfg_Version = '$id$'
" if exists('g:author') && exists('g:email')
"   let g:pdv_cfg_Author = g:author . ' <' . g:email . '>'
" else
"   let g:pdv_cfg_Author = ''
" endif
" let g:pdv_cfg_Copyright = ""
" let g:pdv_cfg_License = ''
" let g:pdv_cfg_EnalbedFoldMarker = 0
" let g:pdv_cfg_CommentEnd = "// }}}"

" python {{{2
let g:pymode_indent = 0

" ruby {{{2
let g:ruby_operators = 1
let g:ruby_no_expensive = 1

" go {{{2
if s:bundle.is_installed('vim-go')
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
endif
if s:bundle.is_installed('vim-gocode')
  if s:bundle.is_installed('vimproc.vim')
    let g:gocomplete#system_function = 'vimproc#system'
  endif
endif

" javascript {{{2
if s:bundle.is_installed('simple-javascript-indenter')
  " shiftwidthを1に
  let g:SimpleJsIndenter_BriefMode = 1
  " better switch indent
  let g:SimpleJsIndenter_CaseIndentLevel = -1
endif
if s:bundle.is_installed('javascript-libraries-syntax.vim')
  let g:used_javascript_libs = 'jquery,underscore,react'
endif

" markdown {{{2
let g:markdown_fenced_languages = [
\  'coffee',
\  'css',
\  'javascript',
\  'js=javascript',
\  'json=javascript',
\  'objc',
\  'ruby',
\  'sass',
\  'xml',
\]
" \  'erb=eruby', " filetype=html をしている
" vim-json {{{2
let g:vim_json_syntax_conceal = 0

" disables plugin {{{1
if !s:is_mac
  let did_install_default_menus = 1
endif
let did_install_syntax_menu = 1

let g:loaded_getscriptPlugin = 1
let g:loaded_vimballPlugin = 1
" let g:loaded_netrwPlugin = 1
" $VIM/plugins/kaoriya/plugin/autodate.vim
" let plugin_autodate_disable  = 1
" $VIM/plugins/kaoriya/plugin/cmdex.vim
let plugin_cmdex_disable     = 1
" $VIM/plugins/kaoriya/plugin/dicwin.vim
let plugin_dicwin_disable    = 1
" $VIMRUNTIME/plugin/plugin/format.vim
let plugin_format_disable    = 1
" $VIM/plugins/kaoriya/plugin/hz_ja.vim
" let plugin_hz_ja_disable     = 1
" $VIM/plugins/kaoriya/plugin/scrnmode.vim
let plugin_scrnmode_disable  = 1
" $VIM/plugins/kaoriya/plugin/verifyenc.vim
let plugin_verifyenc_disable = 1

" plugin settings {{{1
" flags {{{2
let g:vimrc_enabled_plugins = {
  \ 'smartchr': s:bundle.is_installed('vim-smartchr'),
  \ 'smartinput': s:bundle.is_installed('vim-smartinput'),
  \ 'lexima': s:bundle.is_installed('lexima.vim'),
  \ 'increment_activator': s:bundle.is_installed('increment-activator'),
  \ 'cycle': s:bundle.is_installed('vim-cycle'),
  \ 'speeddating': s:bundle.is_installed('vim-speeddating'),
  \ 'unite': s:bundle.is_installed('unite.vim'),
  \ 'expand_region': s:bundle.is_installed('vim-expand-region'),
  \ 'gitv': s:bundle.is_installed('gitv'),
  \ 'memolist': s:bundle.is_installed('memolist.vim'),
  \ 'vimproc': s:bundle.is_installed('vimproc.vim'),
  \ 'neosnippet': s:bundle.is_installed('neosnippet.vim'),
  \ 'neocomplete': s:bundle.is_installed('neocomplete.vim'),
  \ 'neocomplcache': s:bundle.is_installed('neocomplcache.vim'),
  \ 'youcompleteme': s:bundle.is_installed('YouCompleteMe'),
  \ 'unite_candidate_sorter': s:bundle.is_installed('unite-candidate_sorter'),
  \ 'fugitive': s:bundle.is_installed('vim-fugitive'),
  \ 'gita': s:bundle.is_installed('vim-gita'),
  \ 'agit': s:bundle.is_installed('agit.vim'),
  \ 'concealedyank': s:bundle.is_installed('concealedyank.vim'),
  \ 'ambicmd': s:bundle.is_installed('vim-ambicmd'),
  \ 'endwize': s:bundle.is_installed('endwize.vim'),
  \ 'php_namespace': s:bundle.is_installed('vim-php-namespace'),
  \ }

" translategoole.vim {{{2
function! s:vimrc_translategoole()
  nnoremap <buffer><nowait> q :<C-u>TranslateGoogleClose<CR>
  nnoremap <buffer><nowait> T :<C-u>TranslateGoogleToggle<CR>
endfunction
MyAutoCmd User PluginTranslateGoogleInitializeAfter call s:vimrc_translategoole()


" lightline {{{2
if s:bundle.tap('lightline.vim')
  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0
  let g:vimshell_force_overwrite_statusline = 0

  let g:lightline = {
  \ 'colorscheme': 'vimrc',
  \ 'mode_map': {'n': 'N', 'i': 'I', 'R': 'R', 'v': 'V',
  \ 'V': 'V-LINE', 'c': 'C', "\<C-v>": 'V-BLOCK', 's': 'S',
  \ 'S': 'S-LINE', "\<C-s>": 'S-BLOCK', '?': ' ',
  \ },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ], [ 'diff_mode', 'scm', 'filename', 'cwdirname', 'xenv_version', ] ],
  \   'right': [
  \     [ 'qfcount', ],
  \     [ 'linestat' ], [ 'filetype' ],
  \     [ 'anzu_or_charcode', 'fileinfo',],
  \   ],
  \ },
  \ 'inactive': {
  \   'left': [ [ 'diff_mode', 'absfilename' ] ],
  \   'right': [
  \     [ 'winnr' ], [ 'filetype' ],
  \   ],
  \ },
  \ 'component': {
  \   'linestat': '%3p%% %l:%-2v',
  \ },
  \ 'component_function': {
  \   'diff_mode' : 'g:ll_helper.diff_mode',
  \   'scm' : 'g:ll_helper.scm',
  \   'filename' : 'g:ll_helper.filename',
  \   'cwdirname' : 'g:ll_helper.cwdirname',
  \   'absfilename' : 'g:ll_helper.get_absfilename',
  \   'iminsert' : 'g:ll_helper.iminsert',
  \   'qfcount' : 'g:ll_helper.qfcount',
  \   'xenv_version' : 'g:ll_helper.xenv_version',
  \   'anzu': 'g:ll_helper.anzu',
  \   'anzu_or_charcode': 'g:ll_helper.anzu_or_charcode',
  \   'fileinfo': 'g:ll_helper.fileinfo',
  \   'winnr': 'g:ll_helper.winnr',
  \   'bufwinnr': 'g:ll_helper.bufwinnr',
  \ },
  \ }
  let g:ll_helper = {}

  function! g:ll_helper.get(...) "{{{3
    for s in a:000
      if !empty(s)
        return s
      endif
    endfor
    return ""
  endfunction

  function! g:ll_helper.shorten(s, len) "{{{
    let p = - (a:len - 3)
    return len(a:s) > a:len ? "..." . a:s[p :] : a:s
  endfunction "}}}

  function! g:ll_helper.diff_mode() "{{{3
    if !&diff
      return ""
    endif
    return printf("D[%s]", filereadable(expand('%:p')) ? "F" : "-")
  endfunction

  function! g:ll_helper.anzu_or_charcode() "{{{3
    let s = self.anzu()
    if empty(s)
      return self.charcode()
    endif
    return s
  endfunction

  function! g:ll_helper.qfcount() "{{{3
    if s:bundle.is_installed('ale')
      let counts = ale#statusline#Count(bufnr(''))

      let errors = counts.error + counts.style_error
      let warnings = counts.total - errors

      return counts.total == 0 ? '' : printf('%dW %dE', warnings, errors)
    endif
    let qflist = getqflist()
    " let nr = bufnr('%')
    " let c = len(filter(qflist, 'v:val.bufnr == nr'))
    " unlet qflist nr
    let c = len(filter(qflist, 'v:val.lnum != 0'))
    unlet qflist
    if c <= 0
      return ""
    endif
    return "qf:" . c
  endfunction

  function! g:ll_helper.charcode() "{{{3
    let ch = matchstr(getline('.'), '.', col('.')-1)
    let code = strgetchar(ch, 0)
    if code < 0 | return 'NUL' | endif
    return printf('0x%0'.(code>256?4:2).'x[%d]', code, code)
    " redir => ascii
    "   silent! ascii
    " redir END

    " if match(ascii, 'NUL') != -1
    "   return 'NUL'
    " endif

    " let nrformat = '0x%02x' " Zero pad hex values
    " let encoding = (&fenc == '' ? &enc : &fenc)

    " if encoding == 'utf-8' " Zero pad with 4 zeroes in unicode files
    "   let nrformat = '0x%04x'
    " endif

    " " Get the character and the numeric value from the return value of :ascii
    " " This matches the two first pieces of the return value, e.g.
    " " "<F>  70" => char: 'F', nr: '70'
    " let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

    " let nr = printf(nrformat, nr) " Format the numeric value

    " return printf('%s[%s]', nr, char)
  endfunction

  function! g:ll_helper.fileinfo() "{{{3
    let s = empty(&fileformat) ? '' : '['.&fileformat.']'
    return &fileencoding . s
  endfunction "}}}
  function! g:ll_helper.anzu() "{{{3
    return exists('*anzu#search_status') ? anzu#search_status() : ''
  endfunction
  function! g:ll_helper.is_special_ft() "{{{3
    return &filetype =~ 'help\|vimfiler\|gundo'
  endfunction

  function! g:ll_helper.scm() "{{{3
    if self.is_special_ft()
      return ""
    endif
    let fdir = expand('%:p:h')
    if isdirectory(fdir . '/CVS')
      return 'CVS'
    elseif isdirectory(fdir . '/.svn')
      return 'SVN'
    endif
    return self.git()
  endfunction

  function! g:ll_helper.git()
    if g:vimrc_enabled_plugins.gita
      return self.shorten(gita#statusline#format('%lb'), 10)
    elseif g:vimrc_enabled_plugins.fugitive
      let s = fugitive#Head()
      return self.shorten(s, 10)
    endif
    return ''
  endfunction

  function! g:ll_helper.modified() "{{{3
    if self.is_special_ft()
      return ''
    elseif &modified
      return '[+]'
    elseif &modifiable
      return ''
    endif
    return '[-]'
  endfunction

  function! g:ll_helper.readonly() "{{{3
    return !self.is_special_ft() && &readonly ? '[R]' : ''
  endfunction

  function! g:ll_helper.iminsert() "{{{3
    return &iminsert ? "IME" : ''
  endfunction

  function! g:ll_helper.xenv_version() "{{{3
    if has_key(self.xenvs, &filetype)
      return self.get_xenv_version(&filetype, self.xenvs[&filetype])
    endif
    return ""
    " return join(map(copy(self.lang_items), 'self[v:val]()'), '')
    " return g:ll_helper.virtualenv().g:ll_helper.rbenv()
  endfunction

  function! g:ll_helper.cwdirname() "{{{3
    let dir = substitute(fnamemodify(getcwd(), ":p:h"), $HOME, '~', '')
    return self.shorten(dir, 13)
  endfunction

  let g:ll_helper.xenvs = {
        \ 'ruby': 'rbenv',
        \ 'python': 'pyenv',
        \ 'perl': 'plenv',
        \ 'javascript': 'nodenv',
        \ 'php': 'phpenv',
        \ }

  function! g:ll_helper.get_xenv_version(ft, name) "{{{3
    if &filetype != a:ft
      return ""
    endif

    if a:ft == "ruby" && exists('$RBENV_VERSION')
      if winwidth(0) > 70
        return "rbenv:" . $RBENV_VERSION
      endif
      return $RBENV_VERSION
    endif
    let var = a:name . '_version'
    if !exists('b:'.var)
      let b:[var] = ""
      for f in ['.'.a:name.'-version', expand('~/.'.a:name.'/version')]
        if filereadable(f)
          let b:[var] = readfile(f)[0]
          break
        endif
      endfor
    endif
    let ver = get(b:, var, '')
    if empty(ver)
      return ""
    endif
    if winwidth(0) > 70
      return a:name . ':' . ver
    endif
    return ver
  endfunction

  function! g:ll_helper.virtualenv() "{{{3
    if &filetype == 'python' && exists('*virtualenv#statusline')
      return virtualenv#statusline()
    endif
    return ''
  endfunction

  function! g:ll_helper.get_filename() "{{{3
    let filename = self.get_special_filename()
    if !empty(filename)
      return filename
    endif
    return expand('%:t')
  endfunction

  function! g:ll_helper.get_special_filename() "{{{3
    if &filetype == 'vimfiler'
      return vimfiler#get_status_string()
    elseif &filetype == 'unite'
      return unite#get_status_string()
    elseif &filetype == 'vimshell' && exists('b:vimshell.current_dir')
      return substitute(b:vimshell.current_dir, expand('~'), '~', '')
    elseif &filetype == 'tagbar'
      return 'Tagbar ' . tagbar#currenttag("%s", "")
    elseif exists('t:undotree')
      if &filetype == 'undotree' && exists('*t:undotree.GetStatusLine')
        return t:undotree.GetStatusLine()
      elseif &filetype == 'diff' && exists('*t:diffpanel.GetStatusLine')
        return t:diffpanel.GetStatusLine()
      endif
    elseif expand('%:t') == ""
      return '[No Name]'
    endif
    return ""
  endfunction

  function! g:ll_helper.get_absfilename() "{{{3
    let filename = self.get_special_filename()
    if !empty(filename)
      return filename
    endif
    let filename = expand('%:p')
    " if filename =~? '^fugitive://'
    let win_w = winwidth(bufnr('%')) + 30
    if win_w < strlen(filename)
      return "..." . strpart(filename, float2nr(floor(win_w / 2)))
    endif
    return filename
  endfunction

  function! g:ll_helper.filename() "{{{3
    return join([self.readonly(), self.get_filename(), self.modified()], '')
  endfunction
  function! g:ll_helper.winnr() "{{{3
    return join(["W:", winnr()], '')
  endfunction
  function! g:ll_helper.bufwinnr() "{{{3
    return join(["W:", bufwinnr('%')], '')
  endfunction

  call s:bundle.untap()

endif


command! -nargs=0 EnewNofile enew | setlocal buftype=nofile
nmap ,ss :<C-u>EnewNofile<CR>

" netrw {{{2
let g:netrw_home = $VIM_CACHE
let g:netrw_list_hide = '\~$,^tags$,\(^\|\s\s\)\zs\.\.\S\+'

" yankring {{{2
let g:yankring_history_dir = $VIM_CACHE
let g:yankring_default_menu_mode = 0
let g:yankring_min_element_length = 2
let g:yankring_window_height = 14

" TOhtml {{{2
let g:html_number_lines = 0
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = 'utf-8'

" for testcase {{{4
MyAutoCmd BufWinEnter,BufNewFile *_spec.rb setlocal filetype=ruby.rspec
MyAutoCmd BufWinEnter,BufNewFile *test.php,*Test.php setlocal filetype=php.phpunit
MyAutoCmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.nosetests
MyAutoCmd BufWinEnter,BufNewFile *.t setlocal filetype=perl.prove

command! -nargs=0 PhpUnitSkelGen call my#php#generate_phpunit_skelgen()
command! -nargs=0 PhpUnitUpdateSource call my#php#update_phpunit_sourcecode()

" completes {{{3
let g:nodejs_complete_config = {
  \ 'max_node_compl_len': 15,
  \ }
" let g:node_usejscomplete = 1
let g:jscomplete_use = ['dom', 'es6th', 'moz']

if exists("+omnifunc") " {{{4
  MyAutoCmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

  " MyAutoCmd FileType python        setlocal omnifunc=pythoncomplete#Complete
  " MyAutoCmd FileType javascript   setlocal omnifunc=javascriptcomplete#CompleteJS
  " MyAutoCmd FileType javascript    setlocal omnifunc=jscomplete#CompleteJS
  MyAutoCmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
  MyAutoCmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
  MyAutoCmd FileType c             setlocal omnifunc=ccomplete#Complete
  MyAutoCmd FileType actionscript  setlocal omnifunc=actionscriptcomplete#CompleteAS
  MyAutoCmd FileType *
        \ if &l:omnifunc == ''
        \ | setlocal omnifunc=syntaxcomplete#Complete
        \ | endif
endif

" etc functions & commands {{{1
" tiny snippets {{{2
let g:my_snippets_dir = $HOME . "/memos/tiny-snippets"

" buffer commands {{{2
command! ToUnixBuffer set fileformat=unix fileencoding=utf8
command! ToWindowsBuffer set fileformat=dos fileencoding=cp932
command! ToMacBuffer set fileformat=mac fileencoding=utf8
command! ConvChilder %s/〜/～/g

" シェル起動系 {{{2
if s:is_mac "{{{3
  " Utility command for Mac
  command! Here silent execute '!open' shellescape(expand('%:p:h'))
  command! This silent execute '!open' shellescape(expand('%:p'))
  command! In silent execute '!osascript' '-e' "'tell application \"Terminal\" to do script \"cd ".expand('%:p:h')."; clear;\"'"
  command! -nargs=1 -complete=file That silent execute '!open' shellescape(expand(<f-args>), 1)
  command! Subl silent execute '!open' '-a' 'Sublime\ Text\ 2' shellescape(expand('%:p'))
  command! CotEdit silent execute '!open' '-a' 'CotEditor' shellescape(expand('%:p'))
  command! Mate silent execute '!open' '-a' 'TextMate' shellescape(expand('%:p'))
  command! Brackets silent execute '!open' '-a' 'Brackets' shellescape(expand('%:p'))
  command! Iterm silent execute "!osascript -e 'tell application \"iTerm\" to activate' &"
  command! -nargs=1 ActivateWindow silent execute "!osascript -e 'tell application \"<args>\" to activate' &"
  nnoremap <D-i> :<C-u>Iterm<CR>
elseif s:is_win "{{{3
  " Utility command for Windows
  if &shell =~ 'sh\(\.exe\)\?$'
    command! Here silent execute '!explorer' "'".substitute(expand('%:p:h'), '/', '\\', 'g')."'" '&'
    command! This silent execute '!start cmd /c "%"'
    command! In silent execute "!start cmd /k cd '".substitute(expand('%:p:h'), '/', '\\', 'g')."'"
  else
    command! Here silent execute '!explorer' substitute(expand('%:p:h'), '/', '\\', 'g') '&'
    command! This silent execute '!start cmd /c "%"'
    command! In silent execute '!start cmd /k cd "'.substitute(expand('%:p:h'), '/', '\\', 'g').'"'
  endif
  if exists(':tmap')
    command! PowerShell terminal ++close ++curwin powershell
    command! Bash terminal ++close ++curwin C:/Windows/System32/bash.exe -c "cd; bash -l"
  endif
  command! -nargs=1 -complete=file That silent execute '!explorer' shellescape(expand(<f-args>), 1)
else "{{{3
  " command! Here silent execute '!gnome-open' expand('%:p:h')
  command! Here silent execute '!xdg-open' expand('%:p:h') '&'
  command! This silent execute '!"%"'
  if executable('gnome-terminal')
    command! In silent execute '!gnome-terminal --working-directory="'.shellescape(expand('%:p:h')).'"' '&'
  elseif executable('konsole')
    command! In silent execute '!konsole --workdir="'.shellescape(expand('%:p:h')).'"' '&'
  else
    command! In silent execute '!kterm -e "cd '.shellescape(expand('%:p:h')).'; exec $SHELL"' '&'
  endif
  command! -nargs=1 -complete=file That silent execute '!xdg-open' shellescape(expand(<f-args>), 1) '&'
  command! -nargs=1 ActivateWindow silent execute "!togwin \"<args>\"' &"
endif
"}}}

" unique {{{2
command! -range -nargs=0 UniqueSort <line1>,<line2>sort u

" diff {{{2
function! s:exe_if_diff(s)
  if &diff
    execute a:s
  endif
endfunction
command! -nargs=0 DiffQuit call s:exe_if_diff('diffoff')
command! -nargs=0 DQ call s:exe_if_diff('diffoff')
MyAutoCmd InsertLeave * call s:exe_if_diff('diffupdate')

" rename {{{2
command! -nargs=? -complete=file Rename call my#command#rename(<q-args>)
command! -nargs=1 -complete=file Relcp call my#command#relative_copy(<f-args>)

" win maximize toggle {{{3
nnoremap ,mm :call my#winmaximizer#get().toggle()<CR>
nnoremap ,mj :call my#winmaximizer#get().toggleDirection("v")<CR>
nnoremap ,mh :call my#winmaximizer#get().toggleDirection("h")<CR>

" fopen & encoding {{{2
command! -nargs=? -bang -complete=file Utf8 edit<bang> ++enc=utf-8 <args>
command! -nargs=? -bang -complete=file Euc  edit<bang> ++enc=euc-jp <args>
command! -nargs=? -bang -complete=file Sjis edit<bang> ++enc=cp932 <args>
command! -nargs=? -bang -complete=file Jis  edit<bang> ++enc=iso-2022-jp <args>
command! -nargs=? -bang -complete=file Dos  edit<bang> ++ff=dos <args>
command! -nargs=? -bang -complete=file Mac  edit<bang> ++ff=mac <args>
command! -nargs=? -bang -complete=file Unix edit<bang> ++ff=unix <args>

" }}}
" utility {{{2
" TSV {{{3
command! -range Tsvtohtmltable     <line1>,<line2>call my#tsv#to_htmltable()
command! -range Tsvtosqlwhere      <line1>,<line2>call my#tsv#to_sqlwhere()
command! -range Tsvtosqlin         <line1>,<line2>call my#tsv#to_sqlin()
command! -range Tsvinvert          <line1>,<line2>call my#tsv#invert()
command! -range Tsvtosqlinsert     <line1>,<line2>call my#tsv#to_sqlinsert()
command! -range Tsvtosqlupdate     <line1>,<line2>call my#tsv#to_sqlupdate()
command! -range Tsvtocsv           <line1>,<line2>call my#tsv#to_csv()
command! -range Tsvtojson          <line1>,<line2>call my#tsv#to_json()
command! -range Tsvtoflatjson      <line1>,<line2>call my#tsv#to_flat_json()
command! -nargs=0 ExcelTsvNormalizeVlookup call my#tsv#excel_tsv_normalize_vlookup()

" MySQL {{{3
command! -nargs=0 -range TMY <line1>,<line2>call my#mysql#to_tsv()
command! -nargs=0 -range MySQLToTsv <line1>,<line2>call my#mysql#to_tsv()

" text {{{3
command! -nargs=0 -range=0 Plain call my#buffer#normalize_ascii_selected(<count>, <line1>, <line2>)

" padding {{{3
command! -nargs=? -range PadNumber <line1>,<line2>call my#padding#number(<f-args>)
command! -nargs=? -range PadString <line1>,<line2>call my#padding#string(<f-args>)
command! -nargs=? -range PadSprintf <line1>,<line2>call my#padding#sprintf(<f-args>)

" Browser Control
if s:is_mac
  command! -bar ChromePageGo silent !osascript ~/.vim/bin/chrome_go.scpt 1
  command! -bar ChromePageBack silent !osascript ~/.vim/bin/chrome_go.scpt -1
  command! -bar ChromeScrollDown silent !osascript ~/.vim/bin/chrome_scroll.scpt next
  command! -bar ChromeScrollUp silent !osascript ~/.vim/bin/chrome_scroll.scpt previous
  command! -bar ChromeTabClose silent !osascript ~/.vim/bin/chrome_tabclose.scpt next
  command! -bar ChromeTabReload silent !osascript ~/.vim/bin/chrome_reload.scpt next
  command! -bar ChromeTabRight silent !osascript ~/.vim/bin/chrome_tabselect.scpt right
  command! -bar ChromeTabLeft silent !osascript ~/.vim/bin/chrome_tabselect.scpt left
else
  " TODO :
endif

" gtrans {{{2
command! -nargs=? -range=0 Gte call my#buffer#gtrans(<count>, <line1>, <line2>, "enja", <q-args>)
command! -nargs=? -range=0 Gtj call my#buffer#gtrans(<count>, <line1>, <line2>, "jaen", <q-args>)

" ginger {{{2
command! -nargs=? -range=0 Ginger call my#buffer#ginger(<count>, <line1>, <line2>, <q-args>)

" dash & zeal {{{2
if s:is_mac
  command! -nargs=? -complete=customlist,my#docset#dash_complete Dash call my#docset#dash(<f-args>)
  command! -nargs=? DashFiletype call my#docset#dash_with_filetype(<f-args>)
  nnoremap <Plug>(dash) :Dash<Space>
  nnoremap <Plug>(dash-cword) :<C-u>Dash<Space><C-r>=expand('<cword>')<CR><CR>
  nnoremap <Plug>(dash-filetype-cword) :<C-u>DashFiletype<Space><C-r>=expand('<cword>')<CR><CR>
  command! -nargs=0 DashRemoveCace call my#docset#docset_cache_remove()
endif

if executable('zeal')
  command! -nargs=? -complete=customlist,my#docset#zeal_complete Zeal call my#docset#zeal(<f-args>)
  command! -nargs=? ZealFiletype call my#docset#zeal_with_filetype(<f-args>)
  nnoremap <Plug>(zeal) :<C-u>Zeal<Space>
  nnoremap <Plug>(zeal-cword) :<C-u>Zeal<Space><C-r>=expand('<cword>')<CR><CR>
  nnoremap <Plug>(zeal-filetype-cword) :ZealFiletype<Space><C-r>=expand('<cword>')<CR><CR>
  command! -nargs=0 ZealRemoveCache call my#docset#docset_cache_remove()

  nmap [!space]ss <Plug>(zeal)
  nmap [!space]sw <Plug>(zeal-filetype-cword)
  if s:is_mac
    nmap <D-k> <Plug>(zeal-filetype-cword)
  else
    nmap <A-k> <Plug>(zeal-filetype-cword)
  endif
endif

" onsave {{{2
let g:autoexec = {
\ 'coffee': 'coffee -c %:p',
\ 'scss': 'sass -scss --compass compile %:p > %:p:r.css',
\ 'sass': 'sass --compass compile %:p > %:p:r.css',
\ 'less': 'lessc %:p %:p:r.css',
\ }
augroup vimrc-autoexec
  autocmd!
augroup END

function! s:autoexec_format_command(args)
  if empty(a:args)
    let command = get(g:autoexec, &filetype, '')
  else
    let command = join(a:args, " ")
  endif
  if empty(command)
    return command
  endif
  return substitute(command, '%\(:\w\)*', '\=expand(submatch(0))', 'g')
endfunction

function! s:autoexec(bang, ...)
  if a:bang
    autocmd! vimrc-autoexec * <buffer>
  endif
  " TODO : quickrun eco system
  let command = s:autoexec_format_command(a:000)
  if empty(command)
    autocmd vimrc-autoexec
    return
  endif
  if g:vimrc_enabled_plugins.vimproc
    execute 'autocmd vimrc-autoexec BufWritePost <buffer> call vimproc#system_bg('.string(command).')'
  else
    autocmd vimrc-autoexec BufWritePost <buffer> execute '!' command
  endif
  autocmd! vimrc-autoexec BufUnload <buffer> autocmd! vimrc-autoexec * <buffer>
endfunction

command! -nargs=* -bang Autoexec call s:autoexec(<bang>0, <f-args>)
command! -nargs=* -bang AutoexecStatus autocmd vimrc-autoexec

" ctags {{{2
command! -nargs=0 CTagsConfigSample call my#ctags#show()

" verbose {{{2
function! s:set_verbose(off)
  if (a:off)
    set verbose=0
    set verbosefile=
  else
    set verbose=99
    set verbosefile=~/vim-verbosefile.log
  endif
endfunction
command! -nargs=0 -bang VerboseOn call s:set_verbose("<bang>")
command! -nargs=0 VerboseOff call s:set_verbose("1")

" for vim {{{2
command! -nargs=0 ThisSyntaxName echo synIDattr(synID(line("."), col("."), 1), "name")
command! -nargs=0 ThisSyntax echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

" coding style {{{2
" http://vim-users.jp/2010/05/hack149/
let g:vimrc_coding_styles = {
  \ 'Standard'      : 'expandtab   tabstop=4 shiftwidth=4 softtabstop&',
  \ 'Short indent'  : 'expandtab   tabstop=2 shiftwidth=2 softtabstop&',
  \ 'GNU'           : 'expandtab   tabstop=8 shiftwidth=2 softtabstop=2',
  \ 'BSD'           : 'noexpandtab tabstop=8 shiftwidth=4 softtabstop&',
  \ 'Linux'         : 'noexpandtab tabstop=8 shiftwidth=8 softtabstop&',
  \ }

command!
\   -bar -nargs=1 -complete=customlist,my#command#coding_style_complete
\   CodingStyle
\   call my#command#coding_style("<bang>", get(g:vimrc_coding_styles, <f-args>, ''))

let s:q = "['\"]"
let s:pattern_replace = {
\ 'DateTime2now' : join(['%s!', s:q, '\d\{4\}-\d\{2\}-\d\{2\}\( \d\{2\}:\d\{2\}:\d\{2\}\)\?', s:q, '!now()!g'], ''),
\ }

function! s:replace_pattern(bang, arg) "{{{
  if empty(a:arg)
    return
  endif
  execute a:arg
endfunction
function! s:replace_pattern_complete(A, L, P) "{{{
  return filter(keys(s:pattern_replace),'v:val =~? "^".a:A')
endfunction "}}}
command! -bar -nargs=1 -complete=customlist,s:replace_pattern_complete ReplacePattern
  \ call s:replace_pattern("", get(s:pattern_replace, <f-args>, ''))

" util {{{2
command! -nargs=0 ToScratch call my#buffer#set_scratch()
command! -nargs=0 HtmlCommentRemove call my#command#remove_html_comment()
function! s:vimrc_file_pos(l1, l2)
  let line = a:l1 == a:l2 ? line('.') : a:l1 . "-" . a:l2
  let root = substitute(system(printf('cd %s && git rev-parse --show-toplevel 2>/dev/null', expand('%:p:h'))), '[\r\n]\+', '', '')
  let fpath = expand('%:p')
  if !empty(root)
    let fpath = substitute(fpath[len(root):], '^/\+', '', '')
  endif

  let s = fpath . ":" . line
  if has('gui_running')
    let @+=s
  elseif exists(':FakeclipDefaultKeyMappings')
    let sid = fakeclip#_sid_prefix()
    if $DISPLAY || s:is_mac || s:is_win
      call {sid}write_clipboard(s)
    else
      call {sid}write_pastebuffer(s)
    endif
  else
    echo s . "\n"
  endif
endfunction
command! -range FilePos call s:vimrc_file_pos(<line1>, <line2>)

function! s:vimrc_yank_line_with_no(l1, l2)
  let l = strlen(a:l2)
  let lines = map(getline(a:l1, a:l2), 'printf("%".l."d: %s", a:l1 + v:key, v:val)')
  let s = join(lines, "\n")
  if has('gui_running')
    let @+=s
  elseif exists(':FakeclipDefaultKeyMappings')
    let sid = fakeclip#_sid_prefix()
    if $DISPLAY || s:is_mac || s:is_win
      call {sid}write_clipboard(s)
    else
      call {sid}write_pastebuffer(s)
    endif
  else
    echo s . "\n"
  endif
endfunction
command! -range YankLineNo call s:vimrc_yank_line_with_no(<line1>, <line2>)


" errorformat tester {{{2
let g:efm_tester_fmt = '%f:%l:%c:%m'
let g:efm_tester_after_execute = 'cwindow'
command! -nargs=? -range=0 EfmTest call my#efm_tester#eval_text(<count>, <line1>, <line2>, <q-args>)
command! -nargs=? -range=0 EfmSetFormat call my#efm_tester#set_format(<count>, <line1>, <line2>, <q-args>)

" after initializes {{{1
if !has('vim_starting')
  if has('gui_running')
    execute 'source' expand("~/.gvimrc")
  endif

  if s:bundle.is_sourced('lightline')
    call lightline#update()
  endif
else
  " call neobundle#call_hook('on_source')
endif
" __END__ {{{1
" vim: set ft=vim fdm=marker sw=2 ts=2 et:
