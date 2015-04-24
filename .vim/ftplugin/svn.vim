let s:save_cpo = &cpo
set cpo&vim

runtime! ftplugin/svn_file_comment.vim
call AppendCommitFiles()
setlocal expandtab

let &cpo = s:save_cpo
