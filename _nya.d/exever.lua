-- 実行ファイルのバージョンナンバーを調べるスクリプト

if nyaos.create_object then
    function nyaos.command.exever(...)
        local fso = nyaos.create_object("Scripting.FileSystemObject")
        for i,path in pairs{...} do
            local ver=fso:GetFileVersion(path)
            if ver and ver ~= "" then
                print( string.format("%-10s: %s",ver,path) )
            end
        end
    end
end
