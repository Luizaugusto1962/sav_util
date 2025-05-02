@echo off
set HOST=177.45.80.10
set PORT=41122
set USER=lar
set PASSWORD=lar
set REMOTE_PATH=/u/varejo/man/*.zip
set LOCAL_DIR=d:\extras\temps

if not exist "%LOCAL_DIR%" mkdir "%LOCAL_DIR%"

pscp.exe -P %PORT% -pw %PASSWORD% %USER%@%HOST%:"%REMOTE_PATH%" "%LOCAL_DIR%"

if %errorlevel% equ 0 (
    echo Download concluido com sucesso!
) else (
    echo Ocorreu um erro durante o download.
)

pause