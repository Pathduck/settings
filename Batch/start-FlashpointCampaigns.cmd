@echo off
REM Launch Flashpoint Campaigns and AHK script
REM ==========================================
set ahk_dir="d:\bin\Autohotkey"
set ahk_script="%DOCUMENTS%\Settings\Autohotkey\FlashpointCampaigns-V2.ahk"
set game_dir="f:\Games\Flashpoint Campaigns Southern Storm"
set game_exe="FlashpointCampaigns.exe"

REM Start AHK and load script
start "" %ahk_dir%\AutoHotkey64.exe /restart %ahk_script%

REM Check if running and start the game
cd /d %game_dir%
tasklist | find /I %game_exe% >nul || start "" %game_dir%\%game_exe%
