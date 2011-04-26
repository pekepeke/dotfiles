" A ref source for ri.
" Version: 0.4.0
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim



" options. {{{1
if !exists('g:ref_ri_cmd')  " {{{2
  let g:ref_ri_cmd = executable('ri') ? 'ri' : ''
endif
let s:cmd = g:ref_ri_cmd

if !exists('g:ref_ri_encoding')  " {{{2
  let g:ref_ri_encoding = &termencoding
endif

if !exists('g:ref_ri_rsense_cmd')  " {{{2
  let g:ref_ri_rsense_cmd = ''
endif



let s:source = {'name': 'ri'}  " {{{1

function! s:source.available()  " {{{2
  return !empty(g:ref_ri_cmd)
endfunction



function! s:source.get_body(query)  " {{{2
  let res = s:ri(a:query)
  if res.stderr != ''
    throw matchstr(res.stderr, '^.\{-}\ze\n')
  endif

  let content = res.stdout
  " if s:ri_version() == 2
    " " is class or module?
    " let class = matchstr(content, '^\v%(require\s+\S+\n\n)?%(class|module) \zs\S+')
    " if class != ''
      " for [type, sep] in [['Singleton', '.'], ['Instance', '#']]
        " let members = s:ri(class . sep).stdout
        " let members = substitute(members, '\V' . class . sep, '', 'g')
        " let content .= "\n\n---- " . type . " methods ----\n" . members
      " endfor
    " endif
  " endif

  if exists('g:ref_ri_encoding') &&
  \  !empty(g:ref_ri_encoding) && g:ref_ri_encoding != &encoding
    let converted = iconv(content, g:ref_ri_encoding, &encoding)
    if converted != ''
      let content = converted
    endif
  endif

  return content
endfunction



function! s:source.opened(query)  " {{{2
  let [type, _] = s:detect_type()
  " let ver = s:ri_version()

  if type ==# 'list'
    silent! %s/ /\r/ge
    silent! global/^\s*$/delete _
  endif

  " if type ==# 'class' && ver == 1
    " silent! %s/[^[:return:]]\n\zs\ze----/\r/ge
  " endif
  call s:syntax(type)
  1
endfunction



function! s:source.complete(query)  " {{{2
  "let option = s:ri_version() == 2 ? ['-l'] : ['-l', '-s']
  let option = []
  return split(s:ri(option + ref#to_list(a:query)).stdout, "\n")
endfunction



function! s:source.special_char_p(ch)  " {{{2
  return a:ch == '#'
endfunction



function! s:source.get_keyword()  " {{{2
  let id = '\v\w+[!?]?'
  let pos = getpos('.')[1:]

  if &l:filetype ==# 'ref-ri'
    let [type, name] = s:detect_type()

    if type ==# 'list'
      return getline(pos[0])
    endif

    if type ==# 'class'
      if getline('.') =~ '^----'
        return ''
      endif
      let section = search('^---- \w* methods', 'bnW')
      if section != 0
        let sep = matchstr(getline(section), '^---- \zs\w*\ze methods')
        let sep = {'Singleton' : '.', 'Instance' : '#'}[sep]
        return name . sep . expand('<cWORD>')
      endif
    endif

    " if s:ri_version() == 2
      let kwd = ref#get_text_on_cursor('\[\[\zs.\{-}\ze\]\]')

      if kwd != ''
        if kwd =~# '^man:'
          return ['man', matchstr(kwd, '^man:\zs.*$')]
        endif
        return matchstr(kwd, '^\%(\w:\)\?\zs.*$')
      endif
    " endif

  else
    " Literals
    let syn = synIDattr(synID(line('.'), col('.'), 1), 'name')
    if syn ==# 'rubyStringEscape'
      let syn = synIDattr(synstack(line('.'), col('.'))[0], 'name')
    endif
    for s in ['String', 'Regexp', 'Symbol', 'Integer', 'Float']
      if syn =~# '^ruby' . s
        return s
      endif
    endfor

    " RSense
    if !empty(g:ref_ri_rsense_cmd)
      let use_temp = &l:modified || !filereadable(expand('%'))
      if use_temp
        let file = tempname()
        call writefile(getline(1, '$'), file)
      else
        let file = expand('%:p')
      endif

      let pos = getpos('.')
      let ve = &virtualedit
      set virtualedit+=onemore
      try
        let is_call = 0
        if search('\.\_s*\w*\%#[[:alnum:]_!?]', 'cbW')  " Is method call?
          let is_call = 1
        else
          call search('\>', 'cW')  " Move to the end of keyword.
        endif

        " To use the column of character base.
        let col = len(substitute(getline('.')[: col('.') - 2], '.', '.', 'g'))
        let res = ref#system(ref#to_list(g:ref_ri_rsense_cmd) +
        \ ['type-inference', '--file=' . file,
        \ printf('--location=%s:%s', line('.'), col)])
        let type = matchstr(res.stdout, '^type: \zs\S\+\ze\n')
        let is_class = type =~ '^<.\+>$'
        if is_class
          let type = matchstr(type, '^<\zs.\+\ze>$')
        endif

        if type != ''
          if is_call
            call setpos('.', pos)
            let type .= (is_class ? '.' : '#') . ref#get_text_on_cursor(id)
          endif

          return type
        endif

      finally
        if use_temp
          call delete(file)
        endif
        let &virtualedit = ve
        call setpos('.', pos)
      endtry
    endif
  endif

  let class = '\v\u\w*%(::\u\w*)*'
  let kwd = ref#get_text_on_cursor(class)
  if kwd != ''
    return kwd
  endif
  return ref#get_text_on_cursor(class . '%([#.]' . id . ')?|' . id)
endfunction



" functions. {{{1
" Detect the rirence type from content.
" - ['list', ''] (Matched list)
" - ['class', class_name] (Summary of class)
" - ['method', class_and_method_name] (Detail of method)
function! s:detect_type()  " {{{2
  " TODO a quickie job ...
  let [l1, l2, l3] = [getline(1), getline(2), getline(3)]
  " if s:ri_version() == 1
    let m = matchstr(l1, '^==== \zs\S\+\ze ====$')
    if m != ''
      return ['class', m]
    endif

    " include man.*
    if l2 =~ '^\%(---\|:\|=\)'
      return ['method', l1]
    endif

  " else
    " let require = l1 =~# '^require'
    " let m = matchstr(require ? l3 : l1, '^\%(class\|module\|object\) \zs\S\+')
    " if m != ''
      " return ['class', m]
    " endif

    " " include builtin variable.
    " let m = matchstr(require ? l3 : l2, '^--- \zs\S\+')
    " if m != ''
      " return ['method', m]
    " endif
  " endif
  return ['class', '']
  " return ['list', '']
endfunction



function! s:syntax(type)  " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-ri-' . a:type
    return
  endif

  syntax clear

  syntax include @refriRuby syntax/ruby.vim

  if a:type ==# 'list'
    syntax match refriClassOrMethod '^.*$' contains=@refriClassSepMethod
  elseif a:type ==# 'class'
    syntax region refriMethods start="^---- \w* methods .*----$" end="^$" fold contains=refriMethod,refriMethodHeader
    syntax match refriMethod '\S\+' contained
    syntax region refriMethodHeader matchgroup=refriLine start="^----" end="----$" keepend oneline contained
  endif

  syntax match refriClassAndMethod '\v%(\u\w*%(::|\.|#))+\h\w*[?!=~]?' contains=@refriClassSepMethod
  syntax cluster refriClassSepMethod contains=refriCommonClass,refriCommonMethod,refriCommonSep

  syntax match refriCommonSep '::\|#' contained nextgroup=refriCommonClass,refriCommonMethod
  syntax match refriCommonClass '\u\w*' contained nextgroup=refriCommonSep
  syntax match refriCommonMethod '[[:lower:]_]\w*[?!=~]\?' contained


  highlight default link refriMethodHeader rubyClass
  highlight default link refriMethod rubyFunction
  highlight default link refriLine rubyOperator

  highlight default link refriCommonSep rubyOperator
  highlight default link refriCommonClass rubyClass
  highlight default link refriCommonMethod rubyFunction


  call s:syntax_ri(a:type)

  let b:current_syntax = 'ref-ri-' . a:type
endfunction

function! s:syntax_ri(type)  " {{{2
  if a:type ==# 'list'
    syntax match refriClassOrMethod '^.*$' contains=@refriClassSepMethod
  elseif a:type ==# 'class'
    syntax region refriRubyCodeBlock start="^  " end="$" contains=@refriRuby
    syntax region refriClass matchgroup=refriLine start="^====" end="====$" keepend oneline
  elseif a:type ==# 'method'
    syntax region refriRubyCodeBlock start="^      " end="$" contains=@refriRuby
    syntax match refriClassOrMethod '\%1l.*$' contains=@refriClassSepMethod
    syntax region refriRubyCodeInline matchgroup=refriLine start="^---" end="$" contains=@refriRuby oneline
  endif

  highlight default link refriClass rubyClass
endfunction

function! s:syntax_ri2(type)  " {{{2
  " Copy from syntax/ruby.vim
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<\z(\h\w*\)\ze+hs=s+2    matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<"\z([^"]*\)"\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<'\z([^']*\)'\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart		      fold keepend
  syn region rubyString start=+\%(\%(class\s*\|\%([]})"'.]\|::\)\)\_s*\|\w\)\@<!<<`\z([^`]*\)`\ze+hs=s+2  matchgroup=rubyStringDelimiter end=+^ \{2}\z1$+ contains=rubyHeredocStart,@rubyStringSpecial fold keepend

  syntax region refriRubyCodeBlock
  \      start=/^ \{2,4}\ze\S/
  \      end=/\n\+\ze \{,1}\S/ contains=@refriRuby

  syntax keyword rubyClass class
  syntax keyword rubyInclude include
  syntax match refriTitle "^===.\+$"

  if a:type !=# 'list'
    syntax match refriAnnotation '^@\w\+'
  endif
  if a:type ==# 'method'
    syntax match refriMethod '^--- \w\+[!?]'
  endif

  highlight default link refriMethod Function
  highlight default link refriTitle Statement
  highlight default link refriAnnotation Special
endfunction



function! s:ri(args)  " {{{2
  let option = ['--format=rdoc', '-T']
  return ref#system(ref#to_list(g:ref_ri_cmd) + option + ref#to_list(a:args))
endfunction



function! s:ri_version()  " {{{2
  if s:cmd !=# g:ref_ri_cmd
    let s:cmd = g:ref_ri_cmd
    unlet! g:ref_ri_version
  endif
  if !exists('g:ref_ri_version')
    let g:ref_ri_version =
    \   s:ri('--version').stdout =~# 'ri version 2' ? 2 : 1
  endif
  return g:ref_ri_version
endfunction



function! ref#ri#define()  " {{{2
  return copy(s:source)
endfunction

call ref#register_detection('ruby', 'ri')  " {{{1



let &cpo = s:save_cpo
unlet s:save_cpo
