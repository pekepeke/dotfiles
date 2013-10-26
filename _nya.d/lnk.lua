-- lnk.lua
--    ショートカットを作成するコマンド

if nyaos.create_object then
    function nyaos.command.lnk(src,dst)
        if not dst then
            if src then
                local shell=assert(nyaos.create_object('WScript.Shell'))
                local shortcut=assert(shell:CreateShortcut(src))
                if  shortcut and shortcut.TargetPath and 
                    string.len(shortcut.TargetPath) > 0 
                then
                    print('    '..shortcut.TargetPath)
                    print('--> '..src)
                end
            else
                print('Usage: lnk FILENAME SHORTCUT ... make shortcut')
                print('       lnk SHORTCUT          ... print shortcut-target')
            end
            return 1
        end
        local fsObj=nyaos.create_object('Scripting.FileSystemObject')
        if not string.match(src,'^http://') then
            src = fsObj:GetAbsolutePathName(src)
        end
        dst = fsObj:GetAbsolutePathName(dst)
        if fsObj:FolderExists(dst) then
            dst = dst .. '\\' .. fsObj:getFileName(src)
        end
        if string.match(src,'^http://') then
            dst = dst .. '.url'
        elseif not string.match(dst,'%.lnk$') then
            dst = dst .. '.lnk'
        end
        print('    '..src)
        print('--> '..dst)

        local shell = assert(nyaos.create_object('WScript.Shell'))
        local shortcut=assert(shell:CreateShortcut(dst))
        shortcut.TargetPath=src
        shortcut:Save()
    end
end
