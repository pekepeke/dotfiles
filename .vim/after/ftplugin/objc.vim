scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

"setl path=.;,/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS4.1.sdk/System/Library/Frameworks,/Developer/SDKs/MacOSX10.6.sdk/System/Library/Frameworks,,
setl include=^\s*#\s*import
setl includeexpr=substitute(v:fname,'\/','\.framework/Headers/','g')
" setl dictionary=~/.vim/dict/objc.dict
" setl noexpandtab


let &cpo = s:save_cpo
