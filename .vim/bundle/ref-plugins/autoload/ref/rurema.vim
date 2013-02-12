let s:save_cpo = &cpo
set cpo&vim

" options.
if !exists('g:ref_rurema_cmd')
  let g:ref_rurema_cmd = executable('rurema') ? 'rurema' : ''
endif
let s:cmd = g:ref_rurema_cmd

if !exists('g:ref_rurema_encoding')
  let g:ref_rurema_encoding = &termencoding
endif

" source define
let s:source = {'name': 'rurema'} " {{{1

function! s:source.available() " {{{2
  return !empty(g:ref_rurema_cmd)
endfunction

function! s:source.get_body(query) " {{{2
  " let res = ref#system(ref#to_list(g:ref_rurema_cmd) + ref#to_list(a:query))
  let res = s:rurema(a:query)
  if res.stderr != ''
    throw matchstr(res.stderr, '^.\{-}\ze\n')
  endif

  let content = res.stdout

  if exists('g:ref_rurema_encoding') && !('g:ref_rurema_encoding') && g:ref_rurema_encoding != &encoding
    let converted = iconv(content, g:ref_rurema_encoding,  &encoding)
    if converted != ''
      let content = converted
    endif
  endif

  return content
endfunction

function! s:source.opened(query) " {{{2
  let [type, _] = s:detect_type()
  if type ==# 'list'
    silent! %s/ /\r/ge
    silent! global/^\s*$/delete _
  endif

  call s:syntax(type)
  1
endfunction

function! s:source.get_keyword() " {{{2
  let id = '\v\w+[!?]?'
  let class = '\v\u\w*%(::\u\w*)*'
  let kwd = ref#get_text_on_cursor(class)
  if kwd != ''
    return kwd
  endif
  return ref#get_text_on_cursor(class . '%([#.]' . id . ')?|' . id)
  " let pos = getpos('.')[1:]
  " if &l:filetype ==# 'ref-rurema'
  "   let [type, name] = s:detect_type()

  "   if type ==# 'list'
  "     return getline(pos[0])
  "   endif
  " endif
endfunction

function! s:source.complete(query)  " {{{2
  let option = ['--list']
  let query = '^' . a:query
  return filter(split(s:rurema(option + ref#to_list()).stdout, "\n") , 'v:val =~? query')
endfunction
" functions. {{{1
function! s:detect_type() " {{{2
  let [l1, l2, l3] = [getline(1), getline(2), getline(3)]
  let require = l1 =~# '^require'
  let m = matchstr(require ? l3 : l1, '^\%(class\|module\|object\) \zs\S\+')
  if m != ''
    return ['class', m]
  endif

  " include builtin variable.
  let m = matchstr(require ? l3 : l2, '^--- \zs\S\+')
  if m != ''
    return ['method', m]
  endif
  return ['list', '']
endfunction

function! s:syntax(type) " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-rurema-' . a:type
    return
  endif

  syntax clear

  syntax include @refRuremaRuby syntax/ruby.vim

  if a:type ==# 'list'
    syntax match refRuremaClassOrMethod '^.*$' contains=@refRuremaClassSepMethod
  elseif a:type ==# 'class'
    syntax region refRuremaMethods start="^---- \w* methods .*----$" end="^$" fold contains=refRuremaMethod,refRuremaMethodHeader
    syntax match refRuremaMethod '\S\+' contained
    syntax region refRuremaMethodHeader matchgroup=refRuremaLine start="^----" end="----$" keepend oneline contained
  endif

  syntax match refRuremaClassAndMethod '\v%(\u\w*%(::|\.|#))+\h\w*[?!=~]?' contains=@refRuremaClassSepMethod
  syntax cluster refRuremaClassSepMethod contains=refRuremaCommonClass,refRuremaCommonMethod,refRuremaCommonSep

  syntax match refRuremaCommonSep '::\|#' contained nextgroup=refRuremaCommonClass,refRuremaCommonMethod
  syntax match refRuremaCommonClass '\u\w*' contained nextgroup=refRuremaCommonSep
  syntax match refRuremaCommonMethod '[[:lower:]_]\w*[?!=~]\?' contained


  highlight default link refRuremaMethodHeader rubyClass
  highlight default link refRuremaMethod rubyFunction
  highlight default link refRuremaLine rubyOperator

  highlight default link refRuremaCommonSep rubyOperator
  highlight default link refRuremaCommonClass rubyClass
  highlight default link refRuremaCommonMethod rubyFunction

  " Copy from syntax/ruby.vim
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<\z(\h\w*\)\ze+hs=s+2    matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<"\z([^"]*\)"\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<'\z([^']*\)'\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart		      fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<`\z([^`]*\)`\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend

  syntax region refRuremaRubyCodeBlock
        \      start=/^ \{2,4}\ze\S/
        \      end=/\n\+\ze \{,1}\S/ contains=@refRuremaRuby

  syntax match refRefeTitle "^===.\+$"
  highlight default link refRefeTitle Statement

  if a:type ==# 'method'
    syntax match refRuremaMethod '^--- \w\+[!?]'
    highlight default link refRuremaMethod Function
  endif

  let b:current_syntax = 'ref-rurema-' . a:type
endfunction

function! s:rurema(args) "{{{2
  let option = ['--no-ask']
  return ref#system(ref#to_list(g:ref_rurema_cmd) + option + ref#to_list(a:args))
endfunction

function! ref#rurema#define()  " {{{1
  return copy(s:source)
endfunction

if s:source.available()
  call ref#register_detection('ruby', 'rurema', 'prepend') " {{{1
endif

function! ref#rurema#from_current_word() " {{{2
  let word = expand("<cword>")
  call ref#open("rurema", word)
endfunction

function! ref#rurema#from_select_word() " {{{2
  let tmp = @@
  silent normal gvy
  let selected = @@
  let @@ = tmp
  call ref#open("rurema", selected)
endfunction

let &cpo = s:save_cpo
