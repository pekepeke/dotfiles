let s:bundle = VimrcScope().bundle
let s:is_win = VimrcScope().is_win
let s:is_mac = VimrcScope().is_mac

nnoremap <expr><silent><C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"
"silent! nmap <unique> <Space> <Plug>(quickrun)
if !exists('g:quickrun_config')
  let g:quickrun_config={}
endif
let g:quickrun_config._ = {
\   'outputter/buffer/split' : ':botright 8sp',
\   'hook/inu/enable' : 1,
\   'hook/inu/redraw' : 1,
\   'hook/inu/wait' : 20,
\ }
if s:bundle.is_installed('vimproc.vim')
  call extend(g:quickrun_config._, {
  \   'runner' : 'vimproc',
  \   'runner/vimproc/updatetime' : 100,
  \ })
endif

call extend(g:quickrun_config, {
\ 'objc' : {
\   'type' : executable('gcc') ? 'objc/gcc': '',
\ },
\ 'objc/gcc' : {
\   'command' : 'gcc',
\   'exec' : ['%c %o %s -o %s:p:r -framework Foundation', '%s:p:r %a', 'rm -f %s:p:r'],
\   'tempfile': '{tempname()}.m'
\ },
\ 'cpp': {
\   'type' : 'cpp/clang++',
\ },
\ 'cpp/gcc': {
\   'command' : 'g++',
\   'cmdopt' : '-std=c++11 -Wall -Wextra',
\   'hook/quickrunex/enable' : 1,
\ },
\ 'cpp/clang++': {
\   'command' : 'clang++',
\   'cmdopt' : '-std=c++1y -Wall -Wextra',
\   'hook/quickrunex/enable' : 1,
\ },
\ })
call extend(g:quickrun_config, {
\ 'go' : {
\   'type' : executable('8g') ? 'go/8g': '',
\ },
\ 'go/8g' : {
\   'command': '8g',
\   'exec': ['8g %s', '8l -o %s:p:r %s:p:r.8', '%s:p:r %a', 'rm -f %s:p:r'],
\ },
\ })
call extend(g:quickrun_config, {
\ 'cs' : {
\   'type' : executable('csc') ? 'csharp/csc':
\            executable('cs') ? 'csharp/cs': '',
\ },
\ 'csharp/csc' : {
\   'command' : 'csc',
\   'runmode' : 'simple',
\   'exec' : ['%c /nologo %s:gs?/?\\? > /dev/null', '"%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
\   'tempfile' : '{tempname()}.cs',
\ },
\ 'csharp/cs' : {
\   'command' : 'cs',
\   'runmode' : 'simple',
\   'exec' : ['%c %s > /dev/null', 'mono "%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
\   'tempfile' : '{tempname()}.cs',
\ },
\ })
call extend(g:quickrun_config, {
\ 'html' : {
\   "type" : "html/haml"
\ },
\ 'html/haml' : {
\   "command" : "html2haml"
\ },
\ 'html/haml_repace' : {
\   "outputter" : "error",
\   "outputter/success" : "replace_region",
\   "outputter/error"   : "message",
\   "outputter/message/log"   : 1,
\   "runner" : "system",
\   "type" : "html/haml"
\ },
\})
call extend(g:quickrun_config, {
\ 'json': {
\   'type': 'json/jq',
\ },
\ 'jsx' : {
\   'type' : 'jsx/jsx',
\ },
\ 'coffee/to_javascript' : {
\    'command': 'coffee',
\    'cmdopt': '-pb',
\    'outputter/buffer/filetype': 'javascript',
\ },
\ 'json/jq': {
\   'command': 'jq',
\ },
\ 'jsx/jsx' : {
\   'command': 'jsx',
\   'exec' : '%c %o --run %s',
\ },
\ })
call extend(g:quickrun_config, {
\ 'slim' : {
\   'type' : 'slim/slimrb',
\ },
\ 'slim/slimrb' : {
\   'command' : 'slimrb',
\   'exec' : ['%c %o -p %s'],
\ },
\ })
" http://qiita.com/joker1007/items/9dc7f2a92cfb245ad502
call extend(g:quickrun_config, {
\ 'ruby.rspec' : {
\   'type' : 'ruby/rspec',
\ },
\ 'ruby/rspec' : {
\   'command' : 'rspec',
\   'exec' : '%c %o -l {line(".")}',
\ },
\ 'ruby.rspec/rspec_bundle': {
\   'command': 'rspec',
\   'outputter/buffer/split': 'botright',
\   'exec': 'bundle exec %c %o --color --tty %s'
\ },
\ 'ruby.rspec/rspec_normal': {
\   'command': 'rspec',
\   'outputter/buffer/split': 'botright',
\   'exec': '%c %o --color --tty %s'
\ },
\ 'ruby.rspec/rspec_zeus': {
\   'command': 'rspec',
\   'outputter/buffer/split': 'botright',
\   'exec': 'zeus test %o --color --tty %s'
\ },
\ 'ruby.rspec/rspec_spring': {
\   'command': 'rspec',
\   'outputter/buffer/split': 'botright',
\   'exec': 'spring rspec %o --color --tty %s'
\ },
\ 'ruby/cucumber_bundle': {
\   'command': 'cucumber',
\   'outputter/buffer/split': 'botright',
\   'exec': 'bundle exec %c %o --color %s'
\ },
\ 'ruby/cucumber_zeus': {
\   'command': 'cucumber',
\   'outputter/buffer/split': 'botright',
\   'exec': 'zeus cucumber %o --color %s'
\ },
\ 'ruby/cucumber_spring': {
\   'command': 'cucumber',
\   'outputter/buffer/split': 'botright',
\   'exec': 'spring cucumber %o --color %s'
\ },
\ })

call extend(g:quickrun_config, {
\ 'python.nosetests' : {
\   'type' : 'python/nosetests',
\ },
\ 'perl.prove' : {
\   'type' : 'perl/prove',
\ },
\ 'php.phpunit' : {
\   'type' : 'php/phpunit',
\ },
\ 'python/nosetests' : {
\   'command' : 'nosetests',
\   'cmdopt': '-s -vv',
\ },
\ 'php/phpunit' : {
\   'command' : 'phpunit',
\ },
\ 'perl/prove' : {
\   'command' : 'prove',
\ },
\ })
call extend(g:quickrun_config, {
\ 'mysql' : {
\   'type' : 'sql/mysql',
\ },
\ 'sql' : {
\   'type' : 'sql/postgresql',
\ },
\ 'sql/mysql' : {
\   'runner' : 'system',
\   'command' : 'mysql',
\   'exec' : ['%c %o < %s'],
\ },
\ 'sql/postgresql': {
\   'command' : 'psql',
\   'exec': ['%c %o'],
\ }
\ })
call extend(g:quickrun_config, {
\ 'rst': {
\   'type': 'rst/rst2html',
\ },
\ 'rst/rst2html': {
\   'command': 'rst2html',
\ },
\ })

call extend(g:quickrun_config, {
\ 'markdown' : {
\   'type' :
\      s:is_mac && isdirectory('/Applications/Marked.app') ? 'markdown/Marked':
\      executable('markedwrapper')    ? 'markdown/markedwrapper':
\      executable('mdown')            ? 'markdown/mdown':
\      executable('pandoc')           ? 'markdown/pandoc':
\      executable('multimarkdown')    ? 'markdown/multimarkdown':
\      executable('MultiMarkdown.pl') ? 'markdown/MultiMarkdown.pl':
\      executable('rdiscount')        ? 'markdown/rdiscount':
\      executable('bluecloth')        ? 'markdown/bluecloth':
\      executable('markdown')         ? 'markdown/markdown':
\      executable('Markdown.pl')      ? 'markdown/Markdown.pl':
\      executable('redcarpet')        ? 'markdown/redcarpet':
\      executable('kramdown')         ? 'markdown/kramdown':
\      '',
\   'outputter' : 'browser',
\ },
\ })
call extend(g:quickrun_config, {
\ 'markdown/markedwrapper' : {
\   'command' : 'markedwrapper',
\   'exec' : '%c %o %s',
\ },
\ 'markdown/mdown' : {
\   'command' : 'mdown',
\   'exec' : '%c %o -i %s',
\ },
\ 'markdown/Marked' : {
\   'command' : 'open',
\   'outputter' : 'null',
\   'exec' : '%c -a Marked %o %s',
\ },
\ 'markdown/multimarkdown' : {
\   'command' : 'multimarkdown',
\ },
\ 'markdown/rdiscount' : {
\   'command' : 'rdiscount',
\ },
\ 'markdown/markdown' : {
\   'command' : 'markdown',
\ },
\ })
call extend(g:quickrun_config, {
\ 'markdown/md2backlog' : {
\   'command' : 'md2backlog',
\ },
\ 'markdown/vim-helpfile' : {
\   'command' : 'vim-helpfile',
\ },
\ 'markdown/markdown2pod' : {
\   'command' : 'markdown2pod',
\ },
\ })

call extend(g:quickrun_config, {
\ 'processing' : {
\   'type' : executable('processing-java') ? 'processing/processing-java' :
\            executable('osascript') ? 'processing/osascript':
\            '',
\ },
\ 'applescript' : {
\   'type' : executable('osascript') ? 'applescript/osascript':
\            '',
\ },
\ 'diag' : {
\   'type' : 'diag/diag',
\ },
\ })
call extend(g:quickrun_config, {
\ 'processing/osascript' : {
\   'command': 'osascript',
\   'exec' : ['osascript %o ' . globpath(&runtimepath, 'bin/runPSketch.scpt'). ' %s:p:h:t']
\ },
\ 'processing/processing-java' : {
\   'command': 'processing-java',
\   'exec' : '%c %o --sketch=$PWD/ --output=/Library/Processing --run --force',
\ },
\ 'applescript/osascript' : {
\   'command' : 'osascript',
\   'output' : '_',
\ },
\ 'diag/diag' : {
\   'exec': [
\      '%c -a %s -o %{expand("%:r")}.png',
\      printf("%s %{expand(%:r)}.png %s",
\        s:is_win ? 'explorer' : (s:is_mac ? 'open -g' : 'xdg-open'),
\        s:is_win ? "" : "&"),
\   ],
\   'outputter': 'message',
\ },
\ })
call extend(g:quickrun_config, {
\ 'command/cat' : {
\   'command' : 'cat',
\   'exec' : ['%c %o %s'],
\ },
\ })

" TODO : not work
call extend(g:quickrun_config, {
\ 'w3m' : {
\   'type' : 'w3m/open',
\ },
\ 'w3m/open': {
\   'command': (s:is_win ? 'start ""' : (s:is_mac ? "open" : "xdg-open")),
\   'exec': [
\     '%c %o "%{b:last_url}"',
\   ],
\ }
\ })

nnoremap <Leader><Leader>r :<C-u>QuickRun command/cat<CR>

" for testcase {{{3
MyAutoCmd BufWinEnter,BufNewFile *_spec.rb setl filetype=ruby.rspec
MyAutoCmd BufWinEnter,BufNewFile *test.php,*Test.php setl filetype=php.phpunit
function! s:gen_phpunit_skel()
  let old_cwd = getcwd()
  let cwd = expand('%:p:h')
  let name = expand('%:t:r')
  let m = matchlist(join(getline(1, 10), "\n"), "\s*namespace\s*\(\w+\)\s*;")
  let type = match(name, '\(_test|Test\)$') == -1 ? "--test" : "--class"
  let opts = []
  if !empty(m)
    call add(opts, '--')
    call add(opts, m[1])
  endif
  silent exe 'lcd' cwd
  exe "!" printf("phpunit-skelgen %s %s %s", join(opts, " "), type, name)
  silent exe 'lcd' old_cwd
endfunction
command! PhpUnitSkelGen call <SID>gen_phpunit_skel()
MyAutoCmd BufWinEnter,BufNewFile test_*.py setl filetype=python.nosetests
MyAutoCmd BufWinEnter,BufNewFile *.t setl filetype=perl.prove

if s:bundle.is_installed('vim-ref')
  augroup vimrc-plugin-ref
    autocmd!
    autocmd FileType ruby.rspec,php.phpunit,python.nosetests,perl.prove call s:testcase_lazy_init()
  augroup END

  function! s:testcase_lazy_init()
    call ref#register_detection('ruby.rspec', 'refe', 'append')
    call ref#register_detection('php.phpunit', 'phpmanual', 'append')
    call ref#register_detection('python.nosetests', 'pydoc', 'append')
    call ref#register_detection('perl.prove', 'perldoc', 'append')
    augroup vimrc-plugin-ref
      autocmd!
    augroup END
  endfunction
endif


function! s:vimrc_quickrun_init() "{{{4
  nmap <buffer> q :quit<CR>
endfunction "}}}
MyAutoCmd FileType quickrun call s:vimrc_quickrun_init()

if s:bundle.tap('vim-watchdogs') && s:bundle.is_installed('vimproc.vim')

  NeoBundleSource shabadou.vim vim-watchdogs

  " run ok
  "  python, jsonlint, coffee
  " \   'hook/back_window/enable_exit' : 1,
  " \   'hook/unite_quickfix/no_focus' : 1,
  " watchdogs g:quickrun_config {{{3
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/_' : {
        \   'hook/close_quickfix/enable_failure' : 1,
        \   'hook/close_quickfix/enable_success' : 1,
        \   'hook/hier_update/enable' : 1,
        \   'hook/quickfix_status_enable/enable' : 1,
        \   'hook/back_window/enable' : 1,
        \   'outputter/quickfix/open_cmd' : '',
        \ },
        \ })
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
        \   'type' : 'watchdogs_checker/jsonlint',
        \ },
        \ 'watchdogs_checker/jsonlint' : {
        \   'command' : 'jsonlint',
        \    'exec'    : '%c %s:p %o --compact',
        \    'quickfix/errorformat' : '%ELine %l:%c,%Z\\s%#Reason: %m,'
        \                           . '%C%.%#,%f: line %l\, col %c\, %m,%-G%.%#',
        \ },
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
        \ 'watchdogs_checker/jsonval' : {
        \   'command' : 'jsonval',
        \    'exec'    : '%c %o %s:p',
        \    'quickfix/errorformat' : '%E%f: %m at line %l,%-G%.%#',
        \ },
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
        \ 'typescript/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/tsc',
        \ },
        \ 'watchdogs_checker/tsc' : {
        \   'command' : 'tsc',
        \    'exec'    : '%c %o %s:p',
        \    'quickfix/errorformat' : '%+A %#%f %#(%l\,%c): %m,%C%m',
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
        \   'command' : 'python',
        \    'exec'    : "%c %o -c \"compile(open('%s:p').read(), '%s:p', 'exec')\"",
        \    'quickfix/errorformat' :
        \       '%A  File "%f"\, line %l\,%m,' .
        \       '%C    %.%#,' .
        \       '%+Z%.%#Error: %.%#,' .
        \       '%A  File "%f"\, line %l,' .
        \       '%+C  %.%#,' .
        \       '%-C%p^,' .
        \       '%Z%m,' .
        \       '%-G%.%#'
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
        \    'exec'    : '%c -z %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%m',
        \ },
        \ 'watchdogs_checker/ruby_erb' : {
        \   'command' : 'ruby',
        \    'exec'    : '%c -rerb -e "puts ERB.new('
        \           . 'File.read(''%s:p'').gsub(''<\%='', ''<\%'')'
        \           . ', nil, ''-'').src" | %c -c %o',
        \    'quickfix/errorformat' : '%-GSyntax OK,%E-:%l: syntax error, %m,%Z%p^,%W-:%l: warning: %m,%Z%p^,%-C%.%#',
        \ },
        \ 'cucumber/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/cucumber',
        \ },
        \ 'watchdogs_checker/cucumber' : {
        \   'command': 'cucumber',
        \    'exec'  : '%c --dry-run --quiet --strict --format pretty %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%c:%m,%W      %.%# (%m),%-Z%f:%l:%.%#,%-G%.%#',
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
        \    'exec'    : '%c -o %o %s:p',
        \    'quickfix/errorformat' : '%f:%l:%m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'lua/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/luac',
        \ },
        \ 'watchdogs_checker/luac' : {
        \   'command' : 'luac',
        \    'exec'    : '%c -p %o %s:p',
        \    'quickfix/errorformat' : 'luac: %#%f:%l: %m',
        \ },
        \ 'qml/watchdogs_checker' : {
        \   'type' : 'watchdogs_checker/qmlscene',
        \ },
        \ 'watchdogs_checker/qmlscene' : {
        \   'command' : 'qmlscene',
        \    'exec'    : '%c -c %o %s:p',
        \    'cmdopt' : '--quit',
        \    'quickfix/errorformat' : 'file:\/\/%f:%l %m',
        \ },
        \ })
  call extend(g:quickrun_config, {
        \ 'watchdogs_checker/sqlplus' : {
        \   'command' : 'sqlplus',
        \   'cmdopt'  : '-S %{OracleConnection()}',
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
  " call extend(g:quickrun_config, {
  "       \ '/watchdogs_checker' : {
  "       \   'type' : 'watchdogs_checker/',
  "       \ },
  "       \ 'watchdogs_checker/' : {
  "       \   'command' : '',
  "       \   'exec'    : '%c -c %o %s:p',
  "       \   'quickfix/errorformat' : '',
  "       \ },
  "       \ })

  " watchdogs setup {{{3
  call watchdogs#setup(g:quickrun_config)

  let g:watchdogs_check_BufWritePost_enable = 1

  " watchdogs helper command {{{3
  command! -nargs=0 WatchdogsOff let g:watchdogs_check_BufWritePost_enable=0
  command! -nargs=0 WatchdogsOn let g:watchdogs_check_BufWritePost_enable=1
  command! -nargs=? WatchdogsConfig call s:wd_helper.show_config(<f-args>)

  let s:wd_helper = {}
  function! s:wd_helper.find_by_names(...) "{{{4
    let ftype = a:0 > 0 ? a:1 : &filetype
    let names = []
    let default_name = ftype . "/watchdogs_checker"
    let default_type = ""
    if exists('g:quickrun_config[default_name]')
      call add(names, default_name)
      if exists('g:quickrun_config[default_name].type')
        call add(names, g:quickrun_config[default_name].type)
        let default_type = g:quickrun_config[default_name].type
      endif
    endif
    for name in keys(g:quickrun_config)
      if name == default_name || name == default_type
        continue
      endif
      if name =~? 'watchdogs_checker' && name =~? ftype
        call add(names, name)
      endif
    endfor
    return filter(names, '!empty(v:val)')
  endfunction

  function! s:wd_helper.show_config(...) "{{{4
    let names = call(self.find_by_names, a:000)
    let items = []
    if !empty(names)
      if exists(':PP')
        for name in names
          echo printf("let g:quickrun_config['%s']=", name)
          exe 'PP' 'g:quickrun_config["' . name . '"]'
        endfor
      else
        for name in names
          call add(items,
            \ printf("let g:quickrun_config['%s'] = %s",
            \ name, string(g:quickrun_config[name])))
        endfor
        echo join(items, "\n")
      endif
    endif
  endfunction
endif
