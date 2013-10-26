--- mount.lua - wrapper for mountvol (usage: mount -h)

function nyaos.command.mount(...)
    local args={...}
    if args[1] and args[1] == '-h' then
        print([[Usage: mount]])
        print([[       mount VOLUMNESTRING MOUNTPOINT]])
        print([[       mount -h]])
        print([[for example:]])
        print([[    mount \\?\Volume{12345678-9012-3456-7890-123456789012}]] 
              .. [[ C:\mnt\sdcard]])
        print([[    mount d:\ c:\mnt\cdrom]])
        return
    end

    local fd=io.popen("mountvol","r")
    local mount
    local alias={}
    for line in fd:lines() do
        local m = string.match(line,[[^%s+(\\%?\Volume%S+)]])
        if m then
            mount = m
        elseif mount then
            m = string.match(line,"%s+(%S+)")
            if m then
                alias[ m ] = mount
            end
        end
    end
    fd:close()

    if #args ~= 2 then
        for key,val in pairs(alias) do
            print(val .. " on " .. key)
        end
        return
    end
    local src=args[1]
    local dst=args[2]
    if alias[src] then
        src = alias[src]
    elseif alias[src.."\\"] then
        src = alias[src.."\\"]
    elseif alias[string.upper(src)] then
        src = alias[string.upper(src)]
    elseif alias[string.upper(src).."\\"] then
        src = alias[string.upper(src).."\\"]
    end
    local c=string.format('mountvol %s %s',dst,src)
    print(c)
    nyaos.exec(c)
end

function nyaos.command.umount(...)
    for i,e in ipairs{...} do
        local c="mountvol "..e.." /D"
        print(c)
        nyaos.exec(c)
    end
end
