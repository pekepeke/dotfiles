function! s:PuppetGetModuleList()
  let puppet_root = "~/svn/puppet/modules/production"
  let result = expand(puppet_root . "/*")
  let filelist = split(result , "\n")
  return map(filelist, 'fnamemodify(v:val, ":t")')
endfunction

function! PuppetOpenModule()
  let items = s:PuppetGetModuleList()
  "echo  TypeOf(items)
  "let items = ['a','b','c']
  "let items = split(glob('~/.*'), "\n")
  call fuf#givenfile#launch('', 0, 'puppet-module>' , items)
  "call fuf#callbackitem#launch('', 0, 'Fu-Tag>', s:listener, items, 0)
endfunction
