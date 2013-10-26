-- nya_update.lua
-- MIT License (http://d.hatena.ne.jp/wantora/20101212/1292141801)

local function wget(url, output)
	local command = 'wget --no-check-certificate --user-agent="" -O "'..output..'" "'..url..'"'
	
	if output == "-" then
		local f = io.popen(command .. '2> NUL')
		local out = f:read("*a")
		f:close()
		return out
	else
		return os.execute(command)
	end
end

local function confirm(message, chars)
	local key
	
	io.write(message)
	repeat key = nyaos.getkey() until chars:find(key) ~= nil
	io.write(key.."\n")
	return key
end

local function fileread(filename)
	local f = io.open(filename, "rb")
	local body = f:read("*a")
	f:close()
	return body
end

local function check_mod(nyapath, zippath)
	local s, old = pcall(fileread, nyapath.."\\_nya")
	if s == false then return false end
	local new = nyaos.eval('unzip -cp "'..zippath..'" _nya')
	return (old:gsub("%s+$", "") ~= new:gsub("%s+$", ""))
end

local function setupdate(nyapath, zippath)
	local opt = ""
	if check_mod(nyapath, zippath) then
		if confirm("_nyaファイルを上書きしますか？(y/n)", "yn") == "n" then
			opt = "-x _nya"
		end
	end
	nyaos.goodbye.update_nyaos = function()
		nyaos.exec([[%COMSPEC% /c start %COMSPEC% /c "ping localhost -n 2 > nul & unzip -o "]]..zippath..[[" -d "]]..nyapath..[[" ]]..opt..[[ & pause"]])
	end
end

function nyaos.command.update_nyaos()
	local nyapath = nyaos.argv[0]:gsub("\\[^\\]+$", "")
	local html = wget("https://bitbucket.org/zetamatta/nyaos3000/downloads", "-")
	local url, name, version
	
	version = ""
	for u,n,v in html:gmatch('<td class="name"><a class="execute" href="([^"]*/([^"]-%-([^"]-)%-win%.zip))"') do
		if v > version then
			url, name, version = "https://bitbucket.org"..u, n, v
		end
	end
	
	if html == "" or url == nil then
		print("update_nyaos: ページの取得に失敗しました")
		return
	end
	
	if version > nyaos.version then
		if confirm(nyaos.version.." から "..version.." に更新しますか？(y/n)", "yn") == "y" then
			local zippath = nyapath.."\\"..name
			wget(url, zippath)
			setupdate(nyapath, zippath)
			print("NYAOS終了時に更新します")
		end
	else
		print("NYAOSは最新版です")
	end
end