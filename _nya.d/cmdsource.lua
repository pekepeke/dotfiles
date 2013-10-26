-- cmdsource 
--    CMD.EXE のバッチファイル実行して、定義された環境変数を NYAOS に
--    取り込むコマンド

function nyaos.command.cmdsource(...)
    local arg={...}
    if #arg < 1 then
        print('usage: cmdsource BATCHFILENAME ARG...')
        print('')
        print('  the command which execute the batch-file')
        print('  and load environment-variables defined on it.')
        return
    end
    local tmpfile = os.tmpname()
    tmpfile = table.concat({string.byte(tmpfile,1,tmpfile:len())})
    for i=1,#arg do
        if string.match(arg[i],' ') then
            arg[i] = '\034'..arg[i]..'\034'
        end
    end

    os.execute(table.concat(arg,' ')..' & set > '..tmpfile)

    for line in io.lines( tmpfile ) do
        local left,right = string.match(line,'([^=]+)=(.*)$')
        if left and right and os.getenv(left) ~= right then
            print('SET '..left..'='..right)
            nyaos.exec('SET '..left..'='..right)
        end
    end

    os.remove(tmpfile)
end
