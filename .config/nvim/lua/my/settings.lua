local util = require('my/util')
local project = require('my/project')
local HOME = util.HOME
local VIM_CACHE = util.VIM_CACHE
local TEMP = util.TEMP
local is_win = util.is_win
local mkdir = util.mkdir
local myautocmd = util.myautocmd
local autochdir = project.autochdir

vim.cmd(string.format('let $VIM_CACHE="%s"', VIM_CACHE))
vim.cmd(string.format('let $VIM_REFDOC="%s"', vim.fn.expand('~/.local/share/vim/docs')))
util.initAutocmdGroup()

myautocmd({'BufEnter', 'BufRead'}, {
	pattern = '*',
	callback = autochdir,
})


-- vim.cmd('set guioptions+=T guioptions-=m guioptions-=M')
-- vim.opt.runtimepath^=$HOME/.vim
-- vim.opt.runtimepath+=$HOME/.vim/after
vim.opt.encoding='utf-8'
-- vim.opt.termencoding='utf-8'
vim.opt.fileencoding='utf-8'
vim.opt.fileformat=unix
if not vim.fn.has('gui_running') then
	-- vim.cmd([[set termguicolors]])
	vim.opt.termguicolors=true
end
vim.opt.fileencodings='ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932'
vim.opt.fileformats='unix,dos,mac'
vim.opt.synmaxcol=1000
vim.opt.clipboard:append(vim.fn.has('mac') == 1 and 'unnamed' or 'unnamedplus')

vim.opt.display=lastline
vim.opt.spell=false
vim.opt.spelllang='en_us,cjk'
vim.opt.spellfile=HOME..'/.vim/spell/spellfile.utf-8.add'
vim.opt.autochdir=false
-- vim.opt.shellslash=true -- windows only
vim.opt.directory = VIM_CACHE..',/var/tmp,/tmp'
vim.opt.viminfo:append('!')
vim.opt.viminfo:append('n'..VIM_CACHE..'/viminfo.txt')
if vim.o.diff then
	vim.opt.foldlevel=100
end
vim.opt.lazyredraw=true
vim.opt.ttyfast=true
vim.opt.scrolloff=10000000
vim.opt.sidescrolloff=999
vim.opt.number=true
vim.opt.ruler=true

vim.opt.wrap=false
vim.opt.nrformats:remove('octal')
vim.opt.modeline=true
vim.opt.modelines=10

vim.opt.mouse=nch
vim.opt.mousefocus=false
vim.opt.mousehide=true
vim.opt.timeoutlen=1000
vim.opt.ttimeoutlen=100
vim.opt.updatetime=200

vim.opt.pumheight=10
vim.opt.showmatch=true
vim.opt.matchtime=1
vim.opt.showcmd=true
vim.opt.showfulltag=true
vim.opt.backspace=indent,eol,start
vim.opt.linebreak=false
vim.opt.textwidth=1000
vim.opt.formatoptions:append('mM')
vim.opt.whichwrap='b,s,h,l,<,>,[,]'
vim.opt.colorcolumn='+1'
vim.opt.splitbelow=true
vim.opt.splitright=true
vim.opt.switchbuf=useopen
vim.opt.title=true
vim.opt.sessionoptions:remove('options')

vim.opt.hidden=true
vim.opt.sidescroll=5
vim.opt.visualbell=false
-- vim.opt.noerrorbells t_vb=
vim.opt.equalalways=false
vim.opt.langmenu=none
vim.opt.helplang=ja,en
vim.opt.keywordprg=":help"
vim.opt.foldmethod=marker

vim.opt.autoindent=true
vim.opt.smartindent=false
vim.opt.cindent=false
vim.opt.breakindent=true
vim.opt.list=true
vim.opt.showbreak='+++ '
vim.opt.listchars=[[tab:^ ,trail:~,nbsp:%,extends:>,precedes:<]]
vim.opt.smarttab=true
vim.opt.expandtab=false
vim.opt.softtabstop=0 tabstop=4 shiftwidth=4
vim.opt.ambiwidth=double
vim.opt.conceallevel=2 concealcursor=i
vim.opt.winaltkeys=no
-- vim.opt.pastetoggle='<F10>'

vim.opt.ignorecase=true
vim.opt.smartcase=true
vim.opt.wrapscan=true
vim.opt.infercase=true
vim.opt.incsearch=true
vim.opt.hlsearch=true
vim.opt.virtualedit:append('block')

vim.opt.backup=false
vim.opt.swapfile=false
vim.opt.writebackup=false
vim.opt.autoread=true
vim.opt.backupcopy='yes'
vim.opt.backupskip='/tmp/*,'..TEMP..'/*,*.tmp,crontab.*'
vim.opt.backupdir=VIM_CACHE..'/vim-backups'
vim.opt.viewdir=VIM_CACHE..'/vim-views'
mkdir(vim.o.backupdir)
mkdir(vim.o.viewdir)

vim.opt.undodir=VIM_CACHE..'/vim-undo'
mkdir(vim.o.undodir)

vim.opt.undofile=true


-- " 補完 {{{2
vim.opt.wildmenu=true
vim.opt.wildmode='list:longest,list:full'
-- vim.opt.wildchar='<tab>'
vim.opt.wildignore:append('*.o,*.obj,*.rbc,*.dll,*.exe')
vim.opt.wildignore:append('*.out,*.aux')
vim.opt.wildignore:append('.git,.svn')
vim.opt.wildignore:append('.DS_Store')
vim.opt.wildignore:append('*.spl')
vim.opt.wildignore:append('*.png,*.jpg,*.gif')
vim.opt.wildignore:append('+.so,*.sw?')
vim.opt.wildignore:append('+.luac,*.jar,*.pyc,.class')
vim.opt.completeopt='menuone'
vim.opt.complete='.,w,b,u,t,i,k'
vim.opt.background=dark

vim.opt.grepprg='rg'
vim.opt.grepformat='%f:%l:%m'

vim.opt.laststatus=2
vim.opt.viewoptions='cursor'

if is_win then
	myautocmd({'BufWritePost'}, {
		pattern = {"*"},
		callback = function(ev)
			if string.find(vim.fn.getline('1'), '^#!') then
				vim.fn.execute('silent! chmod +x')
			end
		end
	})
end
myautocmd({'BufWritePre'}, {
	pattern = {'*'},
	callback = function(ev)
		local dir = vim.fn.expand('%:p:h')
		if vim.fn.isdirectory(dir) == 0
			and string.find(vim.fn.input(string.format('"%s" does not exist. Create? [y/N]', dir)), '^ye?s?$') == 1 then
			vim.fn.mkdir(dir, 'p')
		end
	end
})


