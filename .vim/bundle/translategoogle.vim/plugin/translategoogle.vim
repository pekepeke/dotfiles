" File: translategoogle.vim
" Author: daisuzu <daisuzu@gmail.com>

if exists('g:loaded_translategoogle')
  finish
endif
let g:loaded_translategoogle = 1

let s:save_cpo = &cpo
set cpo&vim

let g:translategoogle_languages =
            \ get(g:, 'translategoogle_languages', ['ja', 'en'])
let g:translategoogle_default_sl =
            \ get(g:, 'translategoogle_default_sl', 'en')
let g:translategoogle_default_tl =
            \ get(g:, 'translategoogle_default_tl', 'ja')
let g:translategoogle_default_ie =
            \ get(g:, 'translategoogle_default_ie', 'UTF-8')
let g:translategoogle_default_oe =
            \ get(g:, 'translategoogle_default_oe', 'UTF-8')
let g:translategoogle_default_opener_before =
            \ get(g:, 'translategoogle_default_opener_before', '8split')
let g:translategoogle_default_opener_after =
            \ get(g:, 'translategoogle_default_opener_after', 'rightbelow vsplit')
let g:translategoogle_default_opener_retrans =
            \ get(g:, 'translategoogle_default_opener_retrans', 'rightbelow vsplit')
let g:translategoogle_enable_retranslate =
            \ get(g:, 'translategoogle_enable_retranslate', 0)
let g:translategoogle_mapping_close =
            \ get(g:, 'translategoogle_mapping_close', 'q')

command! TranslateGoogle call translategoogle#open()
command! TranslateGoogleExchange call translategoogle#exchange()
command! -nargs=* -complete=customlist,translategoogle#complete_command
            \ TranslateGoogleCmd echo translategoogle#command(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
