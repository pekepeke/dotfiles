--- ln.lua - wrapper for fsutil.exe , mklink.exe and linkd.exe

if nyaos.create_object then
    local major, minor, build = nyaos.eval(os.getenv('COMSPEC') .. ' /c ver'):match('(%d+).(%d+).(%d+)')
    if tonumber(major) >= 6 then
        nyaos.alias['mklink'] = os.getenv('COMSPEC') .. ' /c mklink'
    end

    function nyaos.command.ln(...)
        local src={...}
        local link=0 -- 0:hard link 1:symlink 2:junction(mklink) 3:junction(linkd)
        if src[1] and src[1] == "-l" and nyaos.command.lnk then
            table.remove(src,1)
            return nyaos.command.lnk( table.unpack(src) )
        elseif src[1] and src[1] == '-s' and nyaos.alias.mklink then
            table.remove(src,1)
            link=1
        elseif src[1] and src[1] == '-j' and nyaos.alias.mklink then
            table.remove(src,1)
            link=2
        elseif src[1] and src[1] == '-j' and nyaos.eval('which linkd.exe') then
            table.remove(src,1)
            link=3
        end

        local fsObj=nyaos.create_object('Scripting.FileSystemObject')
        local dst=table.remove(src)

        if #src <= 0 then
            print("Usage: ln TARGET LINK_NAME")
            print("       ln TARGET... DIRECTORY")
            if nyaos.alias.mklink then
                print("       ln -s TARGET ... SYMLINK")
                print("       ln -j TARGET ... JUNCTION")
            elseif nyaos.eval('which linkd.exe') then
                print("       ln -j TARGET ... JUNCTION")
            end
            if nyaos.command.lnk then
                print("       ln -l TARGET ... SHORTCUT")
            end
            print()
            print("When UAC forbid your operation, do...")
            print(" (1) execute as Administrator:")
            print("        net user administrator /active:yes")
            print(" (2) write on _nya:")
            print("        option runas administrator")
            print("Or if you have sudo.exe, write on _nya:")
            print("        option sudo sudo.exe")
            return 
        end

        local sudo = nyaos.exec
        if nyaos.option.runas then
            sudo = function(s)
                s = string.format(
                        'runas /user:%s "%s"' ,
                        nyaos.option.runas ,
                        string.gsub(s,'"','\\"')
                    )
                -- print(s)
                nyaos.exec(s)
            end
        elseif nyaos.option.sudo then
            sudo = function(s)
                nyaos.exec(nyaos.option.sudo .. ' ' .. s)
            end
        end

        local err=false
        for i,src1 in ipairs(src) do
            if fsObj:FolderExists(src1) and link==0 then
                print("ln: `" .. src1 .. 
                      "': hard link not allowed for directory")
                err=true
            elseif fsObj:FileExists(src1) and (link==2 or link==3) then
                print("ln: `" .. src1 .. 
                      "': junction not allowed for file")
                err=true
            end
        end
        if err then
            return 1
        end

        for i,src1 in ipairs(src) do
            local dst1=dst
            if fsObj:FolderExists(dst1) and link<=1 then
                dst1 = fsObj:BuildPath(dst1,fsObj:getFileName(src1))
            end

            if link==0 then
                sudo(string.format(
                    'fsutil hardlink create "%s" "%s"' ,
                    fsObj:GetAbsolutePathName(dst1) ,
                    fsObj:GetAbsolutePathName(src1) ) )
            elseif link==1 then
                if fsObj:FolderExists(src1) then
                    sudo(string.format(
                        '%s /c mklink /D "%s" "%s"' ,
                        os.getenv('COMSPEC') , 
                        fsObj:GetAbsolutePathName(dst1) ,
                        fsObj:GetAbsolutePathName(src1) ) )
                else
                    sudo(string.format(
                        '%s /c mklink "%s" "%s"' ,
                        os.getenv('COMSPEC') , 
                        fsObj:GetAbsolutePathName(dst1) ,
                        fsObj:GetAbsolutePathName(src1) ) )
                end
            elseif link==2 then
                sudo(string.format(
                    '%s /c mklink /J "%s" "%s"' ,
                    os.getenv('COMSPEC') , 
                    fsObj:GetAbsolutePathName(dst1) ,
                    fsObj:GetAbsolutePathName(src1) ) )
            elseif link==3 then
                sudo(string.format(
                    'linkd.exe "%s" "%s"' ,
                    fsObj:GetAbsolutePathName(dst1) ,
                    fsObj:GetAbsolutePathName(src1) ) )
            end
        end
    end
end
