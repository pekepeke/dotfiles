" Vim plugin functions
" Language:     Microsoft C#
" Maintainer:   Kian Ryan (kian@orangetentacle.co.uk)
" Last Change:  2012 Sep 23

let s:dotnet_frameworks = {
  \ '1' : 'v1.1.4322',
  \ '2' : 'v2.0.50727',
  \ '3.5' : 'v3.5',
  \ '4' : 'v4.0.30319',
  \ }


function! s:get_dotnet_framework_dir(version)

    if exists("g:dotnet_sdk_root")
        let dotnet_framework_root = g:dotnet_framework_root
    else
        let dotnet_framework_root = $WINDIR . "\\Microsoft.NET\\Framework\\"
    endif

   let ver = get(s:dotnet_frameworks, a:version, "")
   if !empty(ver)
       return dotnet_framework_root . "\\" . ver . "\\"
   endif
endfunction

function! dotnetsdk#get_dotnet_compiler(compiler)

    if exists("g:dotnet_framework_version")
        let msbuild = s:get_dotnet_framework_dir(g:net_framework_version) . a:compiler
        return msbuild
    else
        for i in keys(s:dotnet_frameworks)
            let msbuild = s:get_dotnet_framework_dir(i) . a:compiler
            if findfile(msbuild) != ""
                return msbuild
            endif
        endfor
    endif

    echom "Unable to find " . a:compiler
endfunction

function! dotnetsdk#find_dotnet_solution_file()
	if exists('b:dotnet_build_file')
		return b:dotnet_build_file
	endif
    return globpath(".", "*.sln")
endfunction

