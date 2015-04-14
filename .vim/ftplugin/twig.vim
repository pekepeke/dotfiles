"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

setl comments=s1:{#,mb:#,ex:#}
setl commentstring={#%s#}

let b:match_skip = 's:comment\|string'
if !exists('b:match_words')
  let b:match_words = ''
endif
let b:match_words = &matchpairs . ',' .
  \ '\<if\>:\<elseif\>:\<else\>:\<endif\>,' .
  \ '\<for\>:\<endfor\>,' .
  \ '\<filter\>:\<endfilter/>,' .
  \ '\<autoescape\>:\<endautoescape/>,' .
  \ '\<block\>:\<endblock/>,' .
  \ '\<embed\>:\<endembed/>,' .
  \ '\<macro\>:\<endmacro/>,' .
  \ '\<sandbox\>:\<endsandbox/>,' .
  \ '\<spaceless\>:\<endspaceless/>,' .
  \ '\<verbatim\>:\<endverbatim/>,' .
  \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
  \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
  \ '<\@<=\([^/?][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>,' .
  \ '<:>,(:),{:},[:]'

let &cpo = s:save_cpo
