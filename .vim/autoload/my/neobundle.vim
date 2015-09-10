let s:save_cpo = &cpo
set cpo&vim

function! my#neobundle#summary_report() "{{{
  let bundles = neobundle#config#get_neobundles()
  let msgs = [
    \ printf("Installed   : %d", len(bundles)),
    \ printf("Enabled     : %d", len(filter(copy(bundles), '!v:val.lazy'))),
    \ printf("Lazy        : %d", len(filter(copy(bundles), 'v:val.lazy'))),
    \ printf("Not Sourced : %d", len(filter(copy(bundles), '!v:val.sourced'))),
    \ printf("Sourced     : %d", len(filter(copy(bundles), 'v:val.sourced'))),
    \ printf("\n### Sourced plugins\n%s", join(map(
    \   filter(copy(bundles), 'v:val.lazy && v:val.sourced'),
    \   'v:val.name'), "\n")),
    \ ]
  echo join(msgs, "\n")
endfunction " }}}

function! my#neobundle#validate_report() "{{{
  let bundles = neobundle#config#get_neobundles()
  let lazies = filter(copy(bundles), 'v:val.lazy && v:val.sourced')
  let plugins = []
  for item in lazies
    if isdirectory(item.path . '/plugin')
      continue
    endif
    call add(plugins, item)
  endfor
  if !empty(plugins)
    echo printf("Following plugins looks good should not be Lazy\n%s",
      \ join(map(plugins, 'v:val.name'), "\n"))
  else
    echo "Finish validate"
  endif
endfunction " }}}

let &cpo = s:save_cpo
