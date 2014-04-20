" options {{{1
let g:neocomplcache_temporary_dir = $VIM_CACHE . '/neocomplcache'
let g:neocomplcache_enable_at_startup                   = 1
let g:neocomplcache_cursor_hold_i_time                  = 500
let g:neocomplcache_max_list = 100  " 補完候補の数
let g:neocomplcache_enable_auto_select = 1   " 一番目の候補を自動選択

let g:neocomplcache_enable_smart_case                   = 1
let g:neocomplcache_enable_camel_case_completion        = 0 " camel case off
let g:neocomplcache_enable_underbar_completion          = 1
let g:neocomplcache_disable_caching_file_path_pattern   =
      \ "\.log$\|_history$\|\.howm$\|\.jax$\|\.snippets$"
let g:neocomplcache_lock_buffer_name_pattern            =
      \ '\*ku\*\|\.log$\|\.jax$\|\.log\.'

let g:neocomplcache_min_syntax_length                   = 3

call my#config#initialize_global_dict('neocomplcache_', [
  \ 'keyword_patterns',
  \ 'dictionary_filetype_lists',
  \ 'source_disable',
  \ 'include_patterns', 'vim_completefuncs',
  \ 'omni_patterns',
  \ 'force_omni_patterns',
  \ 'delimiter_patterns',
  \ 'same_filetype_lists', 'member_prefix_patterns',
  \ 'next_keyword_patterns',
  \ 'include_exprs',
  \ 'omni_functions',
  \ 'include_paths',
  \ ])

let g:neocomplcache_keyword_patterns.default = '\h\w*' " 日本語をキャッシュしない

call extend(g:neocomplcache_source_disable, {
      \ 'syntax_complete' : 1,
      \ })

function! s:neocomplcache_dictionary_config() "{{{
  for fp in split(globpath("~/.vim/dict", "*.dict"), "\n")
    let _name = fnamemodify(fp, ":p:t:r")
    let g:neocomplcache_dictionary_filetype_lists[_name] = fp
  endfor

  call extend(g:neocomplcache_dictionary_filetype_lists, {
        \ 'default'     : '',
        \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
        \ })
  " \ 'javascript'  : $HOME . '/.vim/dict/javascript.dict',

  for [key, val] in items({
        \ 'vimshell'    : $VIM_CACHE . '/vimshell/command-history',
        \ 'javascript'  : $HOME . '/.vim/dict/node.dict',
        \ 'eruby'       : $HOME . '/.vim/dict/ruby.dict',
        \ })
    if exists('g:neocomplcache_dictionary_filetype_lists[key]')
      let g:neocomplcache_dictionary_filetype_lists[key] .= ",".val
    else
      let g:neocomplcache_dictionary_filetype_lists[key] = val
    endif

  endfor
endfunction "}}}
call s:neocomplcache_dictionary_config()

let g:use_zen_complete_tag=1

call extend(g:neocomplcache_vim_completefuncs, {
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

let g:neocomplcache_force_omni_patterns.c =
      \ '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp =
      \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.cs = '[^.]\.\%(\u\{2,}\)\?'
" let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|::'
let g:neocomplcache_force_omni_patterns.objc = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.objcpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_delimiter_patterns.php = ['->', '::', '\']
let g:neocomplcache_member_prefix_patterns.php = '->\|::'
call my#config#bulk_dict_variables([{
  \   'dict' : g:neocomplcache_omni_patterns,
  \   'names' : ['twig', 'smarty'],
  \   'value' : '<[^>]*'
  \ }, {
  \   'dict' : g:neocomplcache_next_keyword_patterns,
  \   'names' : ['twig', 'smarty'],
  \   'value' : '[[:alnum:]_:-]*>\|[^"]*"'
  \ }])

let g:neocomplcache_include_patterns.scala = '^import'
let s:bundle = VimrcScope().bundle
" javascript
if s:bundle.is_installed('tern_for_vim')
  let g:neocomplcache_omni_functions.javascript = 'tern#Complete'
elseif s:bundle.is_installed('vim-nodejs-complete')
  let g:neocomplcache_omni_functions.javascript = 'nodejscomplete#CompleteJS'
endif

" haxe
let g:neocomplcache_omni_patterns.haxe = '\v([\]''"]|\w)(\.|\()\w*'
" autohotkey
let g:neocomplcache_include_paths.autohotkey = '.,,'
let g:neocomplcache_include_patterns.autohotkey = '^\s*#\s*include'
let g:neocomplcache_include_exprs.autohotkey = ''
" }}}

" Recommended key-mappings.
" <CR>: close popup and save indent.
imap <silent><expr> <CR> (pumvisible()?neocomplcache#smart_close_popup():"")
      \ ."\<Plug>(smartinput_CR)\<C-r>=endwize#crend()\<CR>"

" <C-h>, <BS>: close popup and delete backword char.
if s:bundle.is_installed('vim-smartinput')
  imap <expr> <C-h>  neocomplcache#smart_close_popup()
        \ . "\<Plug>(smartinput_BS)"
  imap <expr> <BS>   neocomplcache#smart_close_popup()
        \ . "\<Plug>(smartinput_C-h)"
else
  inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
endif

" inoremap <expr> <C-y>  neocomplcache#close_popup()
inoremap <expr> <C-e>  pumvisible() ? neocomplcache#cancel_popup() : "\<End>"

inoremap <expr> <C-j> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

imap <C-s> <Plug>(neocomplcache_start_unite_complete)

nnoremap [!space]ne :NeoComplCacheEnable<CR>
nnoremap [!space]nd :NeoComplCacheDisable<CR>

