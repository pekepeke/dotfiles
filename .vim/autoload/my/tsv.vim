let s:save_cpo = &cpo
set cpo&vim

function! my#tsv#to_sqlwhere() range "{{{2
  let lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  let tsv = csvutil#tsv_reader()
  let lines = tsv.parse_from_list(lines)
  if empty(lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let head = remove(lines, 0)
  if empty(head)
    echoerr "column name header is not found"
    return
  endif

  let texts = []
  for items in lines
    if empty(items)
      continue
    endif
    let keywords = copy(head)
    call map(keywords, '[v:val, get(items, v:key, "")]')
    let where = []
    for [name, value] in keywords
      call add(where, name . " = '" . value . "'")
    endfor
    call add(texts, join(where, ' AND '))
  endfor
  call my#util#output_to_buffer('__TSV__', texts)
endfunction

function! my#tsv#to_sqlin() range "{{{2
  let lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  let tsv = csvutil#tsv_reader()
  let lines = tsv.parse_from_list(lines)
  if empty(lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let head = remove(lines, 0)
  if empty(head)
    echoerr "column name header is not found"
    return
  endif
  let texts = []
  let rows = map(copy(head), '[v:val]')
  for items in lines
    if empty(line)
      continue
    endif
    call map(rows, 'v:val + [get(items, v:key, "")]')
  endfor
  for row in rows
    let name = remove(row, 0)
    call add(texts, name . " IN ('" . join(row, "', '") ."')")
  endfor
  call my#util#output_to_buffer('__TSV__', texts)
endfunction

function! my#tsv#exchange_matrix() range "{{{2
  let lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  let tsv = csvutil#tsv_reader()
  let lines = tsv.parse_from_list(lines)
  if empty(lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let head = remove(lines, 0)
  if empty(head)
    echoerr "column name header is not found"
    return
  endif
  let texts = []
  let rows = map(copy(head), '[v:val]')
  for items in lines
    if empty(items)
      continue
    endif
    call map(rows, 'v:val + [get(items, v:key, "")]')
  endfor
  for row in rows
    call add(texts, join(row, "\t"))
  endfor
  call my#util#output_to_buffer('__TSV__', texts)
endfunction

function! my#tsv#to_sqlinsert() range "{{{2
  let lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  let tsv = csvutil#tsv_reader()
  let lines = tsv.parse_from_list(lines)
  if empty(lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let head = remove(lines, 0)
  if empty(head)
    echoerr "column name header is not found"
    return
  endif

  let texts = []
  for items in lines
    if empty(items)
      continue
    endif
    let items = map(items, "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let datas = map(copy(head), 'get(items, v:key, "NULL")')
    call add(texts, 'INSERT INTO X ('.join(head, ', ').') VALUES ('.join(datas, ', ').');')
  endfor
  call my#util#output_to_buffer('__TSV__', texts)
endfunction

function! my#tsv#to_sqlupdate() range "{{{2
  let lines = a:firstline == a:lastline ? getline(1, '$') : getline(a:firstline, a:lastline)
  let tsv = csvutil#tsv_reader()
  let lines = tsv.parse_from_list(lines)
  if empty(lines)
    echoer "empty buffer : stop execute!!"
    return
  endif
  let head = remove(lines, 0)
  if empty(head)
    echoerr "column name header is not found"
    return
  endif

  let where_ids = map(filter(copy(head), 'v:val =~ "^id$"'), 'v:key')
  if empty(where_ids)
    let where_ids = map(filter(copy(head), 'v:val =~ "^.*id$"'), 'v:key')
    if empty(where_ids)
      let where_ids = [head[0]]
    endif
  endif

  if empty(where_ids)
    echoerr "column id is not found"
    return
  endif

  let texts = []
  for items in lines
    if empty(items)
      continue
    endif
    let items = map(items, "v:val == '' ? 'NULL' : \"'\".v:val.\"'\"")
    let wheres = []
    for where_id in where_ids
      call add(wheres, head[where_id] . " = " . get(items, where_id, "NULL"))
    endfor

    let head_label = copy(head)
    for where_id in where_ids
      call remove(items, where_id)
      call remove(head_label, where_id)
    endfor

    let datas = map(copy(head_label), 'v:val ." = ". get(items, v:key, "NULL")')
    call add(texts, 'UPDATE X SET '
          \ .join(datas, ', ')
          \ .(empty(wheres) ? "" : ' WHERE '.join(wheres, ' AND ')).";"
          \ )
  endfor
  call my#util#output_to_buffer('__TSV__', texts)
endfunction 
" }}}

let &cpo = s:save_cpo
