autocmd BufNewFile,BufRead *.rb,config.ru,Capfile,Vagrantfile,Guardfile setl filetype=ruby
autocmd BufNewFile,BufRead *.erb,*.erubis setl filetype=eruby
autocmd BufRead,BufNewFile Gemfile setl filetype=Gemfile
