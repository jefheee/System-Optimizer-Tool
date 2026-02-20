@echo off
title SYSTEM OPTIMIZER [ULTIMATE V51]
mode con: cols=120 lines=55
color 0B

:: --- AUTO-ADMINISTRADOR ---
net session >nul 2>&1
if %errorLevel% == 0 (
    goto :run
) else (
    echo Solicitando Permissao de Administrador...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit
)

:run
cls
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0MotorLimpeza.ps1"
if %errorlevel% neq 0 pause
exit