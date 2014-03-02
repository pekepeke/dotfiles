let s:save_cpo = &cpo
set cpo&vim

" toggle window maximize {{{1
let s:maximizer = {
      \ 'is_maximize' : 0 ,
      \ 'max_lines' : 0,
      \ 'max_columns' : 0,
      \ }

function! s:maximizer.maximize() "{{{2
  winpos 0 0
  exe 'set lines=' . (self.max_lines == 0 ? 9999: self.max_lines)
        \ . ' columns=' . (self.max_columns == 0 ? 9999 : self.max_columns)
  call self.set_max_pos()
endfunction

function! s:maximizer.maximizeHorizontal() "{{{2
  execute 'winpos' 0 getwinposy()
  exe 'set columns=' . (self.max_columns == 0 ? 9999: self.max_columns)
  let self.max_columns = &columns
endfunction

function! s:maximizer.maximizeVertical() "{{{2
  execute 'winpos' getwinposx() 0
  exe 'set lines=' . (self.max_lines == 0 ? 9999: self.max_lines)
  let self.max_lines = &lines
endfunction

function! s:maximizer.set_max_pos() "{{{2
  if self.max_lines == 0
    let self.max_lines = &lines
    let self.max_columns = &columns
  endif
endfunction

function! s:maximizer.store() "{{{2
  let self.winx = getwinposx()
  let self.winy = getwinposy()
  let self.lines = &lines
  let self.columns = &columns
  " let self._restore = winsaveview()
endfunction

function! s:maximizer.restore() "{{{2
  execute 'set lines=' . self.lines . ' columns=' . self.columns
  execute 'winpos ' . self.winx . ' ' . self.winy
  " call winrestview(self._restore)
endfunction

function! s:maximizer.toggleDirection(mode) "{{{2
  if self.is_maximize
    call self.restore()
    let self.is_maximize = 0
  else
    call self.store()
    if a:mode == "v"
      call self.maximizeVertical()
    elseif a:mode == "h"
      call self.maximizeHorizontal()
    else
      call self.maximize()
    end
    let self.is_maximize = 1
    redraw!
  endif
endfunction

function! s:maximizer.toggle() "{{{2
  if my#is_win()
    simalt ~r | simalt ~x
  elseif my#is_mac()
    silent execute 'set' (&fullscreen?'no':'').'fullscreen'
  else
    if self.is_maximize
      call self.set_max_pos()
      call self.restore()
      let self.is_maximize = 0
    else
      call self.store()
      call self.maximize()
      let self.is_maximize = 1
      redraw!
    endif
  endif
endfunction

function! my#winmaximizer#get() "{{{2
  return s:maximizer
endfunction

let &cpo = s:save_cpo
