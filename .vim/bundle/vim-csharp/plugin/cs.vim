" Vim plugin file
" Language:     Microsoft C#
" Maintainer:   Kian Ryan (kian@orangetentacle.co.uk)
" Last Change:  2012 Sep 23

function! CsProjFile(file)
    let b:dotnet_build_file = a:file
    compiler msbuild
endfunction

function! CsVersion(version)
    let g:dotnet_framework_version = a:version
    compiler msbuild
endfunction

com! -complete=file -nargs=1 CsProjFile :call CsProjFile(<f-args>)
com! -nargs=1 CsVersion :call CsVersion(<f-args>)
