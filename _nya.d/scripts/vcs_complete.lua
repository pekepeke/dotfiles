-- complete.lua  Copyright (c) 2011 wantora
-- MIT License (http://d.hatena.ne.jp/wantora/20101212/1292141801)

local function clean_cmd(str)
	return str:gsub('%s+$', ''):gsub('^(%S+)%.[^/\\.]+$', '%1')
end

local completes_cache = {}
local completes = {
	hg = function()
		local cmds = {}
		for name in nyaos.eval('hg debugcomplete'):gmatch('[^\n]+') do
			table.insert(cmds, name)
		end
		return cmds
	end,
	gem = function()
		local cmds = {}
		for line in nyaos.eval('gem help commands'):gmatch('[^\n]+') do
			local name = line:match('^    ([^%s]*)')
			if #cmds > 0 and (not name) then break end
			if name and #name > 0         then table.insert(cmds, name) end
		end
		return cmds
	end,
}

function nyaos.complete(basestring, pos, misc)
	local cmd = clean_cmd(misc.text:sub(1, pos))
	
	if nyaos.alias[cmd] then
		cmd = clean_cmd(nyaos.alias[cmd])
	end
	
	for name, comp in pairs(completes) do
		if cmd == name then
			if not completes_cache[name] then completes_cache[name] = comp() end
			return completes_cache[name]
		end
	end
	
	return nyaos.default_complete(basestring, pos)
end