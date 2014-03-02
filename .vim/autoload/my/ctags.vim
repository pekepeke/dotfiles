let s:save_cpo = &cpo
set cpo&vim

" {{{1
let s:ctagsutil = {}  "{{{3
function s:ctagsutil.parse(...) "{{{4
  let lines = split(system('ctags --list-kinds'), "\n")
  let langmap = {}
  let lang = ""
  let charmap = {}
  let definitions = []
  for line in lines
    let matches = matchlist(line, '^\(\w\+\)$')
    if empty(matches)
      if empty(lang)
        continue
      endif
      " call add(definitions, substitute(line, '^\s\+\([^ \t]\)\s\+([^ \t][^\[\]]*).*$', '\1:\2', ''))
      let matches = matchlist(line, '^\s*\([^ \t]\)\s*\([^ \t][^\[\]]\+\).*$')
      " echo matches
      if !empty(matches)
        let ch = matches[1]
        if !exists('charmap[ch]')
          let charmap[ch] = 1
          let desc = substitute(matches[2], '^\s*\|\s*$', '', 'g')
          " escape
          let desc = substitute(desc, "'", "''", 'g')
          call add(definitions, printf("%s:%s", ch, desc))
        endif
      endif
    else
      if !empty(lang)
        let langmap[lang] = definitions
      endif
      let lang = matches[1]
      let definitions = []
      let charmap = {}
    endif
  endfor
  if !empty(lang) && !exists('langmap[lang]')
    let langmap[lang] = definitions
  endif
  let self.langmap = langmap
endfunction

function! s:ctagsutil.show() "{{{4
  call self.parse()
  for lang in keys(self.langmap)
    call self.taglist_source(lang)
    call self.tagbar_source(lang)
  endfor
endfunction

function! s:ctagsutil.taglist_source(...) "{{{4
  let langs = empty(a:000) ? keys(self.langmap) : a:000
  let m = []
  for lang in langs
    if !exists('self.langmap[lang]')
      echoerr "not found:".lang
      continue
    endif
    call add(m, printf("let g:tlist_%s_settings='%s;%s'", tolower(lang), lang, join(self.langmap[lang], ";")))
  endfor
  echo join(m, "\n")
endfunction

function! s:ctagsutil.tagbar_source(...) "{{{4
  let langs = empty(a:000) ? keys(self.langmap) : a:000
  let m = []
  for lang in langs
    if !exists('self.langmap[lang]')
      echoerr "not found:".lang
      continue
    endif
    call add(m, printf("let g:tagbar_type_%s = {'ctagstype': '%s', 'kinds':\n\\   %s\n\\ }",
          \ tolower(lang), lang, string(self.langmap[lang])))
  endfor
  echo join(m, "\n")
endfunction

function! my#ctags#show() "{{{2
  call s:ctagsutil.show()
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
