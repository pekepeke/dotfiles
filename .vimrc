" init setup "{{{1

" platform detection {{{2
let s:is_mac = has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

" reset settings & restore runtimepath {{{2
let s:configured_runtimepath = &runtimepath
set all&

if exists('g:loaded_dot_vimrc')
  if has('gui') | execute 'source' expand("~/.gvimrc") | endif
  let &runtimepath=s:configured_runtimepath
elseif s:is_win
  set runtimepath^=$HOME/.vim
  set runtimepath+=$HOME/.vim/after
endif
unlet s:configured_runtimepath

" for win {{{2
if s:is_win
  let $HOME=substitute($HOME, '\\', '/', 'ge')
  if executable('nyacus')
    function! Nyacus()
      " Use NYACUS.
      set shell=nyacus.exe
      set shellcmdflag=-e
      if executable('tee') | set shellpipe=\|&\ tee | endif
      set shellredir=>%s\ 2>&1
      set shellxquote=\"
    endfunction
    function! Cmd()
      set shell=$COMSPEC
      set shellcmdflag=/c
      set shellpipe=>%s\ 2>&1
      set shellxquote=\"
    endfunction
    call Nyacus()
  endif
endif

" etc settings {{{2
set nocompatible

if filereadable(expand('~/.vimrc.personal'))
  execute 'source' expand('~/.vimrc.personal')
endif
if isdirectory(expand('~/.vim/bin/'))
  let $PATH.=(s:is_win ? ';' : ':').expand('~/.vim/bin/')
endif
" }}}
" defun macros
augroup MyAuGroup
  autocmd!
augroup END
command! -bang -nargs=* MyAutocmd autocmd<bang> MyAuGroup <args>
command! -nargs=* Lazy autocmd MyAuGroup VimEnter * <args>

" preexec for runtimepath {{{1
filetype off

" vundle {{{1
set rtp+=~/.vim/neobundle.vim
let g:my_bundle_dir = expand("$HOME/.vim/neobundle")
call neobundle#rc(g:my_bundle_dir)

NeoBundle 'Shougo/neocomplcache.git'
NeoBundle 'Shougo/vimfiler.git'
NeoBundle 'Shougo/vimproc.git'
NeoBundle 'Shougo/vimshell.git'
NeoBundle 'kana/vim-altr.git'
NeoBundle 'kana/vim-fakeclip.git'
NeoBundle 'kana/vim-scratch.git'
NeoBundle 'kana/vim-smartchr.git'
NeoBundle 'kana/vim-submode.git'
NeoBundle 'tyru/vim-altercmd.git'
NeoBundle 'vim-scripts/ShowMarks7.git'
NeoBundle 'tpope/vim-repeat.git'
NeoBundle 'tpope/vim-surround.git'
NeoBundle 't9md/vim-surround_custom_mapping.git'
NeoBundle 't9md/vim-textmanip.git'
NeoBundle 'ujihisa/camelcasemotion.git'
NeoBundle 'h1mesuke/vim-alignta.git'
" NeoBundle 'vim-scripts/YankRing.vim.git'
" NeoBundle 'chrismetcalf/vim-yankring.git'
NeoBundle 'the-isz/MinYankRing.vim.git'
NeoBundle 'sjl/gundo.vim.git'
NeoBundle 'kana/vim-smartword.git'
NeoBundle 'vim-scripts/matchit.zip.git'
NeoBundle 'vim-scripts/ruby-matchit.git'

NeoBundle 'tyru/open-browser.vim.git'
NeoBundle 'mattn/googletranslate-vim.git'
NeoBundle 'ujihisa/shadow.vim.git'
NeoBundle 'thinca/vim-quickrun.git'
NeoBundle 'thinca/vim-ambicmd.git'
NeoBundle 'thinca/vim-logcat.git'
NeoBundle 'tyru/current-func-info.vim.git'
NeoBundle 'vim-scripts/errormarker.vim.git'
NeoBundle 'thinca/vim-template.git'
" NeoBundle 'mexpolk/vim-taglist.git'
NeoBundle 'vim-scripts/taglist.vim.git'
NeoBundle 'mattn/zencoding-vim.git'
NeoBundle 'mattn/gist-vim.git'
NeoBundle 'tomtom/tcomment_vim.git'
" NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'scrooloose/nerdtree.git'
NeoBundle 'thinca/vim-qfreplace.git'
NeoBundle 'mileszs/ack.vim.git'
"NeoBundle 'motemen/git-vim.git'
NeoBundle 'tpope/vim-fugitive.git'
if has('python')
  NeoBundle 'tsukkee/lingr-vim.git'
endif

NeoBundle 'motemen/hatena-vim.git'
NeoBundle 'lukaszb/vim-web-indent.git'
NeoBundle 'othree/html5.vim.git'
NeoBundle 'hail2u/vim-css3-syntax.git'
NeoBundle 'cakebaker/scss-syntax.vim.git'
NeoBundle 'kchmck/vim-coffee-script.git'
NeoBundle 'pangloss/vim-javascript.git'
NeoBundle 'pekepeke/titanium-vim.git'
NeoBundle 'tpope/vim-haml.git'
NeoBundle 'ciaranm/detectindent.git'
NeoBundle 'thinca/vim-ft-diff_fold.git'
NeoBundle 'thinca/vim-ft-markdown_fold.git'
NeoBundle 'timcharper/textile.vim.git'
NeoBundle 'pekepeke/cocoa.vim.git'

NeoBundle 'tpope/vim-rails.git'
NeoBundle 'vim-scripts/eruby.vim.git'
"NeoBundle 'astashov/vim-ruby-debugger.git'

NeoBundle 'vim-scripts/dbext.vim.git'
NeoBundle 'vim-scripts/SQLUtilities.git'
NeoBundle 'justinrainbow/php-doc.vim.git'
"NeoBundle 'OmniCppComplete'

NeoBundle 'thinca/vim-ref.git'
NeoBundle 'pekepeke/ref-javadoc.git'
NeoBundle 'soh335/vim-ref-jquery.git'

NeoBundle 'kana/vim-operator-replace.git'
NeoBundle 'kana/vim-operator-user.git'
NeoBundle 'tyru/operator-camelize.vim.git'
NeoBundle 'tyru/operator-html-escape.vim.git'

NeoBundle 'kana/vim-textobj-datetime.git'
NeoBundle 'kana/vim-textobj-diff.git'
NeoBundle 'kana/vim-textobj-entire.git'
NeoBundle 'kana/vim-textobj-fold.git'
NeoBundle 'kana/vim-textobj-function.git'
NeoBundle 'kana/vim-textobj-jabraces.git'
NeoBundle 'kana/vim-textobj-lastpat.git'
NeoBundle 'kana/vim-textobj-syntax.git'
NeoBundle 'kana/vim-textobj-user.git'
NeoBundle 'thinca/vim-textobj-between.git'
NeoBundle 'thinca/vim-textobj-comment.git'
NeoBundle 'thinca/vim-textobj-function-javascript.git'
NeoBundle 'thinca/vim-textobj-function-perl.git'
NeoBundle 'vim-scripts/textobj-indent.git'

NeoBundle 'Shougo/unite.vim.git'
" NeoBundle 'Sixeight/unite-grep.git'
" NeoBundle 'Shougo/unite-grep.git'
NeoBundle 't9md/vim-unite-ack.git'
NeoBundle 'h1mesuke/unite-outline.git'
NeoBundle 'hakobe/unite-script.git'
NeoBundle 'mattn/unite-remotefile.git'
NeoBundle 'pekepeke/unite-fileline.git'
NeoBundle 'sgur/unite-git_grep.git'
NeoBundle 'sgur/unite-qf.git'
" NeoBundle 'soh335/unite-qflist.git'
NeoBundle 'tacroe/unite-alias.git'
NeoBundle 'tacroe/unite-mark.git'
NeoBundle 'thinca/vim-unite-history.git'
NeoBundle 'tsukkee/unite-tag.git'
NeoBundle 'ujihisa/unite-colorscheme.git'
NeoBundle 'ujihisa/unite-font.git'
NeoBundle 'ujihisa/unite-gem.git'
NeoBundle 'ujihisa/unite-help.git'
NeoBundle 'ujihisa/unite-rake.git'
NeoBundle 'basyura/unite-rails.git'
NeoBundle 'basyura/unite-yarm.git'

if s:is_win
  NeoBundle 'sgur/unite-everything.git'
else
  if s:is_mac
    NeoBundle 'choplin/unite-spotlight.git'
  else
    NeoBundle 'ujihisa/unite-locate.git'
  endif
  NeoBundle 'ujihisa/neco-look.git'
endif

" pathogen {{{1
let g:pathogen_disabled = []
if !s:is_mac | let g:pathogen_disabled += ['cocoa.vim'] | endif
call pathogen#runtime_append_all_bundles()

command! PathogenHelptags call pathogen#helptags()

" afterexec for runtimepath {{{1
syntax enable
filetype plugin indent on

" vimproc
if executable('sh') && executable('make')
  command! -nargs=0 VimprocCompile call my#util#compile_vimproc(g:my_bundle_dir . '/vimproc')
endif

" color settings "{{{1
"set t_Co=256
if &t_Co == 256 || s:is_win || has('gui')
  " must be write .gvimrc
  colorscheme vividchalk
  "colorscheme mrkn256
  "colorscheme lucius
else
  " colorscheme wombat
  colorscheme desert
endif
MyAutocmd BufEnter *.ehtml,*.erb :hi link erubyRubyDelim Label "Delimiter

"" カーソル行 {{{2
MyAutocmd WinLeave * set nocursorline
MyAutocmd WinEnter,BufRead * set cursorline
hi clear CursorLine
"hi CursorLine gui=underline term=underline cterm=underline
hi CursorLine ctermbg=black guibg=black

" for Filetypes {{{1
" shebang {{{2
if !s:is_win
  MyAutocmd BufWritePost *
        \ if getline(1) =~ "^#!"
        \ | exe "silent !chmod +x %"
        \ | endif
  MyAutocmd BufEnter *
        \ if bufname("") !~ "^\[A-Za-z0-9\]*://"
        \ | silent! exe '!echo -n "k%\\"'
        \ | endif
endif

" etc hacks {{{2
if s:is_mac
  " for objc " override matlab
  MyAutocmd BufNewFile,BufRead *.m setfiletype objc
endif

" http://vim-users.jp/2009/10/hack84/
MyAutocmd BufWritePost * if expand('%') != '' && &buftype !~ 'nofile' | mkview | endif
MyAutocmd BufRead * if expand('%') != '' && &buftype !~ 'nofile' | silent loadview | endif
set viewoptions=cursor

" http://vim-users.jp/2009/12/hack112/
MyAutocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
function! s:vimrc_local(loc)
  let files = findfile('vimrc_local.vim', escape(a:loc, ' '). ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction
if has('vim_starting')
  call s:vimrc_local(getcwd())
endif

" setfiletype {{{2
" html
MyAutocmd BufNewFile,BufRead *.hta setfiletype hta
" js alias
MyAutocmd FileType js setlocal ft=javascript
" Ruby, Yaml
MyAutocmd BufNewFile,BufRead *.ru setfiletype ruby
" CakePHP
MyAutocmd BufNewFile,BufRead *.ctp,*.thtml setfiletype php
" MySQL
MyAutocmd BufNewFile,BufRead *.sql set filetype=mysql
" Textile
MyAutocmd BufRead,BufNewFile *.textile setfiletype textile
" IO
MyAutocmd BufNewFile,BufRead *.io set filetype=io
" MSBuild
MyAutocmd BufNewFile,BufRead *.proj,*.xaml setfiletype xml
MyAutocmd BufNewFile,BufRead *.proj,*.cs,*.xaml compiler msbuild
" command
MyAutocmd BufNewFile,BufRead *.command setfiletype sh

MyAutocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
      \ | exe "normal g`\""
      \ | endif

" indent {{{2
MyAutocmd FileType coffee,ruby,scheme,sh,zsh,vim,yaml,xml
      \ setl tabstop=2 shiftwidth=2 textwidth=0 expandtab
MyAutocmd FileType html
      \ setl noexpandtab wrap tabstop=2 shiftwidth=2 textwidth=0
" haskell
MyAutocmd FileType lisp,perl
      \ setl expandtab
MyAutocmd FileType objc,php,markdown
      \ setl noexpandtab
MyAutocmd FileType help
      \ setl noexpandtab tabstop=8 shiftwidth=8
MyAutocmd FileType python
      \ setl textwidth=80 tabstop=8 softtabstop=4 shiftwidth=4 expandtab smarttab

function! s:cmdwin_my_settings() "{{{3
  noremap <buffer> q :q<CR>
  noremap <buffer> <Esc> :q<CR>
  inoremap <buffer><expr> kk col('.') == 1 ? '<Esc>k' : 'kk'
  inoremap <buffer><expr> <BS> col('.') == 1 ? '<Esc>:quit<CR>' : '<BS>'
  startinsert!
endfunction " }}}
MyAutocmd CmdwinEnter * call s:cmdwin_my_settings()

" vim -b : edit binary using xxd-format! "{{{3
augroup Binary
    au!
    au BufReadPre  *.bin let &bin=1
    au BufReadPost *.bin if &bin | silent %!xxd -g 1
    au BufReadPost *.bin set ft=xxd | endif
    au BufWritePre *.bin if &bin | %!xxd -r
    au BufWritePre *.bin endif
    au BufWritePost *.bin if &bin | silent %!xxd -g 1
    au BufWritePost *.bin set nomod | endif
augroup END

" basic settings {{{1

" 文字コード周り {{{2
set fileencodings=utf-8,euc-jp,iso-2022-jp,cp932
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix

set clipboard=unnamed
" set mouse=a
set mouse=nv

set shellslash
set directory=~/.tmp,/var/tmp,/tmp

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

" MyAutocmd BufEnter * if isdirectory(expand('%:p:h')) | execute ":lcd " . expand("%:p:h") | endif
" MyAutocmd BufEnter * call LcdCurrentOrProjDir()
MyAutocmd BufRead,BufNewFile * call LcdCurrentOrProjDir()
if !exists('g:my_lcd_autochdir')
  let g:my_lcd_autochdir = 1
endif

function! LcdCurrentOrProjDir() "{{{3
  if exists('b:vimfiler')
  elseif g:my_lcd_autochdir && !exists('b:my_lcd_current_or_prj_dir')
    let b:my_lcd_current_or_prj_dir = my#util#find_proj_dir()
    if b:my_lcd_current_or_prj_dir != ''
      execute 'lcd' fnameescape(b:my_lcd_current_or_prj_dir)
    endif
  endif
endfunction

" diff {{{2
set diffopt-=filler diffopt+=iwhite

" 表示周り {{{2
set lazyredraw
set ttyfast
set scrolloff=10000000         " 中央に表示
set sidescrolloff=999
set number                     " 行番号の表示
set ruler

set mouse=nch                  " use mouse normal/command/help

set showmatch                  " 対応する括弧の表示
set showcmd                    " 入力中のコマンドを表示
set backspace=indent,eol,start " BSでなんでも削除
set nolinebreak
set textwidth=1000
set formatoptions+=m
set whichwrap=b,s,h,l,<,>,[,]  " 行頭・行末間移動を可能に
if exists('&colorcolumn') | set colorcolumn=+1 | endif
set splitbelow                 " 横分割は下に
set splitright                 " 縦分割は右に

set hidden                     " 編集中でも他のファイルを開けるように
set sidescroll=5
set viminfo+=!
set visualbell
set noerrorbells

set langmenu=none
set helplang=ja,en
set foldmethod=marker
" http://d.hatena.ne.jp/thinca/20110523/1306080318
augroup foldmethod-expr
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
set autoindent smartindent cindent  " インデント設定
set list
set listchars=tab:^\ ,trail:~,nbsp:%,extends:>,precedes:<
set smarttab             " インテリジェンスなタブ入力
set expandtab
"set softtabstop=4 tabstop=4 shiftwidth=4
set softtabstop=0 tabstop=4 shiftwidth=4

" 全角スペースを強調 {{{3
highlight ZenkakuSpace ctermbg=6
match ZenkakuSpace /\s\+$\|　/
if exists('&ambiwidth')
  set ambiwidth=double
endif " }}}

"set wm=2
set nowrap     " 折り返しなし
set nrformats=hex

" sticky shift {{{2
" http://vim-users.jp/2009/08/hack-54/
" nnoremap <expr> ;; <SID>sticky_func()
" nnoremap <expr> ;; <SID>sticky_func()
" cnoremap <expr> ;  <SID>sticky_func()
" snoremap <expr> ;  <SID>sticky_func()
let g:sticky_shift_enable = 1
command! -nargs=0 StickyShift let g:sticky_shift_enable=1
command! -nargs=0 NoStickyShift let g:sticky_shift_enable=0

inoremap <expr> ;  g:sticky_shift_enable ? <SID>sticky_func() : ";"

function! s:sticky_func() "{{{3
  " let l:sticky_table = {
  " \',' : '<', '.' : '>', '/' : '?',
  " \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
  " \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')', '-' : '_', '=' : '+',
  " \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
  " \}
  let l:sticky_table = {
        \',' : '<', '.' : '>', '/' : '?', '\' : '_',
        \'1' : '!', '2' : '"', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '&', '7' : "'", '8' : '(', '9' : ')', '0' : '|', '-' : '=', '^' : '~', '¥' : '|',
        \'@' : '`', '[' : '{', ';' : '+', ':' : '*', ']' : '}'
        \}
  let l:special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

  let l:key = getchar()
  if nr2char(l:key) =~ '\l'
    return toupper(nr2char(l:key))
  elseif has_key(l:sticky_table, nr2char(l:key))
    return l:sticky_table[nr2char(l:key)]
  elseif has_key(l:special_table, nr2char(l:key))
    return l:special_table[nr2char(l:key)]
  else
    return ''
  endif
endfunction

" statusline {{{2
set laststatus=2  " ステータス表示用変数
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P
let &statusline="%<%f %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'
      \ .'['.cfi#format('%s()','no func').']'
      \ }%=%l,%c%V%8P"

set modeline
set modelines=10

" 検索周り {{{2
set ignorecase smartcase       " 賢い検索
set incsearch                  " インクメンタル
set wrapscan                   " 検索で最初にもどる
set hlsearch                   " 検索で色

set virtualedit=block

" バックアップ {{{2
set nobackup               " バックアップとか自分で
"set backup
set noswapfile
set nowritebackup
set autoread                   " 更新があったファイルを自動で読み直し
set backupdir=$HOME/.tmp/vim-backups
set viewdir=$HOME/.tmp/vim-views
set backupcopy=yes
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
call my#util#mkdir(&backupdir)
call my#util#mkdir(&viewdir)

" 補完 {{{2
set wildmenu                                 " 補完候補を表示する
set wildmode=list:longest,list:full          " zsh like complete
set wildchar=<tab>
set wildignore+=*.o,*.obj,.git,*.rbc,.class,.svn
" set completeopt=menu,preview,longest,menuone
" set complete=.,w,b,u,t,i,k                   " 補完候補の設定
set completeopt=menuone,preview
set complete=.,w,b,u,t,i,k

" for migemo {{{2
if has('kaoriya') && has('migemo')
  set migemo
  if filereadable('/usr/local/share/migemo/utf-8/migemo-dict')
    set migemodict=/usr/local/share/migemo/utf-8/migemo-dict
  endif
elseif executable('cmigemo')
  nnoremap <silent> g/ :Mi<CR>
endif

" mappings {{{1
" define common key-prefixes {{{2
noremap [space] <Nop>
nnoremap g<Space> <Space>
vnoremap g<Space> <Space>
nmap <Space> [space]
vmap <Space> [space]

noremap [t] <Nop>
nmap t [t]
nnoremap <silent> [t]e t

noremap [s] <Nop>
nmap s [s]

nnoremap [prefix] <Nop>
vnoremap [prefix] <Nop>
nmap , [prefix]
vmap , [prefix]

noremap [edit] <Nop>
nmap <C-e> [edit]
vmap <C-e> [edit]

noremap [comment-doc] <Nop>
map     [prefix]c     [comment-doc]

nnoremap q <Nop>
nnoremap Q q

" 行単位で移動 {{{2
nnoremap j gj
nnoremap k gk
" nmap gb :ls<CR>:buf

" disable danger keymaps {{{2
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
if $TERM =~ 'screen'
  map <C-z> <Nop>
endif

" useful keybinds {{{2
nnoremap gs :<C-u>setf<Space>
nnoremap <C-h> :<C-u>help<Space>
nmap Y y$

" http://vim-users.jp/2009/10/hack91/
cnoremap <expr> /  getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ?  getcmdtype() == '?' ? '\?' : '?'

" indent whole buffer
nnoremap [space]= call my#ui#indent_whole_buffer()

" insert timestamp
nmap <silent> [t]w :exe "normal! i" . strftime("%Y-%m-%d\T%H:%M:%S+09:00")<CR>

" redraw map
nmap <silent> [s]r :redraw!<CR>

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

nnoremap [edit]h :<C-u>nohlsearch<CR>
nnoremap [edit]w :<C-u>execute 'setl '.(&wrap?'no':'').'wrap \| echo "wrap=".&wrap'<CR>

" replace & grep {{{2
nnoremap [space]r :<C-u>%S/
vnoremap [space]r :S/

" grep
if executable('ack')
  set grepprg=ack\ -a
  set grepformat=%f:%l:%m

  command! -nargs=? -complete=dir Todos Ack "TODO\|FIXME\|XXX" <args>
else
  set grepprg=grep\ -n\ $*\ /dev/null
  "set grepprg=grep\ -n\ $*\ /dev/null\ --exclude\ \"\*\.svn\*\"
  let Grep_Skip_Dirs = 'RCS CVS SCCS .svn .git .hg BIN bin LIB lib Debug debug Release release'
  let Grep_Skip_Files = '*~ *.bak *.v *.o *.d *.deps tags TAGS *.rej *.orig'
  let Grep_Default_Filelist = '*' "join(split('* '.Grep_Skip_Files, ' '), ' --exclude=')
  command! -nargs=? -complete=dir Todos silent grep -R "TODO\|FIXME\|XXX" <args>
endif
command! TodosBuffer silent exe 'GrepBuffer TODO' | silent exe 'GrepBufferAdd FIXME' | silent exe 'GrepBufferAdd XXX'

let Grep_Default_Options = '-i'
let Grep_OpenQuickfixWindow = 1

let MyGrep_ExcludeReg = '[~#]$\|\.bak$\|\.o$\|\.obj$\|\.exe$\|\.dll$\|\.pdf$\|\.doc$\|\.xls$\|[/\\]tags$\|^tags$'
let MyGrepcmd_useropt = '--exclude="*\.\(svn\|git\|hg)*"'

" mygrep.vim…
"nmap [space]gg :EGrep<CR>
"nmap [space]gr :RGrep<CR>
" nnoremap [space]gg :Grep<CR>
" nnoremap [space]gr :REGrep<CR>
nnoremap [space]g  :Ack<Space>-i<Space>''<Left>
nnoremap [space]gg :Ack<Space>-i<Space>''<Left>
nnoremap [space]gr :Ack<Space>-i<Space>''<Left>
nnoremap [space]gb :GrepBuffer<Space>

function! s:my_qf_backup()
  let name = exists('w:quickfix_title') ? w:quickfix_title : 'quickfix_save'
  let lines = getline(1, "$")
  if empty(lines) || (len(lines) == 1 && empty(lines[0]))
    echohl ErrorMsg
    echo "Text is nothing"
    echohl Normal
    return
  endif
  enew | setl buftype=nofile noswapfile | setf qf
  file `=name`
  nmap <buffer> <CR> <C-w>F
  call append(0, lines)
endfunction

function! s:my_quickfix_settings()
  nnoremap <buffer> ss :<C-u>call <SID>my_qf_backup()<CR>
endfunction

MyAutocmd FileType qf call s:my_quickfix_settings()
" MyAutocmd QuickfixCmdPost make,grep,grepadd,vimgrep copen
" MyAutocmd QuickfixCmdPost l* lopen

" tab {{{2
nnoremap <silent> [t]c :<C-u>tabnew<CR>:tabmove<CR>
nnoremap <silent> [t]q :<C-u>tabclose<CR>
nnoremap <silent> [t]n :<C-u>tabnext<CR>
nnoremap <silent> [t]p :<C-u>tabprevious<CR>
nnoremap <silent> [t]o :<C-u>tabonly<CR>

" tags-and-searches {{{2
nnoremap [t]r t
nnoremap <silent> [t]t <C-]>
nnoremap <silent> [t]j :<C-u>tag<CR>
nnoremap <silent> [t]k :<C-u>pop<CR>
nnoremap <silent> [t]l :<C-u>tags<CR>

" etc {{{2
nnoremap [edit]. :source ~/.vimrc<CR>

nnoremap [edit]<C-a> ggvG$
nnoremap [edit]a ggvG$
nnoremap [edit]v "+P
vnoremap [edit]c "+y

"nnoremap [edit]<C-o> :copen<CR><C-w><C-w>
nnoremap [edit]<C-o> :<C-u>call <SID>toggle_quickfix_window()<CR>
function! s:toggle_quickfix_window() "{{{3
  let n = winnr('$')
  cclose
  if n == winnr('$')
    copen
  endif
endfunction "}}}

nnoremap [edit]<C-f> :NERDTreeToggle<CR>
nnoremap <silent> [edit]<C-t> :TlistToggle<CR>

nnoremap / :<C-u>nohlsearch<CR>/
nnoremap ? :<C-u>nohlsearch<CR>?

" echo
nnoremap [prefix]e :echo<Space>

" gf " http://labs.timedia.co.jp/2011/04/git-diff-aware-gf-commands-for-vim.html#comment-91
" git-diff-aware version of gf commands.
nnoremap <expr> gf  <SID>do_git_diff_aware_gf('gf')
nnoremap <expr> gF  <SID>do_git_diff_aware_gf('gF')
nnoremap <expr> <C-w>f  <SID>do_git_diff_aware_gf('<C-w>f')
nnoremap <expr> <C-w><C-f>  <SID>do_git_diff_aware_gf('<C-w><C-f>')
nnoremap <expr> <C-w>F  <SID>do_git_diff_aware_gf('<C-w>F')
nnoremap <expr> <C-w>gf  <SID>do_git_diff_aware_gf('<C-w>gf')
nnoremap <expr> <C-w>gF  <SID>do_git_diff_aware_gf('<C-w>gF')

function! s:do_git_diff_aware_gf(command)
  let target_path = expand('<cfile>')
  if target_path =~# '^[ab]/'  " with a peculiar prefix of git-diff(1)?
    if filereadable(target_path) || isdirectory(target_path)
      return a:command
    else
      " BUGS: Side effect - Cursor position is changed.
      let [_, c] = searchpos('\f\+', 'cenW')
      return c . '|' . 'v' . (len(target_path) - 2 - 1) . 'h' . a:command
    endif
  else
    return a:command
  endif
endfunction

" imaps {{{2
inoremap <C-t> <C-v><Tab>

inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-d> <Delete>

inoremap <C-]>a <Home>
inoremap <C-]>e <End>
inoremap <C-]>f <S-Right>
inoremap <C-]>b <S-Left>
inoremap <C-]>d <Delete>
inoremap <C-]><C-a> <Home>
inoremap <C-]><C-e> <End>
inoremap <C-]><C-f> <S-Right>
inoremap <C-]><C-b> <S-Left>
inoremap <C-]><C-d> <Delete>

inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>

" cmaps {{{2
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Delete>
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

Lazy cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/

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

" vmaps {{{2
vnoremap tj    :GoogleTranslate ja<CR>
vnoremap te    :GoogleTranslate en<CR>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
"nnoremap : q:

" plugin settings {{{1

" ambicmd
cnoremap <expr> <C-l> ambicmd#expand("\<Space>")
" cnoremap <expr> <CR> ambicmd#expand("\<CR>")

" camelcasemotion {{{2
nmap <silent> [prefix]w <Plug>CamelCaseMotion_w
nmap <silent> [prefix]e <Plug>CamelCaseMotion_e
nmap <silent> [prefix]b <Plug>CamelCaseMotion_b
vmap <silent> [prefix]w <Plug>CamelCaseMotion_w
vmap <silent> [prefix]e <Plug>CamelCaseMotion_e
vmap <silent> [prefix]b <Plug>CamelCaseMotion_b

omap <silent> i,w <Plug>CamelCaseMotion_iw
xmap <silent> i,w <Plug>CamelCaseMotion_iw
omap <silent> i,b <Plug>CamelCaseMotion_ib
xmap <silent> i,b <Plug>CamelCaseMotion_ib
omap <silent> i,e <Plug>CamelCaseMotion_ie
xmap <silent> i,e <Plug>CamelCaseMotion_ie

" textmanip {{{2
nmap [space]v <Plug>(Textmanip.duplicate_selection_n)
vmap [space]v <Plug>(Textmanip.duplicate_selection_v)
vmap <C-j> <Plug>(Textmanip.move_selection_down)
vmap <C-k> <Plug>(Textmanip.move_selection_up)
vmap <C-h> <Plug>(Textmanip.move_selection_left)
vmap <C-l> <Plug>(Textmanip.move_selection_right)

" smartword {{{2
nmap w  <Plug>(smartword-w)
nmap b  <Plug>(smartword-b)
nmap e  <Plug>(smartword-e)
nmap ge <Plug>(smartword-ge)
vmap w  <Plug>(smartword-w)
vmap b  <Plug>(smartword-b)
vmap e  <Plug>(smartword-e)
vmap ge <Plug>(smartword-ge)

" vim-altr {{{2
call altr#define('autoload/%.vim', 'doc/%.txt', 'plugin/%.vim')
call altr#define('controllers/%.rb', 'models/%.rb', 'helpers/%.rb', 'views/%.erb')
call altr#define('controllers/%.php', 'models/%.php', 'helpers/%.php', 'views/%.php')

nmap [prefix]n <Plug>(altr-forward)
nmap [prefix]p <Plug>(altr-back)

" vim-template "{{{2
let g:template_basedir = expand('$HOME/.vim')
let g:template_files = 'template/**'
let g:template_free_pattern = 'template'

call my#util#vars(['g:email', 'g:author', 'g:homepage_url'], '')

"autocmd BufNewFile * execute 'TemplateLoad'
MyAutocmd User plugin-template-loaded call s:template_keywords()

function! s:template_keywords() "{{{3
  silent! %s/<+FILENAME_NOEXTUC+>/\=toupper(expand('%:t:r'))/g
  silent! %s/<+FILENAME_NOEXT+>/\=expand('%:t:r')/g
  silent! %s/<+FILENAME+>/\=expand('%:t')/g
  silent! %s/<+EMAIL+>/\=g:email/g
  silent! %s/<+AUTHOR+>/\=g:author/g
  silent! %s/<+HOMEPAGE_URL+>/\=g:homepage_url/g
  silent! exe "normal! gg"
  "" expand eval
  %s/<%=\(.\{-}\)%>/\=eval(submatch(1))/ge
endfunction

" scratch.vim {{{2
" http://vim-users.jp/2010/11/hack181/
" Open junk file. {{{3
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction "}}}

command! -nargs=0 JunkFile call s:open_junk_file()
command! -nargs=0 EnewNofile enew | setl buftype=nofile

let g:scratch_buffer_name='[Scratch]'

nmap [prefix]s :silent exe :<C-u>EnewNofile<CR>
nmap [prefix]ss <Plug>(scratch-open)
nnoremap [prefix]sj :<C-u>JunkFile<CR>

" altercmd "{{{2
call altercmd#load()

function! s:alias_lc(...) " {{{3
  for cmd in a:000
    silent exe 'Alias' tolower(cmd) cmd
  endfor
endfunction

" }}} def commands
command! -bar -nargs=+
      \ Alias CAlterCommand <args> | AlterCommand <cmdwin> <args>
command! -nargs=+ LCAlias call s:alias_lc(<f-args>)
" command! -nargs=0 -bang MyQ if &buftype != 'nofile' | bd<bang>
      " \ | elseif tabpagenr('$') == 1 && winnr('$') == 1 | enew
      " \ | else | quit<bang> | endif
command! -nargs=0 -bang MyQ
      \ if tabpagenr('$') == 1 && winnr('$') == 1 | enew
      \ | else | quit<bang> | endif
command! -nargs=0 -bang MyWQ write<bang> | MyQ<bang>

"Alias q bd
Alias q MyQ
Alias wq MyWQ
Alias Q quit
Alias WQ wq

Alias ve vsplit
Alias se split
Alias n new

" alignta {{{2
let g:alignta_confirm_for_retab = 0
" let g:Align_xstrlen=3
" vmap [prefix]a :Align
vmap [prefix]a :Alignta<Space>

" submode {{{2
" http://d.hatena.ne.jp/tyru/20100502/vim_mappings
" Change current window size {{{3
call submode#enter_with('winsize', 'n', '', '[s]w', '<Nop>')
call submode#leave_with('winsize', 'n', '', '<Esc>')
call submode#map       ('winsize', 'n', '', 'j', '<C-w>-:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'k', '<C-w>+:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'h', '<C-w><:redraw<CR>')
call submode#map       ('winsize', 'n', '', 'l', '<C-w>>:redraw<CR>')

" undo/redo {{{3
call submode#enter_with('undo/redo', 'n', '', 'g-', 'g-')
call submode#enter_with('undo/redo', 'n', '', 'g+', 'g+')
call submode#leave_with('undo/redo', 'n', '', '<Esc>')
call submode#map       ('undo/redo', 'n', '', '-', 'g-')
call submode#map       ('undo/redo', 'n', '', '+', 'g+')

" Tab walker. {{{3
call submode#enter_with('tabwalker', 'n', '', '[s]t', '<Nop>')
call submode#leave_with('tabwalker', 'n', '', '<Esc>')
call submode#map       ('tabwalker', 'n', '', 'h', 'gT:redraw<CR>')
call submode#map       ('tabwalker', 'n', '', 'l', 'gt:redraw<CR>')
call submode#map       ('tabwalker', 'n', '', 'H', ':execute "tabmove" tabpagenr() - 2<CR>')
call submode#map       ('tabwalker', 'n', '', 'L', ':execute "tabmove" tabpagenr()<CR>')

" Change current window size {{{3
" winmove {{{3
call submode#enter_with('winmove', 'n', '', '[s]e', '<Nop>')
call submode#enter_with('winmove', 'n', '', '[s]j', '<C-w>j')
call submode#enter_with('winmove', 'n', '', '[s]k', '<C-w>k')
call submode#leave_with('winmove', 'n', '', '<Esc>')
call submode#map       ('winmove', 'n', '', 'j', '<C-w>j')
call submode#map       ('winmove', 'n', '', 'k', '<C-w>k')
call submode#map       ('winmove', 'n', '', 'h', '<C-w>h')
call submode#map       ('winmove', 'n', '', 'l', '<C-w>l')
call submode#map       ('winmove', 'n', '', 'J', '<C-w>j')
call submode#map       ('winmove', 'n', '', 'K', '<C-w>k')
call submode#map       ('winmove', 'n', '', 'H', '<C-w>h')
call submode#map       ('winmove', 'n', '', 'L', '<C-w>l')
call submode#map       ('winsize', 'n', '', '-', '<C-w>-:redraw<CR>')
call submode#map       ('winsize', 'n', '', '+', '<C-w>+:redraw<CR>')
call submode#map       ('winsize', 'n', '', '<', '<C-w><:redraw<CR>')
call submode#map       ('winsize', 'n', '', '>', '<C-w>>:redraw<CR>')

" Quickfix {{{3
call submode#enter_with('quickfix', 'n', '', '[s]q', '<Nop>')
call submode#leave_with('quickfix', 'n', '', '<Esc>')
call submode#map       ('quickfix', 'n', '', 'n', ':cn<CR>')
call submode#map       ('quickfix', 'n', '', 'p', ':cp<CR>')
call submode#map       ('quickfix', 'n', '', 'c', ':cclose<CR>')
call submode#map       ('quickfix', 'n', '', 'o', ':copen<CR>')
call submode#map       ('quickfix', 'n', '', 'w', ':cwindow<CR>')

" open-browser.vim {{{2
nmap [space]u <Plug>(openbrowser-open)
vmap [space]u <Plug>(openbrowser-open)

" netrw {{{2
let g:netrw_home = expand("$HOME/.tmp/")

" yankring {{{2
let g:yankring_history_dir = "$HOME/.tmp"

" NERDCommenter {{{2
let g:NERDSpaceDelims = 1

" NERDTree {{{2
let g:NERDTreeHijackNetrw = 0
let g:NERDTReeIgnore = ['\.svn', '\.git', '\~$']
let g:NERDTreeMapOpenSplit="s"
let g:NERDTreeMapOpenVSplit="gi"

" chalice {{{2
let g:chalice_cachedir = expand('$HOME/.tmp/chalice_cache')
call my#util#mkdir(g:chalice_cachedir)
let chalice_startupflags = 'bookmark'

" pydiction {{{2
let g:pydiction_location = '~/.vim/dict/pydiction-complete-dict'

" html5.vim
let g:event_handler_attributes_complete = 1
let g:rdfa_attributes_complete = 1
let g:microdata_attributes_complete = 1
let g:aria_attributes_complete = 1

" sudo.vim {{{2
command! SW w sudo:%

" hatena.vim {{{2
let g:hatena_base_dir = $HOME . '/.tmp/vim-hatena/'
call my#util#mkdir(g:hatena_base_dir.'/cookies')

" dbext.vim
let g:dbext_default_prompt_for_parameters=0
let g:dbext_default_history_file = expand('~/.tmp/dbext_sql_history.txt')

" zen-coding.vim {{{2
let g:user_zen_leader_key='<C-y>'

" endtagcomment https://gist.github.com/411828 {{{2
nmap <C-y>o <Plug>(endtagcomment)

" smartchr "{{{2
inoremap <expr>, smartchr#one_of(', ', ',')

MyAutocmd FileType
      \ c,cpp,javascript,ruby,python,java,perl,php
      \ call s:smartchr_my_settings()

function! s:smartchr_my_settings() "{{{3
  " http://d.hatena.ne.jp/ampmmn/20080925/1222338972
  " 演算子の間に空白を入れる
  "inoremap <buffer><expr> < search('^#include\%#', 'bcn')? ' <': smartchr#one_of(' < ', ' << ', '<')
  "inoremap <buffer><expr> > search('^#include <.*\%#', 'bcn')? '>': smartchr#one_of(' > ', ' >> ', '>')
  "inoremap <buffer><expr> + smartchr#one_of(' + ', '++', '+')
  "inoremap <buffer><expr> - smartchr#one_of(' - ', '--', '-')
  "inoremap <buffer><expr> / smartchr#one_of(' / ', '// ', '/')
  " *はポインタで使うので、空白はいれない
  "inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
  "inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
  "inoremap <buffer><expr> , smartchr#one_of(', ', ',')
  " 3項演算子の場合は、後ろのみ空白を入れる
  "inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
  "inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

  " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
  " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
"  inoremap <buffer><expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"        \ : search('\(*\<bar>!\)\%#.', 'bcn') ? '= '
"        \ : smartchr#one_of(' = ', ' == ', '===', '=')

  " if文直後の(は自動で間に空白を入れる
  inoremap <buffer><expr> ( search('\<\if\%#', 'bcn')? ' (': '('

endfunction

" unite {{{2
LCAlias Unite
nnoremap [unite] <Nop>
nmap     f       [unite]
nnoremap [unite]f f

" unite basic settings {{{3
"let g:unite_enable_start_insert=1
let g:unite_enable_start_insert=0
let g:unite_source_file_mru_limit=200
let g:unite_source_file_mru_time_format = ''
"let g:unite_source_file_mru_time_format = '%Y-%m-%d %H:%M:%S'
let g:unite_winheight = 20
"let g:unite_split_rule = 'botright'
let g:unite_source_file_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o|exe|dll|bak|sw[po]\)$\|/chalice_cache/\|/-Tmp-/'

" unite buffers {{{3
call unite#set_substitute_pattern('file', '\$\w\+', '\=eval(submatch(0))', 200)

call unite#set_substitute_pattern('file', '[^~.]\zs/', '*/*', 20)
call unite#set_substitute_pattern('file', '/\ze[^*]', '/*', 10)

call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
call unite#set_substitute_pattern('file', '^\\', '~/*')
call unite#set_substitute_pattern('file', '^\~', escape($HOME, '\'), -2)

call unite#set_substitute_pattern('file', '^;v', '~/.vim/*')
call unite#set_substitute_pattern('file', '^;ft', '~/.vim/after/ftplugin/')
call unite#set_substitute_pattern('file', '^;r', '\=$VIMRUNTIME."/*"')
if s:is_win
  call unite#set_substitute_pattern('file', '^;p', 'C:/Program Files/*')
  if isdirectory(expand('$USERPROFILE/Desktop'))
    call unite#set_substitute_pattern('file', '^;d', '\=expand("$USERPROFILE/Desktop/")."*"')
  else
    call unite#set_substitute_pattern('file', '^;d', '\=expand("$USERPROFILE/デスクトップ/")."*"')
  endif
else
  call unite#set_substitute_pattern('file', '^;d', '\=$HOME."/Desktop/*"')
endif

" unite-grep {{{3
let g:unite_source_grep_default_opts = '-iRHn'

" unite-ack {{{3
let g:unite_source_ack_command='ack --nocolor --nogroup'

" unite mappings {{{3

nnoremap <silent> [unite][buffer]   :<C-u>Unite buffer_tab<CR>
nnoremap <silent> [unite][tab]   :<C-u>Unite tab<CR>
nnoremap <silent> [unite][file]     :<C-u>Unite -buffer-name=file file<CR>
nnoremap <silent> [unite][rel_file] :<C-u>Unite file:<C-r>=fnameescape(expand('%:p:h'))<CR>/ -buffer-name=file<CR>
nnoremap <silent> [unite][mru]      :<C-u>Unite -buffer-name=file file_mru directory_mru bookmark -default-action=open<CR>
nnoremap <silent> [unite][source]   :<C-u>Unite source<CR>
nnoremap [unite][empty]    :<C-u>Unite<Space>

nmap [unite]u                [unite][empty]
nmap [unite]s                [unite][source]
nmap <silent> [unite]<Space> [unite][buffer]
nmap <silent> [unite]j       [unite][buffer]
nmap <silent> [unite]k       [unite][tab]
nmap <silent> [unite]l       [unite][file]
nmap <silent> [unite];       [unite][rel_file]
nmap <silent> [unite]m       [unite][mru]

nnoremap <silent> [unite]a  :<C-u>Unite file_rec -start-insert<CR>
nnoremap <silent> [unite]o  :<C-u>Unite tag outline<CR>
nnoremap <silent> [unite]gg :<C-u>Unite ack -buffer-name=grep -no-quit<CR>
nnoremap <silent> [unite]gr :<C-u>Unite grep -buffer-name=grep -no-quit<CR>
nnoremap <silent> [unite]gi :<C-u>Unite git_grep -buffer-name=git<CR>
nnoremap <silent> [unite]q  :<C-u>Unite qf -buffer-name=qfix -no-quit<CR>
nnoremap <silent> [unite]c  :<C-u>Unite command history/command<CR>
nnoremap <silent> [unite]/  :<C-u>Unite history/search history/command<CR>
nnoremap <silent> [unite]p  :<C-u>Unite process<CR>
nnoremap <silent> [unite]bb :<C-u>Unite bookmark -default-action=open<CR>
nnoremap <silent> [unite]ba :<C-u>UniteBookmarkAdd<CR>

" nnoremap <silent> [unite]h  :<C-u>UniteWithCursorWord help:ja help<CR>
nnoremap <silent> [unite]h :<C-u>call <SID>smart_unite_ref_launch()<CR>

function! s:smart_unite_ref_launch() " {{{4
  let ft = &ft
  let names = []

  let isk = &l:isk
  setlocal isk& isk+=- isk+=. isk+=:
  let kwd = expand('<cword>')
  let &l:isk = isk

  " let tilang = ['timobileref', 'tidesktopref']
  " if ft == 'php'
  "   let names = ['phpmanual'] + tilang
  " elseif ft == 'ruby'
  "   let names = ['refe'] + tilang
  " elseif ft == 'python'
  "   let names = ['pydoc'] + tilang
  " elseif ft == 'perl'
  "   let names = ['perldoc']
  " elseif ft == 'javascript'
  "   let names = ['jsref'] + tilang
  " elseif ft == 'java'
  "   let names = ['javadoc', 'androiddoc']
  " elseif ft == 'erlang'
  "   let names = ['erlang']
  " endif
  " let ref_names = ref#available_source_names()
  " execute 'Unite'
  "       \ '-input='.kwd
  "       \ join(map(filter(names, 'index(ref_names, v:val)') + ['man'],
  "       \ '"ref/".v:val'), ' ')
  let s = ref#detect()
  if s == ""
    let s = "man"
  endif
  execute 'Unite' '-input='.kwd 'ref/'.s
endfunction "}}}

nnoremap          [unite]rr :<C-u>UniteResume<Space>
nnoremap <silent> [unite]re :<C-u>UniteResume<CR>
nnoremap <silent> [unite]ri :<C-u>UniteResume git<CR>
nnoremap <silent> [unite]rg :<C-u>UniteResume grep<CR>
nnoremap <silent> [unite]rq :<C-u>UniteResume qfix<CR>

inoremap <C-k> <C-o>:Unite neocomplcache -buffer-name=noocompl -start-insert<CR>

MyAutocmd FileType unite call s:unite_my_settings() "{{{3
function! s:unite_my_settings()
  imap <buffer> jj <Plug>(unite_insert_leave)j
  imap <buffer> qq <Plug>(unite_exit)
  imap <buffer> ]] <C-o><Plug>(unite_rotate_next_source)
  imap <buffer> [[ <C-o><Plug>(unite_rotate_previous_source)
  imap <buffer> <ESC> <ESC><ESC>

  nnoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  inoremap <silent><buffer><expr> <C-j> unite#do_action('split')
  nmap <buffer> t <Plug>(unite_choose_action)
  nmap <buffer> l <Plug>(unite_do_default_action)
endfunction

" git-vim {{{2
" let g:git_no_map_default = 1
" let g:git_command_edit = 'rightbelow vnew'
" nnoremap [space]gd :<C-u>GitDiff --cached<Enter>
" nnoremap [space]gD :<C-u>GitDiff<Enter>
" nnoremap [space]gs :<C-u>GitStatus<Enter>
" nnoremap [space]gl :<C-u>GitLog<Enter>
" nnoremap [space]gL :<C-u>GitLog -u \| head -10000<Enter>
" nnoremap [space]ga :<C-u>GitAdd<Enter>
" nnoremap [space]gA :<C-u>GitAdd <cfile><Enter>
" nnoremap [space]gc :<C-u>GitCommit<Enter>
" nnoremap [space]gC :<C-u>GitCommit --amend<Enter>
" nnoremap [space]gp :<C-u>Git push

" fugitive.vim {{{2
nnoremap [space]gd :<C-u>Gdiff --cached<CR>
nnoremap [space]gD :<C-u>Gdiff<CR>
nnoremap [space]gs :<C-u>Gstatus<CR>
nnoremap [space]gl :<C-u>Glog<CR>
nnoremap [space]gL :<C-u>Glog -u \| head -10000<CR>
nnoremap [space]ga :<C-u>Gwrite<CR>
nnoremap [space]gA :<C-u>Gwrite <cfile><CR>
nnoremap [space]gc :<C-u>Gcommit<CR>
nnoremap [space]gC :<C-u>Gcommit --amend<CR>
nnoremap [space]gr :<C-u>Ggrep<Space>
nnoremap [space]gb :<C-u>Gblame<CR>
nnoremap [space]gp :<C-u>Git push

" TOhtml {{{2
let g:html_number_lines = 0
let g:html_use_css = 1
let g:use_xhtml = 1
let g:html_use_encoding = 'utf-8'

" quickrun {{{2
"silent! nmap <unique> <Space> <Plug>(quickrun)
if has('clientserver') && !s:is_win
  let g:quickrun_config = {
        \   '*': {'runmode': 'async:remote:vimproc', 'split': 'below'},
        \ }
else
  let g:quickrun_config = {
        \ '*' : {'split': 'below'},
        \ }
endif
let g:quickrun_config["cat"] = {
      \ 'command' : 'cat',
      \ 'exec' : ['%c %s'],
      \ }

nnoremap <Leader><Leader>r :<C-u>QuickRun cat<CR>
nnoremap [space]q :<C-u>QuickRun<Space>

" for ruby {{{3
MyAutocmd BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.rspec
let g:quickrun_config['ruby.rspec'] = {'command' : 'rspec', 'exec' : '%c -l {line(".")}'}
" html {{{3
if s:is_mac
  let g:quickrun_config['html'] = {'exec' : 'open %s'}
  let g:quickrun_config['xhtml'] = {'exec' : 'open %s'}
else
endif

" objc {{{3
if executable('gcc') && s:is_mac
  let g:quickrun_config['objc'] = {
        \ 'command' : 'gcc',
        \ 'exec' : ['%c %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
        \ 'tempfile': '{tempname()}.m'
        \ }
        "\ 'exec' : ['%c %s -o %s:p:r -framework Cocoa', '%s:p:r %a', 'rm -f %s:p:r'],
endif
" text markups {{{3
if !executable('pandoc') && executable('markdown') "{{{4
  if executable('ruby') && filereadable($HOME.'/bin/mkd2html.rb')
          " \ 'command' : 'ruby ' . $HOME . '/bin/mkd2html.rb' ,
          " \   '%c %s',
    let g:quickrun_config['markdown'] = {
          \ 'command' : 'ruby' ,
          \ 'exec' : [
          \   '%c ' . $HOME . '/bin/mkd2html.rb' . ' %s',
          \ ],
          \ }
  else
    let g:quickrun_config['markdown'] = {
          \ 'command' : 'markdown',
          \ 'exec' : [
          \   'echo "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"></head>"',
          \   '%c %s',
          \ ],
          \ }
  endif
  " \ 'exec' : [
  " \   'echo "<html><head><meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\"></head>" > %s:p:r.html',
  " \   '%c %s >> %s:p:r.html',
  " \   'open %s:p:r.html',
  " \   'sleep 1',
  " \   'rm ' .(s:is_win ? '/f' : '-f'). ' %s:p:r.html'
  " \ ],
  "\ 'exec' : ['%c %s > %s:p:r.html', 'open %s:p:r.html', 'sleep 1', 'rm ' .(s:is_win ? '/f' : '-f'). ' %s:p:r.html '],
endif
if executable('redcloth') "{{{4
  let g:quickrun_config['textile'] = {
        \ 'command' : 'redcloth',
        \ 'exec' : [
        \   '%c %s',
        \ ],
        \ }
endif

function! s:quickrun_my_settings() "{{{4
  nmap <buffer> q :quit<CR>
endfunction "}}}
MyAutocmd FileType quickrun call s:quickrun_my_settings()

" taglist {{{2
" basic options {{{3
set tags+=tags;$HOME
if filereadable($HOME."/.bin/tags/java6") | set tags+=$HOME/.bin/tags/java6 | endif
if filereadable($HOME."/.bin/tags/android-base") | set tags+=$HOME/.bin/tags/android-base | endif

let g:Tlist_Auto_Update = 1
let g:Tlist_Show_One_File = 0
let g:Tlist_Exit_OnlyWindow = 1
let g:Tlist_Use_Right_Window = 0
let g:Tlist_WinWidth = 25

let g:tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods;v:property'
let g:tlist_javascript_settings='javascript;v:var;c:class;p:prototype;m:method;f:function;o:object'
let g:tlist_scala_settings = 'scala;t:trait;c:class;T:type;m:method;C:constant;l:local;p:package;o:object'
let g:tlist_actionscript_settings = 'actionscript;c:class;f:method;p:property;v:variable'
let g:tlist_tex_settings   = 'latex;s:sections;g:graphics;l:labels'

if s:is_mac && executable('/Applications/MacVim.app/Contents/MacOS/ctags')
  let g:Tlist_Ctags_Cmd='/Applications/MacVim.app/Contents/MacOS/ctags'
endif
" }}}
nnoremap <silent> [prefix]tt :<C-u>TlistToggle<CR>1<C-w>h
nnoremap <silent> [prefix]tr :<C-u>TlistUpdate<CR>
nnoremap          [prefix]tc :Ctags<CR>
command! -nargs=0 Ctags call s:exec_ctags()
function! s:exec_ctags() "{{{3
  let cmdname = my#util#has_plugin('vimproc') != '' ? 'VimProcBang' : '!'
  execute cmdname 'ctags -R'
  NeoComplCacheCachingTags
endfunction

" surround.vim {{{2
nmap [s]s <Plug>Ysurround

let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
      \ 'g':  "_('\r')",
      \ 'G':  "_(\"\r\")",
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
      \ }
let g:surround_custom_mapping.markdown = {
      \ 'h': "`\r`",
      \ }
let g:surround_custom_mapping.php = {
      \ '-':  "<?php \r ?>", 
      \ '=':  "<?php echo $\r; ?>", 
      \ 'h':  "<?php echo h( $\r ); ?>", 
      \ '#':  "<?php # \r ?>", 
      \ '/':  "<?php // \r ?>", 
      \ 'f':  "<?php foreach ($\r as $val): ?>\n<?php endforeach; ?>", 
      \ }
let g:surround_custom_mapping.javascript = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.lua = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.python = {
      \ 'p':  "print( \r)",
      \ '[':  "[\r]",
      \ }
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction"
      \ }

" operator {{{2
" http://labs.timedia.co.jp/2011/07/vim-excel-and-sql.html
call operator#user#define('excelize', 'OperatorExcelize')
function! OperatorExcelize(motion_wise)
  let b = line("'[")
  let e = line("']")
  execute b ',' e 'substitute/\v(\''?)(\$?\u+\$?\d+)(\''?)/\1" \& \2 \& "\3/g'
  execute b 'substitute/^/="/'
  execute e 'substitute/$/"/'
endfunction

map ;e <Plug>(operator-excelize)
map _ <Plug>(operator-replace)
map ;h <Plug>(operator-html-escape)
map ;H <Plug>(operator-html-unescape)
map ;c <Plug>(operator-camelize)
map ;C <Plug>(operator-decamelize)

" textobj {{{2
omap iF <Plug>(textobj-function-i)
omap aF <Plug>(textobj-function-a)
vmap iF <Plug>(textobj-function-i)
vmap aF <Plug>(textobj-function-a)

" ref.vim {{{2
" options {{{3
if isdirectory($HOME.'/.bin/apps/phpman/')
  let g:ref_phpmanual_path=$HOME.'/.bin/apps/phpman/'
endif
if isdirectory($HOME.'/.bin/apps/jdk-6-doc/ja')
  let g:ref_javadoc_path = $HOME.'/.bin/apps/jdk-6-doc/ja'
endif
if isdirectory($HOME.'/.bin/apps/jqapi-latest')
  let g:ref_jquery_path = $HOME.'/.bin/apps/jqapi-latest/docs'
  "let g:ref_jquery_use_cache = 1
endif
if isdirectory($HOME."/.nvm/src/node-v0.4.7/doc")
  let g:ref_nodejsdoc_dir = $HOME."/.nvm/src/node-v0.4.7/doc"
endif

if s:is_win
  let g:ref_refe_encoding = 'cp932'
else
  let g:ref_refe_encoding = 'utf-8'
  if exists('$RSENSE_HOME') && executable($RSENSE_HOME.'/bin/rsense')
    let g:ref_refe_rsense_cmd = $RSENSE_HOME.'/bin/rsense'
  endif
endif
let g:ref_perldoc_complete_head = 1
let g:ref_alc_use_cache = 1
let g:ref_alc_start_linenumber = 43
let g:ref_use_vimproc = 0

if exists('*ref#register_detection')
  call ref#register_detection('_', 'alc')
endif
" }}}

LCAlias Ref
for src in ['alc', 'refe', 'ri', 'perldoc', 'man'
      \ , 'pydoc', 'jsref', 'jquery'
      \ , 'cppref', 'cheat', 'nodejs', ]
  silent! exe 'Alias' src 'Ref' src
endfor
Alias mr Ref alc
Alias php[manual] Ref phpmanual
Alias timo Ref timobileref
Alias tide Ref tidesktopref

nnoremap [space]h :Ref alc <C-r>=expand("<cWORD>")<CR><CR>

" echodoc {{{2
let g:echodoc_enable_at_startup=0

" neocomplcache {{{2
" options {{{3
let g:neocomplcache_snippets_dir                        = $HOME . '/.vim/snippets'
let g:neocomplcache_enable_at_startup                   = 1
let g:neocomplcache_cursor_hold_i_time                  = 500
if exists('g:loaded_dot_vimrc') | silent exe 'NeoComplCacheEnable' | endif

let g:neocomplcache_max_list = 10  " 補完候補の数
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*' " 日本語をキャッシュしない
let g:neocomplcache_enable_auto_select = 1   " 一番目の候補を自動選択

let g:neocomplcache_enable_smart_case                   = 1
let g:neocomplcache_enable_camel_case_completion        = 0 " camel case off
let g:neocomplcache_enable_underbar_completion          = 1
" let g:neocomplcache_enable_auto_delimiter               = 1
" let g:neocomplcache_disable_caching_buffer_name_pattern = "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
let g:neocomplcache_disable_caching_file_path_pattern = "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
let g:neocomplcache_lock_buffer_name_pattern            = '\*ku\*'

let g:neocomplcache_min_syntax_length                   = 3
" let g:neocomplcache_plugin_completion_length     = {
" let g:neocomplcache_auto_completion_start_length        = 2
" let g:neocomplcache_manual_completion_start_length      = 1
" let g:neocomplcache_min_keyword_length                  = 3
" let g:neocomplcache_ignore_case                         = 0
  " \ 'snipMate_complete' : 1,
  " \ 'buffer_complete'   : 1,
  " \ 'include_complete'  : 2,
  " \ 'syntax_complete'   : 2,
  " \ 'filename_complete' : 2,
  " \ 'keyword_complete'  : 2,
  " \ 'omni_complete'     : 1,
  " \ }
let g:neocomplcache_dictionary_filetype_lists = {
  \ 'default'     : '',
  \ 'vimshell'    : $HOME . '/.vimshell/command-history',
  \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',
  \ 'ruby'        : $HOME . '/.vim/dict/ruby.dict',
  \ 'perl'        : $HOME . '/.vim/dict/perl.dict',
  \ 'php'         : $HOME . '/.vim/dict/php.dict',
  \ 'objc'        : $HOME . '/.vim/dict/objc.dict',
  \ 'actionscript': $HOME . '/.vim/dict/actionscript.dict',
  \ }
if !exists('g:neocomplcache_vim_completefuncs')
  let g:neocomplcache_vim_completefuncs = {}
endif
let g:neocomplcache_vim_completefuncs.Ref = 'ref#complete'
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {
        \ 'ruby' : '[^. *\t]\.\w*\|\h\w*::',
        \ }
        "\ 'php'  : '[^. \t]->\h\w*\|\h\w*::',
endif
" }}}

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"

" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

inoremap <expr> <C-j> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

imap <C-l> <Plug>(neocomplcache_snippets_expand)
smap <C-l> <Plug>(neocomplcache_snippets_expand)
" imap <expr><C-l> (pumvisible() ? neocomplcache#close_popup():"") ."\<Plug>(neocomplcache_snippets_expand)"
" smap <expr><C-l> (pumvisible() ? neocomplcache#close_popup():"") ."\<Plug>(neocomplcache_snippets_expand)"

nnoremap [space]ne :NeoComplCacheEnable<CR>
nnoremap [space]nd :NeoComplCacheDisable<CR>

" completes {{{3
if exists("+omnifunc") " {{{4
  MyAutocmd FileType php          setl omnifunc=phpcomplete#CompletePHP
  MyAutocmd FileType html,markdown setl omnifunc=htmlcomplete#CompleteTags
  MyAutocmd FileType python       setl omnifunc=pythoncomplete#Complete
  MyAutocmd FileType javascript   setl omnifunc=javascriptcomplete#CompleteJS
  MyAutocmd FileType xml          setl omnifunc=xmlcomplete#CompleteTags
  MyAutocmd FileType css          setl omnifunc=csscomplete#CompleteCSS
  MyAutocmd FileType c            setl omnifunc=ccomplete#Complete
  MyAutocmd FileType actionscript setl omnifunc=actionscriptcomplete#CompleteAS
  MyAutocmd FileType *
        \ if &l:omnifunc == ''
        \ | setlocal omnifunc=syntaxcomplete#Complete
        \ | endif
endif

if exists('$RSENSE_HOME') " {{{4
  let g:rsenseHome=$RSENSE_HOME
  let g:rsenseUseOmniFunc=1
elseif exists('+omnifunc')
  "MyAutocmd FileType ruby setl omnifunc=rubycomplete#Complete
endif

" vimshell {{{2
hi link VimShellError WarningMsg

let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
let g:vimshell_right_prompt = 'vimshell#vcs#info("(%s)-[%b]", "(%s)-[%b|%a]")'
let g:vimshell_enable_smart_case = 1
let g:vimshell_enable_auto_slash = 1

function! s:setup_vimproc_dll() " {{{3
  if s:is_win
    let g:vimproc_dll_path = expand('~/.vim/lib/vimproc/win32/proc.dll')
  endif
  let path = expand(g:my_bundle_dir . '/vimproc/autoload/proc.so')
  if filereadable(path)
    let g:vimproc_dll_path = path
  endif
endfunction " }}}

call s:setup_vimproc_dll()

if s:is_win " {{{3
  " Display user name on Windows.
  let g:vimshell_prompt = $USERNAME."% "
  let g:vimshell_use_ckw = 1
  "let g:vimproc_dll_path = expand("~/.vim/lib/vimproc/win32/proc.dll")
else " {{{3
  " Display user name
  let g:vimshell_prompt = $USER."$ "

  MyAutocmd VimEnter
        \ call vimshell#set_execute_file('bmp,jpg,png,gif', 'gexe eog')
        \ call vimshell#set_execute_file('mp3,m4a,ogg', 'gexe amarok')
        \ let g:vimshell_execute_file_list['zip'] = 'zipinfo'
        \ call vimshell#set_execute_file('tgz,gz', 'gzcat')
        \ call vimshell#set_execute_file('tbz,bz2', 'bzcat')
endif

MyAutocmd FileType vimshell call s:vimshell_my_settings() " {{{3
function! s:vimshell_my_settings() " {{{3
  setl textwidth=0
  "autocmd FileType vimshell
  call vimshell#altercmd#define('g'  , 'git')
  call vimshell#altercmd#define('i'  , 'iexe')
  call vimshell#altercmd#define('l'  , 'll')
  call vimshell#altercmd#define('ll' , 'ls -l')
  call vimshell#altercmd#define('la' , 'ls -a')
  call vimshell#altercmd#define('e' , 'vim')
  for cmd in ['irb', 'termtter']
    if executable(cmd) | call vimshell#altercmd#define(cmd, 'iexe '.cmd) | endif
  endfor
  call vimshell#hook#set('chpwd'     , ['g:my_chpwd'])
  call vimshell#hook#set('emptycmd'  , ['g:my_emptycmd'])
  call vimshell#hook#set('preprompt' , ['g:my_preprompt'])
  call vimshell#hook#set('preexec'   , ['g:my_preexec'])

  imap <silent> <buffer> <C-a> <C-o>:call cursor(line('.'), strlen(g:vimshell_prompt)+1)<CR>
  inoremap <expr><buffer> <C-j> pumvisible() ? neocomplcache#close_popup() : ""
endfunction

function! g:my_chpwd(args, context) " {{{3
  call vimshell#execute('ls')
endfunction

function! g:my_emptycmd(cmdline, context) " {{{3
  "call vimshell#execute('echo "emptycmd"')
  call vimshell#set_prompt_command('ls')
  return 'ls'
endfunction

function! g:my_preprompt(args, context) " {{{3
  "call vimshell#execute('echo "preprompt"')
endfunction

function! g:my_preexec(cmdline, context) " {{{3
  "call vimshell#execute('echo "preexec"')

  if a:cmdline =~# '^\s*diff\>'
    call vimshell#set_syntax('diff')
  endif
  return a:cmdline
endfunction " }}}

nmap [space]vp :<C-u>VimShellPop<CR>
nmap [space]vv :<C-u>VimShellTab<CR>
nmap [space]ve :<C-u>VimShellExecute<Space>
nmap [space]vi :<C-u>VimShellInteractive<Space>
nmap [space]vt :<C-u>VimShellTerminal<Space>

command! IRB VimShellInteractive irb
LCAlias IRB

" vimfiler {{{2
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_edit_action = 'below'

MyAutocmd FileType vimfiler call s:vimfiler_my_settings()

function! s:vimfiler_my_settings() " {{{3
  nmap <buffer> u <Plug>(vimfiler_move_to_history_directory)
  hi link ExrenameModified Statement
  "nnoremap <buffer> v V
endfunction

" qfixhowm {{{2
let QFixHowm_Key      = 'g'
let howm_dir          = $HOME."/.howm"
"let howm_filename     = '%Y-%m/%Y-%m-%d-%H%M%S.howm'
let howm_filename     = '%Y-%m/%Y-%m-%d.howm'
let howm_fileencoding = 'utf8'
let howm_fileformat   = 'unix'
let QFixHowm_ScheduleSearchDir = howm_dir

let QFixHowm_Replace_Title_Len = 64
if !filereadable(g:howm_dir . '/Sche-Hd-0000-00-00-000000.howm')
  call my#util#mkdir(g:howm_dir)
  call my#util#copy($HOME.'/.vim/lib/howm/Sche-Hd-0000-00-00-000000.howm', g:howm_dir.'/Sche-Hd-0000-00-00-000000.howm')
endif
let SubWindow_Title = $HOME.'/.vim/lib/howm/__submenu__.howm'
let SubWindow_Width = 20

" disable menu
let QFixHowm_MenuBar=0
let MyGrep_MenuBar=0

let QFixHowm_ShowTodoOnMenu = 1
let g:QFix_PreviewEnable = 0

MyAutocmd FileType howm_memo call s:howm_memo_my_settings() " {{{3
function! s:howm_memo_my_settings()
  nmap <buffer> [prefix],t :exe 'normal! i'.printf("[%s] ", strftime('%Y-%m-%d %H:%M:%S'))<CR>
  nmap <buffer> [prefix],d :exe 'normal! i'.printf("[%s] ", strftime('%Y-%m-%d'))<CR>
endfunction

" etc functions & commands {{{1
" tiny snippets {{{2
let g:my_snippets_dir = "$HOME/memos/tiny-snippets"

let s:unite_action_file_insert = {} " {{{3
function! s:unite_action_file_insert.func(candicate)
  "echo a:candicate
  let l:path = a:candicate.word
  if isdirectory(l:path)
    call unite#do_action('narrow')
  elseif filereadable(l:path)
    let linesread=line('$')
    let l:old_cpoptions=&cpoptions
    setlocal cpoptions-=a
    :execute 'read '.l:path
    let &cpoptions = l:old_cpoptions
    let linesread=line('$')-linesread-1
    if linesread >= 0
      silent exe 'normal ='.linesread.'+'
    endif
  endif
endfunction
call unite#custom_action('file', 'insert_file', s:unite_action_file_insert)
unlet! s:unite_action_file_insert

function! MyFilerecLauncher(mode, option) " {{{3
  if g:my_snippets_dir == ''
    return
  endif
  if a:mode == 'r'
    let l:snippets_dir = g:my_snippets_dir
  else
    let l:delm=(strpart(g:my_snippets_dir, strlen(g:my_snippets_dir) -1) == '/' ? '' : '/')
    let l:snippets_dir = expand(g:my_snippets_dir . l:delm . &filetype . (&filetype == '' ? '' : "/"))

    if ! isdirectory(l:snippets_dir)
      let l:snippets_dir=expand(g:my_snippets_dir.l:delm)
    endif
  endif
  if a:option == 'i'
    let l:option = ' -default-action=insert_file'
  else
    let l:option = ''
  endif
  exe "Unite file_rec:".fnameescape(l:snippets_dir).l:option
endfunction 
" }}}
" mapping for tiny-snippets
nnoremap [unite]n <Nop>
nnoremap [unite]nr :<C-u>call MyFilerecLauncher('f', 'i')<CR>
nnoremap [unite]ne :<C-u>call MyFilerecLauncher('f', 'o')<CR>
nnoremap [unite]no :<C-u>call MyFilerecLauncher('r', 'o')<CR>
nnoremap [unite]nn :execute 'new' g:my_snippets_dir<CR>
nnoremap [unite]nm :execute 'new $HOME/memos'<CR>

" buffer commands {{{2
command! ToUnixBuffer set fileformat=unix fileencoding=utf8
command! ToWindowsBuffer set fileformat=dos fileencoding=cp932
command! ToMacBuffer set fileformat=mac fileencoding=utf8
command! TrimRSpace %s/ \+$//
command! Tosass call my#util#newfile_with_text(expand('%:p:r').".sass",
      \ system(printf('sass-convert -F css -T sass "%s"', expand('%:p')))
      \ )
command! Toscss call my#util#newfile_with_text(expand('%:p:r').".scss",
      \ system(printf('sass-convert -F css -T scss "%s"', expand('%:p')))
      \ )
command! Tocoffee call my#util#newfile_with_text(expand('%:p:r').".coffee",
      \ system(printf('js2coffee "%s"', expand('%:p')))
      \ )

" シェル起動系 {{{2
if s:is_mac "{{{3
  " Utility command for Mac
  command! Here silent call system('open ' . expand('%:p:h'))
  command! This silent call system('open ' . expand('%:p'))
  command! -nargs=1 -complete=file That silent call system('open ' . shellescape(expand(<f-args>), 1))
elseif s:is_win "{{{3
  " Utility command for Windows
  command! Here silent execute '!explorer' substitute(expand('%:p:h'), '/', '\', 'g')
  command! This silent execute '!start cmd /c "%"'
  command! -nargs=1 -complete=file That silent execute '!explorer' shellescape(expand(<f-args>), 1)
else "{{{3
  " TODO
endif
"}}}
LCAlias Here This That

" chm launcher {{{2
if exists('g:my_chm_dir') && (s:is_win || (!s:is_win && !empty(g:my_chm_command)))
  command! -nargs=1 -complete=customlist,my#chm#complete Chm call my#chm#open("<args>")
  LCAlias Chm
endif

if exists('g:my_cheatsheets_dir')
  command! -nargs=1 -complete=customlist,my#cheatsheet#complete CheatSheet call my#cheatsheet#open("<args>")
  LCAlias CheatSheet
endif

" tail {{{2
if executable('tail')
  command! -nargs=1 -complete=file Tail VimShellExecute tail -f <args>
  LCAlias Tail
endif

" unique {{{2
command! -range -nargs=0 UniqueSort <line1>,<line2>sort u

" diff {{{2
command! -nargs=1 -complete=buffer DiffBuf vertical diffsplit <args>
command! -nargs=1 -complete=file DiffFile vertical diffsplit <args>

" rename {{{2
"command! -nargs=1 -complete=file Rename f <args>|call delete(expand('#'))
"command! -nargs=1 -complete=file Rename f <args> | call delete(expand('#')) | w
command! -nargs=1 -complete=customlist,my#rename#complete Rename call my#rename#exec("<args>")
Alias ren Rename

command! -nargs=1 -complete=file Relcp call my#ui#relative_copy(<f-args>)
LCAlias Relcp

" win maximize toggle {{{3
nnoremap [prefix]m :call my#winmaximizer#get().toggle()<CR>
nnoremap [prefix]mm :call my#winmaximizer#get().toggle()<CR>
nnoremap [prefix]mj :call my#winmaximizer#get().toggleDirection("v")<CR>
nnoremap [prefix]mh :call my#winmaximizer#get().toggleDirection("h")<CR>

" fopen & encoding {{{2
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Fenc setl fenc=<args>
command! -nargs=1 -complete=customlist,my#ui#complete_encodings Freopen e ++enc=<args> %

command! Utf8 e ++enc=utf-8 %
command! Euc e ++enc=euc-jp %
command! Sjis e ++enc=cp932 %
command! Jis e ++enc=iso-2022-jp %
command! Dos e ++ff=dos %
command! Mac e ++ff=mac %
command! Unix e ++ff=unix %
command! Ccd if isdirectory(expand('%:p:h')) | execute ":lcd " . expand("%:p:h") | endif
LCAlias Utf8 Euc Sjis Jis Ccd
" }}}

" utility {{{2
" 選択範囲をブラウザで起動 {{{3
if s:is_win
  "let g:my_preview_browser_cmd = ' start chrome.exe'
  let g:my_preview_browser_cmd = ' start ' . expand('$LOCALAPPDATA/Google/Chrome/Application/chrome.exe')
elseif s:is_mac
  let g:my_preview_browser_cmd = 'open -a "Google Chrome"'
else
  let g:my_preview_browser_cmd = 'firefox'
endif
" }}}
command! -range Brpreview <line1>,<line2>call my#ui#preview_browser()

" browser {{{3
command! Ie call my#ui#launch_browser('ie')
command! Firefox call my#ui#launch_browser('firefox')
command! Opera call my#ui#launch_browser('opera')
command! Chrome call my#ui#launch_browser('chrome')
command! Safari call my#ui#launch_browser('safari')
LCAlias Ie Firefox Opera Chrome Safari

" TSV {{{3
command! -range Tsvtosqlwhere      <line1>,<line2>call my#tsv#to_sqlwhere()
command! -range Tsvtosqlin         <line1>,<line2>call my#tsv#to_sqlin()
command! -range Tsvexchangematrix <line1>,<line2>call my#tsv#exchange_matrix()
command! -range Tsvtosqlinsert     <line1>,<line2>call my#tsv#to_sqlinsert()
command! -range Tsvtosqlupdate     <line1>,<line2>call my#tsv#to_sqlupdate()

" MySQL {{{3
command! -nargs=0 -range TMY <line1>,<line2>call my#mysql#to_tsv()
command! -nargs=0 -range MySQLToTsv <line1>,<line2>call my#mysql#to_tsv()

" padding {{{3
command! -nargs=? -range PadNumber <line1>,<line2>call my#padding#number(<f-args>)
command! -nargs=? -range PadString <line1>,<line2>call my#padding#string(<f-args>)
command! -nargs=? -range PadSprintf <line1>,<line2>call my#padding#sprintf(<f-args>)

" buffer grep {{{3
command! -nargs=? BGY call my#bufgrep#yank(<q-args>)
command! -nargs=? BG call my#bufgrep#enew(<q-args>)

" capture {{{3
command!
      \ -nargs=+ -complete=command
      \ Capture
      \ call my#ui#cmd_capture(<q-args>)

" }}}1

let g:loaded_dot_vimrc=1
" vim: set fdm=marker sw=2 ts=2 et:
