@echo off
set game_dir="%localappdata%\.uoc2\save"
set save_dir="f:\My Games\Unity of Command 2"

for /f "tokens=1-3 delims=. " %%a in ("%DATE%") do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-3 delims=: " %%a in ("%TIME%") do (set mytime=%%a%%b%%c)

if exist %game_dir% (
	cd /d %game_dir%
	zip -qr %save_dir%\%mydate%-%mytime%.zip *
) else (
	echo Game dir not found!
)
