" Vim filetype plugin file
" Language:     Microsoft C#
" Maintainer:   Kian Ryan (kian@orangetentacle.co.uk)
" Last Change:  2012 Sep 22

if ! exists('b:current_compiler')
    if has('win32') || has('win64')
        if dotnetsdk#find_dotnet_solution_file() != ""
            compiler msbuild
        else
            compiler cs
        endif
    else
        compiler gmcs
    endif
endif

set syntax=cs

setl tabstop=4
setl shiftwidth=4
setl softtabstop=4
setl expandtab
setl autoindent
