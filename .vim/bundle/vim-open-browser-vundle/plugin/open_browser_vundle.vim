if v:version < 700
  echoerr 'does not work this version of Vim(' . v:version . ')'
  finish
elseif exists('g:loaded_open_browser_vundle')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

let g:openbrowser_vundle_debug = get(g:, ':openbrowser_vundle_debug', 0)
let g:openbrowser_vundle_no_default_keymappings = get(g:, 'openbrowser_vundle_no_default_keymappings', 0)
let g:openbrowser_vundle_fallback = get(g:, 'openbrowser_vundle_fallback', 0)

command! -nargs=0 OpenBrowserVundle call openbrowser#vundle#open()
nnoremap <Plug>(openbrowser-vundle) :<C-u>call openbrowser#vundle#open()<CR>
vnoremap <Plug>(openbrowser-vundle) :<C-u>call openbrowser#vundle#open()<CR>

if !g:openbrowser_vundle_no_default_keymappings
  augroup plugin-openbrowser-vundle
    autocmd!
    autocmd FileType vim nmap <buffer> gx <Plug>(openbrowser-vundle)
  augroup END
endif

let &cpo = s:save_cpo "{{{2
unlet s:save_cpo


" __END__ {{{1
