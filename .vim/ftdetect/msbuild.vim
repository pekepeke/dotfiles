" MSBuild
autocmd BufNewFile,BufRead *.proj,*.xaml set filetype=xml
autocmd BufNewFile,BufRead *.proj,*.cs,*.xaml compiler msbuild
