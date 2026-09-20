:: Script to start Jotta Daemon service
@echo off

tasklist | find /I "jottad.exe" >nul || ( start D:\bin\Jotta\jottad.exe & timeout 1 )

jotta scan
jotta observe

choice /m "Terminate Jotta Daemon?" /d N /t 10
:: Terminate if Yes
if %errorlevel% equ 1 taskkill /f /im jottad.exe
