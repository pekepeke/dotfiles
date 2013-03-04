@echo OFF

for /f "tokens=3-4 delims=. " %%i in ('ver') do (
    if "%%i" == "XP" set is_xp=xp
)


cd %~dp0
for %%i in (.vimperatorrc .vimperatorrc.js) do copy %~dp0%%i %HOME%\%%i
REM  for /F %%i in ('dir /A:D-S /b .*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
REM  for /F %%i in ('dir /A:D-S /b _*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
REM  for /F %%i in ('dir /A:A-S /b .*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
REM  for /F %%i in ('dir /A:A-S /b _*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:D-S /b .*') do if not %%i == .git call :D_MKLINK %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:D-S /b _*') do if not %%i == .git call :D_MKLINK %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b .*') do if not %%i == .git call :F_MKLINK %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b _*') do if not %%i == .git call :F_MKLINK %HOME%\%%i %~dp0%%i

echo ####################################################
echo # please execute under commands
echo # git submodule init
echo # git submodule update
echo ####################################################

::if not exist .vim\vundle\errormarker.vim\doc mkdir .vim\vundle\errormarker.vim\doc
pause
goto :EOF

:D_MKLINK

if defined is_xp (
    if not exist "%1" (
        echo link %2 %1
        linkd %2 %1
    ) else (
        echo skip %1
    )
) else (
    if not exist "%1" (
        echo mklink /d %1 %2
        mklink /d %1 %2
    ) else (
        echo skip %1
    )
)
goto :EOF

:F_MKLINK

if "%1"=="%HOME%\.gitmodules" goto :EOF
if "%1"=="%HOME%\.gitignore" goto :EOF

if defined is_xp (
    if exist "%1" del "%1"
    if not exist "%1" (
        echo fsutil hardlink create %1 %2
        fsutil hardlink create %1 %2
    ) else (
        echo skip %1
    )
) else (
    if not exist "%1" (
        echo mklink %1 %2
        mklink %1 %2
    ) else (
        echo skip %1
    )
)
goto :EOF


:EOF
