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

if v:version > 703 || (v:version == 703 && has('patch970'))
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
if v:version > 704 || (v:version == 704 && has('patch088'))
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
  function! g:EnableVsplitMode()
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

  map <expr> <t_F9> g:EnableVsplitMode()
  let &t_RV .= "\e[?6;69h\e[1;3s\e[3;9H\e[6n\e[0;0s\e[?6;69l"
endif

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

MyAutoCmd BufEnter,BufRead * call <SID>autochdir()
if !exists('g:my_lcd_autochdir')
  let g:my_lcd_autochdir = 1
endif

function! s:find_proj_dir() "{{{3
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
    return pjdir
  endif
  return cdir
endfunction

function! s:autochdir() "{{{3
  if expand('%') == '' && &buftype =~ 'nofile'
    return
  elseif g:my_lcd_autochdir
    if !exists('b:my_lcd_current_or_prj_dir')
      let b:my_lcd_current_or_prj_dir = s:find_proj_dir()
      if b:my_lcd_current_or_prj_dir != '' && isdirectory(b:my_lcd_current_or_prj_dir)
        execute 'lcd' fnameescape(b:my_lcd_current_or_prj_dir)
      endif
    endif
  endif
endfunction

" diff {{{2
set diffopt& diffopt-=filler diffopt+=iwhite diffopt+=vertical
set diffexpr=GitDiffNormal()
function! GitDiffNormal()
  let args=["git-diff-normal", '--diff-algorithm=histogram']
  if &diffopt =~ "iwhite"
    call add(args, '--ignore-all-space')
  endif
  let args += [v:fname_in, v:fname_new, '>', v:fname_out]
  let cmd='!' . join(args, ' ')
  silent execute cmd
  redraw!
endfunction

" 表示周り {{{2
set lazyredraw ttyfast
set scrolloff=10000000         " 中央に表示
set sidescrolloff=999
set number                     " 行番号の表示
set ruler

set mouse=nch                  " use mouse normal/command/help
" set mouse=a
" set mouse=nv
set nomousefocus
set mousehide
set timeoutlen=1000
set ttimeoutlen=100

set showmatch                  " 対応する括弧の表示
set showcmd                    " 入力中のコマンドを表示
set showfulltag
set backspace=indent,eol,start " BSでなんでも削除
set nolinebreak
set textwidth=1000
set formatoptions& formatoptions+=mM
set whichwrap=b,s,h,l,<,>,[,]  " 行頭・行末間移動を可能に
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
if has('linebreak') && (v:version > 704 || v:version == 704 && has('patch338'))
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
set nowrap     " 折り返しなし
set nrformats-=octal
set updatetime=200
if has('winaltkeys')
  set winaltkeys=no
endif
set modeline
set modelines=10

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
  MyAutoCmd VimLeave * let &l:t_Co=s:t_Co
else
  set t_Co=256
endif
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
" set t_Co=256
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
if has('vim_starting')
  " pathogen
  " call pathogen#infect()
  set runtimepath+=~/.vim/neobundle.vim
  let g:neobundle#log_filename = $VIM_CACHE . '/neobundle.log'
  " let g:neobundle#default_options._ = { 'verbose' : 1, 'focus' : 1 }

  " http://blog.supermomonga.com/articles/vim/neobundle-sugoibenri.html {{{3
  let s:bundle = {'uninstalled':{}, 'vimrc_installed':[]}
  function! s:bundle.tap(bundle) " {{{
    let self.tapped = neobundle#get(a:bundle)
    return self.is_installed(a:bundle)
  endfunction " }}}

  function! s:bundle.get(bundle) "{{{
    return neobundle#get(a:bundle)
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
    return neobundle#is_sourced(a:name)
  endfunction "}}}

  function! s:bundle.is_installed(name) "{{{
    let ret = neobundle#is_installed(a:name)
    if !ret
      let self.uninstalled[a:name] = 1
    endif
    return ret
  endfunction "}}}

  function! s:bundle.summary_report() "{{{
    let bundles = neobundle#config#get_neobundles()
    let msgs = [
    \ printf("Installed   : %d", len(bundles)),
    \ printf("Enabled     : %d", len(filter(copy(bundles), '!v:val.lazy'))),
    \ printf("Lazy        : %d", len(filter(copy(bundles), 'v:val.lazy'))),
    \ printf("Not Sourced : %d", len(filter(copy(bundles), '!v:val.sourced'))),
    \ printf("Sourced     : %d", len(filter(copy(bundles), 'v:val.sourced'))),
    \ printf("\n### Sourced plugins\n%s", join(map(
    \   filter(copy(bundles), 'v:val.lazy && v:val.sourced'),
    \   'v:val.name'), "\n")),
    \ printf("\n### Uninstalled plugins\n%s", join(keys(self.uninstalled), "\n")),
    \ ]
    echo join(msgs, "\n")
  endfunction " }}}

  function! s:bundle.validate_report() "{{{
    let bundles = neobundle#config#get_neobundles()
    let lazies = filter(copy(bundles), 'v:val.lazy && v:val.sourced')
    let plugins = []
    for item in lazies
      if isdirectory(item.path . '/plugin')
        continue
      endif
      call add(plugins, item)
    endfor
    if !empty(plugins)
      echo printf("Following plugins looks good should not be Lazy\n%s",
            \ join(map(plugins, 'v:val.name'), "\n"))
    else
      echo "Finish validate"
    endif
  endfunction " }}}

  command! NeoBundleSummary call s:bundle.summary_report()
  command! NeoBundleValidate call s:bundle.validate_report()
endif

" load neobundle {{{2
" set nocompatible
" filetype off
call neobundle#begin(expand("~/.vim/neobundle"))
NeoBundleLocal ~/.vim/bundle

" vundles {{{2
" vundle start
if neobundle#load_cache($MYVIMRC)
" statusline {{{3
NeoBundle 'itchyny/lightline.vim'

" colorscheme {{{3
NeoBundle 'tpope/vim-vividchalk', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'tomasr/molokai', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'mopp/mopkai.vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'mrkn/mrkn256.vim', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'fmoralesc/vim-vitamins', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'morhetz/gruvbox', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'vim-scripts/Lucius', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'jaromero/vim-monokai-refined', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'freeo/vim-kalisi', {'autoload': {'unite_sources':['colorscheme']}}
NeoBundle 'w0ng/vim-hybrid', {'autoload': {'unite_sources':['colorscheme']}}

" common {{{3
NeoBundleLazy 'osyo-manga/vim-jplus', {'autoload':{
\ 'mappings' : [['nv',
\   '<Plug>(jplus-getchar)', '<Plug>(jplus-getchar-with-space)',
\   '<Plug>(jplus-input)', '<Plug>(jplus-input-with-space)',
\ ]]}}
NeoBundle 'Shougo/context_filetype.vim'
NeoBundle 'Shougo/tabpagebuffer.vim'
NeoBundle 'Shougo/vimfiler.vim', {
\ 'depends': 'Shougo/unite.vim', 'autoload' : {
\ 'commands' : [
\ { 'name': 'VimFiler', 'complete': 'customlist,vimfiler#complete' },
\ { 'name': 'VimFilerTab', 'complete': 'customlist,vimfiler#complete' },
\ { 'name': 'VimFilerBufferDir', 'complete': 'customlist,vimfiler#complete' },
\ { 'name': 'VimFilerExplorer', 'complete': 'customlist,vimfiler#complete' },
\ { 'name': 'Edit', 'complete': 'customlist,vimfiler#complete' },
\ { 'name': 'Write', 'complete': 'customlist,vimfiler#complete' },
\ 'Read', 'Source'],
\ 'mappings' : ['<Plug>(vimfiler'],
\ 'explorer' : 1,
\ }}
if s:is_win
  NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \ 'windows' : executable('nmake') ?
  \   $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' . 'nmake -f Make_msvc.mak nodebug=1'
  \   : 'make -f make_mingw' . (has('win64') ? 64 : 32) . '.mak' ,
  \ 'cygwin' : 'make -f make_cygwin.mak',
  \ }}
else
  NeoBundle 'Shougo/vimproc.vim', {
  \ 'build' : {
  \ 'windows' : $VCVARSALL . ' ' . $PROCESSOR_ARCHITECTURE . ' & ' .
  \ 'nmake -f Make_msvc.mak nodebug=1',
  \ 'cygwin' : 'make -f make_cygwin.mak',
  \ 'mac'    : 'make -f make_mac.mak',
  \ 'unix'   : 'make -f make_unix.mak',
  \ }}
endif
NeoBundle 'Shougo/vimshell.vim', {
\ 'depends': 'Shougo/vimproc.vim', 'autoload' : {
\ 'commands' : [{ 'name' : 'VimShell',
\ 'complete' : 'customlist,vimshell#complete'},
\   'VimShellExecute', 'VimShellInteractive',
\   'VimShellTerminal', 'VimShellPop'],
\ 'mappings' : ['<Plug>(vimshell']
\ }}
NeoBundle "osyo-manga/unite-filters-collection"
" NeoBundle 'osyo-manga/vim-precious'
NeoBundle 'pekepeke/vim-gitcomplete', 'develop'
if has('python') || has('python3')
  NeoBundleLazy 'Shougo/vinarise', { 'autoload': {
  \ 'commands' : [
  \ {'name' : 'Vinarise',
  \  'complete' : 'customlist,vinarise#complete'},
  \ {'name' : 'VinariseDump',
  \  'complete' : 'customlist,vinarise#complete'},
  \ {'name' : 'VinariseScript2Hex',
  \  'complete' : 'customlist,vinarise#complete'}],
  \ 'unite_sources' : 'vinarise/analysis'
  \ },
  \ }
endif
NeoBundleLazy 'Shougo/junkfile.vim', { 'autoload' : {
\ 'commands' : ['JunkfileOpen'],
\ 'unite_sources' : ['junkfile', 'junkfile/new'],
\ }}
NeoBundle 'kana/vim-altr', {'autoload': {
\ 'mappings': ['<Plug>(altr-',],
\ }}
NeoBundle 'kana/vim-fakeclip'
NeoBundle 'kana/vim-smartchr', {'autoload': {'insert':1}}
NeoBundle 'kana/vim-submode'
NeoBundle 'kana/vim-niceblock', { 'autoload' : {
\ 'mappings' : ['<Plug>(niceblock-',]
\ }}
NeoBundle 'tyru/vim-altercmd'
NeoBundle 'cohama/lexima.vim', {'autoload': {'insert':1}}
" NeoBundle 'kana/vim-smartinput', {'autoload': {'insert':1}}
NeoBundleLazy 'tyru/capture.vim', {'autoload': {
\ 'commands': [{'name':'Capture', 'complete':'command'}],
\ }}
NeoBundle 'chikatoike/concealedyank.vim', { 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-concealedyank)']]
\ }}
NeoBundle 'pekepeke/quickfixstatus', {'autoload': {
\ 'commands': ['QuickfixStatusEnable', 'QuickfixStatusDisable'],
\ }}
NeoBundle 'cohama/vim-hier', {'autoload':{
\ 'commands': ['HierUpdate', 'HierClear', 'HierStart', 'HierStop',],
\}}
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-surround'
NeoBundle 't9md/vim-surround_custom_mapping'

" NeoBundleLazy 'tpope/vim-abolish', {'autoload': {
" \ 'commands': [
" \ {'name': 'Abolish'}, {'name': 'Subvert'},
" \ ],
" \ 'mappings': [['n', '<Plug>Coerce']]
" \ }}
NeoBundle 'tpope/vim-dispatch', {'autoload': {
\ 'commands': [
\ {'name': 'FocusDispatch', 'complete': 'custom,dispatch#command_complete'},
\ {'name': 'Dispatch', 'complete': 'custom,dispatch#command_complete'},
\ {'name': 'Start', 'complete': 'custom,dispatch#command_complete'},
\ {'name': 'Make', 'complete': 'file'},
\ {'name': 'Copen'},
\ ],
\ }}
" NeoBundle 'rhysd/endwize.vim', {'autoload': {'insert':1}}
NeoBundleLazy 't9md/vim-quickhl', {'autoload': {
\ 'commands': [
\ 'QuickhlManualEnable', 'QuickhlManualDisable', 'QuickhlManualList',
\ 'QuickhlManualReset', 'QuickhlManualColors', 'QuickhlManualAdd',
\ 'QuickhlManualDelete', 'QuickhlManualLock', 'QuickhlManualUnlock',
\ 'QuickhlManualLockToggle', 'QuickhlManualLockWindow', 'QuickhlManualUnlockWindow',
\ 'QuickhlManualLockWindowToggle', 'QuickhlCwordEnable', 'QuickhlCwordDisable',
\ 'QuickhlCwordToggle', 'QuickhlTagEnable', 'QuickhlTagDisable',
\ 'QuickhlTagToggle',
\ ],
\ 'function_prefix':'quickhl',
\ 'mappings': [['nv', '<Plug>(quickhl-',
\ '<Plug>(operator-quickhl-manual-this-motion)']],
\ }}
NeoBundleLazy 'bkad/CamelCaseMotion', { 'autoload' : {
\ 'mappings' : ['<Plug>CamelCaseMotion_w',
\ '<Plug>CamelCaseMotion_b'],
\ }}
NeoBundleLazy 'h1mesuke/vim-alignta', {'autoload': {
\ 'commands': [
\ {'name': 'Align'},
\ {'name': 'Alignta'},
\ ],
\ 'unite_sources': ['alignta']
\ }}
NeoBundle 'nishigori/increment-activator'
NeoBundle 'tpope/vim-speeddating', {'autoload': {
\ 'mappings' : [['nv', '<Plug>SpeedDatingUp', '<Plug>SpeedDatingDown'],
\ ['n', '<Plug>SpeedDatingNowLocal', '<Plug>SpeedDatingNowUTC']],
\ 'commands' : ['SpeedDatingFormat']
\ }}
NeoBundleLazy 'AndrewRadev/splitjoin.vim', {'autoload': {
\ 'commands': ['SplitjoinJoin', 'SplitjoinSplit'],
\ }}
NeoBundleLazy 'AndrewRadev/inline_edit.vim', {'autoload': {
\ 'commands': [
\ {'name': 'InlineEdit'},
\ ],
\ }}
NeoBundle 'rhysd/clever-f.vim', {'autoload': {
\ 'mappings': [
\ '<Plug>(clever-f-',
\ ]}}
NeoBundle 't9md/vim-smalls', {'autoload': {
\ 'mappings': [['nxo', '<Plug>(smalls']]
\ }}
if s:is_win
  NeoBundle 'sgur/vim-lazygutter'
else
  " NeoBundle 'mhinz/vim-signify'
  NeoBundle 'tomtom/quickfixsigns_vim', {
  \ 'depends': ['tomtom/tlib_vim'],
  \ }
endif
if has('python')
  NeoBundle 'editorconfig/editorconfig-vim'
endif
NeoBundleLazy 'glidenote/memolist.vim', {'autoload': {
\ 'commands': ['MemoNew', 'MemoGrep', 'MemoList']
\ }}
NeoBundle 'pekepeke/vim-trimr'
" NeoBundleLazy 'othree/eregex.vim', { 'autoload': {
" \ 'commands': ['E2v', 'M', 'S', 'G', 'V'],
" \ }}
NeoBundle 'mbbill/undotree'
" NeoBundle 'sjl/gundo.vim'
NeoBundle 'kana/vim-smartword', { 'autoload' : {
\ 'mappings' : [['nv',
\ '<Plug>(smartword-',
\ ]]}}
NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'thinca/vim-localrc'
NeoBundleLazy 'thinca/vim-prettyprint', { 'autoload': {
\ 'commands' : [
\   { 'name' : 'PP', 'complete': 'expression'},
\   { 'name' : 'PrettyPrint', 'complete': 'expression'},
\ ]}}
NeoBundle 'thinca/vim-ambicmd'
NeoBundle 'deris/vim-rengbang', {'autoload':{
\ 'commands': ['RengBang'],
\ 'mappings': ['<Plug>(operator-rengbang'],
\ }}
NeoBundle 'nathanaelkane/vim-indent-guides'
" if has('conceal') && !s:is_mac
"   NeoBundle 'Yggdroot/indentLine'
" endif

NeoBundle 'vim-scripts/sudo.vim'
if s:is_win
  NeoBundleLazy 'mattn/startmenu-vim', {'autoload': {
  \ 'unite_sources':['startmenu']
  \ }}
elseif s:is_mac
  NeoBundleLazy 'rhysd/unite-mac-apps', {'autoload': {
  \ 'unite_sources':['apps']
  \ }}
endif
NeoBundle 'koron/codic-vim'
NeoBundleLazy 'rhysd/unite-codic.vim', {'autoload': {
\ 'unite_sources': 'codic',
\ }}

" lang {{{3
" basic {{{4
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'mattn/quickrunex-vim'
NeoBundleLazy 'mattn/emoji-vim', {'autoload': {
\ 'commands': ['Emoji'],
\ 'mappings': [['in', '<plug>(emoji-selector']],
\ }}
NeoBundle 'osyo-manga/shabadou.vim'
NeoBundle 'osyo-manga/vim-watchdogs'
NeoBundle 'tokorom/vim-quickrun-xctool'
NeoBundle 'manicmaniac/vim-quickrun-qo'
NeoBundle 'osyo-manga/vim-anzu', {'autoload': {
\ 'mappings': [['n', '<Plug>(anzu-']],
\ }}
" NeoBundle 'kien/rainbow_parentheses.vim'
" NeoBundle 'oblitum/rainbow'
NeoBundle 'luochen1990/rainbow'
NeoBundle 'vim-scripts/matchit.zip', {'autoload': {
\ 'mappings' : [['nx', '%']],
\ }}
NeoBundle 'gregsexton/MatchTag'
NeoBundle 'tpope/vim-unimpaired'
NeoBundleLazy 'vim-scripts/ShowMultiBase', {'autoload':{
\ 'commands': ['ShowMultiBase'],
\ }}
" NeoBundle 'tyru/current-func-info.vim'
if s:is_win
  NeoBundleLazy 'majutsushi/tagbar'
else
  NeoBundle 'majutsushi/tagbar'
endif
" NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'tpope/vim-commentary', {'autoload': {
\ 'mappings': [
\   ['xn', '<Plug>Commentary'],
\   ['n', '<Plug>Commentary'],
\ ],
\ }}
NeoBundle 'tpope/vim-projectionist'
NeoBundle 'thinca/vim-template'
NeoBundle 'mattn/sonictemplate-vim', {'autoload': {
\ 'commands': [
\   {'name': 'Template', 'complete': 'complete=customlist,sonictemplate#complete'},
\   {'name': '', 'complete': 'complete=customlist,sonictemplate#complete'},
\ ],
\ 'mappings': [
\   ['in', '<plug>(sonictemplate)', '<plug>(sonictemplate-intelligent)'],
\ ],
\ 'unite_sources': ['sonictemplate'],
\ }}
" NeoBundle 'ciaranm/detectindent', {'autoload': {
" \ 'commands' : ['DetectIndent'],
" \ }}
NeoBundle 'ujihisa/shadow.vim'
NeoBundle 'mhinz/vim-hugefile'
NeoBundle 'tpope/vim-git'
NeoBundle 'tpope/vim-fugitive', {'autoload':{
\ 'commands': [ "Git", "Gstatus", "Gcommit", "Gedit",
\   "Gwrite", "Ggrep", "Glog", "Gdiff"],
\ }}
NeoBundle 'rhysd/committia.vim'
NeoBundle 'idanarye/vim-merginal', {'autoload':{
\ 'commands': [ "Merginal", "MerginalToggle", "MerginalClose",],
\ }}
NeoBundle 'AndrewRadev/gapply.vim', {'autoload':{
\ 'commands': [ "Gapply",],
\ }}

" NeoBundleLazy 'gregsexton/gitv', {'autoload': {
" \ 'commands' : ['Gitv'],
" \ }}
NeoBundle 'cohama/agit.vim', {'autoload': {
\ 'commands': ['Agit', 'AgitGit', 'AgitFile'],
\ }}
NeoBundle 'rhysd/git-messenger.vim', {
\ 'gui': 1,
\ }
NeoBundleLazy 'vim-scripts/DirDiff.vim', {'autoload': {
\ 'commands' : [
\   'DirDiffOpen', 'DirDiffNext', 'DirDiffPrev',
\   'DirDiffUpdate', 'DirDiffQuit',
\   {'name': 'DirDiff', 'complete': 'dir'},
\ ],
\ }}
NeoBundle 'vim-scripts/diffchar.vim'
NeoBundleLazy 'AndrewRadev/linediff.vim', {'autoload': {
\ 'commands': ['Linediff', 'LinediffReset'],
\ }}
NeoBundle 'vim-scripts/ConflictDetection', {
\ 'depends': 'vim-scripts/ingo-library',
\ }
if has('python')
  NeoBundleLazy 'joonty/vdebug.git', {'autoload': {
  \ 'commands': [
  \ "VdebugStart", "Breakpoint",
  \ "BreakpointRemove", "BreakpointWindow",
  \ "VdebugEval", "VdebugOpt",
  \ ],
  \ }}
endif

" help {{{4
NeoBundle 'thinca/vim-ref', { 'autoload' : {
\ 'commands' : {
\   'name' : 'Ref',
\   'complete' : 'customlist,ref#complete',
\ },
\ 'unite_sources' : [
\   'ref/erlang', 'ref/man', 'ref/perldoc',
\   'ref/phpmanual', 'ref/pydoc', 'ref/redis', 'ref/refe', 'ref/webdict'
\ ],
\ 'mappings' : ['n', 'K', '<Plug>(ref-']
\ }}
NeoBundle 'pekepeke/ref-javadoc', {
\ 'depends': 'thinca/vim-ref', 'autoload': {
\ 'unite_sources': [
\   'ref/javadoc',
\ ], }}
NeoBundle 'soh335/vim-ref-jquery', {
\ 'depends': 'thinca/vim-ref', 'autoload': {
\ 'unite_sources': [
\   'ref/jquery',
\ ], }}
NeoBundle 'taka84u9/vim-ref-ri', {
\ 'depends': 'thinca/vim-ref', 'autoload': {
\ 'unite_sources': [
\   'ref/ri',
\ ], }}
NeoBundle 'mfumi/ref-dicts-en'
" NeoBundle 'nishigori/vim-ref-phpunit'
" NeoBundle 'eiiches/vim-ref-gtkdoc'
" NeoBundle 'eiiches/vim-ref-info'
" NeoBundle 'mojako/ref-sources.vim'

" vim {{{4
NeoBundle 'kana/vim-vspec'
NeoBundleLazy 'vim-jp/vital.vim', {'autoload': {
\ 'commands': [{
\ 'name': 'Vitalize', 'complete':'customlist,vitalizer#complete'
\ }]
\ }}

" vim-help {{{4
NeoBundle 'mattn/learn-vimscript'

" completion {{{4
NeoBundleLazy 'm2ym/rsense', {
\ 'rtp' : 'etc',
\ 'build' : {
\    'mac': 'ruby etc/config.rb > ~/.rsense',
\    'unix': 'ruby etc/config.rb > ~/.rsense',
\ } }
" if !s:bundle.is_installed('rsense')
"   NeoBundle "osyo-manga/vim-monster"
" endif
if 0 && has('python')
  NeoBundle 'Valloric/YouCompleteMe', {
    \ 'build': {
    \   'mac': './install.sh --clang-completer --omnisharp-completer',
    \   'unix': './install.sh --clang-completer --system-libclang --system-boost --omnisharp-completer',
    \ }}
elseif has('lua') && (v:version > 703 ||
      \ (v:version == 703 && has('patch885')))
  NeoBundle 'Shougo/neocomplete.vim', {'autoload':{
  \ 'insert':1,
  \ 'unite_sources': ['neocomplete'],
  \ }}
  if s:bundle.is_installed('rsense')
    NeoBundle 'supermomonga/neocomplete-rsense.vim'
  endif
else
  NeoBundle 'Shougo/neocomplcache.vim', {'autoload':{
  \ 'insert':1,
  \ }}
  if s:bundle.is_installed('rsense')
    NeoBundle 'Shougo/neocomplcache-rsense.vim'
  endif
endif
NeoBundle 'Shougo/neosnippet.vim', {
\ 'lazy' : 1,
\ 'autoload' : {
\ 'commands' : ['NeoSnippetEdit', 'NeoSnippetSource'],
\ 'insert' : 1,
\ 'filetypes' : 'snippet',
\ 'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
\ }}
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'hrsh7th/vim-neco-calc'

" ruby {{{4
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails', {'autoload':{
\ 'filetypes': ['ruby','haml','eruby'],
\ }}
NeoBundle 'tpope/vim-bundler', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}
NeoBundle 'hallison/vim-ruby-sinatra'
" NeoBundle 'taq/vim-rspec'
" NeoBundleLazy 'skwp/vim-rspec', {'autoload': {
"       \ 'commands' : ['RunSpec', 'RSpecLine', 'RunSpecs', 'RunSpecLine']
"       \ }}
NeoBundleLazy 'alpaca-tc/neorspec.vim', {
\ 'depends' : ['alpaca-tc/vim-rails', 'tpope/vim-dispatch'],
\ 'autoload' : {
\   'commands' : ['RSpec', 'RSpecAll', 'RSpecCurrent', 'RSpecNearest', 'RSpecRetry']
\ }}
NeoBundle 'ecomba/vim-ruby-refactoring', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}

NeoBundle 'tpope/vim-cucumber'
NeoBundle 'yaymukund/vim-rabl'
NeoBundle 'vim-scripts/eruby.vim'

" NeoBundle 'vim-vagrant'
NeoBundleLazy 't9md/vim-chef', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}

NeoBundle 'rodjek/vim-puppet'
NeoBundle 'joker1007/vim-ruby-heredoc-syntax', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}

NeoBundleLazy 'rhysd/unite-ruby-require.vim', { 'autoload' : {
\ 'unite_sources' : ['ruby/require'],
\ }}
NeoBundle 'rhysd/neco-ruby-keyword-args'

NeoBundleLazy 'ujihisa/unite-gem', { 'autoload' : {
\ 'unite_sources' : ['gem'],
\ }}
NeoBundleLazy 'ujihisa/unite-rake', { 'autoload' : {
\ 'unite_sources' : ['rake'],
\ }}
NeoBundleLazy 'basyura/unite-rails', { 'autoload' : {
\ 'unite_sources' : [
\   'rails/bundle', 'rails/bundled_gem', 'rails/config',
\   'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
\   'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git',
\   'rails/helper', 'rails/heroku', 'rails/initializer',
\   'rails/javascript', 'rails/lib', 'rails/log', 'rails/mailer',
\   'rails/model', 'rails/rake', 'rails/route', 'rails/schema',
\   'rails/spec', 'rails/stylesheet', 'rails/view'
\ ],
\ }}
NeoBundleLazy 'moro/unite-stepdefs', { 'autoload' : {
\ 'unite_sources': ['stepdefs'],
\ }}
NeoBundleLazy 'osyo-manga/unite-highlight', {'autoload':{
\ 'unite_sources': ['highlight'],
\ }}

if has("signs") && has("clientserver") && v:version > 700
  NeoBundleLazy 'astashov/vim-ruby-debugger', {'autoload':{
  \ 'commands': ['Rdebugger']
  \ }}
else
  NeoBundleLazy 'astashov/vim-ruby-debugger'
endif
if s:bundle.is_installed('neocomplete.vim')
  NeoBundleLazy 'alpaca-tc/alpaca_rails_support', {
  \ 'depends' : ['Shougo/neocomplete.vim', 'tpope/vim-rails',
  \    'Shougo/vimproc.vim', 'Shougo/unite.vim'],
  \ 'autoload': {
  \   'unite_sources' : 'rails_support/locales',
  \   'commands' : [
  \     'RSCreateRoutesCache', 'RSCleanCache',
  \     'RSShowLocale', 'RSCreateLocaleCache',
  \   ]
  \ }}
endif

" html {{{4
NeoBundle 'othree/html5.vim'
NeoBundle 'amirh/HTML-AutoCloseTag'
NeoBundleLazy 'mattn/emmet-vim', {'autoload':{
\ 'filetypes': ['html','xhtml','eruby','php','css','scss'],
\ }}
if executable('go')
  NeoBundleLazy 'mattn/livestyle-vim', {'autoload':{
  \ 'commands': ['LiveStyle'],
  \ },
  \ 'build' : {
  \ 'windows': 'go get golang.org/x/net/websocket && go build -o livestyled/livestyled livestyled/livestyled.go',
  \ 'cygwin' : 'go get golang.org/x/net/websocket && go build -o livestyled/livestyled livestyled/livestyled.go',
  \ 'mac'    : 'go get golang.org/x/net/websocket && go build -o livestyled/livestyled livestyled/livestyled.go',
  \ 'unix'   : 'go get golang.org/x/net/websocket && go build -o livestyled/livestyled livestyled/livestyled.go',
  \ }}
endif
NeoBundleLazy 'https://gist.github.com/6576341', {
\ 'directory' : 'endtagcomment',
\ 'script_type' : 'plugin',
\ 'autoload': {'mappings': [['n', '<Plug>(endtagcomment)']]}
\ }
"  templates
NeoBundle 'tpope/vim-haml'
NeoBundle 'digitaltoad/vim-jade'
NeoBundle 'mustache/vim-mustache-handlebars'

" css {{{4
if has('python') || has('python3')
  NeoBundle 'Rykka/colorv.vim', {'autoload':{
  \ 'filetypes': ['html','javascript','css','sass','scss','less','slim','stylus'],
  \ }}
endif

NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'groenewege/vim-less'
NeoBundle 'wavded/vim-stylus'
NeoBundle 'slim-template/vim-slim'

" javascript {{{4
NeoBundle 'guileen/simple-javascript-indenter'
" NeoBundle 'othree/yajs.vim'
NeoBundle 'pangloss/vim-javascript'
NeoBundle 'mxw/vim-jsx'
" NeoBundle 'jsx/vim-jsx'
" NeoBundle 'moll/vim-node'
NeoBundle 'pekepeke/vim-node', {'autoload': {
  \ 'filetypes': ['javascript', 'coffee'],
  \ 'depends': ['gf-user'],
  \ }}
if has('python') || has('python3')
  NeoBundle 'marijnh/tern_for_vim', {
  \ 'build' : {
  \   'cygwin': 'npm install',
  \   'windows': 'npm install',
  \   'mac': 'npm install',
  \   'unix': 'npm install',
  \ }}
endif
NeoBundle 'othree/javascript-libraries-syntax.vim'
NeoBundle 'claco/jasmine.vim'
NeoBundle 'elzr/vim-json'
NeoBundleLazy 'Quramy/vison', {'autoload':{
\ 'commands': [
\ 'VisonSetup',
\ {'name': 'Vison', 'complete': 'vison#switch_type_complete'},
\ 'VisonRemoveSchema',
\ 'VisonRegisterSchema',
\ ] }}

NeoBundleLazy 'chikatoike/sourcemap.vim', {'autoload':{
\ 'commands': [
\   {'name' : 'SourceMapAddMap', 'complete':'file'},
\   'SourceMapSwitch', 'SourceMapConvertQuickfixToOriginal',
\   'SourceMapConvertLocListToOriginal', 'SourceMapAddOriginalToQuickfix',
\   'SourceMapAddOriginalToLocList',]
\ }}
NeoBundle 'briancollins/vim-jst'

NeoBundle 'vim-scripts/Dart'
NeoBundleLazy 'jdonaldson/vaxe', {'autoload':{
\ 'filetypes': ['haxe','hxml','nmml'],
\ }}
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'leafgarland/typescript-vim'
NeoBundleLazy 'clausreinke/typescript-tools', {
\ 'script_type' : 'plugin',
\ 'autoload' : { 'filetypes' : 'typescript' },
\ 'build' : {
\     'cygwin' : 'npm install',
\     'windows' : 'npm install',
\     'mac'    : 'npm install',
\     'unix'   : 'npm install',
\   },
\ }
" NeoBundleLazy 'Quramy/tsuquyomi', {{'autoload': {
" \ 'filetypes': 'typescript',
" \ }}}

" python {{{4
" http://rope.sourceforge.net/
NeoBundle 'klen/python-mode'
NeoBundle 'lambdalisue/vim-python-virtualenv'
NeoBundle 'gerardo/vim-django-support'
NeoBundle 'voithos/vim-python-matchit'
NeoBundle 'heavenshell/vim-pydocstring'
NeoBundleLazy 'hachibeeDI/unite-pythonimport', {'autoload':{
\ 'unite_sources' : ['pythonimport'],
\ }}

if !s:bundle.is_installed('YouCompleteMe')
  if (has('python') || has('python3'))
    NeoBundleLazy 'davidhalter/jedi-vim', {
    \   'autoload' : { 'filetypes' : ['python', 'python3'], },
    \ }
  else
    NeoBundleLazy 'davidhalter/jedi-vim'
  endif
  NeoBundle 'Glench/Vim-Jinja2-Syntax'
endif

" perl {{{4
NeoBundle 'vim-perl/vim-perl'
NeoBundle 'moznion/vim-cpanfile'
NeoBundle 'c9s/perlomni.vim'
NeoBundle 'motemen/xslate-vim'
NeoBundleLazy 'y-uuki/unite-perl-module.vim', { 'autoload' : {
\ 'unite_sources' : ['perl/global', 'perl/local'],
\ }}
NeoBundleLazy 'y-uuki/perl-local-lib-path.vim', {'autoload':{
\ 'filetypes': ['perl'],
\ }}
NeoBundleLazy 'soh335/unite-perl-module', {'autoload' : {
\ 'unite_sources' : ['perl-module/carton', 'perl-module/cpan'],
\ }}

" C,CPP {{{4
NeoBundleLazy 'vim-scripts/DoxygenToolkit.vim', {'autoload':{
\ 'filetypes': ['c', 'cpp'],
\ }}
" NeoBundleLazy 'osyo-manga/vim-snowdrop', {'autoload':{
" \ 'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
" \ }}
if !s:bundle.is_installed('YouCompleteMe')
  NeoBundleLazy 'Rip-Rip/clang_complete', {'autoload':{
  \ 'filetypes': ['c', 'cpp', 'objc', 'objcpp'],
  \ }}
  if s:is_mac
    NeoBundleLazy 'tokorom/clang_complete-getopts-ios', {'autoload': {
    \ 'filetypes': ['objc', 'objcpp'],
    \ }}
  endif
endif
NeoBundle 'peterhoeg/vim-qml'

" C# {{{4
" NeoBundleLazy 'OrangeT/vim-csharp', {'autoload':{
" \ 'filetypes': ['cs'],
" \ }}

if !s:bundle.is_installed('YouCompleteMe')
  if (s:is_win && executable('MSBuild.exe')) || (!s:is_win && executable('xbuild'))
    NeoBundleLazy 'OmniSharp/omnisharp-vim', {
    \ 'autoload': {'filetypes': ['cs']},
    \ 'build': {
    \   'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
    \   'mac': 'xbuild server/OmniSharp.sln',
    \   'unix': 'xbuild server/OmniSharp.sln',
    \ }}
  endif
endif

" OSX {{{4
NeoBundle 'b4winckler/vim-objc'
NeoBundle 'pekepeke/cocoa.vim'
if has('ruby')
  NeoBundleLazy 'eraserhd/vim-ios', {'autoload':{
  \ 'filetypes': ['objc'],
  \ }}
endif
NeoBundle 'vim-scripts/applescript.vim'

" windows {{{4
NeoBundle 'PProvost/vim-ps1'
if s:is_win
  NeoBundle 'cd01/poshcomplete-vim'
endif
NeoBundleLazy 'hachibeeDI/vim-vbnet', {'autoload':{
\ 'filetypes': ['vbnet'],
\ }}

" java, android {{{4
NeoBundleLazy 'mikelue/vim-maven-plugin', {'autoload':{
\ 'filetypes': ['java'],
\ }}
NeoBundleLazy 'kamichidu/unite-javaimport', {'autoload': {
\ 'unite_sources': ['javaimport']
\ }}
NeoBundle 'kamichidu/vim-javaclasspath', {
\   'depends': ['kamichidu/vim-javalang'],
\}
NeoBundleLazy 'kamichidu/javacomplete', {
\   'build' : {
\      'windows' : 'javac autoload/Reflection.java',
\      'cygwin'  : 'javac autoload/Reflection.java',
\      'mac'     : 'javac autoload/Reflection.java',
\      'unix'    : 'javac autoload/Reflection.java',
\   },
\   'autoload' : { 'filetypes' : 'java' },
\ }
NeoBundleLazy 'vim-scripts/jcommenter.vim', {'autoload':{
\ 'filetypes': ['java'],
\ }}
NeoBundle 'vim-scripts/groovyindent'
NeoBundle 'vim-scripts/groovy.vim'
NeoBundleLazy 'thinca/vim-logcat', {'autoload':{
\ 'commands': ['Logcat', 'LogcatClear'],
\ }}
NeoBundle 'lepture/vim-velocity'
NeoBundleLazy 'ryotakato/unite-gradle', {'autoload':{
\ 'unite_sources': ['gradle'],
\ }}

" scala {{{4
NeoBundleLazy 'derekwyatt/vim-scala', {'autoload':{
\ 'filetypes': ['scala'],
\ }}

" go {{{4
NeoBundleLazy 'fatih/vim-go', {'autoload':{
\ 'filetypes': ['go'],
\ }}
if executable('gocode')
  NeoBundle 'undx/vim-gocode'
else
  NeoBundleLazy 'undx/vim-gocode'
endif

" texts {{{4
NeoBundle 'tpope/vim-markdown'
NeoBundle 'nelstrom/vim-markdown-folding'
" NeoBundle 'kannokanno/previm'
NeoBundle 'beckorz/previm'
NeoBundle 'timcharper/textile.vim'
NeoBundle 'aklt/plantuml-syntax'
" NeoBundle 'maxmeyer/vim-taskjuggler'
NeoBundle 'hara/vim-opf'

NeoBundleLazy 'moznion/hateblo.vim', {'autoload': {
\ 'commands': [
\   'HatebloCreate', 'HatebloCreateDraft', 'HatebloList',
\   'HatebloUpdate', 'HatebloDelete',
\ ], 'unite_sources': ['hateblo-list']}}
NeoBundle 'moro/vim-review'
NeoBundle 'nvie/vim-rst-tables'
NeoBundle 'vim-scripts/sequence'

" haskell {{{4
NeoBundleLazy 'dag/vim2hs', {'autoload':{
\ 'filetypes': ['haskell'],
\ }}
NeoBundleLazy 'ujihisa/ref-hoogle', {'autoload':{
\ 'filetypes': ['haskell'],
\ }}
NeoBundle 'ujihisa/neco-ghc'
NeoBundleLazy "ujihisa/unite-haskellimport", {'autoload':{
\ 'filetypes': ['haskell'],
\ }}
NeoBundle 'eagletmt/ghcmod-vim'
NeoBundleLazy 'eagletmt/unite-haddock', {'autoload':{
\ 'filetypes': ['haskell'],
\ }}

NeoBundle 'elixir-lang/vim-elixir'

" php {{{4
NeoBundle 'captbaritone/better-indent-support-for-php-with-html'
NeoBundle '2072/PHP-Indenting-for-VIm'
NeoBundle 'Gasol/vim-php'
NeoBundle 'StanAngeloff/php.vim'
NeoBundle 'arnaud-lb/vim-php-namespace'
NeoBundle 'pekepeke/phpfolding.vim'
NeoBundle 'shawncplus/phpcomplete.vim'
NeoBundle 'beberlei/vim-php-refactor'
NeoBundleLazy 'violetyk/cake.vim', {'autoload':{
\ 'filetypes': ['php'],
\ }}

" sql {{{4
NeoBundle 'mattn/vdbi-vim'
NeoBundleLazy 'vim-scripts/dbext.vim', {'autoload':{
\ 'commands': [
\ { 'name': 'DBExecSQL'},
\ { 'name': 'DBExecSQLTopX'},
\ { 'name': 'DBConnect'},
\ { 'name': 'DBDisconnect'},
\ { 'name': 'DBDisconnectAll'},
\ { 'name': 'DBCommit'},
\ { 'name': 'DBRollback'},
\ { 'name': 'DBListConnections'},
\ { 'name': 'DBExecRangeSQL'},
\ { 'name': 'Call'},
\ { 'name': 'Select', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Alter', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Update', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Insert', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Delete', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Drop', 'complete': 'customlist,dbext#DB_completeTables' },
\ { 'name': 'Create' },
\ { 'name': 'DBSetOption', 'complete': 'customlist,dbext#DB_completeSettings' },
\ { 'name': 'DBGetOption', 'complete': 'customlist,dbext#DB_completeSettings' },
\ { 'name': 'DBVarRangeAssign' },
\ { 'name': 'DBListVar'},
\ { 'name': 'DBSetVar', 'complete': 'customlist,dbext#DB_completeVariable'},
\ ] }}
" NeoBundleLazy 'vim-scripts/SQLUtilities', {'autoload':{}}
" \ 'filetypes': ['sql'],

" etc {{{4
NeoBundle 'honza/dockerfile.vim'
NeoBundle 'chase/vim-ansible-yaml'
NeoBundle 'cespare/vim-toml'
NeoBundleLazy 'xolox/vim-lua-ftplugin', {'autoload':{
\ 'filetypes': ['lua'],
\ },
\ 'depends': ['xolox/vim-misc'],
\ }
NeoBundle 'vim-scripts/httplog'
NeoBundle 'vim-scripts/syslog-syntax-file'
NeoBundle 'uarun/vim-protobuf'
NeoBundle 'sophacles/vim-processing'
NeoBundleLazy 'pekepeke/ref-processing-vim', {'autoload':{
\ 'filetypes': ['processing'],
\ }}
NeoBundle 'sjl/strftimedammit.vim'
NeoBundle 'tangledhelix/vim-octopress'
NeoBundle 'jcfaria/Vim-R-plugin'
NeoBundleLazy 'rbtnn/vimconsole.vim', {
\ 'autoload' : {
\   'commands': [
\     'VimConsoleLog', 'VimConsoleOpen', 'VimConsoleWarn', 'VimConsoleError',
\     'VimConsoleError', 'VimConsoleToggle', 'VimConsoleClear', 'VimConsoleRedraw',
\   ] }
\ }
NeoBundleLazy 'basyura/rmine.vim', {'autoload': {
\ 'commands': [
\   {'name': 'Rmine', 'complete': 'custom,rmine#complete#project'},
\   'RmineIssue', 'RmineNewIssue'
\ ],
\ 'unite_sources': ['rmine/project', 'rmine/query', 'rmine/selector'],
\ }}

" config {{{4
NeoBundle 'qqshfox/vim-tmux'
NeoBundle 'vim-scripts/nginx.vim'
NeoBundle 'smerrill/vcl-vim-plugin'
NeoBundle 'ksauzz/haproxy.vim'
" NeoBundle 'empanda/vim-varnish.vim'
NeoBundle 'glidenote/keepalived-syntax.vim'
NeoBundle 'Shougo/vim-nyaos'

" unite.vim {{{3
NeoBundle 'Shougo/unite.vim', {
\   'autoload': { 'commands' : ['Unite', 'UniteBookmarkAdd'] },
\ }
NeoBundle 'Shougo/neomru.vim', {'autoload': {
\ 'unite_sources': ['file_mru', 'directory_mru',
\   'neomru/file', 'neomru/directory']
\}}
NeoBundleLazy 'thinca/vim-unite-history', {'autoload':{
\ 'unite_sources': ['history/command', 'history/search'],
\ }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
\ 'unite_sources' : ['help'],
\ }}
NeoBundleLazy 'tacroe/unite-mark', { 'autoload' : {
\ 'unite_sources' : ['mark'],
\ }}
NeoBundleLazy 'zhaocai/unite-scriptnames', { 'autoload' : {
\ 'unite_sources' : ['scriptnames'],
\ }}
NeoBundleLazy 'pasela/unite-webcolorname', { 'autoload' : {
\ 'unite_sources' : ['webcolorname'],
\ }}
NeoBundleLazy 'ujihisa/unite-colorscheme', { 'autoload' : {
\ 'unite_sources' : ['colorscheme'],
\ }}
NeoBundleLazy 'LeafCage/unite-gvimrgb', {'autoload': {
\ 'unite_sources': ['gvimrgb'],
\ }}
NeoBundleLazy 'Shougo/unite-build', { 'autoload' : {
\ 'unite_sources' : ['build'],
\ }}
NeoBundleLazy 'Shougo/unite-outline', { 'autoload' : {
\ 'unite_sources' : ['outline'],
\ }}
NeoBundleLazy 'sgur/unite-git_grep', { 'autoload' : {
\ 'unite_sources' : ['vcs_grep', 'vcs_grep/git', 'vcs_grep/hg'],
\ }}
NeoBundleLazy 'osyo-manga/unite-candidate_sorter', {'autoload': {
      \ 'mappings': [['n', '<Plug>(unite-candidate_sort)']]
      \ }}
NeoBundleLazy 'osyo-manga/unite-quickfix', { 'autoload' : {
\ 'unite_sources' : ['quickfix', 'location_list'],
\ }}
NeoBundleLazy "osyo-manga/unite-quickrun_config", { 'autoload' : {
\ 'unite_sources' : ['quickrun_config'],
\ }}
NeoBundleLazy 'eiiches/unite-tselect', { 'autoload' : {
\ 'unite_sources' : ['tselect'],
\ }}
NeoBundleLazy 'tsukkee/unite-tag', { 'autoload' : {
\ 'unite_sources' : ['tag', 'tag/file', 'tag/include'],
\ }}
" NeoBundleLazy 'hewes/unite-gtags', {'autoload': {
" \ 'unite_sources': [
" \ 'gtags/context' , 'gtags/ref' , 'gtags/def' , 'gtags/grep' , 'gtags/completion',
" \ ],
" \ }}
NeoBundleLazy 'haya14busa/unite-ghq', {'autoload' : {
\ 'unite_sources' : ['ghq'],
\ }}
NeoBundleLazy 'alpaca-tc/vim-unite-watson.vim', {
\ 'commands' : 'Watson',
\ 'depends' : 'Shougo/unite.vim',
\ 'autoload' : {
\ 'unite_sources' : ['watson', 'watson/dirty', 'watson/clean', 'watson/current_file'],
\ }}
NeoBundleLazy 'pekepeke/quicklearn', { 'autoload' : {
\ 'unite_sources' : ['quicklearn'],
\ }}
NeoBundleLazy "osyo-manga/unite-fold", {'autoload':{
\ 'unite_sources' : ['fold'],
\ }}
NeoBundleLazy "monochromegane/unite-yaml", {'autoload':{
\ 'unite_sources': ['yaml', 'yaml-list'],
\ }}
" NeoBundle 'RomainEndelin/fusion.vim', { 'autoload' : {
" \ 'unite_sources' : ['projection-files', 'projection-categories'],
" \ }}

if executable('w3m')
  NeoBundleLazy 'yuratomo/w3m.vim', {'autoload':{
  \ 'commands':[
  \ {'name': 'W3m', 'complete':'customlist,w3m#search_engine#List'},
  \ {'name': 'W3mTab', 'complete':'customlist,w3m#search_engine#List'},
  \ {'name': 'W3mSplit', 'complete':'customlist,w3m#search_engine#List'},
  \ {'name': 'W3mVSplit', 'complete':'customlist,w3m#search_engine#List'},
  \ {'name': 'W3mLocal', 'complete':'customlist,w3m#search_engine#List'},
  \ 'W3mHistory', 'W3mHistoryClear',
  \ ]}}
endif

NeoBundleLazy 'pekepeke/vim-unite-repo-files', { 'autoload' : {
\ 'unite_sources' : ['repo_files'],
\ }}
NeoBundleLazy 'pekepeke/vim-unite-z', { 'autoload' : {
\ 'unite_sources' : ['z'],
\ }}

if s:is_win
  NeoBundleLazy 'sgur/unite-everything', { 'autoload' : {
  \ 'unite_sources' : ['everything', 'everything/async'],
  \ }}
else
  if s:is_mac
    NeoBundleLazy 'choplin/unite-spotlight', { 'autoload' : {
    \ 'unite_sources' : ['spotlight'],
    \ }}
  else
    NeoBundleLazy 'ujihisa/unite-locate', { 'autoload' : {
    \ 'unite_sources' : ['locate'],
    \ }}
  endif
  NeoBundle 'ujihisa/neco-look'
endif

" www {{{3
NeoBundleLazy 'tyru/open-browser.vim', {'autoload':{
\ 'functions': ['OpenBrowser', ],
\ 'function_prefix':'openbrowser',
\ 'commands': [
\ {'name': 'OpenBrowser',},
\ {'name': 'OpenBrowserSearch', 'complete':'customlist,openbrowser#_cmd_complete'},
\ {'name': 'OpenBrowserSmartSearch', 'complete':'customlist,openbrowser#_cmd_complete'},
\ ],
\ 'mappings': [
\   ['nv', '<Plug>(openbrowser-',]
\ ],
\ }}
NeoBundleLazy 'tyru/open-browser-github.vim', {'autoload': {
\ 'commands': ['OpenGithubFile', 'OpenGithubIssue',
\   'OpenGithubPullReq'],
\ }}
NeoBundleLazy 'junegunn/vim-github-dashboard', {'autoload': {
\ 'commands': [
\   'GHD', 'GHA', 'GHDashboard', 'GHActivity', ],
\ }}
NeoBundle 'mattn/webapi-vim'
NeoBundleLazy 'mattn/excitetranslate-vim', {'autoload': {
\ 'commands': ['ExciteTranslate'],
\ }}
NeoBundleLazy 'mattn/gist-vim', {'autoload': {
\ 'commands': ['Gist'],
\ }}

" gf-user {{{3
NeoBundle 'kana/vim-gf-user'
NeoBundle 'kana/vim-gf-diff'
NeoBundleLazy 'sgur/vim-gf-autoload', {'autoload':{
\ 'filetypes': ['vim'],
\ }}
NeoBundleLazy 'zhaocai/vim-gf-python', {'autoload':{
\ 'filetypes': ['python'],
\ }}
NeoBundleLazy 'pekepeke/vim-gf-ruby-require', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}
NeoBundleLazy 'pekepeke/vim-gf-vundle', {'autoload':{
\ 'filetypes': ['vim'],
\ }}

" operator {{{3
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-operator-replace', {
\ 'depends' : 'vim-operator-user', 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-replace)']]
\ }}
NeoBundleLazy 'tyru/operator-camelize.vim', {
\ 'depends' : 'vim-operator-user', 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-camelize', '<Plug>(operator-decamelize)']]
\ }}
NeoBundleLazy 'tyru/operator-html-escape.vim', {
\ 'depends' : 'vim-operator-user', 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-html-']]
\ }}
NeoBundleLazy 'syngan/vim-operator-furround', {'autoload':{
\ 'mappings': ['<Plug>(operator-furround-']
\ }}
NeoBundleLazy 'rhysd/vim-operator-surround', {'autoload': {
\ 'mappings': [['nx', '<Plug>(operator-surround-']]
\ }}
NeoBundleLazy 'sgur/vim-operator-openbrowser', {'autoload': {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-openbrowser)']]
\ }}
NeoBundleLazy 'pekepeke/vim-operator-shuffle', {
\ 'depends' : 'vim-operator-user', 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-shuffle)']]
\ }}
NeoBundleLazy 'pekepeke/vim-operator-tabular', {
\ 'depends': 'pekepeke/vim-csvutil',
\ 'autoload' : {
\ 'mappings' : [
\ ['nx', '<Plug>(operator-tabular-', ]]
\ }}
NeoBundleLazy 'pekepeke/vim-operator-normalize-utf8mac', {
\ 'depends' : 'vim-operator-user',
\ 'autoload' : {
\ 'mappings' : [['nx', '<Plug>(operator-normalize_utf8mac)']]
\ }}

" textobj {{{3
NeoBundle 'kana/vim-textobj-user'
" NeoBundleLazy 'kana/vim-textobj-datetime', {'autoload': {
" \ 'mappings': [['vo',
" \ 'ada', 'adf', 'add', 'adt', 'adz',
" \ 'ida', 'idf', 'idd', 'idt', 'idz',
" \ ]],
" \ }}
NeoBundleLazy 'kana/vim-textobj-diff', {'autoload': {
\ 'mappings': [
\ ['n', '<Leader>dj', '<Leader>dJ', '<Leader>dk', '<Leader>dK',
\   '<Leader>dfj', '<Leader>dfJ', '<Leader>dfk', '<Leader>dfK', ]
\ ],
\ }}
NeoBundleLazy 'kana/vim-textobj-entire', {'autoload':{
\ 'mappings': [['vo', '<Plug>(textobj-entire-', ]],
\ }}
" \ 'mappings': [['vo', 'ie', 'ae']],
NeoBundleLazy 'kana/vim-textobj-fold', {'autoload':{
\ 'mappings': [['nvx', '<Plug>(textobj-fold-i)', '<Plug>(textobj-fold-a)']],
\ }}
NeoBundleLazy 'kana/vim-textobj-lastpat', {'autoload': {
\ 'mappings' : [['vo', 'a/', 'i/', 'a?', 'i?' ]],
\ }}
" \ '<Plug>(textobj-lastpat-n)', '<Plug>(textobj-lastpat-N)',
NeoBundleLazy 'kana/vim-textobj-syntax', {'autoload': {
\ 'mappings' : [['nvx',
\ '<Plug>(textobj-syntax-i)', '<Plug>(textobj-syntax-a)',
\ ]],
\ }}
NeoBundleLazy 'kana/vim-textobj-line', {'autoload':{
\ 'mappings': [['vo', 'al', 'il', '<Plug>(textobj-line-',]],
\ }}
NeoBundleLazy 'kana/vim-textobj-underscore', {'autoload':{
\ 'mappings': [['nvx', '<Plug>(textobj-quoted-', ]],
\ }}
NeoBundleLazy 'thinca/vim-textobj-between', {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvx', '<Plug>(textobj-between-',]]
\ }}
" NeoBundle 'thinca/vim-textobj-comment'
NeoBundleLazy 'kana/vim-textobj-function', {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvx', '<Plug>(textobj-function-',]]
\ }}
NeoBundle 'thinca/vim-textobj-function-javascript'
NeoBundle 'thinca/vim-textobj-function-perl'
NeoBundle 't9md/vim-textobj-function-ruby'
NeoBundleLazy 'nelstrom/vim-textobj-rubyblock', {'autoload':{
\ 'filetypes': ['ruby'],
\ }}
NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', {'autoload':{
\ 'mappings' : [['nvo',
\ '<Plug>(textobj-enclosedsyntax-',
\ ]]}}
NeoBundle "osyo-manga/vim-textobj-multitextobj", {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-multitextobj-i)', '<Plug>(textobj-multitextobj-a)']]
\ }}
NeoBundle 'osyo-manga/vim-textobj-multiblock', {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-multiblock-i)', '<Plug>(textobj-multiblock-a)']]
\ }}
NeoBundle 'vim-scripts/textobj-indent', {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-indent-i)', '<Plug>(textobj-indent-a)']]
\ }}
NeoBundle 'sgur/vim-textobj-parameter', {
\ 'depends' : 'vim-textobj-user',
\ 'autoload' : {
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-parameter-i)', '<Plug>(textobj-parameter-a)']]
\ }}
" NeoBundleLazy 'h1mesuke/textobj-wiw', {
" \ 'depends' : 'vim-textobj-user',
" \ 'autoload' : {
" \ 'mappings' : [
" \ ['nvo', '<Plug>(textobj-wiw-i)', '<Plug>(textobj-wiw-a)']]
" \ }}
NeoBundleLazy 'rhysd/vim-textobj-word-column', {'autoload':{
\ 'mappings': [['xo', '<Plug>(textobj-wordcolumn']]
\ }}
NeoBundleLazy 'rhysd/vim-textobj-continuous-line', {'autoload':{
\ 'filetypes': ['vim', 'c', 'cpp', 'sh', 'zsh', 'fish'],
\ }}
NeoBundleLazy 'osyo-manga/vim-textobj-context', {'autoload':{
\ 'mappings' : [['nvo',
\ '<Plug>(textobj-context-i)',
\ ]]}}
NeoBundle "osyo-manga/vim-textobj-blockwise"
NeoBundle 'akiyan/vim-textobj-xml-attribute', {'autoload':{
\ 'mappings' : [['nvo',
\ '<Plug>(textobj-xmlattribute-', 'axa', 'ixa'
\ ]]}}
NeoBundleLazy 'rhysd/vim-textobj-lastinserted', {'autoload':{
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-lastinserted-']]
\ }}
NeoBundleLazy 'gilligan/textobj-lastpaste', {'autoload':{
\ 'mappings': [
\ ['nvo', '<Plug>(textobj-lastpaste-', 'aip', 'iip']]
\ }}
NeoBundle 'mattn/vim-textobj-url', {'autoload':{
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-url-']]
\ }}
NeoBundleLazy 'anyakichi/vim-textobj-ifdef', {'autoload':{
\ 'mappings' : [
\ ['nvo', '<Plug>(textobj-ifdef-i)', '<Plug>(textobj-ifdef-a)']]
\ }}
NeoBundle 'akiyan/vim-textobj-php', {'autoload':{
\ 'mappings' : [['nvo', '<Plug>(textobj-php-', ]]}}

" vundle end {{{2
  NeoBundleSaveCache
endif
" configure for runtimepath {{{1
call neobundle#end()
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
function! MyStatusLine()
  return s:status_generator.get_line()
endfunction
set statusline=%!MyStatusLine()


" for filetypes {{{1
" shebang {{{2
if !s:is_win
  MyAutoCmd BufWritePost *
        \ if getline(1) =~ "^#!"
        \ | exe "silent !chmod +x %"
        \ | endif
  " MyAutoCmd BufEnter *
  "       \ if bufname("") !~ "^\[A-Za-z0-9\]*://"
  "       \ | silent! exe '!echo -n "k%\\"'
  "       \ | endif
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
" MySQL
MyAutoCmd BufNewFile,BufRead *.sql set filetype=mysql
" IO
MyAutoCmd BufNewFile,BufRead *.io set filetype=io
" command
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
    " imap <expr><buffer> <Space> ambicmd#expand("\<Space>")
    " imap <expr><buffer> <CR> ambicmd#expand("\<CR>")
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
  autocmd BufWritePost *.bin setlocal nomodified | endif
augroup END

" some commands & altercmd {{{1
" some commands {{{2
command! -narg=0 SynReload syntax off <Bar> syntax enable
command! -nargs=? -complete=dir Ctags call my#command#exec_ctags(<q-args>)
command! -nargs=? -complete=dir Gtags call my#command#system_with_lcd("gtags", <q-args>)
command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif
command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>

" altercmd "{{{2
if s:bundle.is_installed('vim-altercmd')
  call altercmd#load()

  function! s:alias_lc(...) " {{{3
    for cmd in a:000
      silent exe 'Alias' tolower(cmd) cmd
    endfor
  endfunction "}}}

  command! -bar -nargs=+
        \ Alias CAlterCommand <args> | AlterCommand <cmdwin> <args>
  command! -nargs=+ LCAlias call s:alias_lc(<f-args>)
else
  command! -bar -nargs=+ LCAlias call <SID>nop(<f-args>)
  command! -bar -nargs=+ Alias call <SID>nop(<f-args>)
endif

" alias calls {{{2
"Alias q bd
Alias q MyQ
Alias wq MyWQ
Alias Q quit
Alias WQ wq

Alias ve vsplit
Alias se split
Alias n new
Alias v vnew

" mappings {{{1
" define common key-prefixes {{{2
noremap [!space] <Nop>
nnoremap g<Space> <Space>
vnoremap g<Space> <Space>
nmap <Space> [!space]
vmap <Space> [!space]

" noremap [!prefix] <Nop>
" nmap [!prefix] ,
" vmap [!prefix] ,
" xmap [!prefix] ,

noremap [!edit] <Nop>
nmap <C-e> [!edit]
vmap <C-e> [!edit]

noremap [!app] <Nop>
map [!unite]c [!app]
noremap [!cw-app] <Nop>
map <C-w>[!unite]c [!cw-app]

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
nnoremap q: q:
nnoremap q/ q/
nnoremap q? q?
nnoremap Q q

" 行単位で移動 {{{2
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j (v:count == 0 && mode() !=# 'V') ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k (v:count == 0 && mode() !=# 'V') ? 'gk' : 'k'
" nmap gb :ls<CR>:buf

" disable danger keymaps {{{2
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
if $TERM =~ 'screen'
  map <C-z> <Nop>
endif

" useful keybinds {{{2
nnoremap gs :<C-u>setf<Space>
nmap Y y$

" nnoremap <silent> x "_x
" nnoremap <silent> X "_X
" nnoremap <silent> sx x
" nnoremap <silent> sX X

" http://vim-users.jp/2009/10/hack91/
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" indent whole buffer
nnoremap [!space]= call <SID>execute_motionless('normal! gg=G')

" tab switch
for i in range(10)
  execute 'nnoremap <silent>' ('[!t]'.i) (((i+10) % 10).'gt')
endfor
unlet i
nnoremap <silent> [!t]n gt
nnoremap <silent> [!t]p gT
nnoremap <silent> [!t]h gT
nnoremap <silent> [!t]l gt
nnoremap <silent> [!t]c :<C-u>tabnew<CR>
nnoremap <silent> [!t]C :<C-u>tabnew %<CR>
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

" grep
let s:regexp_todo = 'TODO\|FIXME\|REVIEW\|MARK\|NOTE\|!!!\|\\?\\?\\?\|XXX'
function! s:set_grep(...) "{{{3
  let retval = 0
  for type in copy(a:000)
    if type == "jvgrep" && executable(type)
      set grepprg=jvgrep
      set grepformat=%f:%l:%m
      " set grepprg=jvgrep\ -n

      let g:unite_source_grep_command = "jvgrep"
      let g:unite_source_grep_default_opts = '-in --exclude "\.git|\.svn|\.hg|\.bzr|tags|tmp)"'
      let g:unite_source_grep_recursive_opt = ''
      return 1
    elseif type == "ag" && executable(type)
      set grepprg=ag\ -S\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m
      let g:ackprg="ag -i -S --nocolor --nogroup --column --nopager"

      let g:unite_source_grep_command = 'ag'
      let opts = [
        \ '--ignore-case -S --noheading --nocolor --nogroup --nopager',
        \ '--ignore', '".hg"',
        \ '--ignore', '".git"',
        \ '--ignore', '".bzr"',
        \ '--ignore', '".svn"',
        \ '--ignore', '"node_modules"',
        \ ]
      let g:unite_source_grep_default_opts = join(opts, " ")
      let g:unite_source_grep_recursive_opt = ''
      return 1
    elseif type == "ack" && executable(type)
      set grepprg=ack\ --smart-case\ -a\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m
      let g:ackprg="ack -H --smart-case --nocolor --nogroup --column --nopager"
      let g:unite_source_grep_command = 'ack'
      let g:unite_source_grep_default_opts = '--smartcase --no-heading --nocolor --nogroup --nopager'
      let g:unite_source_grep_recursive_opt = ''
      return 1
    elseif type == "ack-grep"  && executable(type)
      set grepprg=ack-grep\ -a\ --nocolor\ --nogroup\ --nopager
      set grepformat=%f:%l:%m

      let g:ackprg="ack-grep -H --nocolor --nogroup --column --nopager"
      let g:unite_source_grep_command = 'ack-grep'
      let g:unite_source_grep_default_opts = '--no-heading --nocolor -a --nogroup --nopager'
      let g:unite_source_grep_recursive_opt = ''
      return 1
    endif
    if type == "grep"
      let retval = 1
      break
    endif
  endfor

  set grepprg=grep\ -n\ $*\ /dev/null
  "set grepprg=grep\ -n\ $*\ /dev/null\ --exclude\ \"\*\.svn\*\"

  let g:unite_source_grep_command = 'grep'
  let g:unite_source_grep_default_opts = '-iRHn'
  let g:unite_source_grep_recursive_opt = ''
  return retval
endfunction

command! -nargs=0 SetJvgrep call s:set_grep("jvgrep")
command! -nargs=0 SetAck call s:set_grep("ack-grep")
command! -nargs=0 SetAg call s:set_grep("ag")
command! -nargs=0 SetPt call s:set_grep("pt")

let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'
let Grep_Default_Filelist = '*' "join(split('* '.Grep_Skip_Files, ' '), ' --exclude=')
if s:is_win
  call s:set_grep("jvgrep", "ag", "ack-grep")
else
  call s:set_grep("ag", "jvgrep", "ack-grep")
endif

let Grep_Default_Options = '-i'
let Grep_OpenQuickfixWindow = 1

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|^tags$'
let MyGrepcmd_useropt = '--exclude="*\.\(svn\|git\|hg)*"'

" function! s:vimrc_quickfix_init()
"   " nnoremap <buffer> < :<C-u><CR>
" endfunction
" MyAutoCmd FileType qf call s:vimrc_quickfix_init()

" quickfix のエラー箇所を波線でハイライト
" let g:hier_highlight_group_qf  = "qf_error_ucurl"
" function! s:vimrc_make_init()
"   HierUpdate
"   QuickfixStatusEnable
" endfunction
" MyAutoCmd QuickfixCmdPost make call s:vimrc_make_init()
" MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" MyAutoCmd QuickfixCmdPost l* lopen

" tags-and-searches {{{2
nnoremap [!t]r t
if s:bundle.is_installed('unite-tselect')
  nnoremap <silent> [!t]t :<C-u>Unite tselect:<C-r>=expand('<cword>')<CR> -immediately<CR>
  nnoremap <silent> <C-w>tt <C-w>s:<C-u>Unite tselect:<C-r>=expand('<cword>')<CR> -immediately<CR>
else
  " nnoremap <silent> [!t]t g<C-]>
  " nnoremap <silent> <C-w>tt <C-w>sg<C-]>
  nnoremap <silent> [!t]t :<C-u>call <SID>tselect_immediately()<CR>
  nnoremap <silent> <C-w>tt <C-w>s:<C-u>call <SID>tselect_immediately()<CR>
endif
function! s:tselect_immediately()
  execute 'normal!' (len(taglist(expand('<cword>'))) > 1 ? "g" : "")."\<C-]>"
endfunction
nnoremap <silent> [!t]j :<C-u>tag<CR>
nnoremap <silent> [!t]k :<C-u>pop<CR>
" nnoremap <silent> [!t]l :<C-u>tselect<CR>

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
      nnoremap <A-Up>   :<C-u>call <SID>set_transparency('+=5')<CR>
      nnoremap <A-Down> :<C-u>call <SID>set_transparency('-=5')<CR>
      nnoremap <A-Right> :<C-u>call <SID>set_transparency(230)<CR>
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

nnoremap ,ds :call <SID>replace_at_caret_data_scheme()<CR>
function! s:replace_at_caret_data_scheme() " {{{4
  let cfile = expand('<cfile>')
  let cpath = expand(cfile)
  let errmsg = ""
  if empty(cfile) || !filereadable(cpath)
    let errmsg = "file not found : " . cfile
  endif
  if executable('ruby')
    let cmd = printf("ruby -rwebrick/httputils -e '%s'",
          \ printf('fp="%s";include WEBrick::HTTPUtils;'
          \      . 'puts "data:#{mime_type(fp, DefaultMimeTypes)};base64,'
          \      . '#{[File.read(fp)].pack("m").gsub(/\n/,"")}"', cpath))
  " elseif executable('python')
  "   let cmd = printf("python -c 'import mimetypes;fp=\"%s\";print %s'"
  "         \ , cpath, printf('"data:%s;base64,%s" % mimetypes.guess_type(fp)[0], open(fp).read().encode("base64")'))
  elseif executable('php')
    let cmd = printf("php -r '$fp=\"%s\";%s;'", cpath,
          \ 'printf("data:%s;base64,%s",mime_content_type($fp),base64_encode(file_get_contents($fp)))'
          \ )
  else
    let errmsg = "exe not found : ruby or php"
  endif
  if !empty(errmsg)
    echohl Error
    echo errmsg
    echohl None
    return
  endif
  let line = getline(".")
  call setline(".",
        \ strpart(line, 0, stridx(line, cfile))
        \ . system(cmd)
        \ . strpart(line, stridx(line, cfile) + strlen(cfile))
        \ )
endfunction

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
onoremap ( t(
onoremap ) t)
onoremap ] t]
onoremap [ t[

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
" phpfolding.vim
let g:DisableAutoPHPFolding = 1

" let g:PHP_autoformatcomment=0
"" php-doc.vim
let g:pdv_cfg_Type = 'mixed'
let g:pdv_cfg_Package = ""
let g:pdv_cfg_Version = '$id$'
if exists('g:author') && exists('g:email')
  let g:pdv_cfg_Author = g:author . ' <' . g:email . '>'
else
  let g:pdv_cfg_Author = ''
endif
let g:pdv_cfg_Copyright = ""
let g:pdv_cfg_License = 'PHP Version 3.0 {@link http://www.php.net/license/3_0.txt}'
let g:pdv_cfg_CommentEnd = "// }}}"
let g:pdv_cfg_EnalbedFoldMarker = 0

" ruby {{{2
let g:ruby_operators = 1
let g:ruby_no_expensive = 1

" go {{{2
if s:bundle.is_installed('vim-go')
  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
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
  \ 'agit': s:bundle.is_installed('agit.vim'),
  \ 'concealedyank': s:bundle.is_installed('concealedyank.vim'),
  \ 'ambicmd': s:bundle.is_installed('vim-ambicmd'),
  \ 'endwize': s:bundle.is_installed('endwize.vim'),
  \ }

" rengbang {{{2
if s:bundle.is_installed('vim-rengbang')
  let g:rengbang_default_pattern  = '\(\d\+\)'
  let g:rengbang_default_start    = 1
  let g:rengbang_default_step     = 1
  let g:rengbang_default_usefirst = 0
  let g:rengbang_default_confirm_sequence = [
    \ 'pattern',
    \ 'start',
    \ 'step',
    \ 'usefirst',
    \ 'format',
    \ ]
endif

" jqplay {{{2
let g:jqplay_opt = ""

" vim-node {{{2
if s:bundle.is_installed('vim-node')
  let node#filetypes = ["javascript", "json", 'coffee']
  let node#suffixesadd = [] " already registered at ftplugin
endif

" previm {{{2
if s:bundle.is_installed('previm')
  let g:previm_enable_realtime=1
  " let g:previm_disable_default_css = 1
  " let g:previm_custom_css_path = expand('~/.vim/lib/previm/github.css')
endif

" projectionist {{{2
" if s:bundle.is_installed('vim-projectionist')
" endif

" phpcomplete-extended {{{2
if s:bundle.is_installed('phpcomplete-extended')
  let g:phpcomplete_index_composer_command = "composer"
  " disable confirm dialog
  let g:phpcomplete_no_auto_project_detection = 1
  " let g:phpcomplete_extended_use_default_mapping = 0
  " MyAutoCmd FileType php call s:phpcomplete_init()
  " function! s:phpcomplete_init()
  "   <Plug>(phpcomplete-extended-goto)
  "   <Plug>(phpcomplete-extended-doc)
  "   <Plug>(phpcomplete-extended-add-use)
  " endfunction
endif

" phpcomplete {{{2
if s:bundle.is_installed('phpcomplete.vim')
  let g:phpcomplete_add_class_extensions =
  \ ['mongo', 'imagemagick', 'libxml', 'memcache', 'memcached', 'pdo']
  let g:phpcomplete_add_function_extensions =
  \ ['mongo', 'json', 'gd', 'sqlite', 'memcache', 'http']
endif

" translategoole.vim {{{2
function! s:vimrc_translategoole()
  nnoremap <buffer><nowait> q :<C-u>TranslateGoogleClose<CR>
  nnoremap <buffer><nowait> T :<C-u>TranslateGoogleToggle<CR>
endfunction
MyAutoCmd User PluginTranslateGoogleInitializeAfter call s:vimrc_translategoole()

" quickfixsigns_vim {{{2
if s:bundle.tap('quickfixsigns_vim')
  let g:quickfixsigns_blacklist_buffer = '\(^\|[\/]\)\(__.*__\|NERD_tree_.*\|-MiniBufExplorer-\|\[unite\] - .*\|.*/\)$'
endif

" codic-vim {{{2
if s:bundle.tap('codic-vim')
  " http://sgur.tumblr.com/post/91906146884/codic-vim
  inoremap <silent> <C-x><C-t> <C-R>=<SID>codic_complete()<CR>
  function! s:codic_complete()
    let line = getline('.')
    let start = match(line, '\k\+$')
    let cand = s:codic_candidates(line[start :])
    call complete(start +1, cand)
    return ''
  endfunction

  function! s:codic_candidates(arglead)
    let cand = codic#search(a:arglead, 30)
    " error
    if type(cand) == type(0)
      return []
    endif
    " english -> english terms
    if a:arglead =~# '^\w\+$'
      return map(cand, '{"word": v:val["label"], "menu": join(map(copy(v:val["values"]), "v:val.word"), ",")}')
    endif
    " japanese -> english terms
    return s:reverse_candidates(cand)
  endfunction

  function! s:reverse_candidates(cand)
    let _ = []
    for c in a:cand
      for v in c.values
        call add(_, {"word": v.word, "menu": !empty(v.desc) ? v.desc : c.label })
      endfor
    endfor
    return _
  endfunction
  call s:bundle.untap()
endif

" vim-startify {{{2
if s:bundle.is_installed('vim-startify')
  let g:startify_custom_header =
  \ [ "> " . strftime('%Y/%m/%d (%a) %H:%M:%S'), ]
  \ + readfile($HOME."/.vimrc.startify")
  let g:startify_custom_indices = ['f', 'g', 'h', 'r', 'i', 'o', 'b']
  let g:startify_skiplist = [
  \ 'COMMIT_EDITMSG',
  \ $VIMRUNTIME .'/doc',
  \ 'neobundle/.*/doc',
  \ 'bundle/.*/doc',
  \ ]
  let g:startify_bookmarks = [
  \ '~/.vimrc',
  \ '~/.gvimrc',
  \ '~/.vim/snippets/',
  \ '~/.vim/sonictemplate/',
  \ '~/',
  \ '~/Desktop/',
  \ '~/Dropbox/',
  \ ]
endif

" vim-spice
if s:bundle.is_installed('vim-spice')
  let g:spice_highlight_group = "Search"
  let g:spice#enable_filetypes = {
  \   "_"   : 1,
  \ }
endif

" tern_for_vim {{{2
let g:tern_show_argument_hints=1

"  vim-ruby-heredoc-syntax
if s:bundle.tap('vim-ruby-heredoc-syntax')
  let g:ruby_heredoc_syntax_filetypes = {
    \  "sql" : {
    \    "start" : "SQL",
    \ },
    \ }
  call s:bundle.untap()
endif

" vim-signify {{{}}}
if s:bundle.tap('vim-signify')
  nmap [!space]@ <plug>(signify-next-hunk)
  nmap [!space]: <plug>(signify-prev-hunk)
  call s:bundle.untap()
endif

" context_filetype {{{2
if s:bundle.tap('context_filetype')
  let g:context_filetype#search_offset = 500
  let g:context_filetype#filetypes = get(g:, 'context_filetype#filetypes', {})
  let g:context_filetype#filetypes.html = [{
    \  'start':
    \   '<script\%( [^>]*\)\? type="text/javascript"\%( [^>]*\)\?>',
    \  'end': '</script>', 'filetype': 'javascript',
    \ }, {
    \  'start':
    \   '<script\%( [^>]*\)\? type="text/coffee"\%( [^>]*\)\?>',
    \  'end': '</script>', 'filetype': 'coffee',
    \ }, {
    \   'start': '<script[^>]*shader[^>]*>',
    \   'end': '<\/script>', 'filetype' : 'glsl',
    \ }, {
    \  'start': '<style\%( [^>]*\)\? type="text/css"\%( [^>]*\)\?>',
    \  'end': '</style>', 'filetype': 'css',
    \ }, {
    \  'start': '<?php\?',
    \  'end': '?>', 'filetype': 'php',
    \ } ]
  let g:context_filetype#filetypes.qml = [{
    \   'filetype' : 'javascript',
    \   'start'    : '^\(\s*\)\h\w*:\s*{$',
    \   'end'      : '^\1}'
    \ }, {
    \   'filetype' : 'glsl',
    \   'start'    : ':\s*"',
    \   'end'      : '"'
    \ },
    \ ]
endif
" }}}
" vim-precious {{{2
if s:bundle.tap('vim-precious')
  let g:precious_enable_switchers = {
  \ "help" : {
  \   "setfiletype" : 0
  \ },
  \ "javascript" : {
  \   "setfiletype" : 0
  \ },
  \}
endif

" vim-anzu {{{2
if s:bundle.tap('vim-anzu')
  let g:anzu_status_format = "%p(%i/%l)"
  let g:anzu_bottomtop_word = "search hit BOTTOM, continuing at TOP"
  let g:anzu_topbottom_word = "search hit TOP, continuing at BOTTOM"
  " nmap n <Plug>(anzu-n)zx
  " nmap n <Plug>(anzu-n)zo:<C-u>silent AnzuUpdateSearchStatus\|redraw!<CR>
  function! ExecIfFoldClosed(key)
    if foldclosed('.') != -1
      execute "normal!" a:key
    endif
  endfunction
  nnoremap <Plug>(vimrc-eifc-zO) :call ExecIfFoldClosed("zO")<CR>
  nmap <silent> n <Plug>(anzu-n)<Plug>(vimrc-eifc-zO)
  " nmap n <Plug>(anzu-jump-n)zx<Plug>(anzu-echo-search-status)
  nmap <silent> N <Plug>(anzu-N)<Plug>(vimrc-eifc-zO)
  nmap <silent> * <Plug>(anzu-star)N<Plug>(vimrc-eifc-zO)
  nmap <silent> # <Plug>(anzu-sharp)n<Plug>(vimrc-eifc-zO)
  function! s:bundle.tapped.hooks.on_source(bundle)
    " 一定時間キー入力がないとき、ウインドウを移動したとき、タブを移動したときに
    " 検索ヒット数の表示を消去する
    " MyAutoCmd CursorHold,CursorHoldI,WinLeave,TabLeave * if exists('*anzu#clear_search_status') | call anzu#clear_search_status() | endif
    MyAutoCmd CursorMoved,CursorMovedI,WinLeave,TabLeave * if exists('*anzu#clear_search_status') | call anzu#clear_search_status() | endif
  endfunction
  call s:bundle.untap()
endif

" editorconfig {{{2
if s:bundle.tap('editorconfig-vim')
  " augroup vimrc-editorconfig
  "   function! s:editorconfig_init()
  "     if filereadable('.editorconfig')
  "       NeoBundleSource editorconfig-vim
  "       silent EditorConfigReload
  "       autocmd!
  "     endif
  "   endfunction
  "   autocmd BufReadPost * call s:editorconfig_init()
  " augroup END
  call s:bundle.untap()
endif

" detectindent {{{2
if s:bundle.tap('detectindent')
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType * DetectIndent
    let g:detectindent_preferred_expandtab = 1
  endfunction
  call s:bundle.untap()
endif

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
  \   'left': [ [ 'mode', 'paste' ], [ 'diff_mode', 'fugitive', 'filename', 'cwdirname', 'xenv_version', ] ],
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
  \   'fugitive' : 'g:ll_helper.fugitive',
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
  " colorscheme - http://cocopon.me/blog/?p=3522 " {{{3
  function! s:build_ll_colorscheme()
    let mono0 = '#1d1f21'
    let mono1 = '#282a2e'
    let mono2 = '#303030'
    let mono3 = '#373b41'
    let mono4 = '#707880'
    let mono5 = '#c5c8c6'

    let red    = '#cc6666'
    let green  = '#b5bd68'
    let blue   = '#81a2be'
    let orange = '#de935f'

    let p = {
    \ 'normal':   {},
    \ 'inactive': {},
    \ 'insert':   {},
    \ 'replace':  {},
    \ 'visual':   {},
    \ 'tabline':  {}}
    let p.normal.middle = [
    \ {'bg': mono1, 'fg': mono4}]
    let p.normal.left = [
    \ {'bg': green, 'fg': mono0},
    \ {'bg': mono3, 'fg': mono5}]
    let p.normal.right = [
    \ {'fg': 'white', 'bg': 'red'},
    \ {'fg': 'gray5', 'bg': 'gray10'},
    \ {'fg': 'gray9', 'bg': 'gray4'},
    \ {'fg': 'gray8', 'bg': 'gray2'},
    \ ]
    " \ {'fg': 'white', 'bg': red},
    let p.inactive.middle = [
    \ {'bg': mono2, 'fg': mono4}]
    let p.inactive.right = [
    \ p.inactive.middle[0],
    \ p.inactive.middle[0]]
    let p.inactive.left = [
    \ p.inactive.middle[0],
    \ p.inactive.middle[0]]

    let p.insert.left = [
    \ {'bg': blue, 'fg': mono0},
    \ p.normal.left[1]]
    let p.replace.left = [
    \ {'bg': red, 'fg': mono0},
    \ p.normal.left[1]]
    let p.visual.left = [
    \ {'bg': orange, 'fg': mono0},
    \ p.normal.left[1]]
    let p.tabline.middle = [
    \ {'bg': mono4, 'fg': mono0}]
    let p.tabline.right = [
    \ {'bg': mono1, 'fg': mono4},
    \ {'bg': mono4, 'fg': mono0}]
    let p.tabline.left = [
    \ {'bg': mono1, 'fg': mono4}]
    let p.tabline.tabsel = [
    \ {'bg': mono0, 'fg': mono5}]
    let p = copy(p)

    for mode in values(p)
      for colors in values(mode)
        let colors = map(colors, '[v:val.fg, v:val.bg]')
      endfor
    endfor

    let g:lightline#colorscheme#vimrc#palette = lightline#colorscheme#fill(p)
  endfunction "}}}
  call s:build_ll_colorscheme()
  let g:ll_helper = {}

  function! g:ll_helper.get(...) "{{{3
    for s in a:000
      if !empty(s)
        return s
      endif
    endfor
    return ""
  endfunction

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
    redir => ascii
      silent! ascii
    redir END

    if match(ascii, 'NUL') != -1
      return 'NUL'
    endif

    let nrformat = '0x%02x' " Zero pad hex values
    let encoding = (&fenc == '' ? &enc : &fenc)

    if encoding == 'utf-8' " Zero pad with 4 zeroes in unicode files
      let nrformat = '0x%04x'
    endif

    " Get the character and the numeric value from the return value of :ascii
    " This matches the two first pieces of the return value, e.g.
    " "<F>  70" => char: 'F', nr: '70'
    let [str, char, nr; rest] = matchlist(ascii, '\v\<(.{-1,})\>\s*([0-9]+)')

    let nr = printf(nrformat, nr) " Format the numeric value

    return printf('%s[%s]', nr, char)
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

  function! g:ll_helper.fugitive() "{{{3
    if !self.is_special_ft() && exists('*fugitive#head')
      let s = fugitive#head()
      return len(s) > 10 ? "...".s[-10:] : s
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
    return (strlen(dir) > 13 ? "..." . dir[-10:] : dir)
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

  MyAutoCmd ColorScheme * call s:lightline_update()
  function! s:lightline_update() "{{{3
    if !exists('g:loaded_lightline')
      return
    endif
    try
      if g:colors_name =~# 'wombat\|solarized\|landscape\|jellybeans\|Tomorrow'
        let g:lightline.colorscheme =
              \ substitute(substitute(g:colors_name, '-', '_', 'g'), '256.*', '', '') .
              \ (g:colors_name ==# 'solarized' ? '_' . &background : '')
      endif
      call lightline#init()
      call lightline#colorscheme()
      call lightline#update()
    catch
    endtry
  endfunction

  call s:bundle.untap()

endif

"  jplus {{{2
if s:bundle.tap('vim-jplus')
  nmap <Leader>j <Plug>(jplus-getchar-with-space)
  vmap <Leader>j <Plug>(jplus-getchar-with-space)
  call s:bundle.untap()
endif

" commentary {{{2
if s:bundle.tap('vim-commentary')
  xmap gc <Plug>Commentary
  nmap gc <Plug>Commentary
  nmap gcc <Plug>CommentaryLine
  nmap gcu <Plug>CommentaryUndo
  call s:bundle.untap()
endif

" showmultibase {{{2
if s:bundle.tap('ShowMultiBase')
  let g:ShowMultiBase_General_UseDefaultMappings = 0

  noremap <silent> <Leader>= :ShowMultiBase<CR>
  noremap <silent> <Leader>b= :ShowMultiBase 2<CR>
  noremap <silent> <Leader>o= :ShowMultiBase 8<CR>
  noremap <silent> <Leader>d= :ShowMultiBase 10<CR>
  noremap <silent> <Leader>h= :ShowMultiBase 16<CR>
  call s:bundle.untap()
endif

" speeddating {{{2
if s:bundle.tap('vim-speeddating')
  let g:speeddating_no_mappings = 1

  if g:vimrc_enabled_plugins.increment_activator
    function! s:speeddating_or_incact(incr) "{{{3
      let line = getline('.')
      execute 'normal' abs(a:incr)."\<Plug>SpeedDating".(a:incr < 0 ? 'Down' : 'Up')
      if line == getline('.')
        execute 'normal' "\<Plug>(increment-activator-".(a:incr < 0 ? 'decrement' : 'increment').")"
      endif
    endfunction " }}}
    nmap <silent> <C-a> :<C-u>call <SID>speeddating_or_incact(v:count1)<CR>
    nmap <silent> <C-x> :<C-u>call <SID>speeddating_or_incact(-v:count1)<CR>

  elseif !g:vimrc_enabled_plugins.cycle
    nmap <C-A> <Plug>SpeedDatingUp
    nmap <C-X> <Plug>SpeedDatingDown
  else
    function! s:speeddating_or_cycle(incr) "{{{3
      let line = getline('.')
      execute 'normal' abs(a:incr)."\<Plug>SpeedDating".(a:incr < 0 ? 'Down' : 'Up')
      if line == getline('.')
        execute 'normal' "\<Plug>Cycle".(a:incr < 0 ? 'Previous' : 'Next')
      endif
    endfunction " }}}
    nmap <silent> <C-a> :<C-u>call <SID>speeddating_or_cycle(v:count1)<CR>
    nmap <silent> <C-x> :<C-u>call <SID>speeddating_or_cycle(-v:count1)<CR>
  endif
  xmap <C-A> <Plug>SpeedDatingUp
  xmap <C-X> <Plug>SpeedDatingDown
  nmap d<C-A> <Plug>SpeedDatingNowUTC
  nmap d<C-X> <Plug>SpeedDatingNowLocal

  call s:bundle.untap()
endif

" cycle.vim {{{2
if s:bundle.tap('vim-cycle')
  let g:cycle_no_mappings=1

  if !g:vimrc_enabled_plugins.speeddating
    nmap <C-A> <Plug>CycleNext
    nmap <C-X> <Plug>CyclePrevious
  endif

  function! s:bundle.tapped.hooks.on_post_source(bundle)
    call AddCycleGroup(['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
    " call AddCycleGroup(['jan', 'feb', 'mar', 'apr', 'may', 'june', 'july', 'aug', 'sep', 'oct', 'nov', 'dec'])
    call AddCycleGroup([ 'january', 'february', 'march', 'april', 'may',
          \ 'june', 'july', 'august', 'september', 'october',
          \ 'november', 'december'])

    call AddCycleGroup(['specify', 'it'])
    call AddCycleGroup(['describe', 'context'])
    call AddCycleGroup(['public', 'protected', 'private'])
    call AddCycleGroup(['#', '##', '###', '####', '#####'])
    call AddCycleGroup(["-", "\t-", "\t\t-", "\t\t\t-"])
  endfunction
  call s:bundle.untap()
endif

" vimconsole.vim {{{2
if s:bundle.tap('vimconsole.vim')
  let g:vimconsole#auto_redraw = 1
  let g:vimconsole#maximum_caching_objects_count = 1000

  nnoremap [!space]vc :<C-u>VimConsoleToggle<CR>

  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType vimconsole call s:vimrc_vimconsole_init()
    function! s:vimrc_vimconsole_init() "{{{3
      nnoremap <buffer> <C-l> :<C-u>VimConsoleRedraw<CR>
    endfunction
  endfunction "}}}
  call s:bundle.untap()
endif

" perlomni {{{2
if s:bundle.tap('perlomni.vim')
  function! s:bundle.tapped.hooks.on_source(bundle)
    if &filetype == "perl"
      call s:path_push(s:bundle.get('perlomni.vim').path . '/bin')
    endif
  endfunction
  call s:bundle.untap()
endif

" cake.vim {{{2
if s:bundle.tap('cake.vim')
  let g:cakephp_no_default_keymappings = 1
  let g:cakephp_enable_fix_mode = 1
  let g:cakephp_enable_auto_mode = 1
  let g:cakephp_view_exts = ['.ctp', '.twig']

  function! s:bundle.tapped.hooks.on_post_source(bundle)
    MyAutoCmd User PluginCakephpInitializeAfter call s:init_cakephp()
    call cake#init_app('')
    if &filetype =~? "php" || &filetype =~? 'twig'
      call s:init_cakephp()
    endif
  endfunction

  function! s:detect_cakephpapp() "{{{
    if exists('g:cake.paths.app')
      return stridx(expand('%:p'), g:cake.paths.app) == 0
    endif
    return 0
  endfunction " }}}

  function! s:init_cakephp() "{{{
    if s:detect_cakephpapp()
      nmap <buffer> gf <Plug>CakeJump
      nmap <buffer> <C-w>f <Plug>CakeSplitJump
      nmap <buffer> <C-w>gf <Plug>CakeTabJump

      nnoremap <buffer> [!app]c :<C-u>Unite cake_controller<CR>
      nnoremap <buffer> [!app]m :<C-u>Unite cake_model<CR>
      nnoremap <buffer> [!app]v :<C-u>Unite cake_view<CR>
      nnoremap <buffer> [!app]h :<C-u>Unite cake_helper<CR>
      nnoremap <buffer> [!app]s :<C-u>Unite cake_shell<CR>
      nnoremap <buffer> [!app]t :<C-u>Unite cake_task<CR>
      nnoremap <buffer> [!app]f :<C-u>Unite cake_config<CR>
      nnoremap <buffer> [!app]p :<C-u>Unite cake_component<CR>
      nnoremap <buffer> [!app]l :<C-u>Unite cake_lib<CR>
      nnoremap <buffer> [!app]b :<C-u>Unite cake_behavior<CR>

      " nnoremap <buffer> <Leader>cc :Ccontroller
      " nnoremap <buffer> <Leader>cm :Cmodel
      " nnoremap <buffer> <Leader>cv :Cview
      " nnoremap <buffer> <Leader>cw :Ccontrollerview
      " nnoremap <buffer> <Leader>cs :Cshell
      " nnoremap <buffer> <Leader>ct :Ctask
      " nnoremap <buffer> <Leader>cf :Cconfig
      " nnoremap <buffer> <Leader>cp :Ccomponent
      " nnoremap <buffer> <Leader>cl :Clog

      nnoremap <buffer> [!cw-app]cc :Ccontrollersp
      nnoremap <buffer> [!cw-app]cm :Cmodelsp
      nnoremap <buffer> [!cw-app]cv :Cviewsp
      nnoremap <buffer> [!cw-app]cw :Ccontrollerviewsp
      nnoremap <buffer> [!cw-app]cf :Cconfigsp
      nnoremap <buffer> [!cw-app]cp :Ccomponentsp
    endif
  endfunction " }}}

  call s:bundle.untap()
endif


" gitv {{{2
if s:bundle.tap('gitv')
  let g:Gitv_OpenHorizontal = 1
  let g:Gitv_WipeAllOnClose = 1
  let g:Gitv_DoNotMapCtrlKey = 1
  " http://d.hatena.ne.jp/cohama/20130517/1368806202
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd FileType gitv call s:vimrc_gitv_init()
    MyAutoCmd FileType git setlocal foldlevel=99
    " MyAutoCmd FileReadCmd,BufReadCmd fugitive://** setlocal foldlevel=99
    function! s:vimrc_gitv_init()
      setl iskeyword+=/,-,.

      nnoremap <buffer> gx :<C-u>Gbrowse <C-r>=GitvGetCurrentHash()<CR><CR>
      if g:vimrc_enabled_plugins.unite
        nnoremap <buffer><nowait> [!space] :<C-u>Unite menu:ft_gitv<CR>
      endif
    endfunction

    function! GitvGetCurrentHash()
      return matchstr(getline('.'), '\[\zs.\{7\}\ze\]$')
    endfunction
  endfunction
  call s:bundle.untap()
endif

" agit.vim {{{2
if s:bundle.tap('agit.vim')
  let g:agit_enable_auto_show_commit = 0
  let g:agit_enable_auto_refresh = 0
  MyAutoCmd FileType agit call s:vimrc_agit_init()
  function! s:vimrc_agit_init()
    if g:vimrc_enabled_plugins.unite
      nnoremap <buffer><nowait> [!space] :<C-u>Unite menu:ft_agit<CR>
    endif
  endfunction
  call s:bundle.untap()
endif

" w3m {{{2
if s:bundle.tap('w3m.vim')
  Alias w3m W3mSplit
  Alias www W3mSplit
  call s:bundle.untap()
endif

" OmniSharp "{{{2
" let g:OmniSharp_host = "http://localhost:2000"
let g:OmniSharp_typeLookupInPreview = 1

" reanimate.vim {{{2
if s:bundle.tap('vim-reanimate')
  let g:reanimate_save_dir = $VIM_CACHE."/vim-reanimate"
  let g:reanimate_default_save_name = "latest"
  " sessionoptions
  let g:reanimate_sessionoptions =
    \ "blank,curdir,folds,help,localoptions,tabpages,unix"
  let g:reanimate_disables = [
    \ "reanimate_message",
    \ "reanimate_viminfo",
    \ "reanimate_window"
    \ ]

  function! s:bundle.tapped.hooks.on_source(bundle)
    augroup vimrc-plugin-reanimate
      autocmd!
      " autocmd VimEnter * ReanimateLoad
      autocmd CursorHold,VimLeavePre * ReanimateSaveCursorHold
    augroup End

    let s:event = {'name': 'user_event'}
    function! s:event.load_pre(...)
      tabnew
      " hide tabonly
    endfunction

    function! s:event.save_pre(...)
      silent! argdelete *
    endfunction

    call reanimate#hook(s:event)
    unlet s:event
  endfunction
  call s:bundle.untap()
endif

" colorv {{{2
if s:bundle.is_installed('colorv.vim')
  let g:colorv_cache_fav = $VIM_CACHE . "/vim_colorv_fav"
  let g:colorv_cache_file = $VIM_CACHE . "/vim_colorv_cache"
  " let g:colorv_preview_ftype = 'css,html,scss,sass'
  let g:colorv_preview_ftype = 'css,scss,sass'
  " let g:colorv_python_cmd = ''
  let g:colorv_no_global_map = 1
  " g:colorv_global_leader
endif

" trans.vim {{{2
let g:trans_default_lang = "en-ja"

" inline_edit {{{2
if s:bundle.is_installed('inline_edit.vim')
  let g:inline_edit_autowrite = 1
  let g:inline_edit_patterns = [
        \ {
        \ 'main_filetype': '*html',
        \ 'sub_filetype': 'handlebars',
        \ 'indent_adjustment': 1,
        \ 'start': '<script\>[^>]*type="text/template"[^>]*>',
        \ 'end': '</script>',
        \ }
        \ ]
  nnoremap <Leader>i :<C-u>InlineEdit<CR>
endif

" cascading.vim {{{2
if s:bundle.is_installed('cascading.vim')
  nmap <silent> !" <Plug>(cascading)
endif

" increment-activator {{{2
if s:bundle.is_installed('increment-activator')
  let g:increment_activator_no_default_key_mappings = 1
  let g:increment_activator_filetype_candidates = {
    \ '_': [
    \   ['get', 'post', 'put', 'delete'],
    \   ['pick', 'squash', 'edit', 'reword', 'fixup', 'exec'],
    \   ['previous', 'current', 'next'],
    \   ['=', ':='],
    \   ['true', 'false'],
    \   ['月','火','水','木','金','土','日'],
    \ ],
    \ 'php': [
    \   ['private', 'protected', 'public'],
    \   ['extends', 'implements'],
    \   ['assert', 'depends', 'dataProvider', 'expectedException', 'group', 'test'],
    \ ],
    \ 'vim': [
    \   ['echo', 'echomsg'],
    \   ['if', 'elseif', 'endif'],
    \   ['for', 'endfor'],
    \   ['function', 'endfunction'],
    \   ['try', 'catch', 'finally'],
    \   ['nnoremap', 'xnoremap', 'inoremap', 'vnoremap', 'cnoremap', 'onoremap'],
    \   ['nmap', 'xmap', 'imap', 'vmap', 'cmap', 'omap'],
    \   ['NeoBundle', 'NeoBundleLazy'],
    \   ['Home', 'End', 'Left', 'Right', 'Delete'],
    \   ['has', 'has_key', 'exists'],
    \ ],
    \ 'go': [
    \   ['true', 'false', 'iota', 'nil'],
    \   ['print', 'println'],
    \   ['byte', 'complex64', 'complex128'],
    \   ['int', 'int8', 'int16', 'int32', 'int64'],
    \   ['uint', 'uint8', 'uint16', 'uint32', 'uint64'],
    \   ['float32', 'float64'],
    \   ['interface', 'struct'],
    \ ],
    \ 'ruby': [
    \   ["describe", "context", "specific", "example"],
    \   ['public', 'protected', 'private'],
    \   ['before', 'after'],
    \   ['be_true', 'be_false'],
    \   ['get', 'post', 'put', 'delete'],
    \   ['==', 'eql', 'equal'],
    \   [ '.should_not', '.should' ],
    \   ['.to_not', '.to'],
    \ ],
    \ 'markdown': [
    \   ['[ ]', '[x]'],
    \   ['#', '##', '###', '####', '#####', ],
    \   ["-", "\t-", "\t\t-", "\t\t\t-", ],
    \   ["+", "\t+", "\t\t+", "\t\t\t+", ],
    \ ],
    \ }
endif

" undotree {{{2
if s:bundle.is_installed('undotree')
  nnoremap <Leader>u :<C-u>UndotreeToggle<CR>

  let g:undotree_SetFocusWhenToggle = 1
  " let g:undotree_SplitLocation = 'topleft'
  let g:undotree_WindowLayout = 'topleft'
  let g:undotree_SplitWidth = 35
  let g:undotree_diffAutoOpen = 1
  let g:undotree_diffpanelHeight = 25
  let g:undotree_RelativeTimestamp = 1
  let g:undotree_TreeNodeShape = '*'
  let g:undotree_HighlightChangedText = 1
  let g:undotree_HighlightSyntax = "UnderLined"
endif

" vim-localrc {{{2
if s:bundle.is_installed('vim-localrc')
  let g:localrc_filename = '.vimrc_local.vim'
  if has('vim_starting')
    " http://vim-users.jp/2009/12/hack112/ => vimrc-local
    call localrc#load('vimrc_local.vim', getcwd(), 3)
  endif
  function! s:edit_vimrc_local()
    let fpath = s:find_proj_dir() . "/" .g:localrc_filename
    if !filereadable(fpath)
      let fpath = input( g:localrc_filename . " :", fpath)
    endif
    if !empty(fpath)
      execute "edit" "+split" fpath
    endif
  endfunction
  command! VimrcLocalEdit call s:edit_vimrc_local()
endif


" eregex.vim {{{2
let g:eregex_default_enable=0

" vim-trimr {{{2
if s:bundle.is_installed('vim-trimr')
  let g:trimr_method = 'ignore_filetype'
  let g:trimr_targets = ['markdown', 'mkd', 'textile']
endif

" clever-f {{{2
if s:bundle.is_installed('clever-f.vim')
  let g:clever_f_not_overwrites_standard_mappings=1
  if g:vimrc_enabled_plugins.unite
    nmap [!unite]f <Plug>(clever-f-f)
    vmap f <Plug>(clever-f-f)
  else
    map f <Plug>(clever-f-f)
  endif
  map F <Plug>(clever-f-F)
  " map t <Plug>(clever-f-t)
  " map T <Plug>(clever-f-T)
endif

" smalls {{{2
if s:bundle.tap('vim-smalls')
  nmap ,f <Plug>(smalls)
  omap ,f <Plug>(smalls)
  xmap ,f <Plug>(smalls)
  let g:smalls_auto_excursion_min_input_length = 2

  function! s:bundle.tapped.hooks.on_source(bundle)
    let s:cli_table_custom = {
    \ "\<C-g>": 'do_cancel',
    \ "\<C-j>": 'do_jump',
    \ "\<CR>": 'do_set',
    \ }
    call smalls#keyboard#cli#extend_table(s:cli_table_custom)
    unlet s:cli_table_custom
  endfunction
endif

" dirdiff.vim {{{2
if s:bundle.is_installed('DirDiff.vim')
  let g:DirDiffExcludes = "CVS,*.class,*.o,*.exe,.*.swp,*.log,.git,.svn,.hg"
  let g:DirDiffIgnore = "Id:,Revision:,Date:"
  map ;dg <Plug>DirDiffGet
  map ;dp <Plug>DirDiffPut
  map ;dj <Plug>DirDiffNext
  map ;dk <Plug>DirDiffPrev
endif

" splitjoin.vim {{{2
if s:bundle.is_installed('splitjoin.vim')
  let g:splitjoin_split_mapping = 'gS'
  let g:splitjoin_join_mapping = 'gJ'
  let g:splitjoin_normalize_whitespace = 1
  let g:splitjoin_align = 1

  " nmap ,j :<C-u>SplitjoinSplit<CR>
  " nmap ,k :<C-u>SplitjoinJoin<CR>
endif

" rainbow_parentheses {{{2
if s:bundle.tap('rainbow_parentheses.vim')
  function! s:bundle.tapped.hooks.on_source(bundle)
    MyAutoCmd VimEnter * RainbowParenthesesToggleAll
  endfunction
  call s:bundle.untap()
endif

" rainbow {{{2
if s:bundle.tap('rainbow')
  let g:rainbow_active = 1
  let g:rainbow_conf = {
  \  'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
  \  'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
  \  'operators': '_,_',
  \  'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
  \  'separately': {
  \    '*': {},
  \    'tex': {
  \      'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
  \    },
  \    'lisp': {
  \      'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
  \    },
  \    'vim': {
  \      'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
  \    },
  \    'html': {
  \      'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
  \    },
  \    'css': 0,
  \  }}
  " let g:rainbow_load_separately = [
  "   \ [ '*' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
  "   \ [ '*.tex' , [['(', ')'], ['\[', '\]']] ],
  "   \ [ '*.cpp' , [['(', ')'], ['\[', '\]'], ['{', '}']] ],
  "   \ [ '*.{html,htm}' , [['(', ')'], ['\[', '\]'], ['{', '}'], ['<\a[^>]*>', '</[^>]*>']] ],
  "   \ ]
endif

" lexima.vim {{{2
if s:bundle.tap('lexima.vim')
  function! s:bundle.tapped.hooks.on_source(bundle)
    call lexima#add_rule({
      \ 'at':       '(\%#)',
      \ 'char':     '<Space>',
      \ 'input':    '<Space>',
      \ 'input_after': '<Space>',
      \ 'mode': 'i',
      \ })

    call lexima#add_rule({
      \ 'at': '( \%# )',
      \ 'char': '<BS>',
      \ 'input': '<BS>',
      \ 'delete': 1,
      \ 'mode': 'i',
      \ })

    call lexima#add_rule({
      \ 'at':       '{\%#}',
      \ 'char':     '<Space>',
      \ 'input':    '<Space>',
      \ 'input_after': '<Space>',
      \ 'mode': 'i',
      \ })

    call lexima#add_rule({
      \ 'at':       '{ \%# }',
      \ 'char':     '<BS>',
      \ 'input': '<BS>',
      \ 'delete': 1,
      \ 'mode': 'i',
      \ })

    call lexima#add_rule({
      \ 'at':       '\[\%#\]',
      \ 'char':     '<Space>',
      \ 'input':    '<Space>',
      \ 'input_after': '<Space>',
      \ 'mode': 'i',
      \ })

    call lexima#add_rule({
      \ 'at':       '\[ \%# \]',
      \ 'char':     '<BS>',
      \ 'input': '<BS>',
      \ 'delete': 1,
      \ 'mode': 'i',
      \ })

    " Ruby 文字列内変数埋め込み
    call lexima#add_rule({
      \ 'at': '\%#',
      \ 'char': '#',
      \ 'input':    '#{',
      \ 'input_after': '}',
      \ 'filetype': ['ruby'],
      \ 'syntax': ['Constant', 'Special'],
      \ 'mode': 'i',
      \ })

    " Ruby ブロック引数 ||
    call lexima#add_rule({
      \ 'at': '\({\|\<do\>\)\s*\%#',
      \ 'char': '<Bar>',
      \ 'input': '<Bar>',
      \ 'input_after': '<Bar>',
      \ 'filetype': ['ruby'],
      \ 'mode': 'i',
      \  })

    " テンプレート内のスペース
    call lexima#add_rule({
      \ 'at':       '<\%#>',
      \ 'char':     '<Space>',
      \ 'input':    '<Space>',
      \ 'input_after':    '<Space>',
      \ 'filetype': ['cpp'],
      \ 'mode': 'i',
      \ })
    call lexima#add_rule({
      \ 'at':       '< \%# >',
      \ 'char':     '<BS>',
      \ 'input':    '<BS>',
      \ 'filetype': ['cpp'],
      \ 'delete': 1,
      \ 'mode': 'i',
      \ })
    " struct
    call lexima#add_rule({
      \ 'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
      \ 'char'     : '{',
      \ 'input'    : '{',
      \ 'input_after'    : '};',
      \ 'filetype' : ['cpp'],
      \ 'mode': 'i',
      \ })
    " http://qiita.com/hatchinee/items/c5bc19a656925ce33882
    " classとかの定義時に:までを入れる
    call lexima#add_rule({
      \ 'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#',
      \ 'char'     : '(',
      \ 'input'    : '(',
      \ 'input_after': '):',
      \ 'filetype' : ['python'],
      \ 'mode': 'i',
      \ })
    " が、すでに:がある場合は重複させない. (smartinputでは、atの定義が長いほど適用の優先度が高くなる)
    call lexima#add_rule({
      \ 'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#.*:',
      \ 'char'     : '(',
      \ 'input'    : '(',
      \ 'input_after': ')',
      \ 'filetype' : ['python'],
      \ 'mode': 'i',
      \ })
    " 末尾:の手前でも、エンターとか:で次の行にカーソルを移動させる
    call lexima#add_rule({
      \ 'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
      \ 'char'     : ':',
      \ 'input'    : '<CR>',
      \ 'leave' : 1,
      \ 'filetype' : ['python'],
      \ 'mode': 'i',
      \ })
    call lexima#add_rule({
      \ 'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
      \ 'char'     : '<CR>',
      \ 'input'    : '<CR>',
      \ 'leave' : 1,
      \ 'filetype' : ['python'],
      \ 'mode': 'i',
      \ })

    " call lexima#insmode#define_altanative_key('<Plug>(lexima-BS)', '<BS>')
    " call lexima#insmode#define_altanative_key('<Plug>(lexima-C-h)', '<C-h>')
    " call lexima#insmode#define_altanative_key('<Plug>(lexima-CR)', '<CR>')
    " call lexima#insmode#define_altanative_key('<Plug>(lexima-SPACE)', '<Space>')

    if s:bundle.is_installed('neocomplete.vim')
      call lexima#insmode#map_hook('before', '<CR>',
      \ "\<C-]><C-r>=neocomplete#smart_close_popup()\<CR>")
      call lexima#insmode#map_hook('before', '<Space>',
      \ "\<C-]>\<C-r>=neocomplete#smart_close_popup()\<CR>")
      call lexima#insmode#map_hook('before', '<C-h>', "\<C-r>=neocomplete#smart_close_popup()\<CR>")
      call lexima#insmode#map_hook('before', '<BS>', "\<C-r>=neocomplete#smart_close_popup()\<CR>")
    endif

  endfunction
  call s:bundle.untap()
endif

" vim-smartinput {{{2
if s:bundle.tap('vim-smartinput')
  function! s:bundle.tapped.hooks.on_source(bundle)
    function! s:smartinput_init() "{{{
      " if hasmapto('<CR>', 'c')
      "   cunmap <CR>
      " endif
    endfunction " }}}

    function! s:sminput_define_rules(is_load_default_rules) "{{{
      if a:is_load_default_rules
        call smartinput#define_default_rules()
      endif
      source ~/.vim/smartinput.vim
    endfunction "}}}

    command! SmartinputOff call smartinput#clear_rules()
    command! SmartinputOn call s:sminput_define_rules(1) | call s:smartinput_init()
    " --;;;;;;;;
    command! -nargs=? SmartinputBufferMapClear call s:sminput_buffer_mapclear(<q-args>)

    function! s:sminput_buffer_mapclear(mode) "{{{
      let mode = empty(a:mode) ? '*' : a:mode
      let vars = smartinput#scope()
      let hash = {}
      " TODO special keys
      let rules = filter(get(vars, 'available_nrules', []), 'v:val._char =~# "^[a-zA-Z0-9!-/:-@\\[-`{-~]\\+$"')
      for item in copy(filter(rules, 'mode == "*" || mode == v:val.mode'))
        if get(hash, item._char, 1)
          let char = substitute(item._char, '[|]', '\\\1', 'g')
          execute printf("silent! %smap \<buffer> %s", item.mode, char)
          " execute printf("%smap \<buffer> %s %s", item.mode, char, char)
          " execute printf("%sunmap \<buffer> %s", item.mode, char)
          let hash[item._char] = 0
        endif
      endfor
    endfunction "}}}

    call s:sminput_define_rules(0)
    call s:smartinput_init()
  endfunction
  call s:bundle.untap()
endif

" memolist {{{2
if s:bundle.is_installed('memolist.vim')
  let g:memolist_memo_suffix = "md"
  let g:memolist_path = $HOME . '/memo'
  " let g:memolist_vimfiler = 1

  if g:vimrc_enabled_plugins.unite
    nmap <silent> ,ml :<C-u>Unite memolist<CR>
    nmap <silent> ,mg :<C-u>call <SID>unite_grep(g:memolist_path)<CR>
  else
    nmap <silent> ,ml :MemoList<CR>
    nmap <silent> ,mg :MemoGrep<CR>
  endif
  nmap <silent> ,mc :MemoNew<CR>
endif

" golden-ratio {{{2
" let g:golden_ratio_ignore_ftypes=['unite', 'vimfiler']
", 'quickrun']
" nmap [!space]s <Plug>(golden_ratio_toggle)

" ambicmd {{{2
if s:bundle.is_installed('vim-ambicmd')
  function! s:ambicmd_expand(key, mode, line)
    " give priority to altercmd.vim
    if hasmapto(a:line, a:mode, 1)
      return a:key
    endif
    return ambicmd#expand(a:key)
  endfunction

  cmap <expr> <Space> <SID>ambicmd_expand("\<Space>", "c", getcmdline())
  cmap <expr> <CR> <SID>ambicmd_expand("\<CR>", "c", getcmdline())
  " cnoremap <expr> <C-l> ambicmd#expand("\<Space>")
  " cnoremap <expr> <Space> ambicmd#expand("\<Space>")
  " cnoremap <expr> <CR> ambicmd#expand("\<CR>")
endif

" camelcasemotion {{{2
if s:bundle.tap('CamelCaseMotion')
  nmap <silent> ,w <Plug>CamelCaseMotion_w
  nmap <silent> ,e <Plug>CamelCaseMotion_e
  nmap <silent> ,b <Plug>CamelCaseMotion_b
  vmap <silent> ,w <Plug>CamelCaseMotion_w
  vmap <silent> ,e <Plug>CamelCaseMotion_e
  vmap <silent> ,b <Plug>CamelCaseMotion_b

  omap <silent> i,w <Plug>CamelCaseMotion_iw
  xmap <silent> i,w <Plug>CamelCaseMotion_iw
  omap <silent> i,b <Plug>CamelCaseMotion_ib
  xmap <silent> i,b <Plug>CamelCaseMotion_ib
  omap <silent> i,e <Plug>CamelCaseMotion_ie
  xmap <silent> i,e <Plug>CamelCaseMotion_ie

  call s:bundle.untap()
endif

" indent-guides {{{2
if s:bundle.tap('vim-indent-guides')
  let g:indent_guides_enable_on_vim_startup = 1
  let g:indent_guides_indent_levels = 10
  if has('gui_running')
    let g:indent_guides_auto_colors = 1
  else
    function! s:bundle.tapped.hooks.on_source(bundle)
      let g:indent_guides_auto_colors = 0
      augroup vimrc-plugin-indentguides
        autocmd!
        autocmd VimEnter,Colorscheme * :highlight IndentGuidesEven ctermbg=236 ctermfg=white
        autocmd VimEnter,Colorscheme * :highlight IndentGuidesOdd ctermbg=235 ctermfg=white
      augroup END
    endfunction
    call s:bundle.untap()
  endif
endif

if s:bundle.tap('indentLine')
  let g:indentLine_enabled=1
  let g:indentLine_char = '¦'
  let g:indentLine_color_term = 236
  if s:is_win
    let g:indentLine_color_gui = 'lightgray'
  else
    let g:indentLine_color_gui = '#333'
  endif
  let g:indentLine_faster = 1
  let g:indentLine_fileTypeExclude = [
  \ 'help', 'nerdtree', 'calendar', 'thumbnail', 'tweetvim',
  \ 'unite', 'vimfiler', 'vimshell',
  \ ]
endif


" smartword {{{2
if s:bundle.is_installed('vim-smartword')
  nmap w  <Plug>(smartword-w)
  nmap b  <Plug>(smartword-b)
  nmap e  <Plug>(smartword-e)
  nmap ge <Plug>(smartword-ge)
  vmap w  <Plug>(smartword-w)
  vmap b  <Plug>(smartword-b)
  vmap e  <Plug>(smartword-e)
  vmap ge <Plug>(smartword-ge)
endif

" vim-altr {{{2
if s:bundle.tap('vim-altr')
  function! s:bundle.tapped.hooks.on_source(bundle)
    call altr#define('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim', 'test/%.vim')

    call altr#define('%.c', '%.cpp', '%.m', '%.h')

    call altr#define('%.rb', 'spec/%_spec.rb')
    call altr#define('lib/%.rb', 'spec/lib/%_spec.rb')
    call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
    call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
    call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')

    call altr#define('%.js', 'test/%Test.js', 'test/%_test.js', 'spec/%_spec.js', 'spec/%Spec.js')
    call altr#define('%.coffee', 'test/%Test.coffee', 'test/%_test.coffee', 'spec/%_spec.coffee', 'spec/%Spec.coffee')

    call altr#define('Controller/%.php', 'Test/Case/Controller/%Test.php')
    call altr#define('Model/%.php', 'Test/Case/Model/%Test.php')
    call altr#define('View/Helper/%.php', 'Test/Case/View/Helper/%Test.php')
    call altr#define('View/%.php', 'Test/Case/View/%Test.php')
  endfunction

  nmap [!space]k <Plug>(altr-back)
  nmap [!space]j <Plug>(altr-forward)
  nmap <F1> <Plug>(altr-back)
  nmap <F2> <Plug>(altr-forward)
  call s:bundle.untap()
endif

" vim-template "{{{2
if s:bundle.tap('vim-template')
  let g:template_basedir = expand('$HOME/.vim')
  let g:template_files = 'template/**'
  let g:template_free_pattern = 'template'

  function! s:template_keywords() "{{{3
    silent! %s/<+FILENAME_NOEXTUC+>/\=toupper(expand('%:t:r'))/g
    silent! %s/<+FILENAME_NOEXT+>/\=expand('%:t:r')/g
    silent! %s/<+FILENAME+>/\=expand('%:t')/g
    silent! %s/<+EMAIL+>/\=g:email/g
    silent! %s/<+AUTHOR+>/\=g:author/g
    silent! %s/<+HOMEPAGE_URL+>/\=g:homepage_url/g
    silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
    silent! execute "normal! gg"
    "" expand eval
    %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge

    if search('<+CURSOR+>')
      silent! execute 'normal! "_da>'
    endif
  endfunction

  call my#config#mkvars(['g:email', 'g:author', 'g:homepage_url'], '')

  "autocmd BufNewFile * execute 'TemplateLoad'
  MyAutoCmd User plugin-template-loaded call s:template_keywords()

  call s:bundle.untap()
endif

" sonictemplate-vim {{{2
if s:bundle.tap('sonictemplate-vim')
  let g:sonictemplate_vim_template_dir = expand('$HOME/.vim/sonictemplate/')
  " nmap <C-y><C-t> <Plug>(sonictemplate)
  " imap <C-y><C-t> <Plug>(sonictemplate)
  nmap <C-y><C-t> :<C-u>Unite sonictemplate<CR>
  imap <C-y><C-t> <ESC>:<C-u>Unite sonictemplate<CR>

  let g:sonictemplate_key='\<Nop>'
  " let g:sonictemplate_intelligent_key='\<Nop>'
  nmap <C-y>t :<C-u>Unite sonictemplate<CR>
  imap <C-y>t <ESC>:<C-u>Unite sonictemplate<CR>
endif

" junkfile.vim http://vim-users.jp/2010/11/hack181/ {{{2
if s:bundle.tap('junkfile.vim')
  nnoremap ,sj :<C-u>JunkfileOpen<CR>
  call s:bundle.untap()
endif
command! -nargs=0 EnewNofile enew | setl buftype=nofile

nmap ,ss :<C-u>EnewNofile<CR>

" alignta {{{2
if s:bundle.tap('vim-alignta')
  let g:alignta_confirm_for_retab = 0
  " let g:Align_xstrlen=3
  " vmap ,a :Align

  vnoremap ,a :Alignta
  vnoremap ,,a :Alignta<< [:=><\-)}\]]\+
  vnoremap ,,r :Alignta<< [=><\-)}\]]\+
  vnoremap ,,t :Alignta \|<CR>
  vnoremap ,,c :Alignta<< \(//\|#\|\/\*\)/1<CR>
endif

" submode {{{2
" http://d.hatena.ne.jp/tyru/20100502/vim_mappings
if s:bundle.is_installed('vim-submode')

  " browser {{{3
  if s:is_mac
    call submode#enter_with('cscroll', 'n', '', 'sb', ':ChromeScrollDown<CR>')
    " call submode#enter_with('cscroll', 'n', '', 'sk', ':ChromeScrollUp<CR>')
    call submode#map('cscroll', 'n', '', 'j', ':ChromeScrollDown<CR>')
    call submode#map('cscroll', 'n', '', 'k', ':ChromeScrollUp<CR>')
    call submode#map('cscroll', 'n', '', 'l', ':ChromeTabRight<CR>')
    call submode#map('cscroll', 'n', '', 'h', ':ChromeTabLeft<CR>')
    call submode#map('cscroll', 'n', '', 'L', ':ChromePageGo<CR>')
    call submode#map('cscroll', 'n', '', 'H', ':ChromePageBack<CR>')
    call submode#map('cscroll', 'n', '', 'r', ':ChromeTabReload<CR>')
  endif

  " expand-region {{{3
  if g:vimrc_enabled_plugins.expand_region
    " don't work...
    call submode#enter_with('ex_region', 'nv', 'r',  '<Leader>e', '<Plug>(expand_region_expand)')
    call submode#leave_with('ex_region', 'nv', '',  '<Esc>')
    call submode#map       ('ex_region', 'nv', 'r', 'l', "<Plug>(expand_region_expand)")
    call submode#map       ('ex_region', 'nv', 'r', 'e', "<Plug>(expand_region_expand)")
    call submode#map       ('ex_region', 'nv', 'r', 'h', "<Plug>(expand_region_shrink)")
    call submode#map       ('ex_region', 'nv', 'r', 's', "<Plug>(expand_region_shrink)")
    " let g:expand_region_use_select_mode = 0
  endif

  " Change current window size {{{3
  call submode#enter_with('winsize', 'n', '', 'sw', '<Nop>')
  call submode#leave_with('winsize', 'n', '', '<Esc>')
  call submode#map       ('winsize', 'n', '', 'j', '<C-w>-:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'k', '<C-w>+:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'h', '<C-w><:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'l', '<C-w>>:redraw<CR>')
  call submode#map       ('winsize', 'n', '', 'J', ':set lines+=1<CR>')
  call submode#map       ('winsize', 'n', '', 'K', ':set lines-=1<CR>')
  call submode#map       ('winsize', 'n', '', 'H', ':set columns-=5<CR>')
  call submode#map       ('winsize', 'n', '', 'L', ':set columns+=5<CR>')
  call submode#map       ('winsize', 'n', '', '-', '<C-w>-:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '+', '<C-w>+:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '<', '<C-w><:redraw<CR>')
  call submode#map       ('winsize', 'n', '', '>', '<C-w>>:redraw<CR>')

  " undo/redo {{{3
  call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
  call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
  call submode#leave_with('undo/redo', 'n', '', '<Esc>')
  call submode#map       ('undo/redo', 'n', '', '-', 'g-')
  call submode#map       ('undo/redo', 'n', '', '+', 'g+')

  " Tab walk. {{{3
  call submode#enter_with('tabwalk', 'n', '', 'st', '<Nop>')
  call submode#enter_with('tabwalk', 'n', '', 'se', '<Nop>')
  call submode#leave_with('tabwalk', 'n', '', '<Esc>')
  call submode#map       ('tabwalk', 'n', '', 'h', 'gT:redraw<CR>')
  call submode#map       ('tabwalk', 'n', '', 'l', 'gt:redraw<CR>')
  call submode#map       ('tabwalk', 'n', '', 'H', ':execute "tabmove" tabpagenr() - 2<CR>')
  call submode#map       ('tabwalk', 'n', '', 'L', ':execute "tabmove" tabpagenr()<CR>')
  call submode#map       ('tabwalk', 'n', '', 'n', ':execute "tabnew"<CR>:tabmove<CR>')
  call submode#map       ('tabwalk', 'n', '', 'c', ':execute "tabnew"<CR>:tabmove<CR>')
  call submode#map       ('tabwalk', 'n', '', 'q', ':execute "tabclose"<CR>')
  call submode#map       ('tabwalk', 'n', '', 'o', ':execute "tabonly"<CR>')

  " winmove {{{3
  call submode#enter_with('winmove', 'n', '', 'sj', '<C-w>j')
  call submode#enter_with('winmove', 'n', '', 'sk', '<C-w>k')
  call submode#enter_with('winmove', 'n', '', 'sh', '<C-w>h')
  call submode#enter_with('winmove', 'n', '', 'sl', '<C-w>l')
  call submode#leave_with('winmove', 'n', '', '<Esc>')
  call submode#map       ('winmove', 'n', '', 'j', '<C-w>j')
  call submode#map       ('winmove', 'n', '', 'k', '<C-w>k')
  call submode#map       ('winmove', 'n', '', 'h', '<C-w>h')
  call submode#map       ('winmove', 'n', '', 'l', '<C-w>l')
  call submode#map       ('winmove', 'n', '', 'J', '<C-w>j')
  call submode#map       ('winmove', 'n', '', 'K', '<C-w>k')
  call submode#map       ('winmove', 'n', '', 'H', '<C-w>h')
  call submode#map       ('winmove', 'n', '', 'L', '<C-w>l')

  " Quickfix {{{3
  call submode#enter_with('quickfix', 'n', '',  'sq', '<Nop>')
  call submode#leave_with('quickfix', 'n', '',  '<Esc>')
  call submode#map       ('quickfix', 'n', '',  'j', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '',  'k', ':cp<CR>')
  call submode#map       ('quickfix', 'n', '',  'n', ':cn<CR>')
  call submode#map       ('quickfix', 'n', '',  'p', ':cp<CR>')
  call submode#map       ('quickfix', 'n', 'x', 'c', ':cclose<CR>')
  call submode#map       ('quickfix', 'n', '',  'o', ':copen<CR>')
  call submode#map       ('quickfix', 'n', '',  'w', ':cwindow<CR>')
endif

" open-browser.vim {{{2
if s:bundle.is_installed('open-browser.vim')
  nmap [!space]u <Plug>(openbrowser-open)
  vmap [!space]u <Plug>(openbrowser-open)
endif

" netrw {{{2
let g:netrw_home = $VIM_CACHE
let g:netrw_list_hide = '\~$,^tags$,\(^\|\s\s\)\zs\.\.\S\+'

" yankring {{{2
let g:yankring_history_dir = $VIM_CACHE
let g:yankring_default_menu_mode = 0
let g:yankring_min_element_length = 2
let g:yankring_window_height = 14

" cocoa.vim {{{2
let g:objc#man#dash_keyword = 'ios:'
if s:is_mac
  if executable($HOME . '/Applications/zeal.app/Contents/MacOS/zeal')
    let g:objc#man#dash_command_format = $HOME . '/Applications/zeal.app/Contents/MacOS/zeal --query "%s" &'
  endif
endif

" rails.vim {{{2
if s:bundle.tap('vim-rails')
  let g:rails_some_option = 1
  let g:rails_level = 4
  let g:rails_syntax = 1
  let g:rails_statusline = 1
  let g:rails_url='http://localhost:3000'
  let g:rails_subversion=0
  let g:rails_default_file='config/database.yml'

  function! s:vimrc_rails_init()
    nnoremap <buffer>[!space]vv :Rview<CR>
    nnoremap <buffer>[!space]cc :Rcontroller<CR>
    nnoremap <buffer>[!space]mm :Rmodel<Space>
    nnoremap <buffer>[!space]pp :Rpreview<CR>

    nnoremap <buffer> [!space]r :R<CR>
    nnoremap <buffer> [!space]a :A<CR>

    Rnavcommand api app/controllers/api -glob=**/* -suffix=_controller.rb
    " Rnavcommand tmpl app/controllers/tmpl -glob=**/* -suffix=_controller.rb
    Rnavcommand config config   -glob=*.*  -suffix= -default=routes.rb
    nnoremap <buffer>[!app]v  :<C-U>Unite rails/view<CR>
    nnoremap <buffer>[!app]m  :<C-U>Unite rails/model<CR>
    nnoremap <buffer>[!app]c  :<C-U>Unite rails/controller<CR>
    nnoremap <buffer>[!app]C  :<C-U>Unite rails/config<CR>
    nnoremap <buffer>[!app]s  :<C-U>Unite rails/spec<CR>
    nnoremap <buffer>[!app]m  :<C-U>Unite rails/db -input=migrate<CR>
    nnoremap <buffer>[!app]l  :<C-U>Unite rails/lib<CR>

    " nnoremap <buffer><expr><C-H>g     ':e '.b:rails_root.'/Gemfile<CR>'
    " nnoremap <buffer><expr><C-H>r     ':e '.b:rails_root.'/config/routes.rb<CR>'
    " nnoremap <buffer><expr><C-H>se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
    " nnoremap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
    " nnoremap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
  endfunction

  MyAutoCmd User Rails call s:vimrc_rails_init()
endif


" python {{{2
let g:pymode_rope = 1
let g:pymode_rope_lookup_project = 1
let g:pymode_rope_regenerate_on_write = 0
let g:pymode_rope_goto_def_newwin = 'new'
let g:pymode_rope_completion = 0
let g:pymode_rope_complete_on_dot = 0
let g:pymode_run = 0
let g:pymode_doc = 0
let g:pymode_lint = 0
let g:pymode_virtualenv = 0
let g:pymode_rope_global_prefix = '[!rope]'
" let g:vimrc_pymode_rope_project_dirprefixes = [expand("~/project")]

" jedi-vim {{{2
if s:bundle.is_installed('jedi-vim')
  let g:jedi#auto_initialization = 1
  let g:jedi#popup_on_dot = 0
  let g:jedi#rename_command = '<leader>R'
  " let g:jedi#show_call_signatures = 0
  let g:jedi#show_call_signatures = 0
  let g:jedi#auto_vim_configuration = 0
endif
" html5.vim {{{2
let g:event_handler_attributes_complete = 1
let g:rdfa_attributes_complete = 1
let g:microdata_attributes_complete = 1
let g:aria_attributes_complete = 1

" PIV {{{2
let g:PIVCreateDefaultMappings=0

" sudo.vim {{{2
if s:is_mac && has('gui_running') && s:bundle.is_installed('sudo-gui.vim')
  command! -bang SW SudoWriteMacGUI
else
  command! SW w sudo:%
  command! SR read sudo:%
endif

" hatena.vim {{{2
let g:hatena_base_dir = $VIM_CACHE . '/vim-hatena/'
call s:mkdir(g:hatena_base_dir.'/cookies')
let g:hatena_upload_on_write = 0
let g:hatena_upload_on_write_bang = 1
let g:hatena_no_default_keymappings = 1

" dbext.vim {{{2
if s:bundle.is_installed('dbext.vim')
  let g:dbext_default_prompt_for_parameters=0
  let g:dbext_default_history_file=expand('$VIM_CACHE/dbext_sql_history.txt')
  let g:dbext_default_menu_mode=0
  command! -nargs=+ -complete=customlist,dbext#DB_completeTables SELECT :call dbext#DB_execSql("select " . <q-args>)
endif

" SQLUtilities {{{2
let g:sqlutil_default_menu_mode=0

" zen-coding.vim {{{2
let g:user_zen_leader_key='<C-y>'

" endtagcomment https://gist.github.com/411828 {{{2
nmap ,/ <Plug>(endtagcomment)

" smartchr "{{{2
if s:bundle.is_installed('vim-smartchr')
  inoremap <expr>, smartchr#one_of(', ', ',')
endif

" unite.vim {{{2
if s:bundle.tap('unite.vim')
  LCAlias Unite
  nnoremap [!unite] <Nop>
  nmap     f       [!unite]
  " define at clever-f
  " nnoremap [!unite]f f

  " unite basic settings {{{3
  let g:unite_data_directory = $VIM_CACHE . '/vim-unite'
  let g:unite_update_time=600
  let g:unite_source_history_yank_enable=0
  "let g:unite_enable_start_insert=1
  let g:unite_enable_start_insert=0
  let g:unite_winheight = 20
  " let g:unite_winwidth = &columns - 12
  "let g:unite_split_rule = 'botright'
  let g:unite_source_file_rec_max_cache_files = 5000

  let g:unite_source_alias_aliases = get(g:, 'unite_source_alias_aliases', {})

  let g:neomru#do_validate = 0
  let g:neomru#file_mru_limit = 200
  let g:neomru#file_mru_ignore_pattern = 'COMMIT_EDITMSG'

  let g:unite#sources#projectionist#files_start_insert = 1

  function! s:unite_set_rm_command(command)
    if executable(a:command)
      let g:unite_kind_file_delete_file_command = a:command." $srcs"
      let g:unite_kind_file_delete_directory_command = a:command." $srcs"
      return 1
    endif
    return 0
  endfunction


  if s:is_win
  elseif s:is_mac
    if s:unite_set_rm_command("rmtrash") || s:unite_set_rm_command('trash')
    endif
  else
    call s:unite_set_rm_command("trash-put")
  endif

  " unite fn {{{3
  function! s:unite_grep(path, ...) "{{{4
    execute printf('Unite grep:%s %s', a:path, join(a:000, ' '))
  endfunction "}}}

  " unite-history
  let g:unite_source_history_yank_enable = 1

  " unite hooks.on_source {{{3
  function! s:bundle.tapped.hooks.on_source(bundle)
    " file_rec {{{4
    call unite#custom#source('file',
          \ 'ignore_pattern',
          \ '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|/chalice_cache/\|/-Tmp-/')

    call unite#custom#source('file_rec,file_rec/async,repo_files',
        \ 'ignore_pattern', join([
        \ '\.git/', '\.svn/', '\.hg/',
        \ '.ico', '.png', '.jpg',
        \ 'node_modules', 'bower_components', 'dist',
        \ 'coverage',
        \ '.sass_cache',
        \ ], '\|'))
    " files {{{4
    call unite#custom#profile('files', 'context.smartcase', 1)

    call unite#custom#substitute('files', '\$\w\+', '\=eval(submatch(0))', 200)

    call unite#custom#substitute('files', '[^~.]\zs/', '*/*', 20)
    call unite#custom#substitute('files', '/\ze[^*]', '/*', 10)

    call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
    call unite#custom#substitute('files', '^@', '\=getcwd()."/*"', 1)
    call unite#custom#substitute('files', '^\\', '~/*')
    call unite#custom#substitute('files', '^\~', escape($HOME, '\'), -2)

    call unite#custom#substitute('files', '^;v', '~/.vim/*')
    call unite#custom#substitute('files', '^;ft', '~/.vim/after/ftplugin/')
    call unite#custom#substitute('files', '^;r', '\=$VIMRUNTIME."/*"')
    if s:is_win
      call unite#custom#substitute('files', '^;p', 'C:/Program Files/*')
      if isdirectory(expand('$USERPROFILE/Desktop'))
        call unite#custom#substitute('files', '^;d', '\=expand("$USERPROFILE/Desktop/")."*"')
      else
        call unite#custom#substitute('files', '^;d', '\=expand("$USERPROFILE/デスクトップ/")."*"')
      endif
    else
      call unite#custom#substitute('files', '^;d', '\=$HOME."/Desktop/*"')
    endif
    " custom actions {{{4
    " custom action open_unite_file {{{5
    let s:unite_action_open_unite_file = {
      \ }
    function! s:unite_action_open_unite_file.func(candidate)
      " echoerr a:candicate.word
      let path = a:candidate.action__path
      execute 'Unite' 'file:'.path
    endfunction
    call unite#custom_action('directory', 'open_unite_file', s:unite_action_open_unite_file)
    unlet! s:unite_action_action_open_unite_file

    " repo_files{{{5
    if s:bundle.is_installed('vim-unite-repo-files')
      let s:unite_action = {'description': 'select project files'}
      function! s:unite_action.func(candidate)
        if a:candidate.kind ==# 'directory'
          execute 'Unite repo_files:'.
            \ get(a:candidate, 'action__path', a:candidate.action__directory)
        endif
      endfunction
      call unite#custom_action('directory', 'repo_files', s:unite_action)
      unlet! s:unite_action
    endif

    let s:unite_action_finder = { 'description' : 'open with shell' }
    function! s:unite_action_finder.func(candidate)
      if a:candidate.kind ==# 'directory'
        if s:is_mac
          call system('open -a Finder '.a:candidate.action__path)
        elseif s:is_win
          call system('explorer '.substitute(a:candidate.action__path, '/', '\', 'g'))
        else
          call system('xdg-open '.a:candidate.action__path.'&')
        endif
      endif
    endfunction
    call unite#custom_action('directory', 'finder', s:unite_action_finder)
    unlet! s:unite_action_finder

    " custom action insert_or_narrow {{{5
    let s:unite_action_narrow_or_insert = {
          \ 'is_quit': 0
          \ }
    function! s:unite_action_narrow_or_insert.func(candidate)
      " echoerr a:candicate.word
      let path = a:candidate.action__path
      if isdirectory(path)
        call unite#take_action('narrow', a:candidate)
      else
        let context = unite#get_context()
        " call unite#close(context.buffer_name)
        call unite#take_action('insert', a:candidate)
      endif
    endfunction
    call unite#custom_action('file', 'narrow_or_insert', s:unite_action_narrow_or_insert)
    unlet! s:unite_action_narrow_or_insert

    " custom action agit {{{5
    if g:vimrc_enabled_plugins.agit
      let s:agit_action = {}
      function! s:agit_action.func(dir)
        if isdirectory(a:dir.word)
          let dir = fnamemodify(a:dir.word, ':p')
        else
          let dir = fnamemodify(a:dir.word, ':p:h')
        endif
        execute 'Agit --dir=' . dir
      endfunction
      call unite#custom#action('file,cdable', 'agit', s:agit_action)
      unlet! s:agit_action

      let s:agit_file = { 'description' : 'open the file''s history in agit.vim' }
      function! s:agit_file.func(candidate)
        execute 'AgitFile' '--file='.a:candidate.action__path
      endfunction
      call unite#custom#action('file', 'agit-file', s:agit_file)
      unlet! s:agit_file
    endif

    " unite-menu {{{4
    if !exists("g:unite_source_menu_menus")
       let g:unite_source_menu_menus = {}
    endif
    function! s:gui_manual(name) " {{{5
      return "Zeal ".a:name.":"
    endfunction " }}}

    function! s:dispatch(command) "{{{5
      if has('gui_running')
        return "StartSilently ".a:command
        " return "Start ".a:command
      endif
      return "Dispatch " . a:command
    endfunction "}}}
    function! s:start_silently(bang, command) "{{{5
      execute "Start".(a:bang?"!":"") a:command
      let cmd_fmt = ""
      let app = ""
      if s:is_mac
        let cmd_fmt = "osascript -e 'tell application \"%s\" to activate'"
        let app = has('gui_running') ? "MacVim" : "iTerm"
      elseif executable('wmctrl')
        let cmd_fmt = 'sleep 0.5 && wmctrl -a %s'
        let app = has('gui_running') ? "gvim" : "gnome-console"
      endif
      if !empty(app)
        call system(printf(cmd_fmt, app))
      endif
    endfunction
    command! -bang -nargs=* -complete=custom,dispatch#command_complete
    \ StartSilently call s:start_silently(<bang>0, <q-args>)

    command! -nargs=*
    \ UniteBufferRename call my#unite#buffer_rename(<q-args>)

    " http://d.hatena.ne.jp/osyo-manga/20130225/1361794133
    function! s:unite_menu_create(desc, ...) "{{{5
      let commands = {
      \   'description' : a:desc,
      \}
      let commands.candidates = a:0 >= 1 ? a:1 : {}
      function commands.map(key, value)
        let [word, value] = a:value
        if isdirectory(value)
          return {
          \   "word" : "[directory] ".word,
          \   "kind" : "directory",
          \   "action__directory" : value
          \ }
        elseif !empty(glob(value))
          return {
          \   "word" : "[file] ".word,
          \   "kind" : "file",
          \   "default_action" : "tabdrop",
          \   "action__path" : value,
          \ }
        else
          return {
          \   "word" : "[command] ".word,
          \   "kind" : "command",
          \   "action__command" : value
          \ }
          endif
      endfunction
      return commands
    endfunction "5}}}
    " shortcut {{{5

    let g:unite_source_menu_menus["shortcut"] = s:unite_menu_create(
    \ 'Shortcut', [
    \   ["edit files"     , "Unite menu:edit_files"],
    \   ["project"     , "Unite menu:project"],
    \   ["edit .vimrc"            , $MYVIMRC] ,
    \   ["reload .vimrc"          , "source " . $MYVIMRC] ,
    \   ["scriptnames"            , "Unite scriptnames"] ,
    \   ["neobundle vimfiles"     , "Unite neobundle/vimfiles"] ,
    \   ["all vimfiles"           , "Unite neobundle/rtpvimfiles"] ,
    \   ["colorscheme"            , "Unite colorscheme -auto-preview"] ,
    \   ["airline themes"         , "Unite airline_themes -auto-preview"] ,
    \   ["global options"         , "Unite output:set"] ,
    \   ["local options"          , "Unite output:setlocal"] ,
    \   ["mappings"               , "Unite mapping"] ,
    \   ["todo"                   , "Todo"] ,
    \   ["repl"                   , "Unite menu:repl"] ,
    \   ["vim help"               , "Unite menu:vimhelp"] ,
    \   ["os menu"                , "Unite menu:os"] ,
    \   ["fold"                   , "Unite fold"] ,
    \   ["codic"        , "Unite codic"] ,
    \   ["quickrun config"        , "Unite quickrun_config"] ,
    \ ])
    let g:unite_source_menu_menus["project"] = s:unite_menu_create(
      \ '', [
      \   ["ghq"        , "Unite ghq"] ,
      \   ["vhost fqdn"        , "Unite vhost/fqdn"] ,
      \   ["vhost docroot"        , "Unite vhost/docroot"] ,
      \ ])
    " edit files {{{5
    let g:unite_source_menu_menus["edit_files"] = s:unite_menu_create(
    \ 'Edit Files', [
    \   ["edit .gvimrc"           , "edit ".$MYGVIMRC],
    \   ["VimFiler ~/.vim"        , "VimFiler ".$HOME."/.vim"],
    \   ["Edit ~/.vim"     , "UniteEditFile ~/.vim"],
    \   ["Edit ~/.vim/ftplugin"     , "UniteEditFile ~/.vim/ftplugin"],
    \   ["Edit ~/.vim/after/ftplugin"     , "UniteEditFile ~/.vim/after/ftplugin"],
    \   ["Edit snippet"     , "UniteEditFile ~/.vim/snippets"],
    \   ["Edit sonictemplate"     , "UniteEditFile ".g:sonictemplate_vim_template_dir],
    \   ["Edit zsh"     , "UniteEditFile ~/.zsh"],
    \   ["Edit zsh/cheat"     , "UniteEditFile ~/.zsh/opt/cheat"],
    \   ["Edit zsh/peco"     , "UniteEditFile ~/.zsh/zfunc/peco"],
    \   ["Edit pit"     , "UniteEditFile ~/.pit"],
    \   ["Edit tmuxinator"     , "UniteEditFile ~/.tmuxinator"],
    \   ["Edit homebrew"     , "BrewEdit"],
    \ ])
    " edit {{{5
    let g:unite_source_menu_menus["edit"] = s:unite_menu_create(
    \ 'Edit', [
    \   ['SplitjoinJoin' , 'SplitjoinJoin'],
    \   ['SplitjoinSplit' , 'SplitjoinSplit'],
    \   ['InlineEdit' , 'InlineEdit'],
    \   ['UndotreeToggle' , 'UndotreeToggle'],
    \   ['color' , 'Unite webcolorname'],
    \   ['SimpleHTTP' , s:dispatch('python -m SimpleHTTPServer')],
    \   ['Grunt server' , s:dispatch('grunt server')],
    \   ['Grunt build' , s:dispatch('grunt build')],
    \   ['Grunt test' , s:dispatch('grunt test')],
    \   ['Grunt serve' , s:dispatch('grunt serve')],
    \   ['Grunt default' , s:dispatch('grunt')],
    \])
    " vimhelp {{{5
    let g:unite_source_menu_menus["vimhelp"] = s:unite_menu_create(
    \ 'Help', [
    \   ['Vimscript functions' , 'help function-list']         ,
    \   ['Vimscript grammar'   , 'help usr_41']                ,
    \   ['Regexp'              , 'help pattern-overview']      ,
    \   ['quickkref'           , 'help quickref']              ,
    \   ['Option'              , 'help option-list']           ,
    \   ['Tips'                , 'help tips']                  ,
    \   ['User Manual'         , 'help usr_toc']               ,
    \   ['Startup Options'     , 'help startup-options']       ,
    \   ['Window'              , 'help windows']               ,
    \   ['Tab'                 , 'help tabpage']               ,
    \   ['Plugin'              , 'help write-plugin']          ,
    \   ['FtPlugin'            , 'help write-filetype-plugin'] ,
    \   ['Helpfile'            , 'help help-writing']          ,
    \ ])
    " repl {{{5
    let g:unite_source_menu_menus["repl"] = s:unite_menu_create(
    \ 'Repl', [
    \   ["irb"                , "VimShellInteractive irb --simple-prompt"] ,
    \   ["perl"               , "VimShellInteractive reply"]               ,
    \   ["javascript"         , "VimShellInteractive node"]                ,
    \   ["coffee"             , "VimShellInteractive coffee -i --nodejs"]                ,
    \   ["ghci"               , "VimShellInteractive ghci"]                ,
    \   ["python"             , "VimShellInteractive python"]              ,
    \   ["php"                , "VimShellInteractive phpa-norl"]           ,
    \   ["VimShellPop"        , "VimShellPop"]                             ,
    \   ["VimConsole"         , "VimConsoleOpen"]                          ,
    \ ])
    " os {{{5
    if s:is_win
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
      \ 'Windows', [
      \   ["irb", "VimShellInteractive irb --simple-prompt"] ,
      \ ])
    elseif s:is_mac
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
      \ 'Mac', [
      \   ["Library"              , "VimFiler ~/Library"]                                                  ,
      \   ["Desktop"              , "VimFiler ~/Desktop"]                                                  ,
      \   ["Downloads"            , "VimFiler ~/Downloads"]                                                ,
      \   ["Sites"                , "VimFiler ~/Sites"]                                                    ,
      \   ["Documents"            , "VimFiler ~/Documents"]                                                ,
      \   ["Log"                  , "VimFiler ~/Library/Logs/"]                                            ,
      \   ["SystemLog"            , "VimFiler /var/log/"]                                                  ,
      \   ["Keyremap4macbook xml" , "tabnew ~/Library/Application\\ Support/Keyremap4macbook/private.xml"] ,
      \ ])
    else
      let g:unite_source_menu_menus["os"] = s:unite_menu_create(
      \ 'Unix', [
      \   ["irb"                , "VimShellInteractive irb --simple-prompt"] ,
      \ ])
    endif

    " perl {{{5
    let g:unite_source_menu_menus["ft_perl"] = s:unite_menu_create(
    \ 'Perl Menu', [
    \   ["local module"  , "Unite perl/local"]  ,
    \   ["global module" , "Unite perl/global"] ,
    \   ["carton install", s:dispatch("carton install")] ,
    \ ])
    " php {{{5
    let g:unite_source_menu_menus["ft_php"] = s:unite_menu_create(
    \ 'PHP Menu', [
    \   ["Man php"  , s:gui_manual("php")]  ,
    \   ["Composer install"  , s:dispatch('composer install')]  ,
    \   ["Composer update"  , s:dispatch('composer update')]  ,
    \   ["Server", s:dispatch("php -S localhost:8111")] ,
    \ ])
    let g:unite_source_menu_menus["ft_php_cake"] = s:unite_menu_create(
    \ 'CakePHP Menu', [
    \   ["Man cakephp", s:gui_manual("cakephp")],
    \   ["CakePHP controller", "Unite cake_controller"],
    \   ["CakePHP model", "Unite cake_model"],
    \   ["CakePHP view", "Unite cake_view"],
    \   ["CakePHP helper", "Unite cake_helper"],
    \   ["CakePHP component", "Unite cake_component"],
    \   ["CakePHP behavior", "Unite cake_behavior"],
    \   ["CakePHP lib", "Unite cake_lib"],
    \   ["CakePHP shell", "Unite cake_shell"],
    \   ["CakePHP task", "Unite cake_task"],
    \   ["CakePHP config", "Unite cake_config"],
    \   ["CakePHP core", "Unite cake_core"],
    \   ["CakePHP fixture", "Unite cake_fixture"],
    \   ["CakePHP Server", s:dispatch("php -S localhost:8111 -t app/webroot")] ,
    \ ])
    " ruby {{{5
    let g:unite_source_menu_menus["ft_ruby"] = s:unite_menu_create(
    \ 'Ruby Menu', [
    \   ["rake"             , "Unite rake"]              ,
    \   ["rails controller" , "Unite rails/controller"]  ,
    \   ["rails model"      , "Unite rails/model"]       ,
    \   ["rails view"       , "Unite rails/view"]        ,
    \   ["rails helper"     , "Unite rails/helper"]      ,
    \   ["rails lib"        , "Unite rails/lib"]         ,
    \   ['Add param'        , 'RAddParameter']           ,
    \   ['Split cond'       , 'RConvertPostConditional'] ,
    \   ['Extract let'      , 'RExtractLet']             ,
    \   ['Remove tmpvar'    , 'RInlineTemp']             ,
    \   ['chef attribute'   , 'ChefFindAttribute']       ,
    \   ['chef recipe'      , 'ChefFindRecipe']          ,
    \   ['chef definition'  , 'ChefFindDefinition']      ,
    \   ['chef lwrp'        , 'ChefFindLWRP']            ,
    \   ['chef source'      , 'ChefFindSource']          ,
    \   ['chef related'     , 'ChefFindRelated']         ,
    \   ['Bundle install'   , s:dispatch('bundle install')]   ,
    \   ['Bundle update'    , s:dispatch('bundle update')]    ,
    \   ['Rackup' , s:dispatch('rackup -E development')]         ,
    \ ])
    " vmap...
    " \   ['Extract constant', 'RExtractConstant'],
    " \   ['Rename local var', 'RRenameLocalVariable'],
    " \   ['Rename instance var', 'RRenameInstanceVariable'],
    " \   ['Rename instance var', 'RExtractMethod'],
    " java {{{5
    let g:unite_source_menu_menus["ft_java"] = s:unite_menu_create(
    \ 'Java Menu' , [
    \   ["import" , "Unite javaimport"] ,
    \   ["gradle" , "Unite gradle"]     ,
    \ ])
    " javascript {{{5
    let g:unite_source_menu_menus["ft_javascript"] = s:unite_menu_create(
    \ 'Javascript Menu' , [
    \   ["Man angularjs"  , s:gui_manual("angularjs")]  ,
    \   ["Man d3"         , s:gui_manual("d3")]         ,
    \   ["Man nodejs"     , s:gui_manual("nodejs")]     ,
    \   ["Man jquery"     , s:gui_manual("jquery")]     ,
    \   ["Man jqueryui"   , s:gui_manual("jqueryui")]   ,
    \   ["Man underscore" , s:gui_manual("underscore")] ,
    \   ["Man javascript" , s:gui_manual("javascript")] ,
    \   ['Npm install'    , s:dispatch('npm install')]   ,
    \   ['Npm update'     , s:dispatch('npm update')]   ,
    \ ])
    " agit {{{5
    if g:vimrc_enabled_plugins.agit
      " \ ['gbrowse', "execute 'Gbrowse' eval('agit#extract_hash(getline(\".\"))')"],
      let g:unite_source_menu_menus["ft_agit"] = s:unite_menu_create(
      \ 'Gitv', [
      \ ['checkout', "normal \:<Plug>(agit-git-checkout)"],
      \ ['rebase', "normal \<Plug>(agit-git-rebase)"],
      \ ['rebase-i', "normal \<Plug>(agit-git-rebase-i)"],
      \ ['revert', "normal \<Plug>(agit-git-revert)"],
      \ ['cherry-pick', "normal \<Plug>(agit-git-cherry-pick)"],
      \ ['reset --soft', "normal \<Plug>(agit-git-reset-soft)"],
      \ ['reset --hard', "normal \<Plug>(agit-git-reset-hard)"],
      \ ])
    endif
    " gitv {{{5
    if g:vimrc_enabled_plugins.gitv
      let g:unite_source_menu_menus["ft_gitv"] = s:unite_menu_create(
      \ 'Gitv', [
      \ ['gbrowse', "execute 'Gbrowse' eval('GitvGetCurrentHash()')"],
      \ ['checkout', "execute 'Git checkout' eval('GitvGetCurrentHash())"],
      \ ['rebase', "execute 'Git rebase' eval('GitvGetCurrentHash())"],
      \ ['revert', "execute 'Git revert' eval('GitvGetCurrentHash())"],
      \ ['cherry-pick', "execute 'Git cherry-pick' eval('GitvGetCurrentHash())"],
      \ ['reset --hard', "execute 'Git reset --hard' eval('GitvGetCurrentHash())"],
      \ ])
    endif

    " let g:unite_source_menu_menus["ft_"] = s:unite_menu_create(
    " \ '', [
    " \  ["", ""],
    " \ ])

    function! s:unite_context_menu() "{{{5
      let menus = map(filter(sort(keys(g:unite_source_menu_menus)),
      \ 'v:val =~# "^ft_".&filetype'), '"menu:".v:val')
      " if !exists('g:unite_source_menu_menus["ft_' . &filetype . '"]')
      if len(menus) <= 0
        echohl Error
        echon "menu not found"
        echohl None
        return
      endif
      execute 'Unite' join(menus, " ")
    endfunction "5}}}

    " memolist - http://d.hatena.ne.jp/osyo-manga/20130919 {{{4
    if g:vimrc_enabled_plugins.memolist
      let g:unite_source_alias_aliases = {
      \  "memolist" : {
      \     "source" : "file",
      \     "args" : g:memolist_path,
      \  },
      \  "memolist_rec" : {
      \     "source" : "file_rec"
      \  },
      \}


      function! s:get_memolist_tags(filepath)
        return filereadable(a:filepath) ? matchstr(get(filter(readfile(a:filepath, "", 6), 'v:val =~ ''^tags: \[.*\]'''), 0), '^tags: \[\zs.*\ze\]') : ""
      endfunction

      let s:filter = {
      \  "name" : "converter_add_memolist_tags_word",
      \}

      function! s:filter.filter(candidates, context)
        for candidate in a:candidates
          if !has_key(candidate, "converter_add_ftime_word_base")
            let candidate.converter_add_ftime_word_base = candidate.word
          endif
          let word = get(candidate, "converter_add_ftime_word_base", candidate.action__path)
          let candidate.word = s:get_memolist_tags(get(candidate, "action__path")) . " " . word
        endfor
        return a:candidates
      endfunction

      call unite#define_filter(s:filter)
      unlet s:filter

      let s:filter = {
      \  "name" : "converter_add_memolist_tags_abbr",
      \}
      function! s:filter.filter(candidates, context)
        for candidate in a:candidates
          " if !has_key(candidate, "converter_add_ftime_word_base")
          "   let candidate.converter_add_ftime_word_base = candidate.abbr
          " endif
          let abbr = get(candidate, "abbr", candidate.word)
          let candidate.abbr = printf("%s %s", abbr, s:get_memolist_tags(get(candidate, "action__path")))
        endfor
        return a:candidates
      endfunction
      call unite#define_filter(s:filter)
      unlet s:filter

      let s:filter = {
      \  "name" : "converter_add_filename_word",
      \}
      function! s:filter.filter(candidates, context)
        for candidate in a:candidates
          " if !has_key(candidate, "converter_add_ftime_word_base")
          "   let candidate.converter_add_ftime_word_base = candidate.abbr
          " endif
          let abbr = get(candidate, "abbr", candidate.word)
          let candidate.abbr = printf("%s %s", abbr, fnamemodify(get(candidate, "action__path"), ":p:t"))
        endfor
        return a:candidates
      endfunction
      call unite#define_filter(s:filter)
      unlet s:filter

      call unite#custom_max_candidates("memolist", 500)
      call unite#custom#source('memolist', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr", 'converter_add_memolist_tags_abbr'])
      call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])
      " call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "converter_add_filename_word", "matcher_default"])
      " call unite#custom#source('memolist', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr"])
      " call unite#custom#source('memolist', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])

      call unite#custom_max_candidates("memolist_rec", 50)
      call unite#custom#source('memolist_rec', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr", 'converter_add_memolist_tags_abbr'])
      " call unite#custom#source('memolist_rec', 'converters', ["converter_file_firstline_abbr", "converter_add_ftime_abbr"])
      call unite#custom#source('memolist_rec', 'matchers', ["converter_file_firstline_word", "converter_add_memolist_tags_word", "matcher_default"])
    endif
    " 4}}}

  endfunction " 3}}}

  " unite mappings {{{3
  function! s:unite_map(bang, prefix, key, ...) " {{{4
    if a:key[0] == "<"
      let key = empty(a:bang) ? a:key : substitute(a:key, "^<", "<S-", "")
      let bang_key = empty(a:bang) ? substitute(a:key, "^<", "<S-", "") : a:key
    else
      let key = empty(a:bang) ? a:key : toupper(a:key)
      let bang_key = empty(a:bang) ? toupper(a:key) : a:key
    endif
    let cmdargs = join(a:000, " ")
    let fmt = "%snoremap <silent> [!unite]%s :<C-u>Unite %s %s<CR>"

    exe printf(fmt, a:prefix, key, "", cmdargs)
    exe printf(fmt, a:prefix, bang_key, "-no-quit", cmdargs)
  endfunction " }}}
  command! -nargs=* -bang UniteNMap call s:unite_map("<bang>", "n", <f-args>)

  nmap [!unite]u  :<C-u>Unite<Space>

  UniteNMap   <Space>   buffer
  UniteNMap   j         buffer_tab
  UniteNMap   k         tab
  UniteNMap   l         file -profile-name=files
  UniteNMap   d         directory_mru -default-action=vimfiler
  UniteNMap   zz        z -default-action=vimfiler
  UniteNMap   za        fold
  UniteNMap   <Leader>r quickrun_config
  UniteNMap   ;         file:<C-r>=expand('%:p:h')<CR> -profile-name=files
  UniteNMap   m         file_mru -default-action=open -profile-name=files
  UniteNMap   y         sonictemplate
  UniteNMap   ic        webcolorname
  UniteNMap   ij        jump
  UniteNMap   is        neosnippet
  UniteNMap   io        outline
  UniteNMap   o         projectionist -start-insert
  UniteNMap!  gg        grep:. -buffer-name=grep
  UniteNMap!  gs        grep:.:-C\\ 4 -buffer-name=grep
  UniteNMap!  gr        grep -buffer-name=grep
  " UniteNMap!  gt        grep:<C-r>=getcwd()<CR>:TODO\|FIXME\|XXX\|NOTE\|!!!\|\?\?\? -buffer-name=todo -auto-preview
  " UniteNMap   gl        grep_launcher
  UniteNMap!  gi        git_grep -buffer-name=git_grep
  UniteNMap!  gl        line -start-insert
  UniteNMap!  gd        signify
  UniteNMap!  q         quickfix -buffer-name=qfix
  UniteNMap   p         history/yank
  " UniteNMap   @         quickrun_config
  " UniteNMap   :         history/command command
  " UniteNMap   /         history/search
  UniteNMap   /         anzu
  UniteNMap   bb        bookmark -default-action=open
  if s:is_win
    UniteNMap ,         everything -start-insert
    UniteNMap w         startmenu
  elseif s:is_mac
    UniteNMap ,         spotlight -start-insert
    UniteNMap w         apps
  else
    UniteNMap ,         locate -start-insert
  endif

  nnoremap <silent> [!unite]ba :<C-u>UniteBookmarkAdd<CR>
  " UniteNMap   rr        quicklearn -immediately
  nnoremap [!space]R :<C-u>Unite quicklearn -immediately<CR>
  nnoremap <Leader>qr :<C-u>Unite quicklearn -immediately<CR>

  nnoremap <silent> [!unite]v :Unite menu:shortcut<CR>
  nnoremap <silent> [!unite]e :Unite menu:edit<CR>
  nnoremap <silent> [!unite]s :call <SID>unite_context_menu()<CR>

  " filepath insert TODO : don't works well...--;
  nnoremap <C-y><C-f> :<C-u>Unite -default-action=narrow_or_insert file<CR>
  inoremap <C-y><C-f> <C-o>:<C-u>Unite -default-action=narrow_or_insert file<CR>

  " Alias colorscheme Unite colorscheme -auto-preview

  " if g:vimrc_enabled_plugins.vimproc
  "   UniteNMap a file_rec/async -start-insert
  " else
  UniteNMap a file_rec -start-insert
  " endif

  " nnoremap <silent> [!unite]h  :<C-u>UniteWithCursorWord help:ja help<CR>
  " nnoremap <silent> [!unite]hh :<C-u>call my#unite#ref_filetype()<CR>
  nnoremap <silent> [!unite]hh :<C-u>call my#unite#ref_callable()<CR>
  nnoremap <silent> [!unite]he :<C-u>Unite help<CR>
  nnoremap <silent> [!unite]hk :<C-u>Unite mapping<CR>

  nnoremap          [!unite]rr :<C-u>UniteResume<Space>
  nnoremap <silent> [!unite]re :<C-u>UniteResume<CR>
  nnoremap <silent> [!unite]ri :<C-u>UniteResume git<CR>
  nnoremap <silent> [!unite]rg :<C-u>UniteResume grep<CR>
  nnoremap <silent> [!unite]rt :<C-u>UniteResume todo<CR>
  nnoremap <silent> [!unite]rq :<C-u>UniteResume qfix<CR>

  if g:vimrc_enabled_plugins.neocomplete
    inoremap <C-x><C-j> <C-o>:Unite neocomplete -buffer-name=completition -start-insert<CR>
    inoremap <C-x><C-i> <C-o>:Unite neocomplete -buffer-name=completition -start-insert<CR>
  elseif g:vimrc_enabled_plugins.neocomplcache
    inoremap <C-x><C-j> <C-o>:Unite neocomplcache -buffer-name=completition -start-insert<CR>
    inoremap <C-x><C-i> <C-o>:Unite neocomplcache -buffer-name=completition -start-insert<CR>
  endif

  command! Todo silent! exe 'Unite' printf('grep:%s::%s', getcwd(), s:regexp_todo) '-buffer-name=todo' '-no-quit'

  command! -bang -nargs=1 -complete=dir UniteEditFile
    \ call my#unite#edit_file_by_filetype("<bang>", <f-args>)
  command! -bang BrewEdit
    \ call my#unite#edit_file_by_filetype("<bang>", exists('$HOMEBREW_PREFIX') ? expand('$HOMEBREW_PREFIX') : '/usr/local/Library/')

  " cmd-t/r {{{3
  function! s:get_cmd_t_key(key)
    return printf("<%s-%s>", has('gui_macvim') ? "D" : "A", a:key)
  endfunction
  execute 'nnoremap' '<silent>' s:get_cmd_t_key("t") ":<C-u>Unite repo_files -start-insert<CR>"
  execute 'nnoremap' '<silent>' s:get_cmd_t_key("r") ':<C-u>Unite outline -start-insert<CR>'

  MyAutoCmd FileType unite call s:vimrc_unite_init() "{{{3

  function! s:vimrc_unite_init()
    imap <buffer> jj <Plug>(unite_insert_leave)j
    imap <buffer> qq <Plug>(unite_exit)
    imap <buffer> ]] <C-o><Plug>(unite_rotate_next_source)
    imap <buffer> [[ <C-o><Plug>(unite_rotate_previous_source)
    imap <buffer> <ESC> <ESC><ESC>

    nmap <buffer><nowait> q <Plug>(unite_exit)
    nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
    nmap <buffer> t <Plug>(unite_choose_action)
    nmap <buffer> l <Plug>(unite_do_default_action)
    nmap <buffer> P <Plug>(unite_toggle_auto_preview)
    if g:vimrc_enabled_plugins.unite_candidate_sorter
      nmap <silent><buffer> S <Plug>(unite-candidate_sort)
    endif
    if g:vimrc_enabled_plugins.smartinput && exists(':SmartinputBufferMapClear')
      SmartinputBufferMapClear i
    endif
  endfunction

  " milkode http://qiita.com/items/abe5df7c5b21160532b8 "{{{3
  if executable('gmilk')
    " gmilk コマンドの結果をUnite qf で表示する
    command! -nargs=1 Gmilk call <SID>run_gmilk("gmilk -a -n 200", <f-args>)

    function! s:run_gmilk(cmd, arg)
      silent execute "cgetexpr system(\"" . a:cmd . " ". a:arg . "\")"
      if len(getqflist()) == 0
        echohl WarningMsg
        echomsg "No match found."
        echohl None
      else
        execute "Unite -auto-preview qf"
        redraw!
      endif
    endfunction
  endif

  call s:bundle.untap()
endif
" fugitive.vim {{{2
function! s:git_qfix(...)
  let word = input("Pattern: ")
  if empty(word)
    echoerr "abort"
  endif
  execute 'silent' call('printf', copy(a:000) + [word])
  Unite -no-quit quickfix
endfunction

if s:bundle.is_installed('vim-fugitive')
  " if &diff
  " //2 = target-branch, //3 = merge branch
  if s:is_mac
    map <leader>1 :diffget //2 <Bar> duffupdate<CR>
    map <leader>2 :diffget //3 <Bar> duffupdate<CR>
    map <leader>3 :diffupdate <Bar>
      \ echo '<Leader>1 = merges from target branch(left buffer), '."\n"
      \ . '<Leader>2 = merges from merge branch(right buffer)'<CR>
  else
    map <leader>1 :diffget LOCAL <Bar> duffupdate<CR>
    map <leader>2 :diffget REMOTE <Bar> duffupdate<CR>
    map <leader>3 :diffupdate <Bar>
      \ echo '<Leader>1 = merges from target branch(left buffer), '."\n"
      \ . '<Leader>2 = merges from merge branch(right buffer)'<CR>
  endif
  " endif

  nnoremap <silent> [!space]gd :<C-u>Gdiff --cached<CR>
  nnoremap <silent> [!space]gD :<C-u>Gdiff<CR>
  nnoremap <silent> [!space]gs :<C-u>Gstatus<CR>
  nnoremap [!space]gl :<C-u>silent Glog <Bar> Unite -no-quit quickfix<CR>
  nnoremap [!space]gL :<C-u>silent Glog --<Bar> Unite -no-quit quickfix<CR>
  nnoremap [!space]gg :<C-u>call <SID>git_qfix('Ggrep -i "%s"')<CR>
  nnoremap [!space]ggg :<C-u>Unite -no-quit -start-insert vcs_grep<CR>
  nnoremap [!space]ggr :<C-u>Unite -no-quit -start-insert vcs_grep<CR>
  nnoremap [!space]ggm :<C-u>call <SID>git_qfix('Glog --grep="%s"')<CR>
  nnoremap [!space]ggl :<C-u>call <SID>git_qfix('Glog -S="%s"')<CR>
  nnoremap [!space]gR :<C-u>Gremove<CR>
  nnoremap [!space]gm :<C-u>Gmove<Space>
  nnoremap [!space]ga :<C-u>Gwrite<CR>
  nnoremap [!space]gA :<C-u>Gwrite <cfile><CR>
  nnoremap <silent> [!space]gc :<C-u>Gcommit<CR>
  nnoremap <silent> [!space]gC :<C-u>Gcommit --amend<CR>
  nnoremap <silent> [!space]gb :<C-u>Gblame<CR>
  nnoremap <silent> [!space]gB :<C-u>Gbrowse<CR>
  nnoremap <silent> [!space]gp :<C-u>Git push
  nnoremap <silent> [!space]ge :<C-u>Gedit<Space>
  if g:vimrc_enabled_plugins.agit
    nnoremap <silent> [!space]gv :<C-u>Agit<CR>
    nnoremap <silent> [!space]gV :<C-u>AgitFile<CR>
  elseif g:vimrc_enabled_plugins.gitv
    nnoremap <silent> [!space]gv :<C-u>Gitv<CR>
    nnoremap <silent> [!space]gV :<C-u>Gitv!<CR>
  endif
  command! Gdiffoff diffoff | q | Gedit
endif
function! s:vimrc_git_init()
  setl foldmethod=expr
  " setl foldexpr=getline(v:lnum)!~'^commit'
  setlocal foldexpr=GitLogViewerFoldExpr(v:lnum)
  setlocal foldtext=GitLogViewerFoldText()
endfunction
MyAutoCmd FileType git call s:vimrc_git_init()
function! s:vimrc_fugitive_bufread_init()
  if exists('b:fugitive_type')
    if b:fugitive_type == "commit"
      " if exists('b:fugitive_display_format') && !b:fugitive_display_format
      "   normal a
      " endif
      normal! G
      if line('.') == 3
        setlocal modifiable
        normal! o
        execute "r! git show --no-color " . fugitive#buffer().sha1()
        setlocal nomodified nomodifiable
      endif
      normal! gg
    endif
  endif
endfunction
" MyAutoCmd BufReadPost  fugitive://**//[0-9a-f][0-9a-f]* call s:vimrc_fugitive_bufread_init()
" MyAutoCmd User Fugitive call s:vimrc_fugitive_init()

" TOhtml {{{2
let g:html_number_lines = 0
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = 'utf-8'

" tagbar taglist {{{2
" basic options {{{3
function! s:setup_tags()
  set tags+=./tags,tags
  for f in split("\n", glob($HOME . '/.java-dev/tags/*'))
    execute 'set' 'tags+='.f
  endfor
endfunction
call s:setup_tags()

if s:bundle.is_installed('taglist.vim') "{{{4
  let g:Tlist_Auto_Update = 1
  let g:Tlist_Show_One_File = 0
  let g:Tlist_Exit_OnlyWindow = 1
  let g:Tlist_Use_Right_Window = 0
  let g:Tlist_WinWidth = 25

  let g:tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods;v:property'
  let g:tlist_ruby_settings='Ruby;c:classes;f:methods;m:modules;F:singleton methods;r:regex'
  let g:tlist_javascript_settings='js;o:object;f:function;a:array;s:string;b:boolean;n:number;v:variable'
  " let g:tlist_javascript_settings='JavaScript;f:functions;c:classes;m:methods;p:properties;v:global variables;I:inner'
  let g:tlist_coffee_settings='coffee;c:class;n:namespace;f:function;m:method;v:var;i:ivar'
  " let g:tlist_scala_settings = 'scala;t:trait;c:class;T:type;m:method;C:constant;l:local;p:package;o:object'
  let g:tlist_scala_settings='scala;c:classes;o:objects;t:traits;r:cclasses;a:aclasses;m:methods;V:values;v:variables;T:types;i:includes;p:packages'
  let g:tlist_actionscript_settings='actionscript;f:functions;p:properties;v:variables;r:function, functions;c:classes'
  let g:tlist_tex_settings='Tex;c:chapters;s:sections;u:subsections;b:subsubsections;p:parts;P:paragraphs;G:subparagraphs'
  let g:tlist_make_settings='Make;m:macros;t:targets'
  let g:tlist_ant_settings='Ant;p:projects;t:targets'
  let g:tlist_typescript_settings='typescript;c:classes;n:modules;f:functions;v:variables;m:members;i:interfaces;e:enums'
  let g:tlist_haxe_settings='haxe;p:package;f:function;v:variable;p:package;c:class;i:interface;t:typedef'

  if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
    let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
  endif
  nnoremap <silent> ,tt :<C-u>TlistToggle<CR>
  nnoremap <silent> ,to :<C-u>TlistOpen<CR>1<C-w>h
else "{{{4
  let g:tagbar_type_objc = {
        \ 'ctagstype' : 'objc',
        \ 'kinds'     : [
        \   'P:protocols',
        \   'i:interfaces',
        \   'I:implementations',
        \   'M:instance methods',
        \   'C:implementation methods',
        \   'Z:protocol methods',
        \   'v:property',
        \ ]}
  let g:tagbar_type_ruby = {'ctagstype': 'Ruby', 'kinds':
        \   ['c:classes', 'f:methods', 'm:modules', 'F:singleton methods', 'r:regex']
        \ }
  let g:tagbar_type_javascript = {
        \ 'ctagstype' : 'js',
        \ 'kinds'     : [
        \   'o:object',
        \   'f:function',
        \   'a:array',
        \   's:string',
        \   'v:variable',
        \   'b:boolean',
        \   'n:number',
        \ ]}
  " let g:tagbar_type_javascript = {'ctagstype': 'JavaScript',
  "       \   'kinds': ['f:functions', 'c:classes', 'm:methods', 'p:properties', 'v:global variables', 'I:inner'] }
  if executable('coffeetags')
    let g:tagbar_type_coffee = {
          \ 'ctagsbin' : 'coffeetags',
          \ 'ctagsargs' : '',
          \ 'kinds' : [
          \   'f:functions',
          \   'o:object',
          \ ],
          \ 'sro' : ".",
          \ 'kind2scope' : {
          \   'f' : 'object',
          \   'o' : 'object',
          \ }
          \ }
  else
    let g:tagbar_type_coffee = {'ctagstype': 'coffee',
          \   'kinds': ['c:class', 'n:namespace', 'f:function', 'm:method', 'v:var', 'i:ivar'] }
  endif
  let g:tagbar_type_scala = {'ctagstype': 'scala',
        \   'kinds': ['c:classes', 'o:objects', 't:traits', 'r:cclasses',
        \   'a:aclasses', 'm:methods', 'V:values', 'v:variables',
        \   'T:types', 'i:includes', 'p:packages'] }
  let g:tagbar_type_actionscript = {'ctagstype': 'actionscript',
        \   'kinds': ['f:functions', 'p:properties', 'v:variables',
        \   'r:function, functions', 'c:classes'] }
  let g:tagbar_type_tex = {
        \ 'ctagstype' : 'latex',
        \   'kinds': ['c:chapters', 's:sections', 'u:subsections', 'b:subsubsections',
        \   'p:parts', 'P:paragraphs', 'G:subparagraphs'] }
  let g:tagbar_type_make = { 'ctagstype' : 'make',
        \   'kinds': ['m:macros', 't:targets'] }
  let g:tagbar_type_ant = {'ctagstype': 'Ant',
        \   'kinds': ['p:projects', 't:targets'] }
  let g:tagbar_type_typescript = {'ctagstype': 'typescript',
        \   'kinds': ['c:classes', 'n:modules', 'f:functions', 'v:variables', 'm:members',
        \   'i:interfaces', 'e:enums'] }
  let g:tagbar_type_haxe = {'ctagstype': 'haxe', 'kinds': [
        \ 'p:package', 'f:function', 'v:variable', 'p:package', 'c:class', 'i:interface', 't:typedef',
        \ ] }

  " let g:tagbar_type_xxx = {
  "       \ 'ctagstype' : '',
  "       \ 'kinds'     : [
  "       \   '',
  "       \ ]}

  if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
    " let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
    let g:tagbar_ctags_bin='/Applications/MacVim.app/Contents/MacOS/ctags'
  endif
  nnoremap <silent> ,tt :<C-u>TagbarToggle<CR>
  nnoremap <silent> ,to :<C-u>TagbarOpen<CR>1<C-w>h
endif "}}}

" SrcExpl {{{2
if s:bundle.is_installed('SrcExpl')
  nnoremap <silent> ,t<Space> :<C-u>SrcExplToggle<CR>
  let g:SrcExpl_refreshTime = 1000
endif

" repeat.vim {{{2
if s:bundle.is_installed('vim-repeat')
  nnoremap <silent> dp dp:silent! call repeat#set('dp', 1)<Enter>
  nnoremap <silent> do do:silent! call repeat#set('do', 1)<Enter>
endif

" surround.vim {{{2
nmap ss <Plug>Yssurround
" nmap ss <Plug>Ysurround
imap <C-g>y <Esc><Plug>Yssurround

nmap si :Qsurround Yss<CR>
vmap W :Qsurround VS<CR>
command! -nargs=1 -range Qsurround call s:qsurround.exec(<q-args>)
command! -nargs=1 QsurroundSet call s:qsurround.set(<q-args>)
command! -range QsurroundRangeSet call s:qsurround.rangeset(<count>, <line1>, <line2>, <q-args>)
let s:qsurround = {'data': ['', ''], 'pending':''}

function! s:qsurround.rangeset(count, l1, l2, text)
  let strs = a:count == 0 ? split(a:text, "\n") : getline(a:l1, a:l2)
  if len(strs) == 1
    let strs = [s, '']
  elseif len(strs) > 2
    let s = remove(strs, 0)
    let strs = [s,  join(strs, "\n")]
  endif
  let self.data = strs
endfunction

function! s:qsurround.set(s)
  if !empty(self.pending)
    let self.data = [self.pending, a:s]
    let self.pending = ''
  else
    let self.pending = a:s
  endif
endfunction

function! s:qsurround.exec(mode)
  call self.surround(a:mode, self.data[0], self.data[1])
endfunction

function! s:qsurround.surround(mode, head, tail)
  " if exists("b:surround_".char2nr('Z'))
  "   let org = b:surrond_{char2nr('Z')}
  " else
  "   let org = ''
  " endif
  if !exists('b:surround_objects')
    let b:surround_objects = {}
  endif
  let org = get(b:surround_objects, 'Z', '')
  let b:surround_objects.Z = a:head . "\n\r\n" . a:tail

  let char = tolower(a:mode[0:0])
  let op = ""
  if char == "v"
    let op = "gv"
  endif
  execute "normal " . op . "\<Plug>" . a:mode . "urroundZ"

  if !empty(org)
    let b:surround_objects['Z'] = org
    " let b:surrond_{char2nr('Z')} = org
  else
    unlet b:surround_objects['Z']
    " unlet b:surrond_{char2nr('Z')}
  endif
endfunction

let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
  \ "\<CR>" : "\n\r\n",
  \ 'g':  "_('\r')",
  \ 'G':  "_(\"\r\")",
  \ '!':  "<!-- \r -->",
  \ }
let g:surround_custom_mapping.html = {
  \ '1':  "<h1>\r</h1>",
  \ '2':  "<h2>\r</h2>",
  \ '3':  "<h3>\r</h3>",
  \ '4':  "<h4>\r</h4>",
  \ '5':  "<h5>\r</h5>",
  \ '6':  "<h6>\r</h6>",
  \ 'p':  "<p>\r</p>",
  \ 'u':  "<ul>\r</ul>",
  \ 'o':  "<ol>\r</ol>",
  \ 'l':  "<li>\r</li>",
  \ 'a':  "<a href=\"\">\r</a>",
  \ 'A':  "<a href=\"\r\"></a>",
  \ 'i':  "<img src=\"\r\" alt=\"\" />",
  \ 'I':  "<img src=\"\" alt=\"\r\" />",
  \ 'd':  "<div>\r</div>",
  \ 'D':  "<div class=\"selection\">\r</div>",
  \ '!':  "<!-- \r -->",
  \ '?':  "<?php \r ?>",
  \ '%':  "<?php \r ?>",
  \ '#':  "<?php # \r ?>",
  \ '/':  "<?php // \r ?>",
  \ '=':  "<?php echo \r ?>",
  \ '8':  "(( \r ))",
  \ '9':  "(( \r ))",
  \ '(':  "(( \r ))",
  \ ')':  "(( \r ))",
  \ '{':  "{{ \r }}",
  \ '}':  "{{ \r }}",
  \ }
let g:surround_custom_mapping.help = {
  \ 'p':  "> \r <",
  \ }
let g:surround_custom_mapping.ruby = {
  \ '-':  "<% \r %>",
  \ '=':  "<%= \r %>",
  \ '9':  "(\r)",
  \ '5':  "%(\r)",
  \ '%':  "%(\r)",
  \ 'w':  "%w(\r)",
  \ '#':  "#{\r}",
  \ '3':  "#{\r}",
  \ 'e':  "begin \r end",
  \ 'E':  "<<EOS \r EOS",
  \ 'i':  "if \1if\1 \r end",
  \ 'u':  "unless \1unless\1 \r end",
  \ 'c':  "class \1class\1 \r end",
  \ 'm':  "module \1module\1 \r end",
  \ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
  \ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
  \ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
  \ }
let g:surround_custom_mapping.eruby = {
  \ '-':  "<% \r %>",
  \ '=':  "<%= \r %>",
  \ '#':  "<%# \r %>",
  \ 'h':  "<%= h \r %>",
  \ 'e':  "<% \r %>\n<% end %>",
  \ '%':  "<% \r %>",
  \ }
let g:surround_custom_mapping.markdown = {
  \ 'h': "`\r`",
  \ 'c': "```\n\r\n```",
  \ '!':  "<!-- \r -->",
  \ }
let g:surround_custom_mapping.php = {
  \ '-':  "<?php \r ?>",
  \ '?':  "<?php \r ?>",
  \ '=':  "<?php echo \r ?>",
  \ 'h':  "<?php echo h( \r ); ?>",
  \ 'e':  "<?php echo \r ?>",
  \ 'f':  "<?php foreach ($\r as $val): ?>\n<?php endforeach; ?>",
  \ '%':  "<?php \r ?>",
  \ '#':  "<?php # \r ?>",
  \ '/':  "<?php // \r ?>",
  \ }
let g:surround_custom_mapping.javascript = {
  \ 'f':  "function(){ \r }"
  \ }
let g:surround_custom_mapping.coffee = {
  \ '-':  "<% \r %>",
  \ '=':  "<%= \r %>",
  \ '9':  "(\r)",
  \ 'r':  "///\r///",
  \ '#':  "#{\r}",
  \ '3':  "#{\r}",
  \ 'e':  "begin \r end",
  \ 'E':  '""" \r """',
  \ 'i':  "if \1if\1 \r",
  \ 'u':  "unless \1unless\1 \r",
  \ 'c':  "class \1class\1 \r",
  \ }
let g:surround_custom_mapping.lua = {
  \ 'f':  "function(){ \r }"
  \ }
let g:surround_custom_mapping.python = {
  \ 'p':  "print( \r)",
  \ '[':  "[\r]",
  \ }
let g:surround_custom_mapping.vim = {
  \'f':  "function! \r endfunction"
  \ }
let g:surround_custom_mapping.twig = {
  \ '8':  "(( \r ))",
  \ '9':  "(( \r ))",
  \ '(':  "(( \r ))",
  \ ')':  "(( \r ))",
  \ '{':  "{{ \r }}",
  \ '}':  "{{ \r }}",
  \ '%':  "{% \r %}",
  \ '#':  "{# \r #}",
  \ '/':  "{# \r #}",
  \ }
function! s:_copy_surround_mapping(from, to)
  if exists('g:surround_custom_mapping[a:from]')
    let g:surround_custom_mapping[a:to] = g:surround_custom_mapping[a:from]
  endif
endfunction
function! s:copy_surround_mapping(copies)
  call map(a:copies, 's:_copy_surround_mapping(v:val[0], v:val[1])')
endfunction
call s:copy_surround_mapping([
  \ ['twig', 'html.twig'],
  \ ['ruby', 'ruby.rspec'],
  \ ['python', 'python.nosetests'],
  \ ['perl', 'perl.prove'],
  \ ])

" operator {{{2
if s:bundle.tap('vim-operator-user')
  function! s:bundle.tapped.hooks.on_post_source(bundle)
    " http://labs.timedia.co.jp/2011/07/vim-excel-and-sql.html
    call operator#user#define('excelize', 'OperatorExcelize')
    function! OperatorExcelize(motion_wise)
      let b = line("'[")
      let e = line("']")
      execute b ',' e 'substitute/\v(\''?)(\$?\u+\$?\d+)(\''?)/\1" \& \2 \& "\3/g'
      execute b 'substitute/^/="/'
      execute e 'substitute/$/"/'
    endfunction

    call operator#user#define_ex_command('retab', 'retab')
    call operator#user#define_ex_command('join', 'join')
    call operator#user#define_ex_command('uniq', 'sort u')
    call operator#user#define_ex_command('trimright', 's/\s\+$//')
  endfunction
  call s:bundle.untap()

  map H <Plug>(operator-furround-append-reg)
  map _ <Plug>(operator-replace)
  map ;e <Plug>(operator-excelize)
  map ;h <Plug>(operator-html-escape)
  map ;H <Plug>(operator-html-unescape)
  map ;c <Plug>(operator-camelize)
  map ;C <Plug>(operator-decamelize)
  map ;<C-i> <Plug>(operator-retab)
  map ;j <Plug>(operator-join)
  map ;u <Plug>(operator-uniq)
  map ;k <Plug>(operator-trimright)

  map ;q <Plug>(operator-quickhl-manual-this-motion)
  map ;u <Plug>(operator-openbrowser)

  map <Leader>tm <Plug>(operator-tabular-tsv2md))
  map <Leader>Tm <Plug>(operator-tabular-md2tsv)
  map <Leader>nm <Plug>(operator-normalize_utf8mac)
  map ;s <Plug>(operator-shuffle)

  if s:bundle.is_installed('vim-operator-surround')
    map <silent>sa <Plug>(operator-surround-append)
    map <silent>sd <Plug>(operator-surround-delete)
    map <silent>sr <Plug>(operator-surround-replace)
    nmap <silent>saa <Plug>(operator-surround-append)<Plug>(textobj-multiblock-a)
    nmap <silent>sdd <Plug>(perator-surround-delete)<Plug>(textobj-multiblock-a)
    nmap <silent>srr <Plug>(operator-surround-replace)<Plug>(textobj-multiblock-a)
    nmap <silent>sdb <Plug>(operator-surround-delete)<Plug>(textobj-between-a)
    nmap <silent>srb <Plug>(operator-surround-replace)<Plug>(textobj-between-a)
  endif
endif

" textobj {{{2
if s:bundle.is_installed('vim-textobj-user')
  function! s:textobj_mapping(key, cmd)
    silent exe 'omap' a:key a:cmd
    silent exe 'vmap' a:key a:cmd
    " silent exe 'xmap' a:key a:cmd
    " silent exe 'smap' a:key a:cmd
  endfunction
  command! -nargs=+ Tmap call s:textobj_mapping(<f-args>)
  function! s:textobj_mapping_by_name(key, name)
    call s:textobj_mapping('i'.a:key, '<Plug>(textobj-' . a:name . '-i)')
    call s:textobj_mapping('a'.a:key, '<Plug>(textobj-' . a:name . '-a)')
  endfunction
  command! -nargs=+ TTmap call s:textobj_mapping_by_name(<f-args>)

  Tmap if <Plug>(textobj-function-i)
  Tmap af <Plug>(textobj-function-a)
  Tmap ii <Plug>(textobj-indent-i)
  Tmap ai <Plug>(textobj-indent-a)

  " Tmap a/ <Plug>(textobj-lastpat-n)
  " Tmap i/ <Plug>(textobj-lastpat-n)
  " Tmap a? <Plug>(textobj-lastpat-N)
  " Tmap i? <Plug>(textobj-lastpat-N)

  TTmap e entire
  nnoremap <silent> yie :<C-u>call <SID>execute_motionless("normal y\<Plug>(textobj-entire-i)")<CR>
  nnoremap <silent> yae :<C-u>call <SID>execute_motionless("normal y\<Plug>(textobj-entire-a)")<CR>
  TTmap y syntax
  TTmap ,_ quoted
  TTmap f function

  " TTmap e entire
  TTmap ,, parameter
  " TTmap l line
  TTmap ,b between
  TTmap ,f fold
  TTmap q enclosedsyntax
  " TTmap b multiblock
  TTmap b multitextobj
  TTmap ,w wiw
  TTmap u lastinserted
  TTmap U url
  TTmap # ifdef
  Tmap ixx <Plug>(textobj-context-i)

  " Tmap axa <Plug>(textobj-xmlattribute-xmlattribute)
  " Tmap ixa <Plug>(textobj-xmlattribute-xmlattributenospace)
  " TTmap m  motionmotion

  TTmap P php-phptag
  TTmap aP php-phparray

  TTmap c wordcolumn-w
  TTmap C wordcolumn-W

  " let g:textboj_ _no_default_key_mappings=1
  " let g:textboj_datetime_no_default_key_mappings=1
  " let g:textboj_jabraces_no_default_key_mappings=1

  let g:textboj_syntax_no_default_key_mappings=1
  let g:textboj_quoted_no_default_key_mappings=1
  let g:textboj_function_no_default_key_mappings=1

  " let g:textobj_entire_no_default_key_mappings=1
  let g:textobj_parameter_no_default_key_mappings=1
  " let g:textobj_line_no_default_key_mappings=1
  let g:textobj_between_no_default_key_mappings=1
  let g:textboj_fold_no_default_key_mappings=1
  let g:textboj_enclosedsyntax_no_default_key_mappings=1
  let g:textboj_multiblock_no_default_key_mappings=1
  let g:textobj_wiw_no_default_key_mappings=1
  let g:textboj_lastinserted_no_default_key_mappings=1
  let g:textboj_url_no_default_key_mappings=1
  let g:textboj_ifdef_no_default_key_mappings=1
  let g:textboj_context_no_default_key_mappings=1
  " let g:textboj_xbrackets_no_default_key_mappings=1
  let g:textboj_php_no_default_key_mappings=1
  let g:textobj_wordcolumn_no_default_key_mappings=1

  let g:textobj_multiblock_blocks = [
  \ [ '(', ')' ],
  \ [ '[', ']' ],
  \ [ '{', '}' ],
  \ [ '<', '>', 1 ],
  \ [ '"', '"', 1 ],
  \ [ "'", "'", 1 ],
  \ [ "_", "_", 1 ],
  \]

  let g:textobj_multitextobj_textobjects_i = [
  \ "\<Plug>(textobj-url-i)",
  \ "\<Plug>(textobj-php-i)",
  \ "\<Plug>(textobj-parameter-i)",
  \ "\<Plug>(textobj-multiblock-i)",
  \ "\<Plug>(textobj-function-i)",
  \ "\<Plug>(textobj-indent-i)",
  \]
  " \ "\<Plug>(textobj-entire-i)",

  let g:textobj_multitextobj_textobjects_a = [
  \ "\<Plug>(textobj-url-a)",
  \ "\<Plug>(textobj-php-a)",
  \ "\<Plug>(textobj-parameter-a)",
  \ "\<Plug>(textobj-multiblock-a)",
  \ "\<Plug>(textobj-function-a)",
  \ "\<Plug>(textobj-indent-a)",
  \]
  " \ "\<Plug>(textobj-entire-a)",

  let g:textobj_multitextobj_textobjects_group_i = {
  \ "A" : [
  \   "\<Plug>(textobj-url-i)",
  \   "\<Plug>(textobj-wiw-i)",
  \   "iw",
  \ ]
  \}
endif

" vim-niceblock {{{2
if s:bundle.is_installed('vim-niceblock')
  xmap I <Plug>(niceblock-I)
  xmap A <Plug>(niceblock-A)
endif

" ref.vim {{{2
if s:bundle.is_installed('vim-ref')
  let g:ref_open = '8split'
  let g:ref_cache_dir = $VIM_CACHE . '/vim-ref'
  if !exists('g:ref_detect_filetype')
    let g:ref_detect_filetype = {}
  endif
  let g:ref_detect_filetype._ = 'webdict'
  let g:ref_use_vimproc = 0
  let g:ref_alc_use_cache = 1
  let g:ref_alc_start_linenumber = 43

  if g:vimrc_enabled_plugins.vimproc
    let g:ref_use_vimproc = 1
  endif

  " options {{{3
  " webdict {{{4
  if s:is_win
    " for w3m
    let $LANG='C.UTF-8'
    let g:ref_source_webdict_encoding = 'utf-8'
  endif
  let g:ref_source_webdict_sites = {
    \ 'alc' : {
    \   'url': 'http://eow.alc.co.jp/%s',
    \   'keyword_encoding,': 'utf-8',
    \   'cache': 1,
    \ },
    \ 'weblio': {
    \   'url': 'http://ejje.weblio.jp/content/%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': 1,
    \ },
    \ 'wikipedia': {
    \   'url': 'http://ja.wikipedia.org/wiki/%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'wikipedia:en': {
    \   'url': 'http://en.wikipedia.org/wiki/%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'wiktionary': {
    \   'url': 'http://ja.wiktionary.org/wiki/%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'ja_en': {
    \   'url': 'http://translate.google.co.jp/m?hl=ja\&sl=ja\&tl=en\&ie=UTF-8\&prev=_m\&q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'en_ja': {
    \   'url': 'http://translate.google.co.jp/m?hl=ja\&sl=en\&tl=ja\&ie=UTF-8\&prev=_m\&q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'ruby_toolbox': {
    \   'url': 'https://www.ruby-toolbox.com/search?utf8=%%E2%%9C%%93\&q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'rurema': {
    \   'url': 'http://doc.ruby-lang.org/ja/search/query:%s/',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'rubygems': {
    \   'url': 'http://rubygems.org/search?query=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'node_toolbox': {
    \   'url': 'http://nodetoolbox.com/search?q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'chef_cookbooks': {
    \   'url': 'http://community.opscode.com/search?query=%s\&scope=cookbook',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ 'underscore.js': {
    \   'url': 'http://underscorejs.org/?q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '1',
    \ },
    \ 'lodash.js': {
    \   'url': 'http://lodash.com/docs?q=%s',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '1',
    \ },
    \ 'cpan': {
    \   'url': 'http://search.cpan.org/search?q=%s;s={startIndex}',
    \   'keyword_encoding': 'utf-8',
    \   'cache': '0',
    \ },
    \ }
  function! g:ref_source_webdict_sites.alc.filter(output)
    return join(split(a:output, "\n")[38:], "\n")
  endfunction
  function! g:ref_source_webdict_sites.weblio.filter(output)
    return join(split(a:output, "\n")[53 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.wikipedia.filter(output)
    return join(split(a:output, "\n")[17 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.wiktionary.filter(output)
    return join(split(a:output, "\n")[38:], "\n")
  endfunction
  function! g:ref_source_webdict_sites.rurema.filter(output)
    return substitute(a:output, '.*検索結果', '', '')
  endfunction
  function! g:ref_source_webdict_sites.node_toolbox.filter(output)
    return join(split(a:output, "\n")[34 :], "\n")
  endfunction
  function! g:ref_source_webdict_sites.chef_cookbooks.filter(output)
    return join(split(a:output, "\n")[18 :], "\n")
  endfunction

  " webdict default {{{4
  let g:ref_source_webdict_sites.default = 'alc'

  " webdict command {{{4
  command! -nargs=? -range=0 GTransEnJa call my#buffer#ref_gtrans(<count>, <line1>, <line2>, 'en_ja',<q-args>)
  command! -nargs=? -range=0 GTransJaEn call my#buffer#ref_gtrans(<count>, <line1>, <line2>, 'ja_en',<q-args>)

  " langs {{{4
  let g:ref_source_webdict_sites.default = 'alc'
  let g:ref_phpmanual_path=$VIM_REFDOC.'/phpman/'
  let g:ref_javadoc_path = $VIM_REFDOC.'/jdk-6-doc/ja'
  let g:ref_jquery_path = $VIM_REFDOC.'/jqapi-latest/docs'
  let g:ref_html_path=$VIM_REFDOC.'/htmldoc/www.aptana.com/reference/html/api'
  let g:ref_html5_path=$VIM_REFDOC.'/html5doc/dist'
  let g:ref_jscore_path=$VIM_REFDOC.'/jscore/www.aptana.com/reference/html/api'
  let g:ref_jsdom_path=$VIM_REFDOC.'/jscore/www.aptana.com/reference/html/api'
  "let g:ref_jquery_use_cache = 1
  let g:ref_nodejsdoc_dir=$VIM_REFDOC.'/nodejs/doc'

  if executable('rurema')
    let g:ref_refe_cmd     = "rurema"
    let g:ref_refe_version = 2
  endif
  if s:is_win
    let g:ref_refe_encoding = 'cp932'
  else
    " let g:ref_refe_encoding = 'utf-8'
    " if exists('$RSENSE_HOME') && executable($RSENSE_HOME.'/bin/rsense')
    "   let g:ref_refe_rsense_cmd = $RSENSE_HOME.'/bin/rsense'
    " endif
  endif
  let g:ref_perldoc_complete_head = 1
  " }}}

  LCAlias Ref
  " for src in ['refe', 'ri', 'perldoc', 'man'
  "       \ , 'pydoc', 'jsref', 'jquery'
  "       \ , 'cppref', 'cheat', 'nodejs', ]
  "   silent! exe 'Alias' src 'Ref' src
  " endfor
  Alias rd Ref ri
  Alias pd Ref perldoc
  Alias phd Ref phpmanual
  Alias pyd Ref pydoc
  Alias jsd Ref jsref
  Alias jqd Ref jquery
  Alias cppd Ref phpmanual
  Alias nd Ref nodejs
  Alias webd[ict] Ref webdict
  Alias mr Ref webdict
  Alias al[c] Ref webdict alc

endif

" quickrun & watchdogs {{{2
if s:bundle.is_installed('vim-quickrun')
  " quickrun {{{3
  nnoremap <expr><silent><C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
  "silent! nmap <unique> <Space> <Plug>(quickrun)
  if !exists('g:quickrun_config')
    let g:quickrun_config={}
  endif

  " objc {{{4
  call extend(g:quickrun_config, {
  \ 'objc' : {
  \   'type' : executable('xctool') ? 'objc/xctool' : 'objc/gcc',
  \ },
  \ 'objc/gcc' : {
  \   'command' : 'gcc',
  \   'exec' : ['%c %o %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
  \   'tempfile': '{tempname()}.m'
  \ },
  \ 'objc/xctool' : {
  \    'command': 'xctool',
  \    'cmdopt': 'test',
  \    'outputter': 'xctool',
  \    'exec': ['%c %o %a'],
  \ },
  \ 'swift' : {
  \   'type' : 'swift/xcrun',
  \ },
  \ 'swift/xcrun' : {
  \    'command': 'xcrun swift',
  \    'cmdopt': '-i',
  \    'outputter': 'xctool',
  \    'exec': ['%c %s %o %a'],
  \ },
  \ })
  " gcc {{{4
  call extend(g:quickrun_config, {
  \ 'cpp': {
  \   'type' : 'cpp/clang++',
  \ },
  \ 'cpp/gcc': {
  \   'command' : 'g++',
  \   'cmdopt' : '-std=c++11 -Wall -Wextra',
  \   'hook/quickrunex/enable' : 1,
  \ },
  \ 'cpp/clang++': {
  \   'command' : 'clang++',
  \   'cmdopt' : '-std=c++1y -Wall -Wextra',
  \   'hook/quickrunex/enable' : 1,
  \ },
  \ })
  " go {{{4
  call extend(g:quickrun_config, {
  \ 'go' : {
  \   'type' : executable('8g') ? 'go/8g': '',
  \ },
  \ 'go/8g' : {
  \   'command': '8g',
  \   'exec': ['8g %s', '8l -o %s:p:r %s:p:r.8', '%s:p:r %a', 'rm -f %s:p:r'],
  \ },
  \ })
  " csharp {{{4
  call extend(g:quickrun_config, {
  \ 'cs' : {
  \   'type' : executable('csc') ? 'cs/csc':
  \            executable('cs') ? 'cs/cs': '',
  \ },
  \ 'cs/csc' : {
  \   'command' : 'csc',
  \   'runmode' : 'simple',
  \   'exec' : ['%c /nologo %s:gs?/?\\? > /dev/null', '"%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
  \   'tempfile' : '{tempname()}.cs',
  \ },
  \ 'cs/cs' : {
  \   'command' : 'cs',
  \   'runmode' : 'simple',
  \   'exec' : ['%c %s > /dev/null', 'mono "%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
  \   'tempfile' : '{tempname()}.cs',
  \ },
  \ })
  if s:is_win && executable('C:\Program Files (x86)\LINQPad4\LPRun.exe')
    let g:quickrun_config['cs/lprun'] = {
      \   'command': 'C:\Program Files (x86)\LINQPad4\LPRun.exe',
      \ , 'cmdopt': '-lang=S',
      \ , 'exec': '%c:gs?/?\\? %o %s',
      \ , 'tempfile': '%{tempname()}.cs',
      \ , 'hook/output_encode/encoding': '&termencoding',
      \ , 'hook/sweep/files': ['%S:p:r.exe'],
      \ }
  endif
  " html {{{4
  call extend(g:quickrun_config, {
  \ 'html' : {
  \   "type" : "html/haml"
  \ },
  \ 'html/haml' : {
  \   "command" : "html2haml"
  \ },
  \ 'html/haml_repace' : {
  \   "outputter" : "error",
  \   "outputter/success" : "replace_region",
  \   "outputter/error"   : "message",
  \   "outputter/message/log"   : 1,
  \   "runner" : "system",
  \   "type" : "html/haml"
  \ },
  \})
  " javascript {{{4
  call extend(g:quickrun_config, {
  \ 'json': {
  \   'type': 'json/jq',
  \ },
  \ 'coffee/coffee2javascript' : {
  \    'command': 'coffee',
  \    'cmdopt': '-pb',
  \    'outputter/buffer/filetype': 'javascript',
  \ },
  \ 'json/jq': {
  \   'command': 'jq',
  \ },
  \ })

  call extend(g:quickrun_config, {
  \ 'javascript/babel': {
  \   'cmdopt': '',
  \   'exec': "babel %o %s",
  \   'outputter/buffer/filetype': 'javascript',
  \ }})

  " call extend(g:quickrun_config, {
  " \ 'jsx' : {
  " \   'type' : 'denajsx/jsx',
  " \ },
  " \ 'denajsx/jsx' : {
  " \   'command': 'jsx',
  " \   'exec' : '%c %o --run %s',
  " \ },
  " \ })

  " css {{{4
  call extend(g:quickrun_config, {
  \ 'slim' : {
  \   'type' : 'slim/slimrb',
  \ },
  \ 'slim/slimrb' : {
  \   'command' : 'slimrb',
  \   'exec' : ['%c %o -p %s'],
  \ },
  \ })
  " rspec {{{4
  " http://qiita.com/joker1007/items/9dc7f2a92cfb245ad502
  call extend(g:quickrun_config, {
  \ 'ruby.rspec' : {
  \   'type' : 'ruby/rspec',
  \ },
  \ 'ruby/rspec' : {
  \   'command' : 'rspec',
  \   'exec' : '%c %o -l {line(".")}',
  \ },
  \ 'ruby.rspec/rspec_bundle': {
  \   'command': 'rspec',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'bundle exec %c %o --color --tty %s'
  \ },
  \ 'ruby.rspec/rspec_normal': {
  \   'command': 'rspec',
  \   'outputter/buffer/split': 'botright',
  \   'exec': '%c %o --color --tty %s'
  \ },
  \ 'ruby.rspec/rspec_zeus': {
  \   'command': 'rspec',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'zeus test %o --color --tty %s'
  \ },
  \ 'ruby.rspec/rspec_spring': {
  \   'command': 'rspec',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'spring rspec %o --color --tty %s'
  \ },
  \ 'ruby/cucumber_bundle': {
  \   'command': 'cucumber',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'bundle exec %c %o --color %s'
  \ },
  \ 'ruby/cucumber_zeus': {
  \   'command': 'cucumber',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'zeus cucumber %o --color %s'
  \ },
  \ 'ruby/cucumber_spring': {
  \   'command': 'cucumber',
  \   'outputter/buffer/split': 'botright',
  \   'exec': 'spring cucumber %o --color %s'
  \ },
  \ })

  " tests {{{4
  call extend(g:quickrun_config, {
  \ 'python.nosetests' : {
  \   'type' : 'python/nosetests',
  \ },
  \ 'perl.prove' : {
  \   'type' : 'perl/prove',
  \ },
  \ 'php.phpunit' : {
  \   'type' : 'php/phpunit',
  \ },
  \ 'python/nosetests' : {
  \   'command' : 'nosetests',
  \   'cmdopt': '-s -vv',
  \ },
  \ 'php/phpunit' : {
  \   'command' : 'phpunit',
  \ },
  \ 'perl/prove' : {
  \   'command' : 'prove',
  \ },
  \ })

  " database {{{4
  function! s:build_options(vars, ...) "{{{5
    let opts = []
    for [field, fmt] in items(a:vars)
      let value = get(b:, field, get(g:, field, ''))
      if !empty(value)
        call add(opts, printf(fmt, value))
      endif
    endfor

    return join(opts, " ")
  endfunction "}}}

  function! s:str_prepend(val, ch)
    return empty(a:val) ? "" : a:ch . a:val
  endfunction

  function! s:build_sqlplus_options() "{{{5
    let opts = []
    let vars = [
      \ 'dbext_user',
      \ 'dbext_passwd',
      \ 'dbext_host',
      \ 'dbext_port',
      \ 'dbext_dbname',
      \ ]
    let [user, pass, host, port, db] = map(vars, 'get(b:, field, get(g:, field, ""))')
    return printf("%s%s@%s%s%s", user,
      \ s:str_prepend(pass, "/"),
      \ host,
      \ s:str_prepend(port, ":"),
      \ s:str_prepend(db, "/")
      \ )
  endfunction " }}}
  function! MySQLCommandOptions() "{{{5
    if exists('b:MYSQL_cmd_options')
      return b:MYSQL_cmd_options
    endif
    return s:build_options({
          \ 'dbext_host': '-h %s',
          \ 'dbext_user': '-u %s',
          \ 'dbext_passwd': '-p%s',
          \ 'dbext_port': '-P %s',
          \ 'dbext_dbname': '%s',
          \ })
  endfunction "}}}
  function! PgSQLCommandOptions() "{{{5
    if exists('b:PGSQL_cmd_options')
      return b:PGSQL_cmd_options
    endif
    return s:build_options({
      \ 'dbext_host': '-h %s',
      \ 'dbext_user': '-u %s',
      \ 'dbext_port': '-p %s',
      \ 'dbext_dbname': '-d %s',
      \ })
  endfunction "}}}
  function! OracleCommandOptions() "{{{5
    if exists('b:SQLPLUS_cmd_options')
      return b:PGSQL_cmd_options
    endif

    return s:build_sqlplus_options()
  endfunction

  " configs{{{4
  call extend(g:quickrun_config, {
  \ 'mysql' : {
  \   'type' : 'sql/mysql',
  \ },
  \ 'sql' : {
  \   'type' : 'sql/postgresql',
  \ },
  \ 'sql/mysql' : {
  \   'command' : 'mysql',
  \   'cmdopt': '%{MySQLCommandOptions()}',
  \   'exec' : ['%c %o < %s'],
  \ },
  \ 'sql/postgresql': {
  \   'command' : 'psql',
  \   'cmdopt': '%{PgSQLCommandOptions()}',
  \   'exec': ['%c %o -f %s'],
  \ }
  \ })
  " texts {{{4
  if s:bundle.is_installed('previm')
    call extend(g:quickrun_config, {
    \ 'markdown': { 'type': 'text/previm' },
    \ 'rst': { 'type': 'text/previm' },
    \ 'textile': { 'type': 'text/previm' },
    \ })
    call extend(g:quickrun_config, {
    \ 'text/previm' : {
    \   'runner' : 'vimscript',
    \   'exec' : 'silent PrevimOpen %o',
    \   'outputter' : 'null',
    \ }})
  else
    call extend(g:quickrun_config, {
    \ 'rst': {
    \   'type': 'rst/rst2html',
    \ }})

    call extend(g:quickrun_config, {
    \ 'markdown' : {
    \   'type' :
    \      s:is_mac && isdirectory('/Applications/Marked.app') ? 'markdown/Marked':
    \      executable('markedwrapper')    ? 'markdown/markedwrapper':
    \      executable('mdown')            ? 'markdown/mdown':
    \      executable('pandoc')           ? 'markdown/pandoc':
    \      executable('multimarkdown')    ? 'markdown/multimarkdown':
    \      executable('MultiMarkdown.pl') ? 'markdown/MultiMarkdown.pl':
    \      executable('rdiscount')        ? 'markdown/rdiscount':
    \      executable('bluecloth')        ? 'markdown/bluecloth':
    \      executable('markdown')         ? 'markdown/markdown':
    \      executable('Markdown.pl')      ? 'markdown/Markdown.pl':
    \      executable('redcarpet')        ? 'markdown/redcarpet':
    \      executable('kramdown')         ? 'markdown/kramdown':
    \      '',
    \   'outputter' : 'browser',
    \ },
    \ })
  endif

  call extend(g:quickrun_config, {
  \ 'rst/rst2html': {
  \   'command': 'rst2html',
  \ },
  \ })
  call extend(g:quickrun_config, {
  \ 'markdown/markedwrapper' : {
  \   'command' : 'markedwrapper',
  \   'exec' : '%c %o %s',
  \ },
  \ 'markdown/mdown' : {
  \   'command' : 'mdown',
  \   'exec' : '%c %o -i %s',
  \ },
  \ 'markdown/Marked' : {
  \   'command' : 'open',
  \   'outputter' : 'null',
  \   'exec' : '%c -a Marked %o %s',
  \ },
  \ 'markdown/multimarkdown' : {
  \   'command' : 'multimarkdown',
  \ },
  \ 'markdown/rdiscount' : {
  \   'command' : 'rdiscount',
  \ },
  \ 'markdown/markdown' : {
  \   'command' : 'markdown',
  \ },
  \ })
  call extend(g:quickrun_config, {
  \ 'markdown/md2backlog' : {
  \   'command' : 'md2backlog',
  \ },
  \ 'markdown/vim-helpfile' : {
  \   'command' : 'vim-helpfile',
  \ },
  \ 'markdown/markdown2pod' : {
  \   'command' : 'markdown2pod',
  \ },
  \ })

  " script langs {{{4
  call extend(g:quickrun_config, {
  \ 'processing' : {
  \   'type' : executable('processing-java') ? 'processing/processing-java' :
  \            executable('osascript') ? 'processing/osascript':
  \            '',
  \ },
  \ 'applescript' : {
  \   'type' : executable('osascript') ? 'applescript/osascript':
  \            '',
  \ },
  \ 'diag' : {
  \   'type' : 'diag/diag',
  \ },
  \ })
  call extend(g:quickrun_config, {
  \ 'processing/osascript' : {
  \   'command': 'osascript',
  \   'exec' : ['osascript %o ' . globpath(&runtimepath, 'bin/runPSketch.scpt'). ' %s:p:h:t']
  \ },
  \ 'processing/processing-java' : {
  \   'command': 'processing-java',
  \   'exec' : '%c %o --sketch=$PWD/ --output=/Library/Processing --run --force',
  \ },
  \ 'applescript/osascript' : {
  \   'command' : 'osascript',
  \   'output' : '_',
  \ },
  \ 'diag/diag' : {
  \   'exec': [
  \      '%c -a %s -o %{expand("%:r")}.png',
  \      printf("%s %{expand(%:r)}.png %s",
  \        s:is_win ? 'explorer' : (s:is_mac ? 'open -g' : 'xdg-open'),
  \        s:is_win ? "" : "&"),
  \   ],
  \   'outputter': 'message',
  \ },
  \ })
  call extend(g:quickrun_config, {
  \ 'command/cat' : {
  \   'command' : 'cat',
  \   'exec' : ['%c %o %s'],
  \ },
  \ })

  " TODO : not work
  call extend(g:quickrun_config, {
  \ 'w3m' : {
  \   'type' : 'w3m/open',
  \ },
  \ 'w3m/open': {
  \   'command': (s:is_win ? 'start ""' : (s:is_mac ? "open" : "xdg-open")),
  \   'exec': [
  \     '%c %o "%{b:last_url}"',
  \   ],
  \ }
  \ })

  nnoremap <Leader><Leader>r :<C-u>QuickRun command/cat<CR>

  " for testcase {{{4
  MyAutoCmd BufWinEnter,BufNewFile *_spec.rb setl filetype=ruby.rspec
  MyAutoCmd BufWinEnter,BufNewFile *test.php,*Test.php setl filetype=php.phpunit
  MyAutoCmd BufWinEnter,BufNewFile test_*.py setl filetype=python.nosetests
  MyAutoCmd BufWinEnter,BufNewFile *.t setl filetype=perl.prove

  command! PhpUnitSkelGen call my#php#generate_phpunit_skelgen()

  if s:bundle.is_installed('vim-ref')
    augroup vimrc-plugin-ref
      autocmd!
      autocmd FileType ruby.rspec,php.phpunit,python.nosetests,perl.prove call s:testcase_lazy_init()
    augroup END

    function! s:testcase_lazy_init()
      call ref#register_detection('ruby.rspec', 'refe', 'append')
      call ref#register_detection('php.phpunit', 'phpmanual', 'append')
      call ref#register_detection('python.nosetests', 'pydoc', 'append')
      call ref#register_detection('perl.prove', 'perldoc', 'append')
      augroup vimrc-plugin-ref
        autocmd!
      augroup END
    endfunction
  endif

  " quickrun init {{{3
  function! s:vimrc_quickrun_init() "{{{4
    nmap <buffer> q :quit<CR>
  endfunction "}}}
  MyAutoCmd FileType quickrun call s:vimrc_quickrun_init()

  " watchdogs config {{{3
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/_' : {
    \   'hook/close_quickfix/enable_failure' : 1,
    \   'hook/close_quickfix/enable_success' : 1,
    \   'hook/hier_update/enable' : 1,
    \   'hook/quickfix_status_enable/enable' : 1,
    \   "hook/quickfixsigns_update/enable_exit" : 1,
    \   "hook/quickfixsigns_update/priority_exit" : 3,
    \   'hook/back_window/enable' : 1,
    \   'outputter/quickfix/open_cmd' : '',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'perl/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/perl-projectlibs',
    \ },
    \ 'cpanfile/watchdogs_checker': {
    \   'type' : 'watchdogs_checker/cpanfile',
    \ },
    \ "watchdogs_checker/perl-locallib" : {
    \   "command" : "perl",
    \   "exec"    : "%c %o -Mlib=local/lib/perl5/ -Mlib=lib -Mlib=. -cw %s:p",
    \   "quickfix/errorformat" : '%m\ at\ %f\ line\ %l%.%#',
    \ },
    \ 'watchdogs_checker/perl-projectlibs': {
    \   'command' : 'perl',
    \   'exec' : '%c %o -cw -MProject::Libs %s:p',
    \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
    \ },
    \ 'watchdogs_checker/cpanfile': {
    \   'command' : 'perl',
    \   'exec' : '%c %o -w -MModule::CPANfile -e "Module::CPANfile->load(q|%S:p|)"',
    \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
    \ },
    \ })

  function! PhpcsStandardDetect() "{{{
    let standard = get(b:, 'watchdogs_checker_phpcs_standard', 'PSR2')
    let extra_opt = get(b:, 'watchdogs_checker_phpcs_options', '')
    return printf('--standard=%s %s', standard, extra_opt)
  endfunction "}}}
  call extend(g:quickrun_config, {
  \ 'watchdogs_checker/phpcs': {
  \    'command': 'phpcs',
  \    'cmdopt' : '--report=csv %{PhpcsStandardDetect()}',
  \    'exec': '%c %o %s:p',
  \    'quickfix/errorformat': "\"%f\"\\,%l\\,%c\\,%t%*[a-zA-Z]\\,\"%m\"\\,%*[a-zA-Z0-9_.-\\,]"
  \ }
  \ })
  if executable('tidy')
    call extend(g:quickrun_config, {
    \ 'html/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/tidy',
    \ },
    \ 'xhtml/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/tidy',
    \ },
    \ })
  endif
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/tidy' : {
    \   'command' : 'tidy',
    \    'exec'    : '%c -raw -quiet -errors --gnu-emacs yes %o %s:p',
    \    'quickfix/errorformat' : '%f:%l:%c: %m',
    \ },
    \ 'haml/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/haml',
    \ },
    \ 'watchdogs_checker/haml' : {
    \   'command' : 'haml',
    \    'exec'    : '%c -c %o %s:p',
    \    'quickfix/errorformat' : 'Haml error on line %l: %m,'
    \                           . 'Syntax error on line %l: %m,%-G%.%#',
    \ },
    \ 'watchdogs_checker/slimrb' : {
    \   'command' : 'slimrb',
    \    'exec'    : '%c -c %o %s:p',
    \    'quickfix/errorformat' : '%C\ %#%f\, Line %l\, Column %c,'.
    \                             '%-G\ %.%#,'.
    \                             '%ESlim::Parser::SyntaxError: %m,'.
    \                             '%+C%.%#'
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'json/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/jsonlint',
    \ },
    \ 'watchdogs_checker/jsonlint' : {
    \   'command' : 'jsonlint',
    \    'exec'    : '%c %s:p %o --compact',
    \    'quickfix/errorformat' : '%ELine %l:%c,%Z\\s%#Reason: %m,'
    \                           . '%C%.%#,%f: line %l\, col %c\, %m,%-G%.%#',
    \ },
    \ 'watchdogs_checker/jsonval' : {
    \   'command' : 'jsonval',
    \    'exec'    : '%c %o %s:p',
    \    'quickfix/errorformat' : '%E%f: %m at line %l,%-G%.%#',
    \ },
    \ })
  if executable('jsxhint')
    let g:quickrun_config['javascript/watchdogs_checker'] = 'watchdogs_checker/jsxhint'
  endif
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/nodejs' : {
    \   'command' : 'node',
    \    'exec'    : '%c %o %s:p',
    \    'quickfix/errorformat' : '%AError: %m,%AEvalError: %m,'
    \                           . '%ARangeError: %m,%AReferenceError: %m,'
    \                           . '%ASyntaxError: %m,%ATypeError: %m,'
    \                           .  '%Z%*[\ ]at\ %f:%l:%c,%Z%*[\ ]%m (%f:%l:%c),'
    \                           .  '%*[\ ]%m (%f:%l:%c),%*[\ ]at\ %f:%l:%c,%Z%p^,'
    \                           .  '%A%f:%l,%C%m,%-G%.%#'
    \ },
    \ 'watchdogs_checker/jsxhint' : {
    \   'command' : 'jsxhint',
    \    'exec'    : '%c --verbose %o %s:p',
    \    'quickfix/errorformat' : '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'coffee/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/coffee',
    \ },
    \ 'watchdogs_checker/coffee' : {
    \   'command' : 'coffee',
    \   'exec'    : '%c -c -p %o %s:p',
    \   'quickfix/errorformat' : '%E%f:%l:%c: %trror: %m,' .
    \                            'Syntax%trror: In %f\, %m on line %l,' .
    \                            '%EError: In %f\, Parse error on line %l: %m,' .
    \                            '%EError: In %f\, %m on line %l,' .
    \                            '%W%f(%l): lint warning: %m,' .
    \                            '%W%f(%l): warning: %m,' .
    \                            '%E%f(%l): SyntaxError: %m,' .
    \                            '%-Z%p^,' .
    \                            '%-G%.%#'
    \ },
    \ 'watchdogs_checker/coffeelint' : {
    \   'command' : 'coffeelint',
    \   'exec'    : '%c -csv %o %s:p',
    \   'quickfix/errorformat' : '%f\,%l\,%\d%#\,%trror\,%m,' .
    \                            '%f\,%l\,%trror\,%m,' .
    \                            '%f\,%l\,%\d%#\,%tarn\,%m,' .
    \                            '%f\,%l\,%tarn\,%m'
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'typescript/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/tsc',
    \ },
    \ 'watchdogs_checker/tsc' : {
    \   'command' : 'tsc',
    \    'exec'    : '%c %o %s:p',
    \    'quickfix/errorformat' : '%+A %#%f %#(%l\,%c): %m,%C%m',
    \ },
    \ 'watchdogs_checker/jsxhint' : {
    \   'command' : 'jsxhint',
    \    'exec'    : '%c --verbose %o %s:p',
    \    'quickfix/errorformat' : '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'css/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/csslint',
    \ },
    \ 'watchdogs_checker/csslint' : {
    \   'command' : 'csslint',
    \    'exec'    : '%c %o --format=compact %s:p',
    \    'quickfix/errorformat' : '%-G,%-G%f: lint free!'.
    \       ',%f: line %l\, col %c\, %trror - %m,%f: '.
    \       'line %l\, col %c\, %tarning - %m,%f: line %l\, col %c\, %m,',
    \ },
    \ })
  if executable('scss-lint')
    call extend(g:quickrun_config, {
      \ 'scss/watchdogs_checker' : {
      \   'type' : 'watchdogs_checker/scsslint',
      \ },
      \ 'watchdogs_checker/scsslint' : {
      \   'command' : 'scss-lint',
      \    'exec'    : '%c %o --format=compact %s:p',
      \    'quickfix/errorformat' : '%A%f:\ line\ %l\\,\ col\ %c\\,\ %m'
      \ },
      \ })
  endif
  if !executable('pyflakes')
    call extend(g:quickrun_config, {
      \  'python/watchdogs_checker' : {
      \    'type' : 'watchdogs_checker/python',
      \  },
      \ })
  endif
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/python' : {
    \   'command' : 'python',
    \   'exec'    : "%c %o -c \"compile(open('%s:p').read(), '%s:p', 'exec')\"",
    \   'quickfix/errorformat' :
    \      '%A  File "%f"\, line %l\,%m,' .
    \      '%C    %.%#,' .
    \      '%+Z%.%#Error: %.%#,' .
    \      '%A  File "%f"\, line %l,' .
    \      '%+C  %.%#,' .
    \      '%-C%p^,' .
    \      '%Z%m,' .
    \      '%-G%.%#'
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'csharp/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/mcs',
    \ },
    \ 'watchdogs_checker/mcs' : {
    \   'command' : 'mcs',
    \    'exec'    : '%c %o %s:p',
    \    'cmdopt'  : '--parse',
    \    'quickfix/errorformat' : '%f(%l\\\,%c):\ error\ CS%n:\ %m',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'objc/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/gcc_objc',
    \ },
    \ 'watchdogs_checker/gcc_objc' : {
    \   'command' : 'gcc',
    \    'exec'    : '%c -fsyntax-only -lobjc %o %s:p',
    \    'quickfix/errorformat' : '%-G%f:%s:,'
    \                           . '%f:%l:%c: %trror: %m,'
    \                           . '%f:%l:%c: %tarning: %m,'
    \                           . '%f:%l:%c: %m,'
    \                           . '%f:%l: %trror: %m,'
    \                           . '%f:%l: %tarning: %m,'
    \                           . '%f:%l: %m',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'eruby/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/ruby_erb',
    \ },
    \ 'Gemfile/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/ruby',
    \ },
    \ 'watchdogs_checker/erubis' : {
    \   'command' : 'erubis',
    \   'exec'    : '%c -z %o %s:p',
    \   'quickfix/errorformat' : '%f:%l:%m',
    \ },
    \ 'watchdogs_checker/ruby_erb' : {
    \   'command' : 'ruby',
    \   'exec'    : '%c -rerb -e "puts ERB.new('
    \           . 'File.read(''%s:p'').gsub(''<\%='', ''<\%'')'
    \           . ', nil, ''-'').src" | %c -c %o',
    \   'quickfix/errorformat' : '%-GSyntax OK,%E-:%l: syntax error, %m,%Z%p^,%W-:%l: warning: %m,%Z%p^,%-C%.%#',
    \ },
    \ 'cucumber/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/cucumber',
    \ },
    \ 'watchdogs_checker/cucumber' : {
    \   'command': 'cucumber',
    \   'exec'  : '%c --dry-run --quiet --strict --format pretty %o %s:p',
    \   'quickfix/errorformat' : '%f:%l:%c:%m,%W      %.%# (%m),%-Z%f:%l:%.%#,%-G%.%#',
    \ },
    \ 'watchdogs_checker/foodcritic': {
    \   'command': 'foodcritic',
    \   'exec'   : '%c %o %s:p',
    \   'quickfix/errorformat': 'FC%n: %m: %f:%l',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'applescript/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/osacompile',
    \ },
    \ 'watchdogs_checker/osacompile' : {
    \   'command' : 'osacompile',
    \   'exec'    : '%c -o %o %s:p',
    \   'quickfix/errorformat' : '%f:%l:%m',
    \ },
    \ })
  if executable('luac')
    call extend(g:quickrun_config, {
      \ 'lua/watchdogs_checker' : {
      \   'type' : 'watchdogs_checker/luac',
      \ },
      \ })
  endif
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/luac' : {
    \   'command' : 'luac',
    \   'exec'    : '%c -p %o %s:p',
    \   'quickfix/errorformat' : 'luac: %#%f:%l: %m',
    \ },
    \ 'qml/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/qmlscene',
    \ },
    \ 'watchdogs_checker/qmlscene' : {
    \   'command' : 'qmlscene',
    \   'exec'    : '%c -c %o %s:p',
    \   'cmdopt' : '--quit',
    \   'quickfix/errorformat' : 'file:\/\/%f:%l %m',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/sqlplus' : {
    \   'command' : 'sqlplus',
    \   'cmdopt'  : '-S %{OracleCommandOptions()}',
    \   'exec'    : '%c %o \@%s:p',
    \   'quickfix/errorformat' : '%Eerror\ at\ line\ %l:,%Z%m',
    \ },
    \ })
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/twig-lint' : {
    \   'command' : 'twig-lint',
    \   'exec'    : '%c lint --format=csv %o %s:p',
    \   'quickfix/errorformat' : '"%f"\,%l\,%m',
    \ },
    \ })
  if executable('golint')
    call extend(g:quickrun_config, {
      \ 'go/watchdogs_checker' : {
      \   'type' : 'watchdogs_checker/golint',
      \ },
      \ })
  endif
  call extend(g:quickrun_config, {
    \ 'watchdogs_checker/go' : {
    \   'command' : 'gofmt',
    \   'exec'    : '%c -l %o %s:p',
    \   'quickfix/errorformat' : '%f:%l:%c: %m,%-G%.%#',
    \ },
    \ 'watchdogs_checker/golint' : {
    \   'command' : 'golint',
    \   'exec'    : '%c %o %s:p',
    \   'quickfix/errorformat' : '%f:%l:%c: %m,%-G%.%#',
    \ },
    \ })
  " call extend(g:quickrun_config, {
  "   \ '/watchdogs_checker' : {
  "   \   'type' : 'watchdogs_checker/',
  "   \ },
  "   \ 'watchdogs_checker/' : {
  "   \   'command' : '',
  "   \   'exec'    : '%c -c %o %s:p',
  "   \   'quickfix/errorformat' : '',
  "   \ },
  "   \ })
  " watchdogs setup {{{3
  call watchdogs#setup(g:quickrun_config)
  let g:watchdogs_check_BufWritePost_enable = 1
  " watchdogs helper command {{{4
  command! -nargs=0 WatchdogsOff let g:watchdogs_check_BufWritePost_enable=0
  command! -nargs=0 WatchdogsOn let g:watchdogs_check_BufWritePost_enable=1
  command! -nargs=? WatchdogsConfig call my#watchdogs#show_config(<f-args>)
endif


" quickhl {{{2
if s:bundle.is_installed('vim-quickhl')
  let g:quickhl_manual_enable_at_startup = 1
  let g:quickhl_cword_enable_at_startup = 1
  let g:quickhl_tag_enable_at_startup = 1
  nmap [!space]m <Plug>(quickhl-cword-toggle)
  xmap [!space]m <Plug>(quickhl-cword-toggle)
  nmap [!space]M <Plug>(quickhl-manual-reset)
  xmap [!space]M <Plug>(quickhl-manual-reset)
  nmap [!space], <Plug>(quickhl-manual-this)
endif

" chalice {{{2
if s:bundle.is_installed('chalice')
  let g:chalice_bookmark = $VIM_CACHE . "/chalice_bmk"
  let g:chalice_cachedir = $VIM_CACHE . "/chalice_cache"
  call s:mkdir(g:chalice_cachedir)
endif

" echodoc {{{2
let g:echodoc_enable_at_startup=0

" snowdrop {{{2
if s:bundle.tap('vim-snowdrop')
  let g:snowdrop#include_paths = get(g:, 'snowdrop#include_paths', {})
  let g:snowdrop#command_options = get(g:, 'snowdrop#command_options', {})
  if s:is_win
    " let g:snowdrop#libclang_directory = "C:/llvm/bin"
  elseif s:is_mac
    function! s:get_latest_sdk()
      let paths = split(glob('/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/*.sdk'), "\n")
      return empty(paths) ? '' : paths[-1]
    endfunction
    let g:snowdrop#libclang_directory = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/'
    let g:snowdrop#libclang_file = 'libclang.dylib'
    " let g:clang_complete_getopts_ios_sdk_directory = s:get_latest_sdk()
    " MyAutoCmd FileType objc let g:clang_auto_user_options = 'path, .clang_complete, ios'
  else
    let g:snowdrop#libclang_file = 'libclang.so'
    if filereadable("/usr/lib/llvm-3.2/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.2/lib/"
    elseif filereadable("/usr/lib/llvm-3.3/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.3/lib/"
    elseif filereadable("/usr/lib/llvm-3.4/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.4/lib/"
    endif
  endif

  " set include directory path.
  let g:snowdrop#include_paths.cpp = [
  \  "C:/cpp/boost",
  \  "C:/cpp/sprout",
  \ ]

  " set clang command options.
  let g:snowdrop#command_options.cpp = "-std=c++1y"
endif

" clang_complete {{{2
if s:bundle.tap('clang_complete')
  let g:neocomplcache_force_overwrite_completefunc = 1
  " let g:neocomplete#force_overwrite_completefunc = 1
  " clang_complete の自動呼び出し OFF
  let g:clang_complete_auto = 0
  let g:clang_auto_select = 0
  let g:clang_use_library=1
  " let g:clang_snippets=1
  " let g:clang_exec=''
  if s:is_win
  elseif s:is_mac
    function! s:get_latest_sdk()
      let paths = split(glob('/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/*.sdk'), "\n")
      return empty(paths) ? '' : paths[-1]
    endfunction
    let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
    let g:clang_complete_getopts_ios_sdk_directory = s:get_latest_sdk()
    " MyAutoCmd FileType objc let g:clang_auto_user_options = 'path, .clang_complete, ios'
  else
    if filereadable("/usr/lib/llvm-3.2/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.2/lib/"
    elseif filereadable("/usr/lib/llvm-3.3/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.3/lib/"
    elseif filereadable("/usr/lib/llvm-3.4/lib/libclang.so")
      let g:clang_library_path = "/usr/lib/llvm-3.4/lib/"
    endif
  endif
  function! s:bundle.tapped.hooks.on_post_source(bundle)
    doautocmd FileType
  endfunction
  call s:bundle.untap()
endif

" neosnippet {{{2
if s:bundle.is_installed('neosnippet.vim')
  let g:neosnippet#snippets_directory            = $HOME . '/.vim/snippets'
  let g:neosnippet#enable_snipmate_compatibility = 0
  " let g:neosnippet#disable_runtime_snippets._    = 1

  function! s:can_snip()
    return neosnippet#expandable_or_jumpable() && &filetype != "snippet"
  endfunction
  let s:pair_closes = [ "]", "}", ")", "'", '"', ">", "|" , ","]

  function! s:imap_tab()
    " len(matchstr(line[pos-1:pos+1], '[<>"'']')) <= 0
    if g:vimrc_enabled_plugins.neosnippet
      if neosnippet#expandable()
        if g:vimrc_enabled_plugins.neocomplete
          call neocomplete#smart_close_popup()
        endif
        return "\<Plug>(neosnippet_expand)"
      elseif neosnippet#jumpable()
        if g:vimrc_enabled_plugins.neocomplete
          call neocomplete#smart_close_popup()
        endif
        return "\<Plug>(neosnippet_jump)"
      " if s:can_snip()
      "   return "\<Plug>(neosnippet_jump_or_expand)"
      endif
    elseif pumvisible()
      return "\<C-n>"
    endif

    let line = getline(".")
    let pos = col(".") - 1

    let org_pos = pos
    if strlen(substitute(line[0:pos], '^\s*', '', '')) <= 0
      return "\<TAB>"
    endif
    while (line[pos] == " ")
      let pos = pos + 1
    endwhile
    let ch = line[pos]
    if index(s:pair_closes, ch) != -1
      while (line[pos+1] == " ")
        let pos = pos+1
      endwhile
      return repeat("\<Right>", pos - org_pos + 1)
    endif

    if s:bundle.is_sourced('emmet-vim')
      \ && len(matchstr(&filetype, 'x\?html\|s\?css\|php\|eruby')) > 0
      \ && emmet#isExpandable()
      \ && len(matchstr(getline('.'), '^\(\w*\%'.col('.').'c\)')) > 0
      if g:vimrc_enabled_plugins.neocomplete
        call neocomplete#smart_close_popup()
      endif
      " return "\<Plug>(EmmetExpandAbbr)"
      return "\<Plug>(emmet-expand-abbr)"
    endif

    return "\<TAB>"
  endfunction

  imap <expr><TAB> <SID>imap_tab()
  smap <expr><TAB> <SID>can_snip() ?
    \ "\<Plug>(neosnippet_jump_or_expand)" : "\<TAB>"

  imap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  smap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

  imap <C-l> <Plug>(neosnippet_jump_or_expand)
  smap <C-l> <Plug>(neosnippet_jump_or_expand)
endif

" youcompleteme {{{2
if s:bundle.is_installed('YouCompleteMe')

endif

" neocomplete, neocomplcache {{{2
if s:bundle.is_installed('neocomplete.vim') "{{{3
  " options {{{4
  let g:neocomplete#data_directory = $VIM_CACHE . '/neocomplete'
  let g:neocomplete#enable_at_startup                   = 1
  let g:neocomplete#cursor_hold_i_time                  = 500
  let g:neocomplete#max_list = 30  " 補完候補の数
  let g:neocomplete#enable_auto_select = 1   " 一番目の候補を自動選択

  let g:neocomplete#enable_smart_case                   = 1
  let g:neocomplete#enable_camel_case_completion        = 0 " camel case off
  let g:neocomplete#enable_underbar_completion          = 1
  " let g:neocomplete#enable_auto_delimiter               = 1
  let g:neocomplete#disable_caching_file_path_pattern   =
  \ "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
  let g:neocomplete#lock_buffer_name_pattern            =
  \ '\*ku\*\|\.log$\|\.jax$\|\.log\.'

  let g:neocomplete#min_syntax_length                   = 3
  " let g:neocomplete#plugin_completion_length     = {
  " let g:neocomplete#auto_completion_start_length        = 2
  " let g:neocomplete#manual_completion_start_length      = 1
  " let g:neocomplete#min_keyword_length                  = 3
  " let g:neocomplete#ignore_case                         = 0
  " \ 'snipMate_complete' : 1,
  " \ 'buffer_complete'   : 1,
  " \ 'include_complete'  : 2,
  " \ 'syntax_complete'   : 2,
  " \ 'filename_complete' : 2,
  " \ 'keyword_complete'  : 2,
  " \ 'omni_complete'     : 1,
  " \ }

  call my#config#initialize_global_dict('neocomplete#', [
  \ 'keyword_patterns',
  \ 'sources#dictionary#dictionaries',
  \ 'source_disable',
  \ 'sources#include#patterns', 'sources#vim#complete_functions',
  \ 'sources#omni#input_patterns',
  \ 'force_omni_input_patterns',
  \ 'delimiter_patterns',
  \ 'same_filetypes', 'sources#member#prefix_patterns',
  \ 'next_keyword_patterns',
  \ 'sources#include#exprs',
  \ 'sources#omni#functions',
  \ 'sources#include#paths',
  \ ])

  let g:neocomplete#keyword_patterns.default = '\h\w*' " 日本語をキャッシュしない

  call extend(g:neocomplete#source_disable, {
        \ 'syntax_complete' : 1,
        \ })

  function! s:neocomplete_dictionary_config() "{{{4
    for fp in split(globpath("~/.vim/dict", "*.dict"), "\n")
      let _name = fnamemodify(fp, ":p:t:r")
      let g:neocomplete#sources#dictionary#dictionaries[_name] = fp
    endfor

    call extend(g:neocomplete#sources#dictionary#dictionaries, {
      \ 'default'     : '',
      \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
      \ })
    for [key, val] in items({
        \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
        \ 'javascript'  : $HOME . '/.vim/dict/node.dict',
        \ 'eruby'       : $HOME . '/.vim/dict/ruby.dict',
        \ })
      if exists('g:neocomplete#sources#dictionary#dictionaries[key]')
        let g:neocomplete#sources#dictionary#dictionaries[key] .= ",".val
      else
        let g:neocomplete#sources#dictionary#dictionaries[key] = val
      endif

    endfor
    " \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',
  endfunction "}}}
  call s:neocomplete_dictionary_config()

  let g:use_zen_complete_tag=1

  call extend(g:neocomplete#sources#vim#complete_functions, {
  \ 'Ref'   : 'ref#complete',
  \ 'Unite' : 'unite#complete_source',
  \ 'VimShellExecute' :
  \   'vimshell#vimshell_execute_complete',
  \ 'VimShellInteractive' :
  \   'vimshell#vimshell_execute_complete',
  \ 'VimShellTerminal' :
  \   'vimshell#vimshell_execute_complete',
  \ 'VimShell' : 'vimshell#complete',
  \ 'VimFiler' : 'vimfiler#complete',
  \ 'Vinarise' : 'vinarise#complete',
  \ })

  " clang
  call extend(g:neocomplete#force_omni_input_patterns, {
  \ 'c':  '[^.[:digit:] *\t]\%(\.\|->\)',
  \ 'cpp': '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
  \ 'cs':  '[^.]\.\%(\u\{2,}\)\?',
  \ 'objc':  '[^.[:digit:] *\t]\%(\.\|->\)',
  \ 'objcpp':  '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
  \ 'python': '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*',
  \ })
  call extend(g:neocomplete#sources#omni#input_patterns, {
  \ 'perl':  '\h\w*->\h\w*\|\h\w*::',
  \ 'ruby':  '[^. *\t]\.\w*\|\h\w*::',
  \ 'eruby':  '[^. *\t]\.\w*\|\h\w*::',
  \ 'javascript':  '\h\w*\|[^. \t]\.\w*',
  \ 'coffee':  '\h\w*\|[^. \t]\.\w*',
  \ 'typescript': '\h\w*\|[^. \t]\.\%(\h\w*\)\?',
  \ 'haxe': '\v([\]''"]|\w)(\.|\()\w*',
  \ 'php': '[^. \t]->\h\w*\|\h\w*::',
  \ 'r': '[[:alnum:].\\]\+',
  \ 'xquery': '\k\|:\|\-\|&',
  \ 'go': '\h\w\.\w',
  \ })
  " \ 'php': '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?',
  " \ 'php': '\h\w*\|[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?',

  " scala
  let g:neocomplete#sources#include#patterns.scala = '^import'

  " javascript
  if s:bundle.is_installed('tern_for_vim')
    let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
    let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
    " MyAutoCmd FileType coffee call tern#Enable()
  elseif s:bundle.is_installed('vim-nodejs-complete')
    let g:neocomplete#sources#omni#functions.javascript = 'nodejscomplete#CompleteJS'
  endif
  " let g:neocomplete#sources#omni#functions.javascript = 'jscomplete#CompleteJS'

  " php
  " let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  let g:neocomplete#delimiter_patterns.php = ['->', '::', '\']
  let g:neocomplete#sources#member#prefix_patterns.php = '->\|::'
  call my#config#bulk_dict_variables([{
    \   'dict' : g:neocomplete#sources#omni#input_patterns,
    \   'names' : ['twig', 'smarty'],
    \   'value' : '<[^>]*'
    \ }, {
    \   'dict' : g:neocomplete#next_keyword_patterns,
    \   'names' : ['twig', 'smarty'],
    \   'value' : '[[:alnum:]_:-]*>\|[^"]*"'
    \ }])

  " Go
  if s:bundle.is_installed('vim-gocode')
    let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'
  endif

  " Clojure
  if s:bundle.is_installed('vim-clojure')
    let g:neocomplete#sources#omni#functions.clojure = 'vimclojure#OmniCompletion'
  endif

  " SQL
  let g:neocomplete#sources#omni#functions.sql = 'sqlcomplete#Complete'

  " R
  if s:bundle.is_installed('Vim-R-plugin')
    let g:neocomplete#sources#omni#functions.r = 'rcomplete#CompleteR'
  endif

  " XQuery
  if s:bundle.is_installed('XQuery-indentomnicomplete')
    let g:neocomplete#sources#omni#functions.xquery =
    \ 'xquerycomplete#CompleteXQuery'
  endif

  " autohotkey
  let g:neocomplete#sources#include#paths.autohotkey = '.,,'
  let g:neocomplete#sources#include#patterns.autohotkey = '^\s*#\s*include'
  let g:neocomplete#sources#include#exprs.autohotkey = ''
  " }}}

  " <CR>: close popup and save indent.
  " <C-h>, <BS>: close popup and delete backword char.
  if g:vimrc_enabled_plugins.lexima
    " default cr
    imap <silent><expr> <CR> pumvisible()?neocomplete#close_popup():"\<CR>"
  elseif g:vimrc_enabled_plugins.smartinput
    if g:vimrc_enabled_plugins.endwize
      imap <silent><expr> <CR> (pumvisible()?neocomplete#close_popup():"")
        \ ."\<Plug>(smartinput_CR)\<C-r>=endwize#crend()\<CR>"
    else
      imap <silent><expr> <CR> (pumvisible()?neocomplete#close_popup():"")
        \ ."\<Plug>(smartinput_CR)"
    endif

    imap <expr> <C-h>  pumvisible()?neocomplete#smart_close_popup()."\<C-h>":
    \ neocomplete#smart_close_popup()."\<Plug>(smartinput_BS)"
    imap <expr> <BS>   pumvisible()?neocomplete#smart_close_popup()."\<C-h>":
    \ neocomplete#smart_close_popup()."\<Plug>(smartinput_C-h)"
    imap <expr> <Space>   pumvisible()?neocomplete#smart_close_popup()."\<C-h>":
    \ neocomplete#smart_close_popup()."\<Plug>(smartinput_SPACE)"
  else
    inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><Space> neocomplete#smart_close_popup()."\<Space>"
  endif

  " inoremap <expr> <C-y>  neocomplete#close_popup()
  inoremap <expr> <C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"
  inoremap <expr> <C-j> pumvisible() ? neocomplete#close_popup() : "\<CR>"
  imap <C-s> <Plug>(neocomplete_start_unite_complete)

  nnoremap [!space]ne :NeocompleteEnable<CR>
  nnoremap [!space]nd :NeocompleteDisable<CR>

elseif s:bundle.is_installed('neocomplcache.vim') "{{{3
  source ~/.vim/neocomplcache.vim
endif

" completes {{{3
let g:nodejs_complete_config = {
  \ 'max_node_compl_len': 15,
  \ }
if s:bundle.is_installed('tern_for_vim')
  let g:nodejs_complete_config.js_compl_fn = 'tern#Complete'
elseif s:bundle.is_installed('jscomplete-vim')
  let g:nodejs_complete_config.js_compl_fn= 'jscomplete#CompleteJS'
endif
" let g:node_usejscomplete = 1
let g:jscomplete_use = ['dom', 'es6th', 'moz']

if exists("+omnifunc") " {{{4
  if s:bundle.is_installed('phpcomplete-extended')
    MyAutoCmd FileType php           setl omnifunc=phpcomplete_extended#CompletePHP
  elseif s:bundle.is_installed('phpcomplete.vim')
    MyAutoCmd FileType php           setl omnifunc=phpcomplete#CompletePHP
  endif
  MyAutoCmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
  if s:bundle.is_installed('jedi-vim')
    MyAutoCmd FileType python let b:did_ftplugin = 1
          \ | setlocal omnifunc=jedi#completions
  else
    MyAutoCmd FileType python        setl omnifunc=pythoncomplete#Complete
  endif
  " MyAutoCmd FileType javascript   setl omnifunc=javascriptcomplete#CompleteJS
  " MyAutoCmd FileType javascript    setl omnifunc=jscomplete#CompleteJS
  if s:bundle.is_installed('tern_for_vim')
    " mark
    MyAutoCmd FileType coffee    call tern#Enable()
  elseif s:bundle.is_installed('vim-nodejs-complete')
    MyAutoCmd FileType javascript,coffee    setl omnifunc=nodejscomplete#CompleteJS
  endif
  if s:bundle.is_installed('javacomplete')
    MyAutoCmd FileType java          setl omnifunc=javacomplete#Complete completefunc=javacomplete#CompleteParamsInfo
  endif
  MyAutoCmd FileType xml           setl omnifunc=xmlcomplete#CompleteTags
  MyAutoCmd FileType css           setl omnifunc=csscomplete#CompleteCSS
  MyAutoCmd FileType c             setl omnifunc=ccomplete#Complete
  MyAutoCmd FileType actionscript  setl omnifunc=actionscriptcomplete#CompleteAS
  if s:bundle.is_installed('poshcomplete-vim')
    MyAutoCmd FileType ps1 setl omnifunc=poshcomplete#CompleteCommand
  endif
  MyAutoCmd FileType *
        \ if &l:omnifunc == ''
        \ | setlocal omnifunc=syntaxcomplete#Complete
        \ | endif
endif

if s:bundle.is_installed('rsense')
  let $RSENSE_HOME = s:bundle.get('rsense').path
endif

" if exists('$RSENSE_HOME') " {{{4 RSENSE
"   let g:rsenseHome=$RSENSE_HOME
"   let g:rsenseUseOmniFunc=0
" elseif exists('+omnifunc')
"   "MyAutoCmd FileType ruby setl omnifunc=rubycomplete#Complete
" endif

" vimproc {{{2
if s:bundle.is_installed('vimproc.vim')
  function! s:setup_vimproc_dll() " {{{3
    let path = ""
    let vimproc_root = s:bundle.get('vimproc.vim').path
    if s:is_win
      if has('unix')
        let path = expand(vimproc_root . '/autoload/proc_cygwin.dll')
      elseif has('win64')
        let path = expand('$VIM/plugins/vimproc/autoload/vimproc_win64.dll')
      elseif has('win32')
        let path = expand('$VIM/plugins/vimproc/autoload/vimproc_win32.dll')
      endif
    elseif s:is_mac
      let path = expand(vimproc_root . '/autoload/proc_mac.so')
    else
      let path = expand(vimproc_root . '/autoload/proc_unix.so')
    endif
    if filereadable(path)
      let g:vimproc_dll_path = path
      let g:vimproc#dll_path = path
    endif
  endfunction " }}}

  call s:setup_vimproc_dll()
endif

" vimshell {{{2
if s:bundle.tap('vimshell.vim')
  let g:vimshell_temporary_directory = $VIM_CACHE . "/vimshell"
  let g:vimshell_enable_smart_case = 1
  let g:vimshell_enable_auto_slash = 1
  let g:vimshell_enable_transient_user_prompt = 1

  function! s:bundle.tapped.hooks.on_source(bundle) "{{{3
    " prompt
    let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
    if g:vimrc_enabled_plugins.fugitive
      let g:vimshell_right_prompt = 'fugitive#statusline()'
    endif

    if s:is_win
      " Display user name on Windows.
      let g:vimshell_prompt = $USERNAME."% "
      " let g:vimshell_use_terminal_command = 'ckw -e'
    else
      let g:vimshell_prompt = $USER."$ " " Display user name
      let g:vimshell_external_history_path = expand('~/.zsh-history')
    endif

    if s:is_win
    elseif s:is_mac
      let g:vimshell_use_terminal_command = 'open'
    else
      let g:vimshell_use_terminal_command = 'gnome-terminal -e'
    endif
  endfunction "}}}

  function! s:bundle.tapped.hooks.on_post_source(bundle) "{{{3
    let g:vimshell_execute_file_list = get(g:, 'vimshell_execute_file_list', {})

    let g:vimshell_execute_file_list['rb'] = 'ruby'
    let g:vimshell_execute_file_list['pl'] = 'perl'
    let g:vimshell_execute_file_list['py'] = 'python'
    call vimshell#set_execute_file('html,xhtml', 'gexe firefox')

    if !s:is_win
      let g:vimshell_execute_file_list['zip'] = 'zipinfo'
      call vimshell#set_execute_file('tgz,gz', 'gzcat')
      call vimshell#set_execute_file('tbz,bz2', 'bzcat')
      if s:is_mac
        " call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe open')
        " call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe open')
      else
        call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
        call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
      endif
    endif
  endfunction "}}}

  MyAutoCmd FileType vimshell call s:vimshell_init()
  let s:vimshell_hooks = {} "{{{3
  function! s:vimshell_hooks.chpwd(args, context)
    if len(split(glob('*'), '\n')) < 100
      call vimshell#execute('ls')
    else
      call vimshell#execute('echo "Many files."')
    endif
  endfunction
  function! s:vimshell_hooks.emptycmd(cmdline, context)
    " call vimshell#execute('ls')
    return 'ls'
  endfunction

  function! s:vimshell_hooks.preprompt(args, context)
    " call vimshell#execute('echo "preprompt"')
  endfunction

  function! s:vimshell_hooks.preexec(cmdline, context)
    " call vimshell#execute('echo "preexec"')

    let args = vimproc#parser#split_args(a:cmdline)
    if len(args) > 0 && args[0] ==# 'diff'
      call vimshell#set_syntax('diff')
    endif

    return a:cmdline
  endfunction
  " }}}

  function! s:vimshell_init() " {{{3
    setl textwidth=0

    call vimshell#altercmd#define('g'  , 'git')
    call vimshell#altercmd#define('i'  , 'iexe')
    call vimshell#altercmd#define('t'  , 'texe')

    call vimshell#set_alias('j', ':Unite -buffer-name=files
    \ -default-action=lcd -no-split -input=$$args directory_mru')
    call vimshell#set_alias('z', ':Unite -buffer-name=files
    \ -default-action=lcd -no-split -input=$$args z')

    if s:is_mac
      call vimshell#set_alias('gvim'  , 'gexe mvim')
      call vimshell#set_alias('mvim'  , 'gexe mvim')
    else
      call vimshell#set_alias('gvim'  , 'gexe gvim')
      call vimshell#set_alias('mvim'  , 'gexe gvim')
    endif

    call vimshell#hook#add('chpwd'     , 'my_chpwd', s:vimshell_hooks.chpwd)
    call vimshell#hook#add('emptycmd'  , 'my_emptycmd', s:vimshell_hooks.emptycmd)
    call vimshell#hook#add('preprompt' , 'my_preprompt', s:vimshell_hooks.preprompt)
    call vimshell#hook#add('preexec'   , 'my_preexec', s:vimshell_hooks.preexec)

    "autocmd FileType vimshell
    if g:vimrc_enabled_plugins.concealedyank
      nmap y <Plug>(operator-concealedyank)
      xmap y <Plug>(operator-concealedyank)
    endif

    nmap <buffer><nowait> q <Plug>(vimshell_exit)
    nmap <buffer> I G<Plug>(vimshell_append_enter)
    imap <silent> <buffer> <C-a> <C-o>:call cursor(line('.'), strlen(g:vimshell_prompt)+1)<CR>
    if g:vimrc_enabled_plugins.neocomplcache
      inoremap <expr><buffer> <C-j> pumvisible() ? neocomplcache#close_popup() : ""
    elseif g:vimrc_enabled_plugins.neocomplete
      inoremap <expr><buffer> <C-j> pumvisible() ? neocomplete#close_popup() : ""
    endif
  endfunction "}}}

  nmap [!space]vp :<C-u>VimShellPop<CR>
  nmap [!space]vv :<C-u>VimShellTab<CR>
  nmap [!space]ve :<C-u>VimShellExecute<Space>
  nmap [!space]vi :<C-u>VimShellInteractive<Space>
  nmap [!space]vt :<C-u>VimShellTerminal<Space>

  call s:bundle.untap()
endif

" vimfiler {{{2
if s:bundle.is_installed('vimfiler.vim')
  let g:vimfiler_data_directory = $VIM_CACHE . '/vimfiler'
  let g:vimfiler_as_default_explorer=1
  let g:vimfiler_safe_mode_by_default=0
  " let g:vimfiler_enable_auto_cd = 1
  " let g:vimfiler_edit_action = 'below'
  " let g:vimfiler_edit_action = 'tabopen'

  let g:vimfiler_file_icon = '-'
  let g:vimfiler_tree_leaf_icon = ' '
  if s:is_win
    let g:vimfiler_tree_opened_icon = '-'
    let g:vimfiler_tree_closed_icon = '+'
  else
    let g:vimfiler_tree_opened_icon = '▾'
    let g:vimfiler_tree_closed_icon = '▸'
  endif
  " let g:vimfiler_marked_file_icon = '*'
  let g:vimfiler_readonly_file_icon = 'x'
  let g:vimfiler_marked_file_icon = 'v'

  if s:is_win
		let g:vimfiler_quick_look_command = 'maComfort.exe -ql'
  elseif s:is_mac
		let g:vimfiler_quick_look_command = 'qlmanage -p'
  else
		let g:vimfiler_quick_look_command = 'gloobus-preview'
  endif

  " keymaps {{{3
  nnoremap <silent> [!space]f  :call <SID>vimfiler_tree_launch_or_enter()<CR>
  nnoremap <silent> [!space]fr :call <SID>vimfiler_tree_launch_or_enter()<CR>:wincmd p<CR>
  nnoremap <silent> [!space]ff :call <SID>vimfiler_tree_launch()<CR>
  nnoremap <silent> [!space]fg :call <SID>vimfiler_tree_launch(fnameescape(expand('%:p:h')))<CR>
  command! -nargs=? -complete=file VimFilerTree call s:vimfiler_tree_launch(<f-args>)
  command! -nargs=? -complete=file FTree call s:vimfiler_tree_launch(<f-args>)

  function! s:vimfiler_tree_launch_or_enter() "{{{4
    let fpath = expand('%:p')
    if !exists('b:vimfiler')
      wincmd t
      if !exists('b:vimfiler')
        wincmd p
        call s:vimfiler_tree_launch()
        return
      endif
      call s:vimfiler_tree_sync_currentfile(fpath)
    endif
  endfunction

  function! s:vimfiler_tree_sync_currentfile(fpath)
    if !exists('b:vimfiler.current_dir')
      return
    endif
    " lazy work --;;
    let dir = b:vimfiler.current_dir
    let fpath = a:fpath
    let pos = stridx(fpath, dir)
    if pos != -1
      let fpath = strpart(strpart(fpath, pos), strlen(dir))
      let paths = split(fpath, "/")
      let index = 0
      let max_index = len(paths) - 1
      if !b:vimfiler.is_visible_ignore_files &&
            \ len(filter(copy(paths), 'v:val =~# "^\\."')) > 0
        execute "normal \<Plug>(vimfiler_toggle_visible_ignore_files)"
      endif

      execute "normal \<Plug>(vimfiler_cursor_top)"
      while index <= max_index
        let item = paths[index]
        " call s:log("start : %s", item)
        let pattern = escape(" " . item . (max_index == index ? "" : "/"), '\.') . '\s\+$'
        if search(pattern, "W") == 0
          " call s:log("stop : %s, pattern=%s", item, pattern)
          break
        endif
        let file = vimfiler#get_file()
        if file.vimfiler__is_directory && !file.vimfiler__is_opened
          execute "normal \<Plug>(vimfiler_expand_tree)"
        endif
        let index = index + 1
      endwhile
    endif
  endfunction

  function! s:vimfiler_tree_launch(...) "{{{4
    let fpath = expand('%:p')
    let dir = a:0 > 0 ? a:1 : getcwd()
    execute 'VimFiler -toggle -split -direction=topleft -buffer-name=ftree -simple -winwidth=40 file:' . dir
    call s:vimfiler_tree_sync_currentfile(fpath)
  endfunction

  function! s:vimfiler_smart_tree_h(...) "{{{4
    let file = vimfiler#get_file()
    let cmd = a:0 > 0 ? a:1 : ""
    "\<Plug>(vimfiler_smart_h)"
    if !empty(file)
      if file.vimfiler__is_opened
        let cmd = "\<Plug>(vimfiler_expand_tree)"
      elseif file.vimfiler__nest_level > 0
        let nest_level = file.vimfiler__nest_level
        while 1
          exe 'normal!' 'k'
          let file = vimfiler#get_file()
          if empty(file) || file.vimfiler__nest_level < nest_level
            " let cmd = "\<Plug>(vimfiler_expand_tree)" | break
            normal! ^
            return
          endif
        endwhile
      endif
    endif
    if !empty(cmd)
      exe 'normal' cmd
      normal! ^
    endif
  endfunction

  function! s:vimfiler_tree_up() "{{{4
    call s:vimfiler_smart_tree_h("\<Plug>(vimfiler_smart_h)")
  endfunction

  function! s:vimfiler_tree_edit(method, ...) "{{{4
    " let file = vimfiler#get_file()
    " if empty(file) || empty(a:method) | return | endif
    " let path = file.action__path
    " wincmd p
    " execute a:method
    " exe 'edit' path
    if empty(a:method) | return | endif
    let linenr = line('.')
    let context = s:vimfiler_create_action_context(a:method, linenr)
    let cur_nr = bufnr('%')
    " silent wincmd l
    silent wincmd p
    if cur_nr == bufnr('%')
      silent wincmd l
      if cur_nr == bufnr('%')
        silent wincmd v
      endif
    endif
    for cmd in a:000
      silent execute cmd
    endfor
    " call vimfiler#mappings#do_action(a:method, linenr)
    call context.execute()
    unlet context
  endfunction

  function! s:vimfiler_smart_tree_l(method, ...) "{{{4
    let file = vimfiler#get_file()
    if empty(file)
      if (a:0 > 0 && a:1 == 1)
        execute 'normal' "\<Plug>(vimfiler_smart_h)"
      endif
      return
    endif
    let path = file.action__path
    if file.vimfiler__is_directory
      if (a:0 > 0 && a:1 == 2)
        execute 'normal' "\<Plug>(vimfiler_smart_l)"
      else
        execute 'normal' "\<Plug>(vimfiler_expand_tree)"
      endif
      normal! ^
      return
    endif
    call s:vimfiler_tree_edit(a:method)
  endfunction "}}}

  function! s:vimfiler_tabopen_silently() " {{{4
    let curt = tabpagenr()
    silent call s:vimfiler_do_action('tabopen')
    execute curt."tabnext"
  endfunction "}}}

  function! s:vimfiler_do_action(action) " {{{4
    let bnr = bufnr('%')
    let linenr = line('.')
    let context = s:vimfiler_create_action_context(a:action, linenr)
    call context.execute()
    unlet context
  endfunction

  let s:vimfiler_context = {} " {{{4
  function! s:vimfiler_context.new(...)
    let dict = get(a:000, 0, {})
    return extend(dict, self)
  endfunction

  function! s:vimfiler_context.execute()
    call unite#mappings#do_action(self.action, self.files, {
          \ 'vimfiler__current_directory' : self.current_dir,
          \ })
  endfunction

  function! s:vimfiler_create_action_context(action, ...) " {{{4
    let cursor_linenr = get(a:000, 0, line('.'))
    let vimfiler = vimfiler#get_current_vimfiler()
    let marked_files = vimfiler#get_marked_files()
    if empty(marked_files)
      let marked_files = [ vimfiler#get_file(cursor_linenr) ]
    endif

    let context = s:vimfiler_context.new({
          \ 'action' : a:action,
          \ 'files' : marked_files,
          \ 'current_dir' : vimfiler.current_dir,
          \ })
    return context
  endfunction

  MyAutoCmd FileType vimfiler call s:vimfiler_init() "{{{3
  function! s:vimfiler_init() " {{{3
    nmap <silent><buffer> p <Plug>(vimfiler_quick_look)
    nnoremap <silent><buffer> E :<C-u>call <SID>vimfiler_do_action('tabopen')<CR>
    nnoremap <silent><buffer> T :<C-u>call <SID>vimfiler_tabopen_silently()<CR>
    nnoremap <silent><buffer> <C-e> :<C-u>call <SID>vimfiler_do_action('split')<CR>
    nmap <buffer> u <Plug>(vimfiler_move_to_history_directory)
    hi link ExrenameModified Statement
    "nnoremap <buffer> v V
    if exists('b:vimfiler') && !exists('b:my_vimfiler_init')
      let b:my_vimfiler_init=1
      if exists('b:vimfiler.context') && b:vimfiler.context.profile_name == 'ftree' "{{{4
        nnoremap <silent><buffer> e :call <SID>vimfiler_tree_edit('open')<CR>
        nnoremap <silent><buffer> E :call <SID>vimfiler_tree_edit('open', 'wincmd s')<CR>
        nnoremap <silent><buffer> <C-e> :call <SID>vimfiler_do_action('tabopen')<CR>
        nnoremap <silent><buffer> l :call <SID>vimfiler_smart_tree_l('')<CR>
        if exists('g:scrolloff')
          nnoremap <silent><buffer> <LeftMouse>       <Esc>:set eventignore=all<CR><LeftMouse>
            \:<C-u>:call <SID>vimfiler_smart_tree_l('', 1)<CR>:set eventignore=<CR>
          nnoremap <silent><buffer> <2-LeftMouse>     <Esc>:set eventignore=<CR><LeftMouse>
            \ :<C-u>:call <SID>vimfiler_smart_tree_l('open', 2)<CR>
        else
          nnoremap <silent><buffer> <LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>
            \ :call <SID>vimfiler_smart_tree_l('', 1)<CR>
          nnoremap <silent><buffer> <2-LeftMouse> :call <SID>noscrolloff_leftmouse()<CR>
            \ :call <SID>vimfiler_smart_tree_l('open', 2)<CR>
        endif
        " nmap <buffer> l <Plug>(vimfiler_expand_tree)
        nmap <buffer> L <Plug>(vimfiler_smart_l)
        nnoremap <silent><buffer> h :call <SID>vimfiler_smart_tree_h()<CR>
        nnoremap <silent><buffer> gu :call <SID>vimfiler_tree_up()<CR>
      endif
    endif
  endfunction
endif

" vinarise {{{2
" let g:vinarise_enable_auto_detect = 1

" etc functions & commands {{{1
" tiny snippets {{{2
let g:my_snippets_dir = $HOME . "/memos/tiny-snippets"

" mapping for tiny-snippets
nnoremap [!unite]n <Nop>
nnoremap <silent> [!unite]nn :<C-u>execute printf('Unite file_rec:%s -start-insert', expand(g:my_snippets_dir))<CR>
nnoremap <silent> [!unite]ng :<C-u>call <SID>unite_grep(g:my_snippets_dir, '-no-quit')<CR>
nnoremap <silent> [!unite]nm :<C-u>execute 'Unite memolist_rec:'.expand(g:my_snippets_dir)<CR>
nnoremap <silent> [!unite]nv :<C-u>execute 'VimFiler' g:my_snippets_dir<CR>

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
  command! Here silent execute '!explorer' substitute(expand('%:p:h'), '/', '\', 'g')
  command! This silent execute '!start cmd /c "%"'
  command! In silent execute '!start cmd /k cd "'.substitute(expand('%:p:h'), '/', '\', 'g').'"'
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
LCAlias Here This That

" unique {{{2
command! -range -nargs=0 UniqueSort <line1>,<line2>sort u

" diff {{{2
function! s:exe_if_diff(s)
  if &diff
    execute a:s
  endif
endfunction
command! -nargs=0 DiffQuit call <SID>exe_if_diff('diffoff')
command! -nargs=0 DQ call <SID>exe_if_diff('diffoff')

" rename {{{2
command! -nargs=? -complete=file Rename call my#command#rename(<q-args>)
command! -nargs=1 -complete=file Relcp call my#command#relative_copy(<f-args>)
Alias ren Rename

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
command! -nargs=0 VerboseOn call s:set_verbose("1")

" for vim {{{2
command! -nargs=0 ThisSyntaxName echo synIDattr(synID(line("."), col("."), 1), "name")
command! -nargs=0 ThisSyntax echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
  \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
  \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"

" coding style {{{2
" http://vim-users.jp/2010/05/hack149/
let s:coding_styles = {}
let s:coding_styles['Standard']      = 'expandtab   tabstop=4 shiftwidth=4 softtabstop&'
let s:coding_styles['Short indent']  = 'expandtab   tabstop=2 shiftwidth=2 softtabstop&'
let s:coding_styles['GNU']           = 'expandtab   tabstop=8 shiftwidth=2 softtabstop=2'
let s:coding_styles['BSD']           = 'noexpandtab tabstop=8 shiftwidth=4 softtabstop&'    " XXX
let s:coding_styles['Linux']         = 'noexpandtab tabstop=8 shiftwidth=8 softtabstop&'

command!
\   -bar -nargs=1 -complete=customlist,s:coding_style_complete
\   CodingStyle
\   call s:set_coding_style("<bang>", get(s:coding_styles, <f-args>, ''))

function! s:set_coding_style(bang, arg) "{{{
  let expr = a:bang ? "set" : "setlocal"
  execute expr a:arg
endfunction " }}}
function! s:coding_style_complete(A, L, P) "{{{
  " return keys(s:coding_styles)
  return filter(keys(s:coding_styles),'v:val =~? "^".a:A')
endfunction "}}}

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
  call neobundle#call_hook('on_source')
endif
" __END__ {{{1
" vim: set ft=vim fdm=marker sw=2 ts=2 et:
