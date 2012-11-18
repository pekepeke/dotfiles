let s:save_cpo = &cpo
set cpo&vim
" s:reader {{{1
let s:reader = {
      \   '_sep' : ',',
      \   '_delim' : '"',
      \ }

function! s:reader.new() " {{{2
  return extend({}, self)
endfunction

function! s:reader.sep(sep) " {{{2
  let self._sep = a:sep
  return self
endfunction

function! s:reader.delim(delim) " {{{2
  let self._delim = a:delim
  return self
endfunction

function! s:reader.parse_from_string(buf) " {{{2
  return self.parse_from_list(split(a:buf, "\n"))
endfunction

function! s:reader.parse_from_list(all_line) " {{{2
  let lines = []
  let line = []

  let pat = self._delim . self._delim
  let sub = self._delim
  let buf = []
  let line_buf = []
  let is_in_delim = 0
  for a_line in a:all_line
    for item in split(a_line, self._sep)
      if is_in_delim 
        let len = strlen(item)
        if strpart(item, len-1, 1) == self._delim
          call add(buf, strpart(item, 0, len - 1))
          call add(line_buf, join(buf, self._sep))
          let item = join(line_buf, "\n")
          let item = substitute(item, pat, sub, 'g')

          let is_in_delim = 0
          let line_buf = []
          let buf = []
          call add(line, item)
        else
          call add(buf, item)
        endif
      elseif strpart(item, 0, 1) == self._delim
        let len = strlen(item)
        if strpart(item, len-1, 1) == self._delim
          call add(line, strpart(item, 1, len-2))
          " let item = strpart(item, 1, len-2)
        else
          let is_in_delim = 1
          call add(buf, strpart(item, 1))
        endif
      else
        call add(line, item)
      endif
    endfor

    if !is_in_delim
      call add(lines, line)
      let line = []
    else
      call add(line_buf, join(buf, self._sep))
      let buf = []
    endif
  endfor
  if line != []
    call add(lines, line)
  endif

  let len = len(lines)
  for idx in range(len - 1, 0, -1)
    if empty(lines[idx])
      call remove(lines, idx)
      continue
    endif
    " let size = len - idx - 1
    " echo join([len, idx, size], ",")
    " if size > 0
    "   call remove(lines, idx + 1, size)
    " endif
    break
  endfor
  return lines
endfunction

" public function {{{1
function! csvutil#reader#new() "{{{2
  return s:reader.new()
endfunction

function! csvutil#reader#tsv_new() "{{{2
  return s:reader.new().sep("\t")
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
