@echo OFF
start "" %~dp0..\Editor\vim\gvim --remote-tab %*
goto :EOF
