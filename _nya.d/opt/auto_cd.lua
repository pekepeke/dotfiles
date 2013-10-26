function nyaos.filter.auto_cd(argv)
    local dir=argv:gsub('\034',''):gsub('\\$','')
    local stat=nyaos.stat(dir)
    if stat and stat.directory then
        return 'cd '..argv
    end
    return argv
end
