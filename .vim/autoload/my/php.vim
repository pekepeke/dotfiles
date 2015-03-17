let s:save_cpo = &cpo
set cpo&vim

" functions {{{1
function! my#php#generate_phpunit_skelgen() "{{{2
  let old_cwd = getcwd()
  let cwd = expand('%:p:h')
  let name = expand('%:t:r')
  let m = matchlist(join(getline(1, 10), "\n"), "\s*namespace\s*\(\w+\)\s*;")
  " let type = match(name, '\(_test|Test\)$') == -1 ? "--test" : "--class"
  let type = match(name, '\(_test|Test\)$') == -1 ? "generate-test" : "generate-class"
  let opts = []
  " if !empty(m)
  "   call add(opts, '--')
  "   call add(opts, m[1])
  " endif
  silent exe 'lcd' cwd
  exe "!" printf("phpunit-skelgen %s %s %s", join(opts, " "), type, name)
  silent exe 'lcd' old_cwd
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
