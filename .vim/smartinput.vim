let s:save_cpo = &cpo
set cpo&vim

call smartinput#map_to_trigger('i', '<Space>', '<Space>', '<Space>')
call smartinput#define_rule({
  \   'at':       '(\%#)',
  \   'char':     '<Space>',
  \   'input':    '<Space><Space><Left>',
  \   })

call smartinput#define_rule({
  \   'at':       '( \%# )',
  \   'char':     '<BS>',
  \   'input':    '<Del><BS>',
  \   })

call smartinput#define_rule({
  \   'at':       '{\%#}',
  \   'char':     '<Space>',
  \   'input':    '<Space><Space><Left>',
  \   })

call smartinput#define_rule({
  \   'at':       '{ \%# }',
  \   'char':     '<BS>',
  \   'input':    '<Del><BS>',
  \   })

call smartinput#define_rule({
  \   'at':       '\[\%#\]',
  \   'char':     '<Space>',
  \   'input':    '<Space><Space><Left>',
  \   })

call smartinput#define_rule({
  \   'at':       '\[ \%# \]',
  \   'char':     '<BS>',
  \   'input':    '<Del><BS>',
  \   })

" 改行取り除き
" call smartinput#define_rule({
"       \   'at': '\s\+\%#',
"       \   'char': '<CR>',
"       \   'input': "<C-o>:call setline('.', substitute(getline('.'), '\\s\\+$', '', ''))<CR><CR>",
"       \   })

" Ruby 文字列内変数埋め込み
call smartinput#map_to_trigger('i', '#', '#', '#')
call smartinput#define_rule({
  \   'at': '\%#',
  \   'char': '#',
  \   'input': '#{}<Left>',
  \   'filetype': ['ruby'],
  \   'syntax': ['Constant', 'Special'],
  \   })

" Ruby ブロック引数 ||
call smartinput#map_to_trigger('i', '<Bar>', '<Bar>', '<Bar>')
call smartinput#define_rule({
  \   'at': '\({\|\<do\>\)\s*\%#',
  \   'char': '<Bar>',
  \   'input': '<Bar><Bar><Left>',
  \   'filetype': ['ruby'],
  \    })

" テンプレート内のスペース
call smartinput#map_to_trigger('i', '<', '<', '<')
call smartinput#define_rule({
  \   'at':       '<\%#>',
  \   'char':     '<Space>',
  \   'input':    '<Space><Space><Left>',
  \   'filetype': ['cpp'],
  \   })
call smartinput#define_rule({
  \   'at':       '< \%# >',
  \   'char':     '<BS>',
  \   'input':    '<Del><BS>',
  \   'filetype': ['cpp'],
  \   })
" struct
call smartinput#define_rule({
  \   'at'       : '\%(\<struct\>\|\<class\>\|\<enum\>\)\s*\w\+.*\%#',
  \   'char'     : '{',
  \   'input'    : '{};<Left><Left>',
  \   'filetype' : ['cpp'],
  \   })
" http://qiita.com/todashuta@github/items/bdad8e28843bfb3cd8bf
call smartinput#map_to_trigger('i', '<Plug>(smartinput_BS)',
  \   '<BS>',
  \   '<BS>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_C-h)',
  \   '<BS>',
  \   '<C-h>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_CR)',
  \   '<Enter>',
  \   '<Enter>')
call smartinput#map_to_trigger('i', '<Plug>(smartinput_SPACE)',
  \   '<Enter>',
  \   '<Enter>')
" http://qiita.com/hatchinee/items/c5bc19a656925ce33882
" classとかの定義時に:までを入れる
call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#',
  \   'char'     : '(',
  \   'input'    : '():<Left><Left>',
  \   'filetype' : ['python'],
  \   })
" が、すでに:がある場合は重複させない. (smartinputでは、atの定義が長いほど適用の優先度が高くなる)
call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#.*:',
  \   'char'     : '(',
  \   'input'    : '()<Left>',
  \   'filetype' : ['python'],
  \   })
" 末尾:の手前でも、エンターとか:で次の行にカーソルを移動させる
call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
  \   'char'     : ':',
  \   'input'    : '<Right><CR>',
  \   'filetype' : ['python'],
  \   })
call smartinput#define_rule({
  \   'at'       : '^\s*\%(\<def\>\|\<if\>\|\<for\>\|\<while\>\|\<class\>\|\<with\>\)\s*\w\+.*\%#:$',
  \   'char'     : '<CR>',
  \   'input'    : '<Right><CR>',
  \   'filetype' : ['python'],
  \   })

" vim-smartinput {{{2
if s:bundle.tap('vim-smartinput')
  function! s:bundle.tapped.hooks.on_source(bundle)
    function! s:smartinput_init() "{{{
      " if hasmapto('<CR>', 'c')
      "   cunmap <CR>
      " endif
    endfunction " }}}

    function! s:sminput_define_rules(is_load_default_rules) "{{{
      if a:is_load_default_rules
        call smartinput#define_default_rules()
      endif
      source ~/.vim/smartinput.vim
    endfunction "}}}

    command! SmartinputOff call smartinput#clear_rules()
    command! SmartinputOn call s:sminput_define_rules(1) | call s:smartinput_init()
    " --;;;;;;;;
    command! -nargs=? SmartinputBufferMapClear call s:sminput_buffer_mapclear(<q-args>)

    function! s:sminput_buffer_mapclear(mode) "{{{
      let mode = empty(a:mode) ? '*' : a:mode
      let vars = smartinput#scope()
      let hash = {}
      " TODO special keys
      let rules = filter(get(vars, 'available_nrules', []), 'v:val._char =~# "^[a-zA-Z0-9!-/:-@\\[-`{-~]\\+$"')
      for item in copy(filter(rules, 'mode == "*" || mode == v:val.mode'))
        if get(hash, item._char, 1)
          let char = substitute(item._char, '[|]', '\\\1', 'g')
          execute printf("silent! %smap \<buffer> %s", item.mode, char)
          " execute printf("%smap \<buffer> %s %s", item.mode, char, char)
          " execute printf("%sunmap \<buffer> %s", item.mode, char)
          let hash[item._char] = 0
        endif
      endfor
    endfunction "}}}

    call s:sminput_define_rules(0)
    call s:smartinput_init()
  endfunction
  call s:bundle.untap()
endif

let &cpo = s:save_cpo
