local util = require('my/util')

local map = util.map
local nmap = util.nmap
local imap = util.imap
local xmap = util.xmap
local smap = util.smap
local omap = util.omap
local vmap = util.vmap
local tmap = util.tmap
local cmap = util.cmap
local noremap = util.noremap
local nnoremap = util.nnoremap
local inoremap = util.inoremap
local xnoremap = util.xnoremap
local snoremap = util.snoremap
local onoremap = util.onoremap
local vnoremap = util.vnoremap
local tnoremap = util.tnoremap
local cnoremap = util.cnoremap

noremap('[!space]', '<Nop>')
nnoremap('g<Space>', '<Space>')
vnoremap('g<Space>', '<Space>')
nmap('<Space>', '[!space]')
vmap('<Space>', '[!space]')

noremap('[!edit]', '<Nop>')
nmap('<C-e>', '[!edit]')
vmap('<C-e>', '[!edit]')

noremap('[!comment-doc]', '<Nop>')
map(',c', '[!comment-doc]')

noremap('[!t]', '<Nop>')
nmap('t', '[!t]')
nnoremap('[!t]e', 't', {silent=true})
nnoremap('[!t]2', 't"', {silent=true})
nnoremap('[!t]7', "t'", {silent=true})
nnoremap('[!t]8', 't(', {silent=true})
nnoremap('[!t]9', 't)', {silent=true})
nnoremap('[!t][', 't[', {silent=true})
nnoremap('[!t]]', 't]', {silent=true})

nnoremap('q', '<Nop>')
-- nnoremap('q:', 'q:')
-- nnoremap('q/', 'q/')
-- nnoremap('q?', 'q?')
nnoremap('Q', 'q')

-- 行単位で移動 {{{2
nnoremap('j', 'v:count == 0 ? "gj": "j"', { expr=true })
xnoremap('j', '(v:count == 0 && mode() !=# "V") ? "gj": "j"', { expr=true })
nnoremap('k', 'v:count == 0 ? "gk": "k"', { expr=true })
xnoremap('k', '(v:count == 0 && mode() !=# "V") ? "gk": "k"', { expr=true })

nnoremap('ZZ', '<NOP>')
nnoremap('ZQ', '<NOP>')
if string.match(os.getenv('TERM'), 'screen') then
	map('<C-z>', '<Nop>')
end

nnoremap('gs', ':<C-u>setf<Space>')
nmap('Y', 'y$')

-- TODO:
-- -- http://vim-users.jp/2009/10/hack91/
cnoremap('/', [[getcmdtype() == '/' ? '\/' : '/']], { expr=true })
cnoremap('?', [[getcmdtype() == '?' ? '\?' : '?']], { expr=true })

-- " indent whole buffer
-- nnoremap [!space]= call <SID>execute_motionless('normal! gg=G')

nnoremap('[!t]n', 'gt', {silent=true})
nnoremap('[!t]p', 'gT', {silent=true})
nnoremap('[!t]h', 'gT', {silent=true})
nnoremap('[!t]l', 'gt', {silent=true})
nnoremap('[!t]c', ':<C-u>tabnew<CR>', {silent=true})
nnoremap('[!t]C', ':<C-u>tabnew %<CR>:normal! <C-o><CR>', {silent=true})
nnoremap('[!t]*', ':<C-u>tabedit %<CR>*', {silent=true})
nnoremap('[!t]#', ':<C-u>tabedit %<CR>#', {silent=true})
nnoremap('[!t]q', ':<C-u>tabclose<CR>', {silent=true})

-- " redraw map
nmap('sr', ':redraw!<CR>', {silent=true})

-- " for gui
nnoremap('<M-a>', 'ggVG')
nnoremap('<M-v>', 'P')
vnoremap('<M-c>', 'y')
vnoremap('<M-x>', 'x')

-- " winmove & winsize {{{2
nnoremap('<C-Left>',  ':wincmd h<CR>', {silent=true})
nnoremap('<C-Right>', ':wincmd l<CR>', {silent=true})
nnoremap('<C-Up>',    ':wincmd k<CR>', {silent=true})
nnoremap('<C-Down>',  ':wincmd j<CR>', {silent=true})

nnoremap('<S-Left>',  ':10wincmd ><CR>', {silent=true})
nnoremap('<S-Right>', ':10wincmd <<CR>', {silent=true})
nnoremap('<S-Up>',    ':10wincmd -<CR>', {silent=true})
nnoremap('<S-Down>',  ':10wincmd +<CR>', {silent=true})

-- " win switch
for i=0, 9 do
	nnoremap('<C-w>'..i, '<C-w>t'..string.rep('<C-w>w', (i+9)%10), {silent=true})
end

nnoremap('<C-w><C-n>', ':tabnext<CR>')
nnoremap('<C-w><C-p>', ':tabprev<CR>')
nnoremap('<C-w><C-c>', ':tabnew<CR>')
-- " tmaps
tnoremap('<C-w><C-n>', '<C-w>:tabnext<CR>')
tnoremap('<C-w><C-p>', '<C-w>:tabprev<CR>')
tnoremap('<C-w><C-c>', '<C-w>:tabnew<CR>')
tnoremap('<C-\\><C-\\>', '<C-\\><C-n>')
-- " tnoremap <Esc> <C-\><C-n>

nnoremap('[!t]r', 't')

-- TODO
-- let g:square_brackets = {
--

-- TODO
nnoremap('[!space].', ':source ~/.vimrc<CR>')

nnoremap('/', ':<C-u>nohlsearch<CR>/')
nnoremap('?', ':<C-u>nohlsearch<CR>?')

nnoremap('[!space]/', ':<C-u>nohlsearch<CR>')

nnoremap('[!space][', ':<C-u>cprevious<CR>')
nnoremap('[!space]]', ':<C-u>cnext<CR>')

nnoremap('<C-w><Space>', '<C-w>p')
nnoremap('*', '*N')
nnoremap('#', '#n')
nnoremap('<C-w>*', '<C-w>s*N')
nnoremap('<C-w>#', '<C-w>s#n')

-- " imaps {{{3
inoremap('<C-t>', '<C-v><Tab>')

inoremap('<C-f>', '<Right>')
inoremap('<C-b>', '<Left>')
inoremap('<C-d>', '<Delete>')
inoremap('<C-a>', '<Home>')
inoremap('<S-Insert>', '<C-r>+')
inoremap('<C-w>', '<C-g>u<C-w>')
inoremap('<C-u>', '<C-g>u<C-u>')

cnoremap('<C-a>', '<Home>')
cnoremap('<C-e>', '<End>')
cnoremap('<C-f>', '<Right>')
cnoremap('<C-b>', '<Left>')
cnoremap('<C-d>', '<Delete>')
cnoremap('<C-x>', [[<C-r>=substitute(expand('%:p:h'), ' ', '\\v:val', 'e')<CR>/]])
cnoremap('<C-z>', [[<C-r>=expand('%:p:r')<CR>]])
-- cnoremap('<C-t>', '<C-\>e<SID>expand_filename()<CR>')
--   function! s:expand_filename()
--     let c = getcmdline()
--     let files = split(glob(c), "\n")
--     if empty(files)
--       return c
--     endif
--     return join(files, " ")
--   endfunction
cnoremap('<Up>', '<C-p>')
cnoremap('<Down>', '<C-n>')
cnoremap('<C-p>', '<Up>')
cnoremap('<C-n>', '<Down>')

cnoremap('<C-]>a', '<Home>')
cnoremap('<C-]>e', '<End>')
cnoremap('<C-]>f', '<S-Right>')
cnoremap('<C-]>b', '<S-Left>')
cnoremap('<C-]>d', '<Delete>')
cnoremap('<C-]>i', '<C-d>')
cnoremap('<C-]><C-a>', '<Home>')
cnoremap('<C-]><C-e>', '<End>')
cnoremap('<C-]><C-f>', '<S-Right>')
cnoremap('<C-]><C-b>', '<S-Left>')
cnoremap('<C-]><C-d>', '<Delete>')
cnoremap('<C-]><C-i>', '<C-d>')

-- " v+omap
onoremap('aa', 'a>')
vnoremap('aa', 'a>')
onoremap('ia', 'i>')
vnoremap('ia', 'i>')
onoremap('ar', 'a]')
vnoremap('ar', 'a]')
onoremap('ir', 'i]')
vnoremap('ir', 'i]')
onoremap('ak', 'a)')
vnoremap('ak', 'a)')
onoremap('ik', 'i)')
vnoremap('ik', 'i)')
vnoremap('<C-a>', '<C-a>gv')
vnoremap('<C-x>', '<C-x>gv')

-- " vmaps {{{3
vnoremap('.', ':normal .<CR>')
-- vnoremap <Leader>tg    :Ginger<CR>
-- vnoremap <Leader>te    :Gte<CR>
-- vnoremap <Leader>tj    :Gtj<CR>
vnoremap('<Tab>',   '>gv')
vnoremap('<S-Tab>', '<gv')
-- "nnoremap : q:
xnoremap('.', ':normal .<CR>')
-- " from http://vim-users.jp/2011/04/hack214/
vnoremap('(',   't(')
vnoremap('))',  't)')
vnoremap(')]',  't]')
vnoremap(')[',  't[')
vnoremap(')""', 't"')
vnoremap("'",   "t'")
onoremap('(',   't(')
onoremap(')',   't)')
onoremap(']',   't]')
onoremap('[',   't[')
onoremap('"',   't"')
onoremap("'",   "t'")

