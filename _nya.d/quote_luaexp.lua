-- quote_luaexp.lua
--     Lua式をコマンドラインで引用できるようにする。
--     「%(1+2)%」は「3」になる。

function nyaos.filter.quote_lua_expression(cmdline)
    return cmdline:gsub('%%(%b())%%',function(m)
        local status,result=pcall( loadstring('return '..m) )
        if status then
            return result
        else
            print('Ignore invalid Lua expression: '..m)
            return false;
        end
    end)
end
