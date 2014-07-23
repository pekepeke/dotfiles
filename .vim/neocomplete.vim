" options {{{4
let g:neocomplete#data_directory = $VIM_CACHE . '/neocomplete'
let g:neocomplete#enable_at_startup                   = 1
let g:neocomplete#cursor_hold_i_time                  = 500
let g:neocomplete#max_list = 100  " 補完候補の数
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
let g:neocomplete#force_omni_input_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplete#force_omni_input_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
" let g:neocomplete#force_omni_input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
let g:neocomplete#force_omni_input_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplete#force_omni_input_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" perl
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" ruby
let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

" python
let g:neocomplete#force_omni_input_patterns.python = '[^. \t]\.\w*'
let g:neocomplete#force_omni_input_patterns.python = '\%([^. \t]\.\|^\s*@\|^\s*from\s.\+import \|^\s*from \|^\s*import \)\w*'

" scala
let g:neocomplete#sources#include#patterns.scala = '^import'

let s:bundle = VimrcScope().bundle
" javascript
if s:bundle.is_installed('tern_for_vim')
  let g:neocomplete#sources#omni#functions.javascript = 'tern#Complete'
  let g:neocomplete#sources#omni#functions.coffee = 'tern#Complete'
  " MyAutoCmd FileType coffee call tern#Enable()
elseif s:bundle.is_installed('vim-nodejs-complete')
  let g:neocomplete#sources#omni#functions.javascript = 'nodejscomplete#CompleteJS'
endif
" let g:neocomplete#sources#omni#functions.javascript = 'jscomplete#CompleteJS'
let g:neocomplete#sources#omni#input_patterns.javascript =
  \ '\h\w*\|[^. \t]\.\w*'
let g:neocomplete#sources#omni#input_patterns.coffee =
  \ '\h\w*\|[^. \t]\.\w*'

" haxe
let g:neocomplete#sources#omni#input_patterns.haxe = '\v([\]''"]|\w)(\.|\()\w*'

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
  let g:neocomplete#sources#omni#input_patterns.r = '[[:alnum:].\\]\+'
  let g:neocomplete#sources#omni#functions.r = 'rcomplete#CompleteR'
endif

" XQuery
if s:bundle.is_installed('XQuery-indentomnicomplete')
  let g:neocomplete#sources#omni#input_patterns.xquery =
        \ '\k\|:\|\-\|&'
  let g:neocomplete#sources#omni#functions.xquery =
        \ 'xquerycomplete#CompleteXQuery'
endif

" autohotkey
let g:neocomplete#sources#include#paths.autohotkey = '.,,'
let g:neocomplete#sources#include#patterns.autohotkey = '^\s*#\s*include'
let g:neocomplete#sources#include#exprs.autohotkey = ''

" }}}

" <CR>: close popup and save indent.
imap <silent><expr> <CR> (pumvisible()?neocomplete#close_popup():"")
      \ ."\<Plug>(smartinput_CR)\<C-r>=endwize#crend()\<CR>"

" <C-h>, <BS>: close popup and delete backword char.
if s:bundle.is_installed('vim-smartinput')
  imap <expr> <C-h>  neocomplete#smart_close_popup()
        \ . "\<Plug>(smartinput_BS)"
  imap <expr> <BS>   neocomplete#smart_close_popup()
        \ . "\<Plug>(smartinput_C-h)"
  " imap <expr> <C-h>  neocomplete#cancel_popup()
  "       \ . "\<Plug>(smartinput_BS)"
  " imap <expr> <BS>   neocomplete#cancel_popup()
  "       \ . "\<Plug>(smartinput_C-h)"
else
  " inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
  " inoremap <expr><BS>   neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-h>  neocomplete#cancel_popup()."\<C-h>"
  inoremap <expr><BS>   neocomplete#cancel_popup()."\<C-h>"
endif

" inoremap <expr> <C-y>  neocomplete#close_popup()
inoremap <expr> <C-e> pumvisible() ? neocomplete#cancel_popup() : "\<End>"

inoremap <expr> <C-j> pumvisible() ? neocomplete#close_popup() : "\<CR>"

imap <C-s> <Plug>(neocomplete_start_unite_complete)

nnoremap [!space]ne :NeocompleteEnable<CR>
nnoremap [!space]nd :NeocompleteDisable<CR>


