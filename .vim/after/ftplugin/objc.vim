scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

" setlocal path=.;,/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/System/Library/Frameworks,/Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks,,
setlocal include=^\s*#\s*import
setlocal includeexpr=substitute(v:fname,'\/','\.framework/Headers/','g')
" setlocal dictionary=~/.vim/dict/objc.dict
" setlocal noexpandtab


let &cpo = s:save_cpo
