# compatible.ny
#    CMD.EXE 内蔵コマンドをそのまま使えるようにするエイリアス・関数定義 ###

foreach i (mkdir rmdir type md rd start assoc)
    alias $i $COMSPEC /c $i
end

foreach cmd (dir copy move del rename ren del attrib for)
    $cmd{
        if %glob.defined% -ne 0 then
            option -glob
            $COMSPEC /c $0 $*
            option +glob
        else
            $COMSPEC /c $0 $*
        endif
    }
end
