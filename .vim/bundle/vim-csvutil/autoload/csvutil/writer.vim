let s:save_cpo = &cpo
set cpo&vim

" s:writer {{{1
let s:writer = {
      \   '_sep' : ',',
      \   '_delim' : '"',
      \ }

function! s:writer.new() "{{{2
  return extend({}, self).init()
endfunction

function! s:writer.init() "{{{2
  let self._lines = []
  let self._line = []
  return self
endfunction

function! s:writer.sep(sep) "{{{2
  let self._sep = a:sep
  return self
endfunction

function! s:writer.delim(delim) "{{{2
  let self._delim = a:delim
  return self
endfunction

function! s:writer.add(s) "{{{2
  let s = a:s
  if self.is_required_escape(s)
    let s = self.escape(s)
  endif
  call add(self._line, s)
  return self
endfunction

function s:writer.is_required_escape(s) "{{{2
  if stridx(a:s, self._sep) != -1
    return 1
  elseif stridx(a:s, self._delim) != -1
    return 1
  elseif stridx(a:s, "\n") != -1
    return 1
  elseif stridx(a:s, "\r") != -1
    return 1
  endif
  return 0
endfunction

function! s:writer.escape(s) "{{{2
  let d = self._delim
  let sub = self._delim . self._delim
  return d . substitute(a:s, d, sub, 'g') . d
endfunction

function! s:writer.addLine(...) "{{{2
  if a:0
    for s in (type([]) == type(a:1) ? a:1 : a:000)
      call self.add(s)
    endfor
  endif
  if self._line != []
    call add(self._lines, self._line)
    let self._line = []
  endif
  return self
endfunction

function! s:writer.grid(grid) "{{{2
  for line in a:grid
    call self.addLine(line)
  endfor
  return self
endfunction

function! s:writer.render() "{{{2
  let lines = []
  call self.addLine()
  for line in self._lines
    call add(lines, join(line, self._sep))
  endfor
  return join(lines, "\n")
endfunction

" public functions {{{1
function! csvutil#writer#new() "{{{2
  return s:writer.new()
endfunction

function! csvutil#writer#tsv_new() "{{{2
  return s:writer.new().sep("\t")
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
