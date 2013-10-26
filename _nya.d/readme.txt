Lua extension library for NYAOS.EXE
===================================

Write these lines on your _nya on the same directory with _nya.d

    foreach module "%0.d"\*.ny "%0.d"\*.lua
        if exist $module then
            source $module
        endif
    end

------------------------------------------------------------------------
These are loaded on default.

cmdsource.lua    - cmdsource: load environemnt variables' change in batch-files
compatible.ny    - Aliases to keep compatiblity with CMD.EXE
exever.lua       - exever: print the version in the properties of executables
fc.lua           - fc: Edit previous typed command like bash
gpath.lua        - gpath: maintain the global PATH
gui_cd.lua       - Do `cd @' to open folder dialog to chdir
ln.lua           - ln: wrapper for fsutil.exe , mklink.exe and linkd.exe
lnk.lua          - lnk: Make shortcut command `lnk'
lslua.lua        - lslua,rmlua: List or Remove lua-command.
mount.lua        - mount: wrapper for mountvol.exe (usage: mount -h)
quote_luaexp.lua - Replace %(lua expression)% to its result
readme.txt       - This file
which.lua        - which: print the position of executable

------------------------------------------------------------------------
These are optional. To load, write source command on your _nya
    for example: 
        source "%0.d"\_nya.d\opt\auto_cd.lua
    (%0 are replaced _nya's fullpath automatically)

opt/auto_cd.lua  - When command-name is directory, chdir there automatically
opt/vz.ny        - Key binding like Vz
