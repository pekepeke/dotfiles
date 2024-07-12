
local HOME = os.getenv('HOME')
local VIM_CACHE = HOME..'/.cache/nvim'
local TEMP = nil
for _, name in pairs({'TEMP', 'TMP'}) do
	TEMP = os.getenv('TEMP')
	if TEMP then
		break
	end
end
if not TEMP then
	TEMP = os.tmpname():match("(.*)")
end
local function map(mode, lhs, rhs, opts)
	if not opts then opts = {} end
	vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
local function noremap(mode, lhs, rhs, opts)
	if not opts then opts = {} end
	local options = vim.tbl_extend("force", {noremap = true}, opts)
	vim.keymap.set(mode, lhs, rhs, options)
end
local function myautocmd(event, opts)
	-- error(vim.inspect(event)..vim.inspect(opts))
	opts.group = 'MyAutoCmd'
	vim.api.nvim_create_autocmd(event, opts)
end
local function lazy(callback)
	local opts = {
		pattern = '*',
		callback = callback,
	}
	myautocmd({'VimEnter'}, opts)
end

-- vim.api.nvim_create_autocmd('')
local util = {
	HOME = HOME,
	VIM_CACHE = VIM_CACHE,
	TEMP = TEMP,
	is_win = vim.fn.has('win16')==1 or vim.fn.has('win32')==1 or vim.fn.has('win64')==1,
	is_mac = vim.fn.has('mac')==1 or vim.fn.has('macunix')==1 or vim.fn.has('gui_mac')==1,
	mkdir = function (dir)
		if vim.fn.isdirectory(dir) ~= 0 then
			vim.fn.mkdir(dir, 'p')
		end
	end,
	initAutocmdGroup = function()
		vim.api.nvim_create_augroup('MyAutoCmd', {})
		vim.api.nvim_create_user_command('MyAutoCmd', function(callback)
			vim.cmd('autocmd MyAutoCmd '..callback["args"])
		end, {bang = true, nargs='*'})
		vim.api.nvim_create_user_command('Lazy', function(callback)
			-- error(vim.inspect(callback))
			vim.cmd(callback["args"])
		end, {bang = true, nargs='*'})
	end,
	-- clearAutocmd = function()
	-- 	vim.api.nvim_clear_autocmds({ group = 'MyAutoCmd' })
	-- end,
	myautocmd = myautocmd,
	map = function(lhs, rhs, opts)
		-- map('nvo', lhs, rhs, opts)
		map('n', lhs, rhs, opts)
		map('v', lhs, rhs, opts)
		map('o', lhs, rhs, opts)
	end,
	noremap = function(lhs, rhs, opts)
		-- noremap('nvo', lhs, rhs, opts)
		noremap('n', lhs, rhs, opts)
		noremap('v', lhs, rhs, opts)
		noremap('o', lhs, rhs, opts)
	end,
	lazy = lazy,
}

for _, mode in pairs({'n', 'i', 'x', 's', 'o', 'v', 't', 'c'}) do
	util[mode..'map']= function(lhs, rhs, opts) map(mode, lhs, rhs, opts) end
	util[mode..'noremap']= function(lhs, rhs, opts) noremap(mode, lhs, rhs, opts) end
end

return util
