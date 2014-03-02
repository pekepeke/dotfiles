let s:save_cpo = &cpo
set cpo&vim

let s:help_util = {}

function! my#help_util#get()
  return s:help_util
endfunction

function! s:help_util.tagfiles()
  let tagfiles = split(globpath(&runtimepath, 'doc/tags'), "\n")
  let tagfiles += split(globpath(&runtimepath, 'doc/tags-*'), "\n")
  return tagfiles
endfunction

function! s:help_util.docdirs()
  return split(globpath(&runtimepath, 'doc'), "\n")
endfunction

function! s:help_util.refresh()
  call self.clear()
  call self.tags()
endfunction

function! s:help_util.clear_bundles()
  let tagfiles = self.tagfiles()
  for f in tagfiles
    if stridx(f, $HOME) != -1
      call delete(f)
      " echo f
    endif
  endfor
endfunction

function! s:help_util.clear()
  let tagfiles = self.tagfiles()
  for f in tagfiles
    call delete(f)
  endfor
endfunction

function! s:help_util.tags()
  let dirs = self.docdirs()
  for d in dirs
    silent execute 'helptags' d
  endfor
endfunction

function! s:help_util.show_tags()
  echo join(self.tagfiles(), "\n")
endfunction

function! s:help_util.show_dirs()
  echo join(self.docdirs(), "\n")
endfunction


let &cpo = s:save_cpo
