let s:source = {
      \ 'name': 'titanium',
      \ 'kind' : 'ftplugin',
      \ 'filetypes': { 'ruby': 1, 'js': 1 },
      \ }

function! s:source.initialize()
endfunction

function! s:source.finalize()
endfunction

function! s:source.get_keyword_pos(cur_text)
  return matchend(a:cur_text[:getpos('.')[2]], 'Ti\S\+')
endfunction

function! s:source.get_complete_words(cur_keyword_pos, cur_keyword_str)
  let words = titanium#complete#words()
  call map(words, 'split(v:val, "\\s\\+#\\s\\+")')
  return map(list, "{'word': substitute(v:val[0], '^'.cur_keyword_str, '', ''), 'menu': v:val[1]}")
endfunction

function! neocomplcache#sources#titanium#define()
  "return s:source
  return {}
endfunction

