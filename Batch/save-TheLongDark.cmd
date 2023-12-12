@echo off
set save_dir="%documents%\My Games\The Long Dark"
set game_dir="%localappdata%\Hinterland"

for /f "tokens=1-3 delims=. " %%a in ("%DATE%") do (set mydate=%%c-%%b-%%a)
for /f "tokens=1-3 delims=: " %%a in ("%TIME%") do (set mytime=%%a%%b%%c)
	
cd /d %game_dir%
zip -qr %save_dir%\%mydate%-%mytime%.zip TheLongDark*
