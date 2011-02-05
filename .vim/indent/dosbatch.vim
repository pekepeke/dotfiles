" Vim indent file
" Language:	DOS batch files
" Version:	1
" Last Change:	2009 May 14
" Maintainer:	Geoff Wood (morska@yahoo.com)
" 
" Very simple indenting for DOS batch files, just
" - generally keep the indent of the previous line 
" - if previous line is not a comment and has ( and no matching ), 
"   increase indent
" - if this line starts with ), decrease indent
"
" Cut down and modified from Erik Janssen's awk.vim
"
"  History:
"  gw 14/5/9 created

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1

setlocal indentexpr=GetBatIndent()
setlocal indentkeys+=)

" Only define the function once.
if exists("*GetBatIndent")
  finish
endif

function! GetBatIndent()
   " Find previous line and get its indentation
   let prev_lineno = s:Get_prev_line( v:lnum )
   if prev_lineno == 0
      return 0
   endif
   let prev_data = getline( prev_lineno )
   let ind = indent( prev_lineno )

   " Increase indent if the previous line contains an unmatched '('
   if prev_data =~ '.*([^)]*$'
      let ind = ind + &sw
   endif

   " Decrease indent if this line starts with a ')'
   if getline(v:lnum) =~ '^\s*).*'
      let ind = ind - &sw
   endif

   return ind
endfunction

" Get previous relevant line. Search back until a line is that is no
" comment or blank and return the line number
function! s:Get_prev_line( lineno )
   let lnum = a:lineno - 1
   let data = getline( lnum )
   while lnum > 0 && (data =~? '^\s*\(rem\|@rem\|::\)' || data =~ '^\s*$')
      let lnum = lnum - 1
      let data = getline( lnum )
   endwhile
   return lnum
endfunction
