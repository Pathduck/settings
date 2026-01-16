@echo off
set game_dir="%localappdata%\Hinterland"
set save_dir="%documents%\My Games\The Long Dark"

for /f "tokens=1-3 delims=. " %%a in ("%DATE%") do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-3 delims=: " %%a in ("%TIME%") do (set mytime=%%a%%b%%c)

if exist %game_dir% (
	cd /d %game_dir%
	zip -qr %save_dir%\%mydate%-%mytime%.zip TheLongDark*
) else (
	echo Game dir not found!
)
