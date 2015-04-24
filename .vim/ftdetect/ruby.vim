autocmd BufNewFile,BufRead *.rb,config.ru,*.gemspec setlocal filetype=ruby
autocmd BufNewFile,BufRead *.cap,*.rake setlocal filetype=ruby
autocmd BufNewFile,BufRead *.erb,*.erubis setlocal filetype=eruby
autocmd BufRead,BufNewFile Gemfile setlocal filetype=Gemfile
autocmd BufNewFile,BufRead Capfile,Guardfile setlocal filetype=ruby
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby.vagrant
autocmd BufNewFile,BufRead Cheffile,Berksfile setlocal filetype=ruby
" CocoaPods
autocmd BufNewFile,BufRead Podfile,*.podspec setlocal filetype=ruby
