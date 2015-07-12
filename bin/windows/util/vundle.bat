@echo OFF

cd %HOME%\.vim\vundle
for /D %%i in (*) do cd %%i && git pull && cd ..

goto :EOF
