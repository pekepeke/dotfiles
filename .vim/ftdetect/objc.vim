let s:save_cpo = &cpo
set cpo&vim

function! s:detect_objc()
  if match(getline(1, min([line("$"), 200])), '^\(@\(interface\|end\|class\|implementation\)\|#\(import\)\)') 
    setl filetype=objc
  endif
endfunction

augroup filetypedetect
  autocmd BufNewFile,BufRead *.m,*.mm,*.h call s:detect_objc()
augroup END

let &cpo = s:save_cpo
