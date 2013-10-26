function nyaos.command.lslua()
    for name in pairs(nyaos.command) do
        print(name)
    end
end
function nyaos.command.rmlua(...)
    for ignore,name in pairs{...} do
        nyaos.command[ name ] = nil
    end
end
