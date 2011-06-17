" A ref source for ri.
" Version: 0.0.1
" Author : pekepeke <pekepekesamurai@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim



" options. {{{1
if !exists('g:ref_ri_cmd')  " {{{2
  let g:ref_ri_cmd = executable('ri') ? 'ri' : ''
endif
let s:cmd = g:ref_ri_cmd

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

  return s:filter(content)
endfunction



function! s:source.opened(query)  " {{{2
  call s:syntax()
  setl foldmethod=marker
  1
endfunction



function! s:source.complete(query)  " {{{2
  let option = []
  " return split(s:ri(option + ref#to_list(a:query)).stdout, "\n")
  return filter(split(s:ri(option + ref#to_list()).stdout, "\n") , 'v:val =~? a:query')
endfunction



function! s:source.special_char_p(ch)  " {{{2
  return a:ch == '#'
endfunction



function! s:source.get_keyword()  " {{{2
  let id = '\v\w+[!?]?'
  let class = '\v\u\w*%(::\u\w*)*'
  let kwd = ref#get_text_on_cursor(class)
  if kwd != ''
    return kwd
  endif
  return ref#get_text_on_cursor(class . '%([#.]' . id . ')?|' . id)
endfunction



" functions. {{{1
function! s:filter(src)
  let lines = []
  " TODO convert foldexpr...
  for line in split(a:src, "\n")
    if line =~ '^=\+ .*$'
      let len = strlen(matchstr(line, '^=\+'))
      if strridx(line, ":") == len(line) - 1
        let line .= "                               {{{1"
      elseif len > 1
        let line .= "                               {{{".len
      endif
    elseif line =~ '^\w\+:$'
        let line .= "                               {{{2"
    endif
    call add(lines, line)
  endfor
  return join(lines, "\n")
endfunction


function! s:syntax()  " {{{2
  if exists('b:current_syntax') && b:current_syntax == 'ref-ri'
    return
  endif

  syntax clear

  syntax include @refRiRuby syntax/ruby.vim

  syntax region refRiMethods start="^= \w* methods:$" end="^$" fold contains=refRiMethod,refRiMethodHeader
  syntax match refRiMethod '\S\+' contained
  "syntax region refRiMethodHeader matchgroup=refRiLine start="^----" end="----$" keepend oneline contained

  syntax match refRiClassAndMethod '\v%(\u\w*%(::|\.|#))+\h\w*[?!=~]?' contains=@refRiClassSepMethod
  syntax cluster refRiClassSepMethod contains=refRiCommonClass,refRiCommonMethod,refRiCommonSep

  syntax match refRiCommonSep '::\|#' contained nextgroup=refRiCommonClass,refRiCommonMethod
  syntax match refRiCommonClass '\u\w*' contained nextgroup=refRiCommonSep
  syntax match refRiCommonMethod '[[:lower:]_]\w*[?!=~]\?' contained

  syntax match refRiLine '^-*$'

  highlight default link refRiMethodHeader rubyClass
  highlight default link refRiMethod rubyFunction
  highlight default link refRiLine rubyOperator

  highlight default link refRiCommonSep rubyOperator
  highlight default link refRiCommonClass rubyClass
  highlight default link refRiCommonMethod rubyFunction

  syntax region refRiRubyCodeBlock start="^      " end="$" contains=@refRiRuby
  syntax match refRiClassOrMethod '\%1l.*$' contains=@refRiClassSepMethod
  "syntax region refRiRubyCodeInline matchgroup=refRiLine start="^---" end="$" contains=@refRiRuby oneline
  highlight default link refRiClass rubyClass

  " syn region refRiNonUniqueTerm	start=+^\w+ end=+^\s\{5}\w.*$+ contains=riTermString,riMethodSpec,riClassFold
  " syn match refRiTermString	contained "`[^']*'"
  " syn match refRiClassFold	contained "^\s\{5}.* {{{" contains=riClassOrModule

  " syn match refRiMethodSpec	contained "\([A-Z]\w*\(\#\|::\|\.\)\)\+[^, ()]\+" contains=riClassOrModule,riComma,riSeparator
  " syn match refRiSeparator 	contained "\(::\|\#\|\.\)"
  " syn match refRiClassOrModule	contained "[A-Z]\w*"

  " syn region refRiSection	start=+^---*+ end=+^---*$+ keepend contains=riMethodSpec,riApiCode,riSectionDelim
  " syn match refRiSectionDelim	contained "---*"

  " syn region refRiApiCode	contained start=+^\s\{5}+ end=+\(->\|$\)+me=s-1 keepend contains=riComma,riBufferType,@riRuby nextgroup=riEvalsto
  " syn match refRiBufferType	contained "^\s\{5}\(class\|module\):"
  " syn match refRiEvalsTo	contained "->.*$"	contains=riOutput
  " "syn match refRiComma		contained ","
  " syn region refRiOutput	contained start=+->+ms=s+3 end=+$+me=s-1 keepend

  " " Keep below riApiCode but before riExampleCode ;)
  " syn match refRiDescription	"^\s\{5}.*$"	contains=riString,riMethodSpec
  " syn match refRiString	contained "``[^']\+''"

  " syn region refRiExampleCode	start=+^\s\{8}+ end=+\(#=>\|$\)+me=s-1 contains=@riRuby nextgroup=riEvalsTo
  " syn match refRiEvalsTo	"#=>.*$" contains=riRubyOutput
  " syn region refRiRubyOutput	contained start=+#=>+ms=s+3 end=+$+me=s-1 keepend contains=@riRuby

  " syn region refRiProduces	start=+\s\{5}produces:+ skip=+^\s\{8}.*$+ end=+^\(\s\{5}\w.*\)\?$+ contains=riProduct
  " syn match refRiProduct	contained "\s\{8}.*$"

  " syn sync minlines=40

  " highlight default link refRiMethodHeader rubyClass
  " highlight default link refRiMethod rubyFunction
  " highlight default link refRiLine rubyOperator

  " highlight default link refRiSeparator rubyOperator
  " highlight default link refRiClassOrModule rubyClass
  " highlight default link refRiMethodSpec rubyFunction


  let b:current_syntax = 'ref-ri'
endfunction

function! s:ri(args)  " {{{2
  let option = ['--format=rdoc', '-T']
  return ref#system(ref#to_list(g:ref_ri_cmd) + option + ref#to_list(a:args))
endfunction






function! ref#ri#define()  " {{{2
  return copy(s:source)
endfunction

call ref#register_detection('ruby', 'ri')  " {{{1



let &cpo = s:save_cpo
unlet s:save_cpo
