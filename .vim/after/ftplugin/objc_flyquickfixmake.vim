"scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim


if !exists('g:objc_framework_paths')
  " find iphone sdk
  function s:find_lastdir(prefix)
    let items = reverse(split(glob(a:prefix.'*'), "\n"))
    for item in items
      return item
    endfor
    return ""
  endfunction
  let s:sdk_dirs = []
  let s:sdk_dir = s:find_lastdir('/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS')
  if s:sdk_dir != ""
    call add(s:sdk_dirs, s:sdk_dir.'/System/Library/Frameworks')
  endif
  let s:sdk_dir = s:find_lastdir('/Developer/SDKs/MacOSX')
  if s:sdk_dir != ""
    call add(s:sdk_dirs, s:sdk_dir.'/System/Library/Frameworks')
  endif
  let g:objc_framework_paths = join(s:sdk_dirs, ',')
endif

silent exe "setl path=.,".g:objc_framework_paths

"setl makeprg=xcodebuild\ -activetarget\ -activeconfiguration\ \|\ grep\ -e\ "^/.*"\ \|\ sort\ -u
setl makeprg=xcodebuild\ -activetarget\ -activeconfiguration

" build command
function! s:xcodebuild()
  if !exists('b:cocoa_proj')
    echoerr "can't find cocoa project"
    return
  endif
  let l:proj_dir = substitute(b:cocoa_proj, '(.*)/.*', '1', '')
  let l:current_dir = getcwd()
  execute ':lcd '.escape(expand(l:proj_dir), ' #\')
  silent make!
  execute ':lcd ' .escape(expand(current_dir),  ' #\')
endfunction

command! -buffer -nargs=0 Xcodebuild call s:xcodebuild()

if !exists('g:objc_flyquickfixmake')
  let g:objc_flyquickfixmake = 1
endif
if !executable('xcodebuild')
  " echoerr "can't execute flyquickfixmake"
else
  au! BufWritePost *.m
        \ if exists('b:cocoa_proj') && b:cocoa_proj != ""
        \ | call objc#xcodebuild()
        \ | endif
endif


let &cpo = s:save_cpo
