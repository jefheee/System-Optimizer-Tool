@echo off
title SYSTEM OPTIMIZER [V56 LAUNCHER]
mode con: cols=120 lines=55
color 0B

:: --- FIX DE DIRETORIO (Garante que o script sabe onde esta) ---
cd /d "%~dp0"

:: --- AUTO-UNBLOCK (Evita erro de script nao assinado) ---
powershell -Command "Get-ChildItem -LiteralPath '%~dp0' -Recurse | Unblock-File" >nul 2>&1

:: --- AUTO-ADMINISTRADOR ---
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run
) else (
    echo [SYSTEM] Solicitando Permissao de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:run
cls
:: Verifica se o arquivo principal existe antes de tentar abrir
if exist "%~dp0OptimizerCore.ps1" (
    powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0OptimizerCore.ps1"
) else (
    color 0C
    echo [ERRO] O arquivo 'OptimizerCore.ps1' nao foi encontrado na mesma pasta!
    echo Verifique se voce renomeou o arquivo antigo 'MotorLimpeza.ps1' para 'OptimizerCore.ps1'.
    pause
)
exit
