" vim:fdm=marker sw=2 ts=2 ft=vim expandtab:
" let g:vimrc_first_finish=1

" let s:is_mac = has('mac') || has('macunix') || has('gui_macvim')
" let s:is_win = has('win16') || has('win32') || has('win64')

" " from /Applications/MacVim.app/Contents/Resources/vim/vimrc
" " コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
" if !has('gui_running') && has('xterm_clipboard')
"   set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
" endif

" if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
"   " tagsファイルの重複防止
"   set tags=./tags,tags
" endif

" if s:is_win && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
"   let $PATH = $VIM . ';' . $PATH
" endif

" if s:is_mac
"   " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
"   set iskeyword=@,48-57,_,128-167,224-235
" endif

" if has('gui_macvim')
"   set langmenu=ja_ja.utf-8.macvim
"   let $PATH = simplify($VIM . '/../../MacOS') . ':' . $PATH
" endif

" __END__
