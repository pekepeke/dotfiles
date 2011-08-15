" cdd.vim - cdd for vim
" Author: Sora Harakami <http://codnote.net/>
" WebPage: http://github.com/sorah/cdd-vim
" License: MIT Licence
" MIT Licence {{{
"Permission is hereby granted, free of charge, to any person obtaining a copy
"of this software and associated documentation files (the "Software"), to deal
"in the Software without restriction, including without limitation the rights
"to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
"copies of the Software, and to permit persons to whom the Software is
"furnished to do so, subject to the following conditions:

"The above copyright notice and this permission notice shall be included in
"all copies or substantial portions of the Software.

"THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
"IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
"AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
"LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
"OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
"THE SOFTWARE.
"}}}

if exists('g:cdd_vim_loaded')
  finish
endif

command! -nargs=1 Cdd call <SID>cdd(<f-args>)

function! s:cdd(no)
  for l:lin in readfile(expand('~').'/.zsh/cdd_pwd_list')
    let l:line = split(l:lin,':')
    if len(l:line) >= 2
      if l:line[0] == a:no
        execute "cd" l:line[1]
        return
      endif
    endif
  endfor
  echo 'Not found'
endfunction

let g:cdd_vim_loaded = 1
