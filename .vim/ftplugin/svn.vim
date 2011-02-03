let s:save_cpo = &cpo
set cpo&vim

runtime! ftplugin/svn_file_comment.vim
call AppendCommitFiles()
setl expandtab

let &cpo = s:save_cpo
