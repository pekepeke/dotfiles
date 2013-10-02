" basic settings "{{{1
scriptencoding utf-8

set columns=100
set lines=70
set cmdheight=1
" set guioptions-=T
" set nohlsearch
" set guioptions+=a
" set mouse=a
" set nomousefocus
" set mousehide

" autocmd BufReadPost * tab ball

" environment settings "{{{1
let s:is_mac = has('mac') || has('macunix') || has('gui_macvim') ||
      \ (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')

if s:is_win " {{{2
  "set guifont=MS_Gothic:h10:cSHIFTJIS
  "set guifont=MeiryoConsolas:h9:cSHIFTJIS
  "set guifont=Anonymous\ Pro:h10,Lucida_Console:h10:w5 guifontwide=MS_Gothic:h10
  command! -nargs=0 Consolas set guifont=Consolas:h10,Lucida_Console:h10:w5 guifontwide=MS_Gothic:h10
  command! -nargs=0 Ricty set guifont=Ricty:h11 guifontwide=Ricty:h11
  " command! -nargs=0 Ricty set guifont=Ricty:h12 guifontwide=Ricty:h12

  MyAutocmd GUIEnter * set transparency=210

  if filereadable($WINDIR . '\Fonts\Ricty-Regular.ttf')
    Ricty
  else
    Consolas
  endif

  if has('directx') && &encoding == 'utf-8'
    silent! exe 'set' 'renderoptions=type:directx'
  endif

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

elseif s:is_mac "{{{2
  if exists('&macatsui')
    set nomacatsui
  endif
  if has('gui_macvim')
    " fonts {{{3
    command! -nargs=0 Osaka set noantialias guifont=Osaka-Mono:h14 guifontwide=Osaka-Mono:h14
    command! -nargs=0 OsakaAnti set antialias guifont=Osaka-Mono:h14 guifontwide=Osaka-Mono:h14
    command! -nargs=0 OsakaMonaco set antialias guifont=Monaco:h12 guifontwide=Osaka-Mono:h12
    " command! -nargs=0 Monaco set antialias guifont=Monaco:h12 guifontwide=Hiragino\ Kaku\ Gothic\ Pro:h14
    command! -nargs=0 Monaco set antialias guifont=Monaco:h12 guifontwide=HiraKakuPro-W3:h14
    command! -nargs=0 Menlo set antialias guifont=Menlo:h12 guifontwide=HiraKakuPro-W3:h14
    command! -nargs=0 Ricty set antialias guifont=Ricty:h14 guifontwide=Ricty:h14
    " Monaco
    " OsakaMonaco
    Ricty

    " etc settings {{{3
    if has('printer')
      set printfont=Osaka-Mono:h14
    endif

    set transparency=10
    augroup gvimrc-hack234
      autocmd!
      if has('mac')
        autocmd FocusGained * set transparency=10
        autocmd FocusLost * set transparency=50
      endif
    augroup END
    set imdisable " Disable IM
    set guioptions=e

    " full screen
    set fuoptions=maxvert,maxhorz
    " MyAutocmd GUIEnter * set fullscreen

    " keybinds {{{3
    function! s:set_transparency(ope)
      execute "let newval = &transparency " . a:ope . " " . 10
      let newval = (newval <   0) ? 0   : newval
      let newval = (newval > 100) ? 100 : newval
      let &transparency = newval
    endfunction

    nnoremap <silent> gwn :macaction selectNextWindow:<CR>
    nnoremap <silent> gwp :macaction selectPreviousWindow:<CR>

    inoremap <silent> <Esc> <Esc>:set iminsert=0<CR>

    nnoremap <C-D-=> :<C-u>call <SID>set_transparency("+")<CR>
    nnoremap <C-D--> :<C-u>call <SID>set_transparency("-")<CR>

    nnoremap <S-LeftMouse> :<C-u>help<Space><C-r><C-W><CR>
    nnoremap <D-Up> zk
    nnoremap <D-Down> zj

    " unbind menu keys {{{3
    macmenu File.New\ Tab key=<nop>

  endif
else " unix setting {{{2
  set guioptions=te

  "set guifont=VL\ ゴシック\ 12
  command! -nargs=0 Inconsolata set guifont=Inconsolata\ 11
  command! -nargs=0 Ricty set guifont=Ricty\ 14
endif
"source $HOME/.vimrc

" some commands {{{1
function! s:make_gvimrc_first()
  call writefile(["let g:gvimrc_local_finish = 1"], $VIM . '/gvimrc_local.vim')
endfunction
command! -nargs=0 MkGvimrcfirst call s:make_gvimrc_first()


" __END__ {{{1
