let s:dir = expand('<sfile>:p:h')
let &l:tags=&ltags.','.s:dir."/tags"
unlet s:dir
