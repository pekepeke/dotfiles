local function each2(obj)
    return coroutine.wrap( function()
        local prevkey,prevval
        for key,val in pairs(obj) do
            if prevkey then
                coroutine.yield(prevkey,prevval,key)
            end
            prevkey = key
            prevval = val
        end
        if prevkey then
            coroutine.yield(prevkey,prevval,nil)
        end
    end)
end
local function iterable(obj)
    if type(obj) == 'table' then
        return true
    end
    if type(obj) == 'userdata' then
        local m=getmetatable(obj)
        if m and m.__pairs then
            return true
        end
    end
    return false
end
local function p(header,obj)
    for key,val,nextval in each2(obj) do
        io.write(header)
        if nextval then
            io.write("Ñ•Ñü")
        else
            io.write("Ñ§Ñü")
        end
        io.write(key)
        if type(val) == 'string' then
            io.write(' = "' .. string.gsub(val,'"','\\"') .. '"')
        elseif type(val) == 'number' then
            io.write(' = ' .. val )
        else
            io.write(" = "..type(val))
        end
        io.write("\n")
        if iterable(val) then
            if nextval then
                p(header.."Ñ†Å@",val)
            else
                p(header.."Å@Å@",val)
            end
        end
    end
end

nyaos.command['nyaos.browse'] = function()
    print("nyaos")
    p("",nyaos)
end
