local project = {
	repoRootDirectories = {
		'.git', '.bzr', '.hg',
	},
	projectFiles = {
		'build.xml', 'pom.xml', 'prj.el',
		'.project',
		'Gruntfile.js', 'Gruntfile.coffee',
		'Jakefile', 'Cakefile',
		'tiapp.xml', 'NAnt.build',
		'Makefile', 'Rakefile',
		'Gemfile', 'cpanfile',
		'package.json', 'composer.json',
		'bower.json',
		'configure', 'tags', 'gtags',
	},
	projectDirectories = {
		'src', 'lib', 'node_modules', 'vendor', 'app',
	},
	findRoot = function(self)
		local cdir = vim.fn.expand('%:p:h')
		local pjdir = ''
		if vim.fn.isdirectory(vim.fn.expand('%:p')) ~= 0 then
			return ''
		end
		pjdir = self:_find(cdir, self.repoRootDirectories, ':p:h:h')
		if pjdir == '' then
			pjdir = self:_find(cdir, self.projectFiles, ':p:h:h')
		end
		if pjdir == '' then
			pjdir = self:_find(cdir, self.projectDirectories, ':p:h')
		end
		return pjdir
	end,
	_find = function(self, cdir, targets, fnameModifier)
		for _, d in pairs(targets) do
			d = vim.fn.finddir(d, cdir..';')
			if d ~= '' then
				return vim.fn.fnamemodify(d, fnameModifier)
			end
		end
	end,
}

return {
	project = project,
	autochdir = function()
		if vim.g.my_lcd_autochdir == nil then
			vim.g.my_lcd_autochdir = true
		end
		if vim.fn.expand('%') == '' and (vim.o.buftype == '' or vim.o.buftype == 'nofile') then
			return
		elseif vim.g.my_lcd_autochdir then
			local dir = project:findRoot()
			if dir and dir ~= '' and vim.fn.isdirectory(dir) then
				vim.cmd.lcd(vim.fn.fnameescape(dir))
			end
		end
	end,
}
