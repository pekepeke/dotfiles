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
set rtp+=~/.vim/vundle.git
call vundle#rc(expand("$HOME/.vim/vundle"))

Bundle 'Shougo/neocomplcache.git'
Bundle 'Shougo/vimfiler.git'
Bundle 'Shougo/vimproc.git'
Bundle 'Shougo/vimshell.git'
Bundle 'kana/vim-fakeclip.git'
Bundle 'kana/vim-scratch.git'
Bundle 'kana/vim-smartchr.git'
Bundle 'kana/vim-submode.git'
Bundle 'tyru/vim-altercmd.git'
Bundle 'tpope/vim-surround.git'
Bundle 'ujihisa/camelcasemotion.git'
Bundle 'h1mesuke/vim-alignta.git'
Bundle 'chrismetcalf/vim-yankring.git'
Bundle 'smartword'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'matchit.zip'
Bundle 'ruby-matchit'

Bundle 'tyru/open-browser.vim.git'
Bundle 'mattn/googletranslate-vim.git'
Bundle 'ujihisa/shadow.vim.git'
Bundle 'tsukkee/lingr-vim.git'
Bundle 'thinca/vim-quickrun.git'
Bundle 'tyru/current-func-info.vim.git'
Bundle 'vim-scripts/errormarker.vim.git'
Bundle 'thinca/vim-template.git'
Bundle 'mexpolk/vim-taglist.git'
Bundle 'mattn/zencoding-vim.git'
Bundle 'mattn/gist-vim.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'scrooloose/nerdtree.git'
Bundle 'thinca/vim-qfreplace.git'
Bundle 'mileszs/ack.vim.git'
"Bundle 'motemen/git-vim.git'
Bundle 'tpope/vim-fugitive.git'

Bundle 'motemen/hatena-vim.git'
Bundle 'lukaszb/vim-web-indent.git'
Bundle 'othree/html5.vim.git'
Bundle 'hail2u/vim-css3-syntax.git'
Bundle 'cakebaker/scss-syntax.vim.git'
Bundle 'kchmck/vim-coffee-script.git'
Bundle 'pangloss/vim-javascript.git'
Bundle 'pekepeke/titanium-vim.git'
Bundle 'graywh/vim-haml.git'
Bundle 'ciaranm/detectindent.git'
Bundle 'thinca/vim-ft-diff_fold.git'
Bundle 'thinca/vim-ft-markdown_fold.git'
Bundle 'timcharper/textile.vim.git'
Bundle 'pekepeke/cocoa.vim.git'

Bundle 'tpope/vim-rails.git'
Bundle 'vim-scripts/eruby.vim.git'
"Bundle 'astashov/vim-ruby-debugger.git'

Bundle 'dbext.vim'
Bundle 'SQLUtilities'
Bundle 'php-doc'
"Bundle 'OmniCppComplete'

Bundle 'thinca/vim-ref.git'
Bundle 'pekepeke/ref-javadoc.git'
Bundle 'soh335/vim-ref-jquery.git'

Bundle 'kana/vim-operator-replace.git'
Bundle 'kana/vim-operator-user.git'
Bundle 'tyru/operator-camelize.vim.git'
Bundle 'tyru/operator-html-escape.vim.git'

Bundle 'kana/vim-textobj-datetime.git'
Bundle 'kana/vim-textobj-diff.git'
Bundle 'kana/vim-textobj-entire.git'
Bundle 'kana/vim-textobj-fold.git'
Bundle 'kana/vim-textobj-function.git'
Bundle 'kana/vim-textobj-jabraces.git'
Bundle 'kana/vim-textobj-lastpat.git'
Bundle 'kana/vim-textobj-syntax.git'
Bundle 'kana/vim-textobj-user.git'
Bundle 'thinca/vim-textobj-between.git'
Bundle 'thinca/vim-textobj-comment.git'
Bundle 'thinca/vim-textobj-function-javascript.git'
Bundle 'thinca/vim-textobj-function-perl.git'
Bundle 'vim-scripts/textobj-indent.git'

Bundle 'Shougo/unite.vim.git'
"Bundle 'Sixeight/unite-grep.git'
Bundle 'Shougo/unite-grep.git'
Bundle 'h1mesuke/unite-outline.git'
Bundle 'hakobe/unite-script.git'
Bundle 'mattn/unite-remotefile.git'
Bundle 'pekepeke/unite-fileline.git'
Bundle 'sgur/unite-git_grep.git'
Bundle 'sgur/unite-qf.git'
Bundle 'soh335/unite-qflist.git'
Bundle 'tacroe/unite-alias.git'
Bundle 'tacroe/unite-mark.git'
Bundle 'thinca/vim-unite-history.git'
Bundle 'tsukkee/unite-tag.git'
Bundle 'ujihisa/unite-colorscheme.git'
Bundle 'ujihisa/unite-font.git'
Bundle 'ujihisa/unite-gem.git'
Bundle 'ujihisa/unite-help.git'
Bundle 'ujihisa/unite-rake.git'
Bundle 'basyura/unite-rails.git'
Bundle 'basyura/unite-yarm.git'

if s:is_win
  Bundle 'sgur/unite-everything.git'
else
  Bundle 'ujihisa/neco-look.git'
  Bundle 'ujihisa/unite-locate.git'
endif

" pathogen {{{1
let g:pathogen_disabled = []
if !s:is_mac | let g:pathogen_disabled += ['cocoa.vim'] | endif
call pathogen#runtime_append_all_bundles()

command! PathogenHelptags call pathogen#helptags()

" afterexec for runtimepath {{{1
syntax enable
filetype plugin indent on

" vim git 更新
if executable('sh') && executable('git')
  "command! BundlesUpdate exe "!sh $HOME/.vim/bin/update_bundles.sh" | call pathogen#helptags()
  command! UpdateSubmodule exe "! cd $HOME/.github-dotfiles && git submodule foreach 'git fetch;git checkout origin/master'" | call pathogen#helptags()
endif
if executable('sh')
  function! s:vimproc_compile()
    let path = expand('$HOME/.vim/vundle/vimproc')
    let makefile = s:is_win ? 'make_cygwin.mak' :
          \ (s:is_mac ? 'make_mac.mak' : 'make_gcc.mak')

    exe printf("! cd %s && make -f %s/%s", path, path, makefile)
  endfunction
  command! -nargs=0 VimprocCompile call <SID>vimproc_compile()
endif

" color settings "{{{1
"set t_Co=256
if &t_Co == 256 || s:is_win || has('gui')
  " must be write .gvimrc
  colorscheme vividchalk
  "colorscheme mrkn256
  "colorscheme lucius
else
  colorscheme wombat
  "colorscheme desert
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
set mouse=a

set shellslash
set directory=~/.tmp,/var/tmp,/tmp

" IME の設定 {{{2
if has('kaoriya') | set iminsert=0 imsearch=0 | endif

"MyAutocmd BufEnter * if isdirectory(expand('%:p:h')) | execute ":lcd " . expand("%:p:h") | endif
MyAutocmd BufEnter * call LcdCurrentOrProjDir()
function! LcdCurrentOrProjDir() "{{{3
  let pdir = my#util#find_proj_dir()
  if pdir != ''
    execute 'lcd' fnameescape(pdir)
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
command! -nargs=0 StickyShiftEnable let g:sticky_shift_enable=1
command! -nargs=0 StickyShiftDisable let g:sticky_shift_enable=0

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

set laststatus=2  " ステータス表示用変数
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'}%=%l,%c%V%8P
let &statusline="%<%f %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']['.&ft.']'
      \ .'['.cfi#format('%s()','no func').']'
      \ }%=%l,%c%V%8P"

" statusline {{{2
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
set wildmode=list:longest,full               " zsh like complete
set wildchar=<tab>
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
nnoremap [space]= call <SID>IndentWholeBuffer()
function! s:IndentWholeBuffer() " {{{3
  let l:p = getpos(".")
  normal gg=G
  call setpos(".", l:p)
endfunction "}}}

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

nnoremap [edit]f :NERDTreeToggle<CR>
nnoremap <silent> [edit]<C-t> :TlistToggle<CR>

nnoremap / :<C-u>nohlsearch<CR>/
nnoremap ? :<C-u>nohlsearch<CR>?

" echo
nnoremap [prefix]e :echo<Space>

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

" cmaps {{{2
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-]>a <Home>
cnoremap <C-]>e <End>
"cnoremap <C-]>f <C-f>
cnoremap <C-]>f <S-Right>
cnoremap <C-]>b <S-Left>
cnoremap <C-]>d <Delete>
cnoremap <C-]><C-a> <Home>
cnoremap <C-]><C-e> <End>
cnoremap <C-]><C-f> <S-Right>
cnoremap <C-]><C-b> <S-Left>
cnoremap <C-]><C-d> <Delete>

Lazy cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/

" vmaps {{{2
vnoremap tj    :GoogleTranslate ja<CR>
vnoremap te    :GoogleTranslate en<CR>
vnoremap <Tab>   >gv
vnoremap <S-Tab> <gv
"nnoremap : q:

" plugin settings {{{1

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

" easymotion {{{2
let g:EasyMotion_leader_key = '[prefix]f'

" smartword {{{2
nmap w  <Plug>(smartword-w)
nmap b  <Plug>(smartword-b)
nmap e  <Plug>(smartword-e)
nmap ge <Plug>(smartword-ge)
vmap w  <Plug>(smartword-w)
vmap b  <Plug>(smartword-b)
vmap e  <Plug>(smartword-e)
vmap ge <Plug>(smartword-ge)

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
call submode#enter_with('winmove', 'n', '', '[s]e', '<Nop>')
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
" let g:unite_source_grep_command = 'ack'
" let g:unite_source_grep_default_opts = '-iH --nocolor --nogroup'
let g:unite_source_grep_default_opts = '-iRHn'

" unite mappings {{{3

nnoremap <silent> [unite][buffer]   :<C-u>Unite buffer tab<CR>
nnoremap <silent> [unite][file]     :<C-u>Unite -buffer-name=file file<CR>
nnoremap <silent> [unite][rel_file] :<C-u>Unite file -buffer-name=file -input=<C-r>=fnameescape(expand('%:p:h'))<CR>/<CR>
nnoremap <silent> [unite][mru]      :<C-u>Unite -buffer-name=file file_mru directory_mru bookmark -default-action=open<CR>
nnoremap <silent> [unite][source]   :<C-u>Unite source<CR>
nnoremap [unite][empty]    :<C-u>Unite<Space>

nmap [unite]u                [unite][empty]
nmap [unite]uu               [unite][empty]
nmap [unite]us               [unite][source]
nmap <silent> [unite]<Space> [unite][buffer]
nmap <silent> [unite]j       [unite][buffer]
nmap <silent> [unite]l       [unite][rel_file]
nmap <silent> [unite]m       [unite][mru]
nmap <silent> [unite]d       [unite][file]
nmap <silent> [unite]k       [unite][file]

nnoremap <silent> [unite]a  :<C-u>Unite file_rec -start-insert<CR>
nnoremap <silent> [unite]o  :<C-u>Unite tag outline<CR>
nnoremap <silent> [unite]gg :<C-u>Unite grep -buffer-name=grep<CR>
nnoremap <silent> [unite]gi :<C-u>Unite git_grep -buffer-name=git<CR>
nnoremap <silent> [unite]q  :<C-u>Unite qf -buffer-name=qf<CR>
nnoremap <silent> [unite]c  :<C-u>Unite command history/command<CR>
nnoremap <silent> [unite]/  :<C-u>Unite history/search history/command<CR>
nnoremap <silent> [unite]bb :<C-u>Unite bookmark<CR>
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

  let tilang = ['timobileref', 'tidesktopref']
  if ft == 'php'
    let names = ['phpmanual'] + tilang
  elseif ft == 'ruby'
    let names = ['refe'] + tilang
  elseif ft == 'python'
    let names = ['pydoc'] + tilang
  elseif ft == 'perl'
    let names = ['perldoc']
  elseif ft == 'javascript'
    let names = ['jsref'] + tilang
  elseif ft == 'java'
    let names = ['javadoc', 'androiddoc']
  elseif ft == 'erlang'
    let names = ['erlang']
  endif
  let ref_names = ref#available_source_names()
  execute 'Unite'
        \ '-input='.kwd
        \ join(map(filter(names, 'index(ref_names, v:val)') + ['man'],
        \ '"ref/".v:val'), ' ')
endfunction "}}}
nnoremap          [unite]rr :<C-u>UniteResume<Space>
nnoremap <silent> [unite]re :<C-u>UniteResume<CR>
nnoremap <silent> [unite]ri :<C-u>UniteResume git<CR>
nnoremap <silent> [unite]rg :<C-u>UniteResume grep<CR>
nnoremap <silent> [unite]rq :<C-u>UniteResume qf<CR>

nmap <silent> [space]f       [unite][buffer]
nmap <silent> [space]d       [unite][file]

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
nnoremap [space]gd :<C-u>Gdiff --cached<Enter>
nnoremap [space]gD :<C-u>Gdiff<Enter>
nnoremap [space]gs :<C-u>Gstatus<Enter>
nnoremap [space]gl :<C-u>Glog<Enter>
nnoremap [space]gL :<C-u>Glog -u \| head -10000<Enter>
nnoremap [space]ga :<C-u>Gwrite<Enter>
nnoremap [space]gA :<C-u>Gwrite <cfile><Enter>
nnoremap [space]gc :<C-u>Gcommit<Enter>
nnoremap [space]gC :<C-u>Gcommit --amend<Enter>
nnoremap [space]gr :<C-u>Ggrep<CR>
nnoremap [space]gr :<C-u>Ggrep<CR>
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
let g:quickrun_config['ruby.rspec'] = {'command' : 'rspec -l {line(".")}'}
" html {{{3
if s:is_mac
  let g:quickrun_config['html'] = {'command' : 'open %s'}
  let g:quickrun_config['xhtml'] = {'command' : 'open %s'}
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
    let g:quickrun_config['markdown'] = {
          \ 'command' : 'ruby ' . $HOME . '/bin/mkd2html.rb' ,
          \ 'exec' : [
          \   '%c %s',
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
command! -nargs=0 Ctags call Ctags()
function! Ctags() "{{{3
  let cmdname = my#util#has_plugin('vimproc') != '' ? 'VimProcBang' : '!'
  execute cmdname 'ctags -R'
  NeoComplCacheCachingTags
endfunction

" surround.vim {{{2
nmap [s]s <Plug>Ysurround

let g:surround_{char2nr('g')} = "_('\r')"
let g:surround_{char2nr('G')} = "_(\"\r\")"

" operator {{{2
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
  MyAutocmd FileType html,mardown setl omnifunc=htmlcomplete#CompleteTags
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
  let path = expand('~/.vim/vundle/vimproc/autoload/proc.so')
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

" vimfiler {{{2
let g:vimfiler_as_default_explorer=1
let g:vimfiler_safe_mode_by_default=0
let g:vimfiler_edit_command = 'new'

MyAutocmd FileType vimfiler call s:vimfiler_my_settings()

function! MyVimfilerYankPath() " {{{3
  " let l:register = v:register "'0'
  let l:register = &clipboard == "unnamed" ? '*' : '0'
  let l:path = vimfiler#get_filename(line('.'))
  if l:path == '' || l:path == '..'
    return
  endif
  "let l:mode = input('yank - [f]ilename, [p]ath, [d]ir path, [e]xt : ', '')
  echo 'yank - [f]ilename, [p]ath, [d]ir path, [e]xt : '
  let l:mode = nr2char(getchar())
  let l:copy_str = ''
  if l:mode ==# 'f'
    let l:copy_str = fnamemodify(l:path,  ':t')
  elseif l:mode ==# 'p'
    let l:copy_str = l:path
  elseif l:mode ==# 'd'
    let l:copy_str = fnamemodify(l:path,  ':p:h')
  elseif l:mode ==# 'e'
    let l:copy_str = fnamemodify(l:path,  ':e')
  endif

  if l:copy_str !=# ''
    call setreg(l:register, l:copy_str)
    echo 'yank to ['.l:register.']:' . l:copy_str
  else
    echo 'yank is canceled'
  endif
endfunction

function! s:vimfiler_my_settings() " {{{3
  nnoremap <buffer> Y :call MyVimfilerYankPath()<CR>
  nmap <buffer> L <Plug>(vimfiler_move_to_history_forward)
  nmap <buffer> H <Plug>(vimfiler_move_to_history_back)
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
command! ToSass silent exe '!css2sass ' . expand('%:p') . ' ' . expand('%:p:h').'.sass' | exe 'new' expand('%:p:h').'.sass'
command! TrimRSpace %s/ \+$//

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
  function! s:chm_complete(A, L, P) " {{{3
    let items = map(split(globpath(g:my_chm_dir, "/*.chm"), "\n"), 'matchstr(v:val, "[^/]\\+$")')
    if s:is_win
      call add(items, 'ntcmds.chm')
    endif
    let matches = []
    for item in items
      if item =~? '^' . a:A
        call add(matches, item)
      endif
    endfor
    return matches
  endfunction
  function! s:chm_open(fname) " {{{3
    let l:chm_path = g:my_chm_dir . "/" . a:fname
    if !filereadable(l:chm_path)
      let l:chm_path = a:fname
    endif
    if s:is_win
      silent exe '! start hh' l:chm_path
    else
      silent exe "!" g:my_chm_command l:chm_path
    endif
  endfunction
  " }}}
  command! -nargs=1 -complete=customlist,s:chm_complete Chm call s:chm_open("<args>")
  LCAlias Chm
endif
function! s:cheatsheet_complete(A, L, P) "{{{3
  let items = map(split(globpath(g:my_cheatsheets_dir, "/*"), "\n"), 'matchstr(v:val, "[^/]\\+$")')
  let matches = []
  for item in items
    "if item =~? '^' . a:A
    if item =~? a:A
      call add(matches, item)
    endif
  endfor
  return matches
endfunction " }}}
function! s:cheatsheet_open(fname) "{{{3
  let l:path = g:my_cheatsheets_dir . "/" . a:fname
  if !filereadable(l:path)
    let l:path = a:fname
  endif
  if s:is_win
    silent exe '! start hh' l:path
  elseif s:is_mac
    silent exe '! open' l:path
  else
    silent exe '!' l:path
  endif
endfunction " }}}
command! -nargs=1 -complete=customlist,s:cheatsheet_complete CheatSheet call s:cheatsheet_open("<args>")
LCAlias CheatSheet

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
function! s:my_rename(path) " {{{3
  let path = a:path
  if stridx(path, "/") < 0 || stridx(path, "\\")
    let path = expand("%:p:h") . "/" . path
  endif
  exe "f" path | call delete(expand('#')) | w
endfunction "}}}
"command! -nargs=1 -complete=file Rename f <args> | call delete(expand('#')) | w
command! -nargs=1 -complete=file Rename call s:my_rename(<f-args>)
Alias ren Rename

function! s:relative_copy(dst) "{{{3
  let fpath = expand('%')
  if !filereadable(fpath)
    echo 'file is cannot readable'
    "return
  endif
  let dpath = stridx(a:dst, '/') < 0 ? expand('%:p:h').'/'.a:dst : a:dst
  if filereadable(dpath)
    let res = input('dpath is already exists. overwrite ? [y/n]:')
    if res !=? 'y' | return | endif
    " echo 'dpath is already exists. overwrite?[y/n]'
    " let ch = getchar()
    " if nr2char(ch) !=? "y" | return | endif
  endif
  let cmd = s:is_win ? 'copy' : 'cp'
  execute '!' cmd fpath dpath
endfunction "}}}
command! -nargs=1 -complete=file Relcp call s:relative_copy(<f-args>)
LCAlias Relcp

" toggle window maximize {{{2
" defun object {{{3
let WinMaximizer = {
      \ 'is_maximize' : 0 ,
      \ 'max_lines' : 0,
      \ 'max_columns' : 0,
      \ }
function! WinMaximizer.maximize() "{{{4
  winpos 0 0
  exe 'set lines=' . (self.max_lines == 0 ? 9999: self.max_lines)
        \ . ' columns=' . (self.max_columns == 0 ? 9999 : self.max_columns)
endfunction
function! WinMaximizer.set_max_pos() "{{{4
  if self.max_lines == 0
    let self.max_lines = &lines
    let self.max_columns = &columns
  endif
endfunction
function! WinMaximizer.store() "{{{4
  let self.winx = getwinposx()
  let self.winy = getwinposy()
  let self.lines = &lines
  let self.columns = &columns
  " let self._restore = winsaveview()
endfunction
function! WinMaximizer.restore() "{{{4
  execute 'set lines=' . self.lines . ' columns=' . self.columns
  execute 'winpos ' . self.winx . ' ' . self.winy
  " call winrestview(self._restore)
endfunction

function! WinMaximizer.toggle() "{{{4
  if s:is_win
    simalt ~r | simalt ~x
  elseif s:is_mac
    silent execute 'set' (&fullscreen?'no':'').'fullscreen'
  else
    if self.is_maximize
      call self.set_max_pos()
      call self.restore()
      let self.is_maximize = 0
    else
      call self.store()
      call self.maximize()
      let self.is_maximize = 1
      redraw!
    endif
  endif
endfunction 
" }}}3 }}}
nnoremap [prefix]m :call WinMaximizer.toggle()<CR>

" fopen & encoding {{{2
function! s:encodings(A, L, P) "{{{3
  let encodings = ['utf-8', 'sjis', 'euc-jp', 'iso-2022-jp']
  let matches = []

  for encoding in encodings
    if encoding =~? '^' . a:A
      call add(matches, encoding)
    endif
  endfor

  return matches
endfunction 
" }}}
command! -nargs=1 -complete=customlist,s:encodings Fenc setl fenc=<args>
command! -nargs=1 -complete=customlist,s:encodings Freopen e ++enc=<args> %

command! Utf8 e ++enc=utf-8 %
command! Euc e ++enc=euc-jp %
command! Sjis e ++enc=cp932 %
command! Jis e ++enc=iso-2022-jp %
command! Dos e ++ff=dos %
command! Mac e ++ff=mac %
command! Unix e ++ff=unix %
command! Ccd if isdirectory(expand('%:p:h')) | execute ":lcd " . expand("%:p:h") | endif
LCAlias Utf8 Euc Sjis Jis Ccd

" utility {{{2
" 選択範囲をブラウザで起動 {{{3
if s:is_win
  "let g:my_browserpreview_cmd = ' start chrome.exe'
  let g:my_browserpreview_cmd = ' start ' . expand('$LOCALAPPDATA/Google/Chrome/Application/chrome.exe')
elseif s:is_mac
  let g:my_browserpreview_cmd = 'open -a "Google Chrome"'
else
  let g:my_browserpreview_cmd = 'firefox'
endif
function! MyBrowserpreview() range "{{{4
  if !exists('g:my_browserpreview_cmd')
    echoerr "command not found."
    return
  endif
  let cmd = g:my_browserpreview_cmd
  if ! &modified && &buftype != 'nofile'
    let fpath = expand('%:p')
    silent execute "!" cmd fpath
    redraw!
    return
  endif
  let lines = a:firstline == a:lastline 
        \ ? getline(1, "$") : getline(a:firstline, a:lastline)
  "let lines = a:lines
  if empty(lines)
    echo "empty buffer : stop execute!!"
    return
  endif

  let fpath = tempname() . '.html'
  call writefile(lines, fpath)
  silent execute "!" cmd fpath
  " FIXME いい方法はないものか？
  silent execute "sleep 2"
  if filewritable(fpath) | call delete(fpath) | endif
  redraw!
endfunction 
" }}}
command! -range Brpreview <line1>,<line2>call MyBrowserpreview()

" browser {{{3
function! s:launch_browser(appname) "{{{4
  let path = ""
  if a:appname == "ie"
    if s:is_win
      let path = ' start '.expand('$ProgramFiles/Internet Explorer/iexplore.exe')
    endif
  elseif a:appname == "firefox"
    if s:is_win
      let path = ' start '.expand('$ProgramFiles/Firefox/firefox.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Firefox/firefox.exe')
      endif
    elseif s:is_mac
      let path = 'open -a "Firefox"'
    else
      let path = 'firefox'
    endif
  elseif a:appname == "opera"
    if s:is_win
      let path = ' start '.expand('$ProgramFiles/Opera/Opera.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Opera/Opera.exe')
      endif
    elseif s:is_mac
      let path = 'open -a "Opera"'
    else
      let path = 'opera'
    endif
  elseif a:appname == "chrome"
    if s:is_win
      let path = ' start ' . expand('$LOCALAPPDATA/Google/Chrome/Application/chrome.exe')
    elseif s:is_mac
      let path = 'open -a "Google Chrome"'
    else
      let path = 'google-chrome'
    endif
  elseif a:appname == "safari"
    if s:is_win
      let path = ' start '.expand('$ProgramFiles/Safari/safari.exe')
      if !exists(path)
        let path = ' start '.expand('$ProgramFiles(x86)/Safari/safari.exe')
      endif
    elseif s:is_mac
      let path = 'open -a "Safari"'
    else
    endif
  endif
  if len(path) > 0
    silent execute "!" path expand("%:p")
  endif
endfunction "}}}
command! Ie call s:launch_browser('ie')
command! Firefox call s:launch_browser('firefox')
command! Opera call s:launch_browser('opera')
command! Chrome call s:launch_browser('chrome')
command! Safari call s:launch_browser('safari')
LCAlias Ie Firefox Opera Chrome Safari

" TSV {{{3
function! s:tsv_to_sqlwhere() range "{{{4
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    let l:keywords = copy(l:head)
    call map(l:keywords, '[v:val, get(l:items, v:key, "")]')
    let l:where = []
    for [l:name, l:value] in l:keywords
      call add(l:where, l:name . " = '" . l:value . "'")
    endfor
    call add(l:texts, join(l:where, ' AND '))
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! s:tsv_to_sqlin() range "{{{4
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif
  let l:texts = []
  let l:rows = map(copy(l:head), '[v:val]')
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    call map(l:rows, 'v:val + [get(l:items, v:key, "")]')
  endfor
  for l:row in l:rows
    let l:name = remove(l:row, 0)
    call add(l:texts, l:name . " IN ('" . join(l:row, "', '") ."')")
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! s:tsv_exchange_matrix() range "{{{4
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif
  let l:texts = []
  let l:rows = map(copy(l:head), '[v:val]')
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    call map(l:rows, 'v:val + [get(l:items, v:key, "")]')
  endfor
  for l:row in l:rows
    call add(l:texts, join(l:row, "\t"))
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! s:tsv_to_sqlinsert() range "{{{4
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = map(split(l:line, "\t", 1), "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let l:datas = map(copy(l:head), 'get(l:items, v:key, "NULL")')
    call add(l:texts, 'INSERT INTO X ('.join(l:head, ', ').') VALUES ('.join(l:datas, ', ').');')
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! s:tsv_to_sqlupdate() range "{{{4
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:where_ids = map(filter(copy(l:head), 'v:val =~ "^id$"'), 'v:key')
  if empty(l:where_ids)
    let l:where_ids = map(filter(copy(l:head), 'v:val =~ "^.id$"'), 'v:key')
    if empty(l:where_ids)
      let l:where_ids = map(filter(copy(l:head), 'v:val =~ ".\\+_id$"'), 'v:key')
    endif
  endif
  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = map(split(l:line, "\t", 1), "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let l:wheres = []
    for l:where_id in l:where_ids
      call add(l:wheres, l:head[l:where_id] . " = " . get(l:items, l:where_id, "NULL"))
    endfor
    for l:where_id in l:where_ids
      call remove(l:items, l:where_id)
      call remove(l:head, l:where_id)
    endfor
    let l:datas = map(copy(l:head), 'v:val ." = ". get(l:items, v:key, "NULL")')
    call add(l:texts, 'UPDATE X SET '
          \ .join(l:datas, ', ')
          \ .(empty(l:wheres) ? "" : ' WHERE '.join(l:wheres, ' AND ')).";"
          \ )
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction 
" }}}
command! -range Tsvtosqlwhere      <line1>,<line2>call s:tsv_to_sqlwhere()
command! -range Tsvtosqlin         <line1>,<line2>call s:tsv_to_sqlin()
command! -range Tsvexchangematrix <line1>,<line2>call s:tsv_exchange_matrix()
command! -range Tsvtosqlinsert     <line1>,<line2>call s:tsv_to_sqlinsert()
command! -range Tsvtosqlupdate     <line1>,<line2>call s:tsv_to_sqlupdate()

" MySQL {{{3
function! TMY() range " {{{4
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    let s = substitute(s, '^[+\-]\+$', '', 'g')
    let s = substitute(s, '^|\s\+\|\s\+|$', '', 'g')
    let s = substitute(s, '\s\+|\s\+', "\t", 'g')
    call setline(line, s)
  endfor
endfunction "}}}
command! -nargs=0 -range TMY <line1>,<line2>call TMY()
command! -nargs=0 -range MySQLToTsv <line1>,<line2>call TMY()

" padding {{{3
function! PadNumber(...) range "{{{4
  let fmt = a:0 > 0 ? a:1 : '%d. '
  " try format
  try
    call printf(fmt, 0)
  catch
    echohl ErrorMsg
    echon v:exception . "\n"
    echohl Normal
    return 0
  endtry
  for line in range(a:firstline, a:lastline)
    call setline(line, substitute(getline(line),
          \ '^\(\s*\)', '\1'.printf(fmt, line - a:firstline + 1), ''))
  endfor
  redraw!
endfunction
function! PadString(...) range "{{{4
  let str = len(a:000) > 0 ? a:000[0] : '- '
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    if s != ''
      call setline(line, substitute(s, '^\(\s*\)', '\1'.str, ''))
    endif
  endfor
  redraw!
endfunction
function! PadSprintf(...) range " {{{4
  let fmt = len(a:000) > 0 ? a:000[0] : '%'
  try
    call printf(fmt, "")
  catch
    echohl ErrorMsg
    echon v:exception . "\n"
    echohl Normal
    return 0
  endtry
  for line in range(a:firstline, a:lastline)
    let s = getline(line)
    if s != ''
      call setline(line, matchstr(s, '^\s*').printf(fmt, substitute(s, '^\s*', '', '')))
    endif
  endfor
  redraw!
endfunction
" }}}
command! -nargs=? -range PadNumber <line1>,<line2>call PadNumber(<f-args>)
command! -nargs=? -range PadString <line1>,<line2>call PadString(<f-args>)
command! -nargs=? -range PadSprintf <line1>,<line2>call PadSprintf(<f-args>)

" buffer grep {{{3
function! s:buf_grep(args) " {{{4
  if !len(a:args) || strlen(a:args[0]) <= 1 | return | endif
  let args = a:args[0]
  let delim = args[0]
  if delim !=# '/'
    le v:errmsg= 'The delimiter `'.delim."` isn't available, please use `/`."
    echo v:errmsg
    return []
  endif
  let rxp ='^delim\([^delim\\]*\%(\\.[^delim\\]*\)*\)' .
        \      '\(delim.*\)\=$'
  let rxp=substitute(rxp, 'delim', delim, "g")
  let re = substitute(args, rxp, '\1', "")

  let s:buf = []
  silent execute 'g/'.re.'/call add(s:buf,  getline("."))'
  return s:buf
endfunction

function! s:buf_grep_yank(...) " {{{4
  let @+=join(s:bufgrep(a:000), "\n")
endfunction

function! s:buf_grep_enew(...) " {{{4
  let s=join(s:buf_grep(a:000), "\n")
  silent execute 'enew | setl buftype=nofile'
  silent exe 'normal i'.s
endfunction

"}}}
command! -nargs=? BGY call s:buf_grep_yank(<q-args>)
command! -nargs=? BG call s:buf_grep_enew(<q-args>)

" capture {{{3
command!
      \ -nargs=+ -complete=command
      \ Capture
      \ call s:cmd_capture(<q-args>)

function! s:cmd_capture(q_args) "{{{4
  redir => output
  silent execute a:q_args
  redir END
  let output = substitute(output, '^\n\+', '', '')

  belowright new

  silent file `=printf('[Capture: %s]', a:q_args)`
  setlocal buftype=nofile bufhidden=unload noswapfile nobuflisted
  call setline(1, split(output, '\n'))
endfunction
" }}}1

let g:loaded_dot_vimrc=1
" vim: set fdm=marker sw=2 ts=2 et:
