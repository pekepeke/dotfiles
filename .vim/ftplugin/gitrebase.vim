"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

nnoremap [!space]p :<C-u>Pick<CR>
nnoremap [!space]s :<C-u>Squash<CR>
nnoremap [!space]e :<C-u>Edit<CR>
nnoremap [!space]r :<C-u>Reword<CR>
nnoremap [!space]f :<C-u>Fixup<CR>

let &cpo = s:save_cpo
