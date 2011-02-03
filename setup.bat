@echo OFF

cd %~dp0
for /F %%i in ('dir /A:D-S /b .*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:D-S /b _*') do if not %%i == .git mklink /D %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b .*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
for /F %%i in ('dir /A:A-S /b _*') do if not %%i == .git mklink    %HOME%\%%i %~dp0%%i
call git submodule init
call git submodule update
pause
goto :EOF
