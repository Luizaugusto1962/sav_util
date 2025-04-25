@echo off
setlocal EnableDelayedExpansion
:: =========================================================
:: Script de Seleção de Versões isCOBOL 
:: =========================================================
:: Descrição: Permite selecionar versões do isCOBOL e conectar
:: a diferentes portas de servidores ou panel.
:: =========================================================

:: Salvar variáveis de ambiente originais
set "oldPATH=%PATH%"
set "oldCLASSPATH=%CLASSPATH%"
set "oldLIBRARYPATH=%LD_LIBRARY_PATH%"
set "line======================"
set "line2=================================="

:: Configuração da janela do console
title Menu de Selecao isCOBOL
mode con cols=66 lines=30
color e0

:: Menu de seleção de versão
:menu_versao
cls
echo %time% %date%
echo   %line%
echo  ^| Selecione a Versao ^|
echo   %line%
echo  ^|  1) 2024           ^|
echo  ^|  2) 2023           ^|
echo  ^|  3) 2020           ^|
echo  ^|  4) 2018           ^|
echo  ^|  0) Sair           ^|
echo   %line%
echo.
set /p "op_vesao=Qual versao vai usar? "
echo.

:: Validação e configuração da versão
if "!op_vesao!"=="0" goto limpar_sair
if "!op_vesao!"=="1" set "ISCOBOL=C:\isCOBOL2024R2"& goto configure_java
if "!op_vesao!"=="2" set "ISCOBOL=C:\isCOBOL2023R2"& goto configure_java
if "!op_vesao!"=="3" set "ISCOBOL=C:\isCOBOL2020R2"& goto configure_java
if "!op_vesao!"=="4" set "ISCOBOL=C:\isCOBOL2018R2"& goto configure_java
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto menu_versao

:: Configuração do ambiente Java
:configure_java
set "ISCOBOL_JDK_ROOT=C:\Program Files\Java\jdk-21"
set "ISCOBOL_JRE_ROOT=C:\Program Files\Java\jre1.8.0_451"
set "EXE4J_JAVA_HOME=C:\iscobol\jre"
goto MENU_ISCOBOL

:: Menu de seleção de porta
:LISTA_OPCAO
echo %time% %date%
echo   %line2%
echo  ^|      Selecione a Porta          ^|
echo   %line2%
echo  ^|  35) Servidor Maq.Virtual       ^|
echo  ^|  33) Servidor Luiz              ^|
echo  ^|  30) 41130 - Lojao              ^|
echo  ^|   1) 41131 - Vip/Gil            ^|
echo  ^|   2) 41132 - C.Pronta           ^|
echo  ^|   3) 41133 - Jisam              ^|
echo  ^|   4) 41134 - Dmaker             ^|
echo  ^|   5) 41135 - Diten              ^|
echo  ^|   6) 41136 - Fat                ^|
echo  ^|   7) 41137 - Kalebre            ^|
echo  ^|   8) 41138 - Atual              ^|
echo  ^|   9) 41139 - Dishelp            ^|
echo  ^|  10) 41140 - Jtelecom           ^|
echo  ^|  11) 41141 - Cheddar            ^|
echo  ^|  12) 41142 - Titan              ^|
echo  ^|  13) 41143 - Patricia           ^|
echo  ^|  14) 41144 - Velas              ^|
echo  ^|  15) 41145 - Ideal/2Leoes       ^|
echo  ^|  16) 41146 - Deposito Lima      ^|
echo  ^|  17) 41147 - LA                 ^|
echo  ^|  18) 41148 - Vilas Boas         ^|
echo  ^|  19) 41149 - Real Pecas         ^|
echo  ^|  99) Panel                      ^|
echo  ^|   0) Voltar                     ^|
echo   %line2%
exit /b

:MENU_ISCOBOL
:: Validação e configuração da porta
cls
echo %LINE%
echo ^|      SELECIONE A LOJA           ^|
echo %LINE%
call :LISTA_OPCAO
set /p "op_porta=Selecione o numero da porta para o sistema ou Painel: "
echo.

if "!op_porta!"=="0" goto menu_versao
if "!op_porta!"=="99" goto menu_panel
if "!op_porta!"=="35" set "PORT=10999"& set "HOSTNAME=169.169.69.69"& goto run_client
if "!op_porta!"=="33" set "PORT=10999"& set "HOSTNAME=luizzy.duckdns.org"& goto run_client
if "!op_porta!"=="30" set "PORT=41130"& set "HOSTNAME=177.45.80.10"& goto run_client
:: Validação para portas sequenciais (1 a 19)
echo !op_porta!| findstr /r "^[1-9]$ ^1[0-9]$" >nul
if !errorlevel! equ 0 (
    set /a PORT=41130 + !op_porta!
    if !PORT! GEQ 41131 if !PORT! LEQ 41149 (
        set "HOSTNAME=177.45.80.10"
        goto run_client
    )
)
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto menu_porta

:: Menu de seleção de painel
:menu_panel
cls
echo %time% %date%
echo   %line2%
echo  ^|  Selecione o Painel             ^|
echo   %line2%
call :LISTA_OPCAO
set /p "op_panel=Selecione o numero da porta para o Painel: "
echo.

:: Validação e configuração do painel
if "!op_panel!"=="0" goto menu_porta
if "!op_panel!"=="35" set "PORT=10999"& set "HOSTNAME=169.169.69.69"& goto run_panel
if "!op_panel!"=="33" set "PORT=10999"& set "HOSTNAME=luizzy.duckdns.org"& goto run_panel
if "!op_panel!"=="30" set "PORT=41130"& set "HOSTNAME=177.45.80.10"& goto run_panel

:: Validação para portas sequenciais (1 a 19)
echo !op_panel!| findstr /r "^[1-9]$ ^1[0-9]$" >nul
if !errorlevel! equ 0 (
    set /a PORT=41130 + !op_panel!
    if !PORT! GEQ 41131 if !PORT! LEQ 41149 (
        set "HOSTNAME=177.45.80.10"
        goto run_panel
    )
)
echo Opcao invalida! Tente novamente.
timeout /t 2 >nul
goto menu_panel

:: Executa o cliente isCOBOL
:run_client
call :ser_variaveis
if not exist "%ISCOBOL%\bin\isclient.exe" (
    echo Erro: isclient.exe nao encontrado em %ISCOBOL%\bin
    timeout /t 3 >nul
    goto limpar_sair
)
start /min "" "%ISCOBOL%\bin\isclient.exe" -J-Discobol.encoding=CP860 -J-Dfile.encoding=CP860 -hostname %HOSTNAME% -port %PORT% SPS800
goto limpar_sair

:: Executa o painel isCOBOL
:run_panel
call :ser_variaveis
if not exist "%ISCOBOL%\bin\isclient.exe" (
    echo Erro: isclient.exe nao encontrado em %ISCOBOL%\bin
    timeout /t 3 >nul
    goto limpar_sair
)
start /min "" "%ISCOBOL%\bin\isclient.exe" -J-Discobol.encoding=CP860 -J-Dfile.encoding=CP860 -hostname %HOSTNAME% -port %PORT% -panel
goto limpar_sair

:: Configura variáveis de ambiente
:ser_variaveis
set "PATH=%ISCOBOL%\bin;%oldPATH%"
set "CLASSPATH=.;%ISCOBOL%\bin;%ISCOBOL%\lib\;%ISCOBOL%\jars\;%oldCLASSPATH%"
set "LD_LIBRARY_PATH=%CLASSPATH%"
exit /b

:: Restaura variáveis e sai
:limpar_sair
set "PATH=%oldPATH%"
set "CLASSPATH=%oldCLASSPATH%"
set "LD_LIBRARY_PATH=%oldLIBRARYPATH%"
set "oldPATH="
set "oldCLASSPATH="
set "oldLIBRARYPATH="
set "ISCOBOL="
set "PORT="
set "HOSTNAME="
set "op_vesao="
set "op_porta="
set "op_panel="
exit