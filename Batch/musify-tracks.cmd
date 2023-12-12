:: Download individual musify tracks
@echo off
set script=d:\bin\node\dl-musify.club\download_album.js

:: Usage
set argC=0
for %%x in (%*) do set /A argC+=1
if %argC% == 0 ( 
	echo Usage: %~n0 ^<start-track^> ^<end-track^> ^<url^>
	exit /b 0
)

:: Start, End, URL
set start=%1
set end=%2
set url=%3

:: Loop
for /L %%f in (%start%,1,%end%) do (node %script% -t %%f %url%)
