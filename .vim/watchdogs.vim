let s:save_cpo = &cpo
set cpo&vim

call extend(g:quickrun_config, {
  \ 'watchdogs_checker/_' : {
  \   'hook/close_quickfix/enable_failure' : 1,
  \   'hook/close_quickfix/enable_success' : 1,
  \   'hook/hier_update/enable' : 1,
  \   'hook/quickfix_status_enable/enable' : 1,
  \   "hook/quickfixsigns_update/enable_exit" : 1,
  \   "hook/quickfixsigns_update/priority_exit" : 3,
  \   'hook/back_window/enable' : 1,
  \   'outputter/quickfix/open_cmd' : '',
  \ },
  \ })
if has('job') && exists('*ch_close_in')
  call extend(g:quickrun_config['watchdogs_checker/_'], {
  \ 'runner': 'job',
  \ 'runner/job/interval': 100,
  \ })
endif
call extend(g:quickrun_config, {
  \ 'perl/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/perl-projectlibs',
  \ },
  \ 'cpanfile/watchdogs_checker': {
  \   'type' : 'watchdogs_checker/cpanfile',
  \ },
  \ "watchdogs_checker/perl-locallib" : {
  \   "command" : "perl",
  \   "exec"    : "%c %o -Mlib=local/lib/perl5/ -Mlib=lib -Mlib=. -cw %s:p",
  \   "quickfix/errorformat" : '%m\ at\ %f\ line\ %l%.%#',
  \ },
  \ 'watchdogs_checker/perl-projectlibs': {
  \   'command' : 'perl',
  \   'exec' : '%c %o -cw -MProject::Libs %s:p',
  \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
  \ },
  \ 'watchdogs_checker/cpanfile': {
  \   'command' : 'perl',
  \   'exec' : '%c %o -w -MModule::CPANfile -e "Module::CPANfile->load(q|%S:p|)"',
  \   'quickfix/errorformat' : '%m\ at\ %f\ line\ %l%.%#',
  \ },
  \ })

function! PhpcsStandardDetect() "{{{
  let standard = get(b:, 'watchdogs_checker_phpcs_standard',
    \ (filereadable('phpcs.xml') ? 'phpcs.xml': 'PSR2'))
  let extra_opt = get(b:, 'watchdogs_checker_phpcs_options', '')
  return printf('--standard=%s %s', standard, extra_opt)
endfunction "}}}

if !exists('g:quickrun_config["watchdogs_checker/php"]')
  call extend(g:quickrun_config, {
  \ 'watchdogs_checker/php': {
  \   'cmdopt': '-d error_reporting=E_ALL',
  \ },
  \ })
endif
call extend(g:quickrun_config, {
\ 'watchdogs_checker/phpcs': {
\    'command': 'phpcs',
\    'cmdopt' : '--report=emacs %{PhpcsStandardDetect()}',
\    'exec': '%c %o -l %s:p',
\    "errorformat" : '%f:%l:%c:\ %m',
\ }
\ })
call extend(g:quickrun_config, {
\ 'watchdogs_checker/phpmd': {
\    'command': 'phpmd',
\    'cmdopt' : 'cleancode,codesize,design,unusedcode,naming',
\    'exec': '%c %s:p %o text',
\    'quickfix/errorformat': '%f:%l%\s%m, %-G%.%#',
\ }
\ })
call extend(g:quickrun_config, {
\ 'watchdogs_checker/phpcheck': {
\    'command': $HOME . '/.vim/bin/phpcheck.php',
\    'cmdopt' : '--phpcs="%{PhpcsStandardDetect()}"',
\    'exec': '%c %o %s:p',
\    'quickfix/errorformat': '%f:%l:%c:%m',
\ }
\ })
call extend(g:quickrun_config, {
  \ 'php/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/phpcheck',
  \ },
  \ })
if executable('tidy')
  call extend(g:quickrun_config, {
  \ 'html/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/tidy',
  \ },
  \ 'xhtml/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/tidy',
  \ },
  \ })
endif
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/tidy' : {
  \   'command' : 'tidy',
  \    'exec'    : '%c -raw -quiet -errors --gnu-emacs yes %o %s:p',
  \    'quickfix/errorformat' : '%f:%l:%c: %m',
  \ },
  \ 'haml/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/haml',
  \ },
  \ 'watchdogs_checker/haml' : {
  \   'command' : 'haml',
  \    'exec'    : '%c -c %o %s:p',
  \    'quickfix/errorformat' : 'Haml error on line %l: %m,'
  \                           . 'Syntax error on line %l: %m,%-G%.%#',
  \ },
  \ 'watchdogs_checker/slimrb' : {
  \   'command' : 'slimrb',
  \    'exec'    : '%c -c %o %s:p',
  \    'quickfix/errorformat' : '%C\ %#%f\, Line %l\, Column %c,'.
  \                             '%-G\ %.%#,'.
  \                             '%ESlim::Parser::SyntaxError: %m,'.
  \                             '%+C%.%#'
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'json/watchdogs_checker' : {
  \   'type' : executable('jsonlint') ? 'watchdogs_checker/jsonlint' :
  \            executable('jsonval') ? 'watchdogs_checker/jsonval' : '',
  \ },
  \ 'watchdogs_checker/jsonlint' : {
  \   'command' : 'jsonlint',
  \    'exec'    : '%c %s:p %o --compact',
  \    'quickfix/errorformat' : '%ELine %l:%c,%Z\\s%#Reason: %m,'
  \                           . '%C%.%#,%f: line %l\, col %c\, %m,%-G%.%#',
  \ },
  \ 'watchdogs_checker/jsonval' : {
  \   'command' : 'jsonval',
  \    'exec'    : '%c %o %s:p',
  \    'quickfix/errorformat' : '%E%f: %m at line %l,%-G%.%#',
  \ },
  \ })
if executable('jsxhint')
  let g:quickrun_config['javascript/watchdogs_checker'] = 'watchdogs_checker/jsxhint'
endif
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/nodejs' : {
  \   'command' : 'node',
  \    'exec'    : '%c %o %s:p',
  \    'quickfix/errorformat' : '%AError: %m,%AEvalError: %m,'
  \                           . '%ARangeError: %m,%AReferenceError: %m,'
  \                           . '%ASyntaxError: %m,%ATypeError: %m,'
  \                           .  '%Z%*[\ ]at\ %f:%l:%c,%Z%*[\ ]%m (%f:%l:%c),'
  \                           .  '%*[\ ]%m (%f:%l:%c),%*[\ ]at\ %f:%l:%c,%Z%p^,'
  \                           .  '%A%f:%l,%C%m,%-G%.%#'
  \ },
  \ 'watchdogs_checker/jsxhint' : {
  \   'command' : 'jsxhint',
  \    'exec'    : '%c --verbose %o %s:p',
  \    'quickfix/errorformat' : '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
  \ },
  \ 'watchdogs_checker/eslint': {
  \   'command' : 'eslint',
  \    'exec'    : '%c -f compact %o %s:p',
  \    'quickfix/errorformat' : '%E%f: line %l\, col %c\, Error - %m,' .
  \       '%W%f: line %l\, col %c\, Warning - %m'
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'coffee/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/coffee',
  \ },
  \ 'watchdogs_checker/coffee' : {
  \   'command' : 'coffee',
  \   'exec'    : '%c -c -p %o %s:p',
  \   'quickfix/errorformat' : '%E%f:%l:%c: %trror: %m,' .
  \                            'Syntax%trror: In %f\, %m on line %l,' .
  \                            '%EError: In %f\, Parse error on line %l: %m,' .
  \                            '%EError: In %f\, %m on line %l,' .
  \                            '%W%f(%l): lint warning: %m,' .
  \                            '%W%f(%l): warning: %m,' .
  \                            '%E%f(%l): SyntaxError: %m,' .
  \                            '%-Z%p^,' .
  \                            '%-G%.%#'
  \ },
  \ 'watchdogs_checker/coffeelint' : {
  \   'command' : 'coffeelint',
  \   'exec'    : '%c -csv %o %s:p',
  \   'quickfix/errorformat' : '%f\,%l\,%\d%#\,%trror\,%m,' .
  \                            '%f\,%l\,%trror\,%m,' .
  \                            '%f\,%l\,%\d%#\,%tarn\,%m,' .
  \                            '%f\,%l\,%tarn\,%m'
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'typescript/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/tsc',
  \ },
  \ 'watchdogs_checker/tsc' : {
  \   'command' : 'tsc',
  \    'exec'    : '%c %o %s:p',
  \    'quickfix/errorformat' : '%+A %#%f %#(%l\,%c): %m,%C%m',
  \ },
  \ 'watchdogs_checker/jsxhint' : {
  \   'command' : 'jsxhint',
  \    'exec'    : '%c --verbose %o %s:p',
  \    'quickfix/errorformat' : '%A%f: line %l\, col %v\, %m \(%t%*\d\)',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'css/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/csslint',
  \ },
  \ 'watchdogs_checker/csslint' : {
  \   'command' : 'csslint',
  \    'exec'    : '%c %o --format=compact %s:p',
  \    'quickfix/errorformat' : '%-G,%-G%f: lint free!'.
  \       ',%f: line %l\, col %c\, %trror - %m,%f: '.
  \       'line %l\, col %c\, %tarning - %m,%f: line %l\, col %c\, %m,',
  \ },
  \ })
if executable('scss-lint')
  call extend(g:quickrun_config, {
    \ 'scss/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/scsslint',
    \ },
    \ 'watchdogs_checker/scsslint' : {
    \   'command' : 'scss-lint',
    \    'exec'    : '%c %o --format=compact %s:p',
    \    'quickfix/errorformat' : '%A%f:\ line\ %l\\,\ col\ %c\\,\ %m'
    \ },
    \ })
endif
if !executable('pyflakes')
  call extend(g:quickrun_config, {
    \  'python/watchdogs_checker' : {
    \    'type' : 'watchdogs_checker/python',
    \  },
    \ })
endif
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/python' : {
  \   'command' : $HOME . '/.vim/lib/python/compile.py',
  \   'exec'    : "%c %o %s:p",
  \   'quickfix/errorformat' : '%E%f:%l:%c: %m',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'csharp/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/mcs',
  \ },
  \ 'watchdogs_checker/mcs' : {
  \   'command' : 'mcs',
  \    'exec'    : '%c %o %s:p',
  \    'cmdopt'  : '--parse',
  \    'quickfix/errorformat' : '%f(%l\\\,%c):\ error\ CS%n:\ %m',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'objc/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/gcc_objc',
  \ },
  \ 'watchdogs_checker/gcc_objc' : {
  \   'command' : 'gcc',
  \    'exec'    : '%c -fsyntax-only -lobjc %o %s:p',
  \    'quickfix/errorformat' : '%-G%f:%s:,'
  \                           . '%f:%l:%c: %trror: %m,'
  \                           . '%f:%l:%c: %tarning: %m,'
  \                           . '%f:%l:%c: %m,'
  \                           . '%f:%l: %trror: %m,'
  \                           . '%f:%l: %tarning: %m,'
  \                           . '%f:%l: %m',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'eruby/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/ruby_erb',
  \ },
  \ 'Gemfile/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/ruby',
  \ },
  \ 'watchdogs_checker/erubis' : {
  \   'command' : 'erubis',
  \   'exec'    : '%c -z %o %s:p',
  \   'quickfix/errorformat' : '%f:%l:%m',
  \ },
  \ 'watchdogs_checker/ruby_erb' : {
  \   'command' : 'ruby',
  \   'exec'    : '%c -rerb -e "puts ERB.new('
  \           . 'File.read(''%s:p'').gsub(''<\%='', ''<\%'')'
  \           . ', nil, ''-'').src" | %c -c %o',
  \   'quickfix/errorformat' : '%-GSyntax OK,%E-:%l: syntax error, %m,%Z%p^,%W-:%l: warning: %m,%Z%p^,%-C%.%#',
  \ },
  \ 'cucumber/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/cucumber',
  \ },
  \ 'watchdogs_checker/cucumber' : {
  \   'command': 'cucumber',
  \   'exec'  : '%c --dry-run --quiet --strict --format pretty %o %s:p',
  \   'quickfix/errorformat' : '%f:%l:%c:%m,%W      %.%# (%m),%-Z%f:%l:%.%#,%-G%.%#',
  \ },
  \ 'watchdogs_checker/foodcritic': {
  \   'command': 'foodcritic',
  \   'exec'   : '%c %o %s:p',
  \   'quickfix/errorformat': 'FC%n: %m: %f:%l',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'applescript/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/osacompile',
  \ },
  \ 'watchdogs_checker/osacompile' : {
  \   'command' : 'osacompile',
  \   'exec'    : '%c -o %o %s:p',
  \   'quickfix/errorformat' : '%f:%l:%m',
  \ },
  \ })
if executable('luac')
  call extend(g:quickrun_config, {
    \ 'lua/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/luac',
    \ },
    \ })
endif
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/luac' : {
  \   'command' : 'luac',
  \   'exec'    : '%c -p %o %s:p',
  \   'quickfix/errorformat' : 'luac: %#%f:%l: %m',
  \ },
  \ 'qml/watchdogs_checker' : {
  \   'type' : 'watchdogs_checker/qmlscene',
  \ },
  \ 'watchdogs_checker/qmlscene' : {
  \   'command' : 'qmlscene',
  \   'exec'    : '%c -c %o %s:p',
  \   'cmdopt' : '--quit',
  \   'quickfix/errorformat' : 'file:\/\/%f:%l %m',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/sqlplus' : {
  \   'command' : 'sqlplus',
  \   'cmdopt'  : '-S %{OracleCommandOptions()}',
  \   'exec'    : '%c %o \@%s:p',
  \   'quickfix/errorformat' : '%Eerror\ at\ line\ %l:,%Z%m',
  \ },
  \ })
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/twig-lint' : {
  \   'command' : 'twig-lint',
  \   'exec'    : '%c lint --format=csv %o %s:p',
  \   'quickfix/errorformat' : '"%f"\,%l\,%m',
  \ },
  \ })
if executable('golint')
  call extend(g:quickrun_config, {
    \ 'go/watchdogs_checker' : {
    \   'type' : 'watchdogs_checker/golint',
    \ },
    \ })
endif
call extend(g:quickrun_config, {
  \ 'watchdogs_checker/go' : {
  \   'command' : 'gofmt',
  \   'exec'    : '%c -l %o %s:p',
  \   'quickfix/errorformat' : '%f:%l:%c: %m,%-G%.%#',
  \ },
  \ 'watchdogs_checker/golint' : {
  \   'command' : 'golint',
  \   'exec'    : '%c %o %s:p',
  \   'quickfix/errorformat' : '%f:%l:%c: %m,%-G%.%#',
  \ },
  \ })
" call extend(g:quickrun_config, {
"   \ '/watchdogs_checker' : {
"   \   'type' : 'watchdogs_checker/',
"   \ },
"   \ 'watchdogs_checker/' : {
"   \   'command' : '',
"   \   'exec'    : '%c -c %o %s:p',
"   \   'quickfix/errorformat' : '',
"   \ },
"   \ })
" watchdogs setup {{{4
call watchdogs#setup(g:quickrun_config)
let g:watchdogs_check_BufWritePost_enable = 1
" watchdogs helper command {{{4
command! -nargs=0 WatchdogsOff let g:watchdogs_check_BufWritePost_enable=0
command! -nargs=0 WatchdogsOn let g:watchdogs_check_BufWritePost_enable=1
command! -nargs=? WatchdogsConfig call my#watchdogs#show_config(<f-args>)

let &cpo = s:save_cpo
