@echo OFF

set IP_ADDR=192.168.1.19
set DOMAIN=test.jp
::set DST_FILE="%~n0_result.txt"
::set BAK_FILE="%~n0_result.bak"
set DST_FILE=%SYSTEMROOT%\SYSTEM32\drivers\etc\hosts
set BAK_FILE=%SYSTEMROOT%\SYSTEM32\drivers\etc\hosts.bak

cd "%~dp0"
if not exist %BAK_FILE% move %DST_FILE% %BAK_FILE%

type "_%~n0.txt" > %DST_FILE%
for /f "delims=" %%p IN (_%~n0_list.txt) do (
	echo %IP_ADDR%		%%p.%DOMAIN%>> %DST_FILE%
)
pause

