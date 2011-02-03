let s:save_cpo = &cpo
set cpo&vim

if !exists('b:titanium_proj')
  finish
endif

setl include=i^\s*Titanium.include
"setl includeexpr=v:fname

"setl path=$HOME."/app-settings/komodo/js/timobile.js"
"setl makeprg=/Library/Application\ Support/Titanium/mobilesdk/osx/1.3.2/iphone/builder.py run ./
if exists('g:titanium_builder_path')
  exe! "setl makeprg=".fnameescape(g:titanium_builder_path)."\\ ".fnameescape(b:titanium_proj)
else 
  exe! "setl makeprg=/Library/Application\\ Support/Titanium/mobilesdk/osx/1.4.2/iphone/builder.py\\ run\\ ".fnameescape(b:titanium_proj)
endif

" build command
function! s:titaniumbuild()
  if !exists('b:titanium_proj')
    echoerr "can't find titanium project"
    return
  endif
  "let l:proj_dir = substitute(b:titanium_proj, '(.*)/.*', '1', '')
  let l:current_dir = getcwd()
  execute ':lcd '.escape(expand(b:titanium_proj), ' #\')
  silent make!
  execute ':lcd ' .escape(expand(current_dir),  ' #\')
endfunction

command! -buffer -nargs=0 TitaniumBuild call s:titaniumbuild()

let &cpo = s:save_cpo
