" basic settings "{{{
set columns=100
set lines=70
set guioptions-=T
set cmdheight=1
"set nohlsearch

set mouse=a
set nomousefocus
set mousehide
"set guioptions+=a

"colorscheme molokai
colorscheme mrkn256

" autocmd BufReadPost * tab ball
"}}}

" environment settings "{{{
let s:is_mac = has('macunix') || (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

if s:is_win
  "set guifont=MS_Gothic:h10:cSHIFTJIS
  "set guifont=MeiryoConsolas:h9:cSHIFTJIS
  "set guifont=Anonymous\ Pro:h10,Lucida_Console:h10:w5 guifontwide=MS_Gothic:h10
  set guifont=Consolas:h10,Lucida_Console:h10:w5 guifontwide=MS_Gothic:h10

  if has('printer')
    set printfont=MS_Gothic:h12:cSHIFTJIS
  endif
  " if has('iconv')
    " set encoding=cp932
    " set guifont=ProggyCleanTTSZBF:h12,Lucida_Console:h12
    " "set guifontwide=Osaka－等幅:h9,MS_Gothic:h10
    " let &guifont = iconv('Osaka－等幅:h9,MS_Gothic:h10', 'cp932')
  " endif

  set linespace=2 " 行間隔
  "set guioptions=egmrLt
  set guioptions=te
  set transparency=210

  if has('kaoriya')
    set iminsert=0 imsearch=0
    set ambiwidth=auto
  endif

elseif s:is_mac
  if exists('&macatsui')
    set nomacatsui
  endif
  if has('gui_macvim')
    command! -nargs=0 Osaka set noantialias guifont=Osaka-Mono:h14
    command! -nargs=0 Monaco set antialias guifont=Monaco:h12
    command! -nargs=0 Menlo set antialias guifont=Menlo:h12
    Monaco

    if has('printer')
      set printfont=Osaka-Mono:h14
    endif

    set imdisable " Disable IM
    set transparency=10
    set guioptions=e

    " full screen
    set fuoptions=maxvert,maxhorz
    " MyAutocmd GUIEnter * set fullscreen

    nnoremap <silent> gwn :macaction selectNextWindow:<CR>
    nnoremap <silent> gwp :macaction selectPreviousWindow:<CR>

    inoremap <silent> <Esc> <Esc>:set iminsert=0<CR>

    nnoremap <C-D-=> :<C-u>call SetTransparency("+")<CR>
    nnoremap <C-D--> :<C-u>call SetTransparency("-")<CR>

    nnoremap <S-LeftMouse> :<C-u>help<Space><C-r><C-W><CR>
    nnoremap <D-Up> zk
    nnoremap <D-Down> zj

    function! SetTransparency(ope)
      execute "let newval = &transparency " . a:ope . " " . 10
      let newval = (newval <   0) ? 0   : newval
      let newval = (newval > 100) ? 100 : newval
      let &transparency = newval
    endfunction
  endif
else " unix setting
  "set guifont=VL\ ゴシック\ 12
  set guifont=Inconsolata:h14
endif
" }}}

"source $HOME/.vimrc

