-- which.lua
--    コマンドのおかれたディレクトリを調べる

-- 汎用 which
function nyaos.which(cmd)
    local path='.;' .. os.getenv('PATH')
    local variation={
        [ cmd ] = true ,
        [ cmd .. '.exe' ] = true ,
        [ cmd .. '.cmd' ] = true ,
        [ cmd .. '.bat' ] = true ,
        [ cmd .. '.com' ] = true
    }

    local result={}
    for dir1 in string.gmatch(path,'[^;]+') do
        for name1 in pairs(variation) do
            local fullpath=dir1.."\\"..name1
            if nyaos.access(fullpath) then
                table.insert(result,fullpath)
            end
        end
    end
    return result
end

function nyaos.command.which(cmd)
    local path='.;' .. os.getenv('PATH')

    --- 引数が無い場合は、PATH の一覧を表示するだけ ---
    if not cmd then
        for path1 in path:gmatch('[^;]+') do
            print(path1)
        end
        return
    end

    local cmdl=cmd:lower()

    --- エイリアスを検索 ---
    local a=nyaos.alias[ cmdl ]
    if a then
        print('aliased as '..a)
    end

    --- 関数を検索 ---
    local f=nyaos.functions[ cmd ]
    if f then
        print('defined as function')
    end

    --- Lua 関数を検索 ---
    local L=nyaos.command[ cmd ]
    if L then
        print('define as Lua-function')
    end

    --- PATH を検索 ---
    local result=nyaos.which(cmd)
    for i,e in ipairs(result) do
        print(e)
    end
end
