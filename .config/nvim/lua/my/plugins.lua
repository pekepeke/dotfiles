local dpp_base = vim.fn.expand('~/.cache/dpp')

-- vim.g["denops#debug"] = 1
-- vim.g["denops#trace"] = 1
vim.g.denops_server_addr = "127.0.0.1:32123"
-- Set dpp source path (required)
local denops_src = dpp_base..'/repos/github.com/vim-denops/denops.vim'
local dpp_src_base = dpp_base..'/repos/github.com/Shougo'
local dpp_config = '~/.config/nvim/dpp.ts'
local dpp_repos = {
   'dpp.vim',
   'dpp-ext-toml',
   'dpp-ext-lazy',
   'dpp-ext-installer',
   'dpp-ext-local',
   'dpp-protocol-git',
   }

for _, repo in pairs(dpp_repos) do
	vim.opt.runtimepath:prepend(dpp_src_base..'/'..repo)
end
vim.opt.runtimepath:prepend(denops_src)
local dpp = require('dpp')

if dpp.load_state(dpp_base) then
  -- NOTE: dpp#make_state() requires denops.vim
  vim.api.nvim_create_autocmd('User', {
	  pattern = 'DenopsReady',
	  callback = function ()
		  dpp.make_state(dpp_base, dpp_config)
	  end
  })
end
vim.api.nvim_create_autocmd('User', {
	pattern = 'Dpp:makeStatePost',
	callback = function ()
		vim.notify('dpp make_state() is done')
	end
})

vim.api.nvim_create_user_command('DenopsCacheReload', function()
	vim.cmd([[call denops#cache#update(#{reload: v:true})]])
end, {bang = true})
vim.api.nvim_create_user_command('DppEditStartup', function()
	vim.cmd(string.format('edit %s/nvim/startup.vim', dpp_base))
end, {bang = true})
vim.api.nvim_create_user_command('DppMakeState', function() dpp.make_state(dpp_base, dpp_config) end, {bang = true})
vim.api.nvim_create_user_command('DppClearState', function() dpp.clear_state('nvim') end, {bang = true})
vim.api.nvim_create_user_command('DppInstall', function() dpp.async_ext_action('installer', 'install') end, {bang = true})
vim.api.nvim_create_user_command('DppUpdate', function() dpp.async_ext_action('installer', 'update') end, {bang = true})

-- if !isdirectory(s:denops_src)
--   function! s:vimrc_install_dpp()
--     let cwd = getcwd()
--     call mkdir(s:dpp_src_base, 'p')
--     execute 'lcd' s:dpp_src_base
--     for repo in s:dpp_repos
--       call system(printf('git clone https://github.com/Shougo/%s', repo))
--     endfor
--     call mkdir(s:denops_src, 'p')
--     execute 'lcd' s:denops_src.'/..'
--     call system('git clone https://github.com/vim-denops/denops.vim')

--     execute 'lcd' cwd
--     echo 'finish'
--   endfunction
--   command! -narg=0 DppInit call s:vimrc_install_dpp()
-- else
--   unlet s:dpp_src_base s:denops_src s:dpp_repos
-- endif
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')
vim.cmd([[
	colorscheme Monokai-Refined
]])
