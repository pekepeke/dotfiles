let s:save_cpo = &cpo
set cpo&vim

" functions {{{1
function! my#php#generate_phpunit_skelgen() "{{{2
  let old_cwd = getcwd()
  let cwd = expand('%:p:h')
  let path = expand('%:p')
  let name = expand('%:t:r')
  let ns = ''
  let matches = matchlist(getline(1,30), 'namespace\s\+\([^;]\+\);')
  if exists('matches[1]')
    let ns = matches[1]
    let name = ns . '\' . name
  endif
  " let m = matchlist(join(getline(1, 10), "\n"), "\s*namespace\s*\(\w+\)\s*;")
  " let type = match(name, '\(_test|Test\)$') == -1 ? "--test" : "--class"
  let type = match(name, '\(_test|Test\)$') == -1 ? "generate-test" : "generate-class"
  let opts = []
  let bootstrap = get(b:, 'phpunit_skelgen_bootstrap', '')
  if len(bootstrap) > 0
    call add(opts, '--bootstrap')
    call add(opts, bootstrap)
    call add(opts, '--')
  endif
  " if !empty(m)
  "   call add(opts, '--')
  "   call add(opts, m[1])
  " endif
  silent exe 'lcd' cwd
  exe "!" printf("phpunit-skelgen %s %s %s %s", type, join(opts, " "), name, path)
  silent exe 'lcd' old_cwd
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
