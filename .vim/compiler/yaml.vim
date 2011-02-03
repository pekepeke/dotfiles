if exists("current_compiler")
  finish
endif
let current_compiler = "yaml"

let s:savecpo = &cpo
set cpo&vim

if exists(":CompilerSet") != 2  " older Vim always used :setlocal
  command -nargs=* CompilerSet setlocal <args>
endif

CompilerSet makeprg=perl\ -MYAML\ -e\ '$f=shift\ or\ die\ qq/No\ input\ file.\\n/;eval{YAML::LoadFile($f)};if($@){warn\ qq/$@$f\ had\ compilation\ errors.\\n/}else{warn\ qq/$f\ syntax\ OK\\n/}'\ %

CompilerSet errorformat=
    \%EYAML\ Error:\ %m,
    \%C\ \ \ Code:\ %t,
    \%C\ \ \ Line:\ %l,
    \%C\ \ \ Document:\ %c,
    \%-G\ at\ %.%#,
    \%C%f\ had\ compilation\ errors.,
    \%-G%.%#syntax\ OK,
    \%Z,%-C%.%#

let &cpo = s:savecpo
unlet s:savecpo
