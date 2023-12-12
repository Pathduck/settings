@echo off
set save_dir="f:\My Games\Unity of Command 2"
set game_dir="%localappdata%\.uoc2\save"

for /f "tokens=1-3 delims=. " %%a in ("%DATE%") do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-3 delims=: " %%a in ("%TIME%") do (set mytime=%%a%%b%%c)
	
cd /d %game_dir%
zip -qr %save_dir%\%mydate%-%mytime%.zip *
