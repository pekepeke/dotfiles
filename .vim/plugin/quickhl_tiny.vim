if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_quickhl_tiny')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim
set shortmess-=S

nnoremap <silent>* *N:cal HiSet()<CR>:cal Hitpop()<CR>
nnoremap <silent># *N:cal HiSet()<CR>:cal Hitpop()<CR>
nnoremap <silent><Leader>q :noh<CR>:cal clearmatches()<CR>:cal popup_clear(s:hitpopid)<CR>

" highlight -----------------------------------
" on word, bright
aug auto_hl_cword
  au!
  au BufEnter,CmdwinEnter * cal HiCwordStart()
aug END
fu! HiCwordStart()
  aug QuickhlCword
    au!
    au! CursorMoved <buffer> cal HiCwordR()
    au! ColorScheme * execute("hi link QuickhlCword CursorLine")
  aug END
  execute("hi link QuickhlCword CursorLine")
endf

fu! HiCwordR()
  silent! 2match none
  exe "2mat QuickhlCword /\\\<". escape(expand('<cword>'), '\/~ .*^[''$') . "\\\>/"
endf

" on search, multi highlight
aug QuickhlManual
  au!
  au! ColorScheme * cal HlIni()
aug END
let s:search_hl= [
    \ "cterm=bold ctermfg=16 ctermbg=153 gui=bold guifg=#ffffff guibg=#0a7383",
    \ "cterm=bold ctermfg=7  ctermbg=1   gui=bold guibg=#a07040 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=2   gui=bold guibg=#4070a0 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=3   gui=bold guibg=#40a070 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=4   gui=bold guibg=#70a040 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=5   gui=bold guibg=#0070e0 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=6   gui=bold guibg=#007020 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=21  gui=bold guibg=#d4a00d guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=22  gui=bold guibg=#06287e guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=45  gui=bold guibg=#5b3674 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=16  gui=bold guibg=#4c8f2f guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=50  gui=bold guibg=#1060a0 guifg=#ffffff",
    \ "cterm=bold ctermfg=7  ctermbg=56  gui=bold guibg=#a0b0c0 guifg=black",
    \ ]
let s:now_hi = 0
fu! HlIni()
  for v in s:search_hl
    exe "hi UserSearchHi" . index(s:search_hl, v) . " " . v
  endfor
endf
cal HlIni()

fu! HiSet() abort
  let cw = expand('<cword>')
  let already = filter(getmatches(), {i, v -> v['pattern'] == cw})
  if len(already) > 0
    cal matchdelete(already[0]['id'])
    retu
  endif
  cal matchadd("UserSearchHi" . s:now_hi, cw)
  let s:now_hi = s:now_hi >= len(s:search_hl)-1 ? 0 : s:now_hi + 1
endf

" hitspop
let s:hitpopid = ''
fu! Hitpop()
  cal popup_clear(s:hitpopid)
  let s:hitpopid = popup_create(expand('<cword>'), #{ border: [], pos: "topleft", line: 1, col: &columns - 15 })
endf

let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_quickhl_tiny = 1

" vim: foldmethod=marker
