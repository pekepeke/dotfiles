let s:save_cpo = &cpo
set cpo&vim

" bufutil {{{1
let s:bufutil = {}
function! s:bufutil.new(...) "{{{
  let obj = copy(self)
  if a:0 > 0
    return extend(obj, a:1)
  endif
  return obj
endfunction "}}}

function! s:bufutil.buffer_init() "{{{
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal buflisted
  resize 8
endfunction "}}}

function! s:bufutil.set_text(bufname, text) "{{{
  let bufname = a:bufname
  let bufnum = bufnr(bufname)
  if bufnum == -1
    execute 'new' bufname
    call self.buffer_init()
  else
    let winnum = bufwinnr(bufnum)
    if winnum != -1
      if bufwinnr('%') != winnum
        execute winnum . "wincmd w"
      endif
    else
      silent execute 'split +buffer' bufname
    endif
  endif

  normal! "Gzz"
  call append(line('$'), a:text)
endfunction "}}}

function! s:bufutil.command(count, l1, l2, ...) "{{{
  let args = copy(a:000)
  if a:count != 0
    let text = join(getline(a:l1, a:l2), "\n")

    call remove(args, len(args) - 1)
    let args += [text]
  endif
  call self.execute(args)
endfunction "}}}

" ref gtrans {{{1
let s:ref_gtrans = s:bufutil.new()
function! s:ref_gtrans.execute(args) "{{{2
  let [source, text] = a:args
  execute "Ref" "webdict" source text
endfunction

function! my#buf_util#ref_gtrans(...) "{{{2
  call call(s:ref_gtrans.command, a:000, s:ref_gtrans)
endfunction

" google translate {{{1
let s:gtrans = s:bufutil.new({
  \ 'endpoint': 'http://translate.google.co.jp/translate_a/t',
  \ 'header': {
  \ 'User-Agent': 'w3m/0.5.3',
  \ },
  \ 'query' : {
  \ 'client': 't', 'sc': '2', 'ie': 'UTF-8', 'oe': 'UTF-8',
  \ 'oc': '1', 'otf': '1', 'ssel': '0', 'tsel': '0',
  \ 'sl': 'en', 'tl': 'ja', 'hl': 'ja',
  \ },
  \ })

function s:gtrans.execute(args) "{{{
  let [sltl, text] = a:args
  if strlen(sltl) > 3
    let sl = sltl[0:1]
    let tl = sltl[2:3]
  else
    let sl = "en"
    let tl = "ja"
  endif

  let query = extend(copy(self.query), {
    \ 'q': text, 'sl': sl, 'tl': tl, })

  let res = webapi#http#get(self.endpoint, query, self.header)
  if res.status != 200
    return
  endif
  let s = substitute(res.content, ',\+', ',', 'g')
  let json = webapi#json#decode(s)
  if exists('json[0][0][1]')
    let lines = split(printf("Original: %s\nTranslated: %s",
      \ json[0][0][1], json[0][0][0]), "\n")
    call self.set_text("[Google Translate]", lines)
  endif
endfunction "}}}

function! my#buf_util#gtrans(...) "{{{2
  call call(s:gtrans.command, a:000, s:gtrans)
endfunction

" ginger {{{1
let s:ginger = s:bufutil.new({
  \ 'endpoint' : 'http://services.gingersoftware.com/Ginger/correct/json/GingerTheText',
  \ 'apikey' : '6ae0c3a0-afdc-4532-a810-82ded0054236',
  \ })

function! s:ginger.execute(args) "{{{2
  let [text] = a:args
  let [mistake, correct] = self.get(text)

  let texts = split(printf("Original: %s\nCorrect: %s", text, correct), "\n")
  call self.set_text("[Ginger]", texts)
endfunction

function! s:ginger.get(text)  "{{{2
  let res = webapi#json#decode(webapi#http#get(self.endpoint, {
    \ 'lang': 'US',
    \ 'clientVersion': '2.0',
    \ 'apiKey': self.apikey,
    \ 'text': a:text}).content)
  let i = 0
  let mistake = ''
  let correct = ''
  " echon "Mistake: "
  for rs in res['LightGingerTheTextResult']
    let [from, to] = [rs['From'], rs['To']]
    if i < from
      " echon a:text[i : from-1]
      let mistake .= a:text[i : from-1]
      let correct .= a:text[i : from-1]
    endif
    " echohl WarningMsg
    " echon a:text[from : to]
    let mistake .= a:text[from : to]
    " echohl None
    if exists("rs['Suggestions'][0]")
      let correct .= rs['Suggestions'][0]['Text']
    endif
    let i = to + 1
  endfor
  if i < len(a:text)
    " echon a:text[i :]
    let mistake .= a:text[i :]
    let correct .= a:text[i :]
  endif
  " echo "Correct: ".correct
  " return correct
  return [mistake, correct]
endfunction

function! my#buf_util#ginger(...) "{{{2
  call call(s:ginger.command, a:000, s:ginger)
endfunction

let &cpo = s:save_cpo
" __END__ {{{1
