-- 「-t」オプション付きで起動された時：
for i,e in pairs(nyaos.argv) do
    if e == '-t' then
        -- ls にカラーオプションを付ける --
        nyaos.alias.ls = (nyaos.alias.ls or 'ls')..' --color -x'

        if os.getenv('VIMSHELL') == '1' then
            nyaos.option.ls_colors='fi=37:di=32:sy=31:ro=34:hi=33:ex=35:ec=0'
            nyaos.option.prompt='$e[31m[$w]$_$$ $e[37m'
            nyaos.option.term_clear = ''
            nyaos.option.term_cursor_on = ''

            function nyaos.command.complete_test(arg)
                local list=nyaos.default_complete(arg,1)
                for i=1,#list do
                    print(list[i][2])
                end
            end
        else
            nyaos.option.ls_colors='fi=30:di=32:sy=31:ro=34:hi=33:ex=35:ec=0'
            nyaos.option.prompt='$e[31m[$w]$_$$ $e[30m'
        end
    end
end

