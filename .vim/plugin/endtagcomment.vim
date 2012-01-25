" endtagcomment.vim
" こういうHTMLがあったときに
" <div id="hoge" class="fuga">
" ...
" </div>
"
" 実行するとこうなる
" <div id="hoge" class="fuga">
" ...
" <!-- /div#hoge.fuga --></div>
"
" ----------
" update:2010-12-08 @kosei27
"
" ,ti でidのみを出力
" ,tc でclassのみを出力(",tt" ",t" も同様)
" ,ta でidとclassを出力
" ,t<Space> でコメント内のテキストの前後の空白をトグル
" <!--/hoge-->  <->  <!-- /hoge -->

function! Endtagcomment(type)
    let reg_save = @@

    try
        silent normal! vaty
    catch
        execute "normal! \<Esc>"
        echohl ErrorMsg
        echo 'no match html tags'
        echohl None
        return
    endtry

    let html = @@

    let start_tag = matchstr(html, '\v(\<.{-}\>)')
    let tag_name  = matchstr(start_tag, '\v([a-zA-Z]+)')

    let comment_type = a:type
    let comment_space = g:endtagcomment_space
    let firstclass_symbol = g:endtagcomment_firstclass_symbol

    let id = ''
    let id_match = matchlist(start_tag, '\vid\=["'']([^"'']+)["'']')
    if exists('id_match[1]')
        let id = '#' . id_match[1]
    endif

    let class = ''
    let class_match = matchlist(start_tag, '\vclass\=["'']([^"'']+)["'']')
    if exists('class_match[1]')
        "let class = '.' . join(split(class_match[1], '\v\s+'), '.')
        let class = join(split(class_match[1], '\v\s+'), '.')
    endif

    execute "normal! `>va<\<Esc>`<"

    if l:comment_type == 'id'
        let g:endtagcommentFormat = '<!--%comment_space/%id%comment_space-->'
    elseif l:comment_type == 'class'
        let g:endtagcommentFormat = '<!--%comment_space/%firstclass_symbol%class%comment_space-->'
    elseif l:comment_type == 'id_class'
        let g:endtagcommentFormat = '<!--%comment_space/%id.%class%comment_space-->'
    elseif l:comment_type == 'tag_id_class'
        let g:endtagcommentFormat = '<!--%comment_space/%tag_name%id.%class%comment_space-->'
    endif

    let comment = g:endtagcommentFormat
    let comment = substitute(comment, '%comment_space', comment_space, 'g')
    let comment = substitute(comment, '%firstclass_symbol', firstclass_symbol, 'g')
    let comment = substitute(comment, '%tag_name', tag_name, 'g')
    let comment = substitute(comment, '%id', id, 'g')
    let comment = substitute(comment, '%class', class, 'g')

    let @@ = comment

    normal! ""P

    let @@ = reg_save
endfunction

"let g:endtagcommentFormat = '<!-- /%tag_name%id%class -->'

"" keymap
nnoremap <Plug>(endtagcomment-i)  :<C-u>call Endtagcomment('id')<CR>
nnoremap <Plug>(endtagcomment-c)  :<C-u>call Endtagcomment('class')<CR>
nnoremap <Plug>(endtagcomment-ic) :<C-u>call Endtagcomment('id_class')<CR>
nnoremap <Plug>(endtagcomment)    :<C-u>call Endtagcomment('tag_id_class')<CR>


" コメント内のテキストの前後の空白
let g:endtagcomment_space = ''
"" 有無をトグル
function! Endtagcomment_space_toggle()
  let comment_space = g:endtagcomment_space
  if l:comment_space == ''
    let g:endtagcomment_space = ' '
  else
    let g:endtagcomment_space = ''
  endif
endfunction
""" keymap
nnoremap <silent> ,t<Space>  :<C-u>call Endtagcomment_space_toggle()<CR>


" コメント内のテキストの最初のclass名の「.」
let g:endtagcomment_firstclass_symbol = ''
"" 有無をトグル（id+classの場合は固定で「.」がつきます）
function! Endtagcomment_firstclass_symbol_toggle()
  let firstclass_symbol = g:endtagcomment_firstclass_symbol
  if l:firstclass_symbol == ''
    let g:endtagcomment_firstclass_symbol = '.'
  else
    let g:endtagcomment_firstclass_symbol = ''
  endif
endfunction
"" keymap
nnoremap <silent> <Plug>(endtagcomment-toggle)  :<C-u>call Endtagcomment_firstclass_symbol_toggle()<CR>

