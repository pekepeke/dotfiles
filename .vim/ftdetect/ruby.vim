autocmd BufNewFile,BufRead *.rb,config.ru,*.gemspec setl filetype=ruby
autocmd BufNewFile,BufRead *.cap,*.rake setl filetype=ruby
autocmd BufNewFile,BufRead *.erb,*.erubis setl filetype=eruby
autocmd BufRead,BufNewFile Gemfile setl filetype=Gemfile
autocmd BufNewFile,BufRead Capfile,Guardfile setl filetype=ruby
autocmd BufNewFile,BufRead Vagrantfile setlocal filetype=ruby.vagrant
autocmd BufNewFile,BufRead Cheffile,Berksfile setl filetype=ruby
" CocoaPods
au BufNewFile,BufRead Podfile,*.podspec setl filetype=ruby
