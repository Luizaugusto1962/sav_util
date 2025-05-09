@echo off
setlocal EnableDelayedExpansion

:: ======================================
:: Script de Seleção de Versões isCOBOL  
:: ======================================

:: Salvar variáveis originais
set "ORIGINAL_PATH=%PATH%"
set "ORIGINAL_CLASSPATH=%CLASSPATH%"
set "ORIGINAL_LIBRARY_PATH=%LD_LIBRARY_PATH%"

:: Configuração da janela
title Gerenciador Lojas
color 0e

:: Constantes
set "LINE===================================="
set "LINE2===================================================================="
set "ISCOBOL_BASE=C:\isCOBOL"
set "ISCOBOL_JDK_ROOT=C:\Program Files\Java\jdk-21"
set "ISCOBOL_JRE_ROOT=C:\Program Files\Java\jre1.8.0_451"
set "EXE4J_JAVA_HOME=C:\iscobol\jre"

:: Mapeamento de lojas/painéis
set "HOST_1=45.166.152.54"  & set "PORT_1=10999"  & set "VERSION_1=2023R2"
set "HOST_2=casapronta.dyndns.org" & set "PORT_2=10999" & set "VERSION_2=2023R2"
set "HOST_3=177.45.80.10"   & set "PORT_3=41133"   & set "VERSION_3=2024R2"
set "HOST_4=177.45.80.10"   & set "PORT_4=10999"   & set "VERSION_4=2024R2"
set "HOST_5=192.168.100.244" & set "PORT_5=10999" & set "VERSION_5=2023R2"
set "HOST_6=177.45.80.10"   & set "PORT_6=41133"   & set "VERSION_6=2024R2"
set "HOST_7=192.168.1.139"  & set "PORT_7=10999"   & set "VERSION_7=2024R2"
::set "HOST_7=127.0.0.1"  & set "PORT_7=10999"   & set "VERSION_7=2024R2"
set "HOST_8=10.10.10.14" & set "PORT_8=10999" & set "VERSION_8=2023R2"
set "HOST_9=dishelp.dyndns.org"  & set "PORT_9=10999"   & set "VERSION_9=2023R2"
set "HOST_10=jotatelecom.homelinux.com"   & set "PORT_10=10999"  & set "VERSION_10=2023R2"
set "HOST_11=52.67.103.231" & set "PORT_11=10999" & set "VERSION_11=2023R2"
set "HOST_12=192.168.15.101"   & set "PORT_12=10999"  & set "VERSION_12=2020R2"
set "HOST_13=192.168.15.101"   & set "PORT_13=11888"  & set "VERSION_13=2020R2"
set "HOST_14=192.168.1.199" & set "PORT_14=10999"  & set "VERSION_14=2023R2"
set "HOST_15=192.168.1.199" & set "PORT_15=11888" & set "VERSION_15=2023R2"
set "HOST_16=186.192.97.112"   & set "PORT_16=10999"  & set "VERSION_16=2023R2"
set "HOST_17=depositolima.homelinux.com"  & set "PORT_17=10999"  & set "VERSION_17=2023R2"
set "HOST_18=192.168.50.100" & set "PORT_18=10999"  & set "VERSION_18=2020R2"
set "HOST_19=189.84.75.140"  & set "PORT_19=10999"  & set "VERSION_19=2020R2"
set "HOST_20=192.168.1.100"  & set "PORT_20=10999"  & set "VERSION_20=2020R2"
set "HOST_21=lojaoitapua.dyndns.org"   & set "PORT_21=10999"  & set "VERSION_21=2020R2"


:: Menu principal
:MAIN_MENU
cls
echo %TIME% %DATE%
echo %LINE%
echo ^|       SELECIONE UMA OPCAO       ^|
echo %LINE%
echo ^|   1) Conectar a Loja            ^|
echo ^|   2) Acessar Painel             ^|
echo ^|   0) Sair                       ^|
echo %LINE%
set /p "CHOICE=Digite a opcao: "

if "%CHOICE%"=="1" goto STORE_MENU
if "%CHOICE%"=="2" goto PANEL_MENU
if "%CHOICE%"=="0" goto limpar_sair

echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto MAIN_MENU

:: Menu de Lojas
:STORE_MENU
cls
echo %TIME% %DATE%
echo %LINE2%
echo ^|      SELECIONE A LOJA        ^|^|                                 ^|
echo %LINE2%
call :LISTA_OPCAO
set /p "STORE_ID=Digite o numero da loja: "

if "%STORE_ID%"=="0" goto MAIN_MENU

call :SET_CONNECTION %STORE_ID%
if errorlevel 1 (
    echo Opcao invalida!
    timeout /t 2 >nul
    goto STORE_MENU
)
goto RUN_CLIENT

:: Menu de Painel
:PANEL_MENU
cls
echo %TIME% %DATE%
echo %LINE2%
echo ^|      SELECIONE O PANEL       ^|^|                                 ^|
echo %LINE2%
call :LISTA_OPCAO
set /p "PANEL_ID=Digite o numero do painel: "

if "%PANEL_ID%"=="0" goto MAIN_MENU

call :SET_CONNECTION %PANEL_ID%
if errorlevel 1 (
    echo Opcao invalida! Tente novamente.
    timeout /t 2 >nul
    goto PANEL_MENU
)
goto RUN_PANEL

:: Impressão da lista de lojas/painéis
:LISTA_OPCAO
echo ^|   1) Gil                     ^|^| 13) Titan Loja - VPN            ^|
echo ^|   2) Casa Pronta             ^|^| 14) Patricia - VPN              ^|
echo ^|   3) Jisam                   ^|^| 15) PatriciaMW - VPN            ^|
echo ^|   4) Dmaker                  ^|^| 16) 2Leoes                      ^|
echo ^|   5) Diten - VPN             ^|^| 17) Deposito Lima               ^|
echo ^|   6) Fat                     ^|^| 18) LA - VPN                    ^|
echo ^|   7) Kalebre                 ^|^| 19) Vilas Boas                  ^|
echo ^|   8) Atual                   ^|^| 20) Real Pecas                  ^|
echo ^|   9) Dishelp                 ^|^| 21) Lojao Itapua                ^|
echo ^|  10) Jtelecom                ^|^|                                 ^|
echo ^|  11) Cheddar                 ^|^|                                 ^|
echo ^|  12) Titan - VPN             ^|^| 0) Voltar                       ^|

echo %LINE2%
exit /b

:: Configurar conexão
:SET_CONNECTION
set "HOST=!HOST_%1!"
set "PORT=!PORT_%1!"
set "VERSION=!VERSION_%1!"

if not defined HOST (
    exit /b 1
)
exit /b 0

:: Configuração de ambiente
:SETUP_ENVIRONMENT
set "ISCOBOL_PATH=%ISCOBOL_BASE%%VERSION%"
set "PATH=%ISCOBOL_PATH%\bin;%ORIGINAL_PATH%"
set "CLASSPATH=.;%ISCOBOL_PATH%\lib;%ORIGINAL_CLASSPATH%"
set "LD_LIBRARY_PATH=%ISCOBOL_PATH%\bin;%ORIGINAL_LIBRARY_PATH%"

if not exist "%ISCOBOL_PATH%\bin\isclient.exe" (
    echo [ERRO] Arquivo isclient.exe nao encontrado em:
    echo %ISCOBOL_PATH%\bin
    timeout /t 5
    exit /b 1
)
exit /b 0

:: Executar cliente isCOBOL
:RUN_CLIENT
call :SETUP_ENVIRONMENT
if errorlevel 1 goto limpar_sair

start "isCOBOL Client" "%ISCOBOL_PATH%\bin\isclient.exe" ^
-J-Discobol.encoding=CP860 ^
-J-Dfile.encoding=CP860 ^
-hostname %HOST% ^
-port %PORT% ^
SPS800

goto limpar_sair

:: Executar painel isCOBOL
:RUN_PANEL
call :SETUP_ENVIRONMENT
if errorlevel 1 goto limpar_sair

start "isCOBOL Panel" "%ISCOBOL_PATH%\bin\isclient.exe" ^
-J-Discobol.encoding=CP860 ^
-J-Dfile.encoding=CP860 ^
-hostname %HOST% ^
-port %PORT% ^
-panel

:: Finalização
:limpar_sair
set "HOST="
set "PORT="
set "VERSION="
set "ISCOBOL_PATH="
set "PATH=%ORIGINAL_PATH%"
set "CLASSPATH=%ORIGINAL_CLASSPATH%"
set "LD_LIBRARY_PATH=%ORIGINAL_LIBRARY_PATH%"

endlocal
exit
