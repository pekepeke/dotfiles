function nyaos.command.gpath(...)
    local argv={...}
    local shell=nyaos.create_object("WScript.Shell")
    local sysEnv=shell:Environment("System")
    local path={}
    for p in string.gmatch(sysEnv:Item("PATH"),"[^;]+") do
        table.insert( path , p )
    end
    if argv[1] == "del" then
        if argv[2] then
            if string.match(argv[2],"^%d+$") then
                table.remove( path , argv[2] )
            else
                print("gpath del [POSITION]")
                return
            end
        else
            table.remove( path )
        end
    elseif argv[1] == "add" then
        if argv[2] then
            if argv[3] then
                if string.match(argv[2],"^%d+$") then
                    table.insert( path , argv[2] , argv[3] )
                else
                    print("gpath add [POSITION] DIRECTORY")
                    return
                end
            else
                table.insert( path , argv[2] )
            end
        else
            print("gpath add [POSITION] DIRECTORY")
            return
        end
    elseif argv[1] == "swap" then
        local tmp1 = path[tonumber(argv[2])] 
        local tmp2 = path[tonumber(argv[3])]
        if tmp1 and tmp2 then
            path[ tonumber(argv[2]) ] = tmp2
            path[ tonumber(argv[3]) ] = tmp1
        else
            print("gpath swap POSITION-1 POSITION-2")
            return
        end
    else
        print("Usage:")
        print("  gpath add [POSITION] DIRECTORY")
        print("  gpath del [POSITION]")
        print("  gpath swap POSITION-1 POSITION-2")
        print("")
        for i=1,#path do
            print(i,path[i])
        end
        return
    end
    path = table.concat(path,";")
    sysEnv:__put__("Item","PATH",path)
end
