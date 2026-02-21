@echo off
title SYSTEM OPTIMIZER [V55 LAUNCHER]
mode con: cols=120 lines=55
color 0B

:: --- DETECTOR DE DIRETÓRIO (CORREÇÃO DE PATH) ---
cd /d "%~dp0"

:: --- AUTO-ADMINISTRADOR ROBUSTO ---
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
:: Chama o núcleo com política de execução irrestrita
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0OptimizerCore.ps1"
if %errorlevel% neq 0 (
    color 0C
    echo.
    echo [ERRO CRITICO] O nucleo (OptimizerCore.ps1) nao foi encontrado ou falhou.
    echo Verifique se os arquivos estao na mesma pasta.
    pause
)
exit
