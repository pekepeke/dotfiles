-- gui_cd.lua
--    「cd @」で、新しいディレクトリを GUI のダイアログで指定できる
--    ようにする

if nyaos.create_object then
    function nyaos.command.cd(arg)
        if arg == '@' then
            local objShell=nyaos.create_object('shell.application')
            local folder = objShell:BrowseForFolder(0, 'フォルダ選択', 0)
            if not folder or not folder.self or folder.self.path then
                return 
            end
            arg = folder.self.path
        end
        if arg and string.match(arg,' ') then
            arg = '\034'..arg..'\034'
        end
        nyaos.exec('__cd__ '..(arg or ''))
    end
end
