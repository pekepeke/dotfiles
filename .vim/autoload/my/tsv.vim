let s:save_cpo = &cpo
set cpo&vim

function! my#tsv#to_sqlwhere() range "{{{2
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    let l:keywords = copy(l:head)
    call map(l:keywords, '[v:val, get(l:items, v:key, "")]')
    let l:where = []
    for [l:name, l:value] in l:keywords
      call add(l:where, l:name . " = '" . l:value . "'")
    endfor
    call add(l:texts, join(l:where, ' AND '))
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! my#tsv#to_sqlin() range "{{{2
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif
  let l:texts = []
  let l:rows = map(copy(l:head), '[v:val]')
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    call map(l:rows, 'v:val + [get(l:items, v:key, "")]')
  endfor
  for l:row in l:rows
    let l:name = remove(l:row, 0)
    call add(l:texts, l:name . " IN ('" . join(l:row, "', '") ."')")
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! my#tsv#exchange_matrix() range "{{{2
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif
  let l:texts = []
  let l:rows = map(copy(l:head), '[v:val]')
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = split(l:line, "\t", 1)
    call map(l:rows, 'v:val + [get(l:items, v:key, "")]')
  endfor
  for l:row in l:rows
    call add(l:texts, join(l:row, "\t"))
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! my#tsv#to_sqlinsert() range "{{{2
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = map(split(l:line, "\t", 1), "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let l:datas = map(copy(l:head), 'get(l:items, v:key, "NULL")')
    call add(l:texts, 'INSERT INTO X ('.join(l:head, ', ').') VALUES ('.join(l:datas, ', ').');')
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction
function! my#tsv#to_sqlupdate() range "{{{2
  let l:lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  if empty(l:lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let l:head = split(remove(l:lines, 0), "\t", 1)
  if empty(l:head)
    echoerr "column name header is not found"
    return
  endif

  let l:where_ids = map(filter(copy(l:head), 'v:val =~ "^id$"'), 'v:key')
  if empty(l:where_ids)
    let l:where_ids = map(filter(copy(l:head), 'v:val =~ "^.*id$"'), 'v:key')
    if empty(l:where_ids)
      let l:where_ids = [l:head[0]]
    endif
  endif

  if empty(l:where_ids)
    echoerr "column id is not found"
    return
  endif

  let l:texts = []
  for l:line in l:lines
    if empty(l:line)
      continue
    endif
    let l:items = map(split(l:line, "\t", 1), "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let l:wheres = []
    for l:where_id in l:where_ids
      call add(l:wheres, l:head[l:where_id] . " = " . get(l:items, l:where_id, "NULL"))
    endfor

    let l:head_label = copy(l:head)
    for l:where_id in l:where_ids
      call remove(l:items, l:where_id)
      call remove(l:head_label, l:where_id)
    endfor

    let l:datas = map(copy(l:head_label), 'v:val ." = ". get(l:items, v:key, "NULL")')
    call add(l:texts, 'UPDATE X SET '
          \ .join(l:datas, ', ')
          \ .(empty(l:wheres) ? "" : ' WHERE '.join(l:wheres, ' AND ')).";"
          \ )
  endfor
  call my#util#output_to_buffer('__TSV__', l:texts)
endfunction 
" }}}

let &cpo = s:save_cpo
