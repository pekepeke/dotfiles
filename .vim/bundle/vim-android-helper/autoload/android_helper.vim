let s:save_cpo = &cpo
set cpo&vim

let s:is_mac = has('mac') || has('macunix') || has('gui_macvim') ||
      \ (executable('uname') && system('uname') =~? '^darwin')
let s:is_win = has('win16') || has('win32') || has('win64')
let s:saved_classpath = ''

let g:android_sdk_path = get(g:, 'android_sdk_path', '')


function! android_helper#add_android_classpath()
  let root = android_helper#get_proj_dir(expand('%:p:h'))
  if strlen(root) > 0
    let sdk_ver = android_helper#get_sdk_version(root)
    let jar = android_helper#get_android_jar_path(sdk_ver)
    call android_helper#merge_classpath(jar)
    return 1
  endif
  return 0
endfunction

function! android_helper#get_proj_dir(path)
  let path = fnamemodify(a:path, ":p:h")
  let prev_path = ""

  while (path != prev_path)
    if filereadable(s:file_join(path, "AndroidManifest.xml"))
      return path
    endif
    let prev_path = path
    let path = fnamemodify(path, ":p:h")
  endwhile
  return ""
endfunction


function! android_helper#get_sdk_version(proj_root)
  let prop_path = s:file_join(a:proj_root, "project.properties")

  if filereadable(prop_path)
    let entries = filter(readfile(prop_path), 'v:val !~? "^#" && v:val =~? "^.\\+=.\\+"')
    if len(entries) > 0
      return split(entries[0], "=")[1]
    endif
  endif
  return ""
endfunction


function! android_helper#get_android_jar_path(ver)
  return s:file_join(g:android_sdk_path, 'platforms', a:ver, 'android.jar')
endfunction


function! android_helper#merge_classpath(...)
  if empty($CLASSPATH)
    let $CLASSPATH = join(a:000 + [$CLASSPATH], s:is_win ? ';' : ":")
  else
    let $CLASSPATH = join(a:000, s:is_win ? ';' : ":")
  endif
endfunction


function! android_helper#is_saved_classpath()
  return !empty(s:saved_classpath)
endfunction


function! android_helper#save_classpath()
  let s:saved_classpath = $CLASSPATH
endfunction


function! android_helper#restore_classpath()
  let $CLASSPATH = s:saved_classpath
endfunction

function! s:file_join(...)
  return join(a:000, s:is_win ? '\' : "/")
endfunction

function! s:detect_androidsdk_path(entries)
  for dir in a:entries
    if isdirectory(dir)
      let g:android_sdk_path = dir
      return
    endif
  endfor
endfunction

if empty(g:android_sdk_path)
  if s:is_win
    call s:detect_androidsdk_path(['C:\android\android-sdk-windows'])
  elseif s:is_mac
    call s:detect_androidsdk_path(
          \ ['/Applications/android-sdk-mac_x86', '/opt/android-sdk']
          \ + split(globpath('/usr/local/Cellar/android-sdk', '*'), "\n")
          \ )
  else
    call s:detect_androidsdk_path(['/usr/local/android-sdk-linux'])
  endif
endif


let &cpo = s:save_cpo
