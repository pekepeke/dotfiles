" File: translategoogle.vim
" Author: daisuzu <daisuzu@gmail.com>

let s:save_cpo = &cpo
set cpo&vim

" difinitions {{{
let s:V = vital#of('translategoogle')
let s:BufferManager = s:V.import('Vim.BufferManager')
let s:HTTP = s:V.import('Web.HTTP')
let s:HTML = s:V.import('Web.HTML')
let s:JSON = s:V.import('Web.JSON')
let s:Message = s:V.import('Vim.Message')
let s:OptionParser = s:V.import('OptionParser')

augroup TranlateGoogle
    autocmd!
augroup END

let s:url = 'https://translate.google.com/'

let s:params = {
            \   'sl': g:translategoogle_default_sl,
            \   'tl': g:translategoogle_default_tl,
            \   'ie': g:translategoogle_default_ie,
            \   'oe': g:translategoogle_default_oe,
            \ }

let s:bufname_pre = 'translate.google.com'
let s:bufname_before = s:bufname_pre . '- before'
let s:bufname_after = s:bufname_pre . '- after'
let s:bufname_retrans = s:bufname_pre . '- retrans'

function! s:complete_language(optlead, cmdline, cursorpos)
    return filter(copy(g:translategoogle_languages),
                \ 'a:optlead == "" ? 1 : (v:val =~# a:optlead)')
endfunction

let s:parser = s:OptionParser.new()
call s:parser.on('--sl=VALUE', 'source language', {'completion': function('s:complete_language')})
call s:parser.on('--tl=VALUE', 'target language', {'completion': function('s:complete_language')})
call s:parser.on('--ie=VALUE', 'input encoding')
call s:parser.on('--oe=VALUE', 'outout encoding')

let s:translategoogle = {
            \   'index': -1,
            \   'buffers': [],
            \   'params': [],
            \   'retranslate': [],
            \   'auto_update': [],
            \ }
" }}}

" interfaces {{{
function! translategoogle#complete_command(arglead, cmdline, cursorpos)
    return s:parser.complete(a:arglead, a:cmdline, a:cursorpos)
endfunction

function! translategoogle#exchange()
  let sl = g:translategoogle_default_sl
  let g:translategoogle_default_sl = g:translategoogle_default_tl
  let g:translategoogle_default_tl = sl
endfunction

function! translategoogle#command(args)
    try
        let args = s:parser.parse(a:args)
    catch /vital: OptionParser: Must specify value for option:/
        call s:Message.error(v:exception)
        return s:parser.help()
    endtry

    if exists('args.help')
        return ''
    endif

    let text = iconv(join(get(args, '__unknown_args__', []), " "), &encoding, 'utf-8')

    return join(s:get_translated_text(text, args), "\n")
endfunction

function! translategoogle#buffer(bufnr, ...)
    if !a:bufnr
        return []
    endif

    let text = iconv(join(getbufline(a:bufnr, 1, '$'), "\n"), &encoding, 'utf-8')
    let params = get(a:000, 0, {})

    return s:get_translated_text(text, params)
endfunction

function! translategoogle#open()
    call s:open_buffers()
endfunction

" }}}

" internal functions {{{
function! s:define_cmd_map(idx)
    execute 'command! -buffer TranslateGoogleToggle call s:toggle_language(' . a:idx . ')'
    execute 'command! -buffer TranslateGoogleClose call s:close_buffers(' . a:idx . ')'
    execute 'command! -buffer TranslateGoogleEnableRetranslate call s:enable_retranslate(' . a:idx . ')'
    execute 'command! -buffer TranslateGoogleDisableRetranslate call s:disable_retranslate(' . a:idx . ')'
    execute 'command! -buffer TranslateGoogleEnableAutoUpdate let s:translategoogle.auto_update[' . a:idx . '] = 1'
    execute 'command! -buffer TranslateGoogleDisableAutoUpdate let s:translategoogle.auto_update[' . a:idx . '] = 0'
    execute 'command! -buffer TranslateGoogleStatus call s:show_status(' . a:idx . ')'

    if g:translategoogle_mapping_close != ''
        execute 'nnoremap <buffer> ' . g:translategoogle_mapping_close . ' :TranslateGoogleClose<CR>'
    endif
endfunction

function! s:toggle_language(idx)
    let tl = s:translategoogle.params[a:idx].tl
    let s:translategoogle.params[a:idx].tl = s:translategoogle.params[a:idx].sl
    let s:translategoogle.params[a:idx].sl = tl

    let bufnr = get(s:translategoogle.buffers[a:idx].before.list(), 0)
    let text = join(getbufline(bufnr, 1))
    if len(text)
        call s:update_buffers(a:idx)
    endif
endfunction

function! s:enable_retranslate(idx)
    if !s:translategoogle.retranslate[a:idx]
        let s:translategoogle.retranslate[a:idx] = 1

        call s:translategoogle.buffers[a:idx].after.move()
        call s:translategoogle.buffers[a:idx].retrans.open(s:bufname_retrans,
                    \ {'opener': g:translategoogle_default_opener_retrans})
        call s:define_cmd_map(a:idx)

        let retrans = translategoogle#buffer(get(s:translategoogle.buffers[a:idx].after.list(), 0),
                    \   {'sl': s:translategoogle.params[a:idx].tl, 'tl': s:translategoogle.params[a:idx].sl}
                    \ )
        call s:rewrite_buffer(retrans)

        call s:translategoogle.buffers[a:idx].before.move()
    else
        call s:Message.warn('already enabled')
    endif
endfunction

function! s:disable_retranslate(idx)
    if s:translategoogle.retranslate[a:idx]
        let s:translategoogle.retranslate[a:idx] = 0
        call s:translategoogle.buffers[a:idx].retrans.close()
        call s:translategoogle.buffers[a:idx].before.move()
    else
        call s:Message.warn('already disabled')
    endif
endfunction

function! s:show_status(idx)
  echo s:translategoogle.params[a:idx]
endfunction

function! s:create_buffers()
    let s:translategoogle.index += 1
    call add(s:translategoogle.buffers,
                \   {
                \       'before': s:BufferManager.new(),
                \       'after': s:BufferManager.new(),
                \       'retrans': s:BufferManager.new(),
                \   }
                \ )
    call add(s:translategoogle.params,
                \   {
                \       'sl': g:translategoogle_default_sl,
                \       'tl': g:translategoogle_default_tl,
                \       'ie': g:translategoogle_default_ie,
                \       'oe': g:translategoogle_default_oe,
                \   }
                \ )
    call add(s:translategoogle.retranslate,
                \   g:translategoogle_enable_retranslate
                \ )
    call add(s:translategoogle.auto_update,
                \   1
                \ )
endfunction

function! s:open_buffers(...)
    if !a:0
        if s:translategoogle.index < 0
            call s:create_buffers()
        endif

        let idx = 0
    else
        let idx = a:1
    endif

    call s:translategoogle.buffers[idx].before.open(s:bufname_before,
                \ {'opener': g:translategoogle_default_opener_before})
    setlocal buftype=nofile
    call s:define_cmd_map(idx)
    autocmd! TranlateGoogle * <buffer>
    execute 'autocmd TranlateGoogle InsertLeave,TextChanged <buffer> call s:update_buffers(' . idx . ')'
    silent doautocmd User PluginTranslateGoogleInitializeAfter

    call s:translategoogle.buffers[idx].after.open(s:bufname_after,
                \ {'opener': g:translategoogle_default_opener_after})
    call s:define_cmd_map(idx)

    if s:translategoogle.retranslate[idx]
        call s:translategoogle.buffers[idx].retrans.open(s:bufname_retrans,
                    \ {'opener': g:translategoogle_default_opener_retrans})
        call s:define_cmd_map(idx)
    endif
    silent doautocmd User PluginTranslateGoogleInitializeAfter

    call s:translategoogle.buffers[idx].before.move()
endfunction

function! s:close_buffers(idx)
    call s:translategoogle.buffers[a:idx].before.close()
    call s:translategoogle.buffers[a:idx].after.close()
    if s:translategoogle.retranslate[a:idx]
        call s:translategoogle.buffers[a:idx].retrans.close()
    endif
endfunction

function! s:update_buffers(idx)
    if !s:translategoogle.auto_update[a:idx]
        return
    endif

    let after = translategoogle#buffer(get(s:translategoogle.buffers[a:idx].before.list(), 0),
                \   {'sl': s:translategoogle.params[a:idx].sl, 'tl': s:translategoogle.params[a:idx].tl}
                \ )
    call s:translategoogle.buffers[a:idx].after.move()
    call s:rewrite_buffer(after)

    if s:translategoogle.retranslate[a:idx]
        let retrans = translategoogle#buffer(get(s:translategoogle.buffers[a:idx].after.list(), 0),
                    \   {'sl': s:translategoogle.params[a:idx].tl, 'tl': s:translategoogle.params[a:idx].sl}
                    \ )
        call s:translategoogle.buffers[a:idx].retrans.move()
        call s:rewrite_buffer(retrans)
    endif

    call s:translategoogle.buffers[a:idx].before.move()
endfunction

function! s:rewrite_buffer(text)
    setlocal modified
    % delete _
    call append(0, a:text)
    setlocal nomodified
endfunction

function! s:get_translated_text(text, ...)
    let getdata = {
                \     'sl': get(a:1, 'sl', s:params.sl),
                \     'tl': get(a:1, 'tl', s:params.tl),
                \     'ie': get(a:1, 'il', s:params.ie),
                \     'oe': get(a:1, 'ol', s:params.oe),
                \     'text': a:text,
  \ 'client': 't', 'sc': '2',
  \ 'oc': '1', 'otf': '1', 'ssel': '0', 'tsel': '0',
  \ 'hl': 'ja',
                \ }
    let headdata = {'User-Agent': 'w3m/0.5.3'}

    try
        let response = s:HTTP.get(s:url . 'translate_a/t', getdata, headdata)
    catch /.*/
        call s:Message.error(v:exception)
        return []
    endtry

    if response.status != 200
        call s:Message.error(response.statusText)
        return []
    endif

    let s = substitute(response.content, ',\+', ',', 'g')
    try
      let json = s:JSON.decode(s)
    finally
      echohl Error
      echomsg v:exception . ":" . response.content
      echohl Normal
    endtry

    let text = []
    if exists('json[0][0][0]')
      let text = split(json[0][0][0], "\n")
    endif
    " let html = s:HTML.parse(response.content)
    " let result = html.find({'id': 'result_box'}).childNodes()

    " let text = []
    " let tmp_string = ""
    " for childs in result
    "     for child in childs.child
    "         if type(child) == 4
    "             call add(text, tmp_string)
    "             let tmp_string = ""
    "         else
    "             let tmp_string.= substitute(child, '&quot', '"', 'g')
    "         endif
    "         unlet child
    "     endfor
    " endfor

    " if tmp_string != ""
    "     call add(text, tmp_string)
    " endif

    return text
endfunction
" }}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
