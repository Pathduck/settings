@echo off
set game_dir="%localappdata%\StoneShard"
set save_dir="f:\My Games\Stoneshard"

for /f "tokens=1-3 delims=. " %%a in ("%DATE%") do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-3 delims=: " %%a in ("%TIME%") do (set mytime=%%a%%b%%c)
	
cd /d %game_dir%
zip -qr %save_dir%\%mydate%-%mytime%.zip *
