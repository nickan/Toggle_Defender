@echo off
chcp 65001 >nul
title Переключатель Windows Defender

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo ══════════════════════════════════════════════════
    echo   ОШИБКА: Запустите этот файл от имени администратора!
    echo ══════════════════════════════════════════════════
    echo.
    pause
    exit /b 1
)

echo ══════════════════════════════════════════════════
echo        Переключатель защитника Windows
echo ══════════════════════════════════════════════════
echo.
echo Проверяем текущее состояние защитника...
echo.

:: Получаем текущее состояние защиты в реальном времени
for /f "tokens=*" %%A in ('powershell -NoProfile -Command "(Get-MpPreference).DisableRealtimeMonitoring"') do set "STATUS=%%A"

if /i "%STATUS%"=="True" (
    echo [!] Защитник Windows сейчас: ВЫКЛЮЧЕН
    echo.
    echo     Включаем защитник Windows...
    powershell -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $false"
    if %errorlevel% equ 0 (
        echo.
        echo ══════════════════════════════════════════════════
        echo   [OK] Защитник Windows был ВЫКЛЮЧЕН.
        echo   [OK] Сейчас мы его ВКЛЮЧИЛИ.
        echo ══════════════════════════════════════════════════
    ) else (
        echo.
        echo   [X] Ошибка при включении защитника!
    )
) else (
    echo [i] Защитник Windows сейчас: ВКЛЮЧЕН
    echo.
    echo     Выключаем защитник Windows...
    powershell -NoProfile -Command "Set-MpPreference -DisableRealtimeMonitoring $true"
    if %errorlevel% equ 0 (
        echo.
        echo ══════════════════════════════════════════════════
        echo   [OK] Защитник Windows был ВКЛЮЧЕН.
        echo   [OK] Сейчас мы его ВЫКЛЮЧИЛИ.
        echo ══════════════════════════════════════════════════
    ) else (
        echo.
        echo   [X] Ошибка при выключении защитника!
    )
)

echo.
pause
