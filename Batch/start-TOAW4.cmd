@echo off
REM Launch TOAW4 and AHK script
REM ===========================
set ahk_dir="d:\bin\Autohotkey"
set ahk_script="%DOCUMENTS%\Settings\Autohotkey\TOAW4-V2.ahk"

REM Check if BorderlessGaming is already running
tasklist | find /I "BorderlessGaming.exe" >nul || start "" d:\bin\BorderlessGaming\BorderlessGaming.exe
REM Start AHK and load script
start "" %ahk_dir%\AutoHotkey64.exe /restart %ahk_script%
REM Start the game
start "" "f:\games\The Operational Art of War IV\Opart 4.exe"