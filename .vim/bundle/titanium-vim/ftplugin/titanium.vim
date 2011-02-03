" titanium filetype plugin
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>


if exists('b:did_ftplugin_titanium')
  finish
endif

if &include != '' | setl include+=\| | endif
setl include+=^\s*Ti.include\|^\s*Titanium.include\|\s*url\s*:\s*\|\s*test\s*:\s*
"setl includeexpr=v:fname
call titanium#titaniumcomplete#enable_omnifunc()

if titanium#build#can()
  if titanium#build#can_multi()
    command! -nargs=* -complete=customlist,titanium#build#device_complete -buffer
          \ TitaniumBuild call titanium#build#execute(<f-args>)
  else
    command! -nargs=* -buffer
          \ TitaniumBuild call titanium#build#execute(<f-args>)
  endif
endif

" buffer mappings
if titanium#command#unite_utilizable()
  nnoremap <silent><buffer> <Plug>(titanium_unite_completion)
        \ :call titanium#command#unite_completion()<CR>
  inoremap <silent><buffer> <Plug>(titanium_unite_completion)
        \ :call titanium#command#unite_completion()<CR>
  if !hasmapto('<Plug>(titanium_unite_completion)', 'n')
        \ && maparg('<LocalLeader>i', 'n', 'rhs') == ''
    nmap <silent><buffer> <LocalLeader>i
          \ <Plug>(titanium_unite_completion)
  endif
endif

if titanium#command#help_utilizable()
  if titanium#is_desktop()
    command! -nargs=? -buffer TiDesktopHelp call titanium#command#help_open(<f-args>)
    nnoremap <buffer> K :TiDesktopHelp<CR>
  else
    command! -nargs=? -buffer TiMobileHelp call titanium#command#help_open(<f-args>)
    nnoremap <buffer> K :TiMobileHelp<CR>
  endif
endif

let b:did_ftplugin_titanium = 1

