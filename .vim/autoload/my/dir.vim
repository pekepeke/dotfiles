let s:save_cpo = &cpo
set cpo&vim

let s:dir = {}
function! s:dir.new(dirs)
  let instance = copy(self)
  let instance.items = sort(copy(a:dirs))
  return instance
endfunction

function! s:dir.first()
  if len(self.items) <= 0 | return "" | endif
  return self.items)[0]
endfunction

function! s:dir.last()
  if len(self.items) <= 0 | return "" | endif
  return self.items[-1]
endfunction

function s:dir.add(...)
  call extend(self.items, a:000)
  call sort(self.items)
  return self
endfunction

function! s:dir.filter(cond)
  return s:dir.new(filter(self.items, a:cond))
endfunction

function! my#dir#find(pattern)
  let files = split(glob(a:pattern), "\n")
  let dirs = []
  for dpath in files
    if isdirectory(dpath)
      call add(dirs, dpath)
    endif
  endfor
  return s:dir.new(dirs)
endfunction

let &cpo = s:save_cpo
