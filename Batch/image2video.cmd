:: image2video - Add still image and music file to make music video
@echo off
set argC=0
set ffmpeg="d:\bin\ffmpeg\bin\ffmpeg.exe"

for %%x in (%*) do set /A argC+=1

if %argC% == 0 ( 
	echo Usage: %~n0 ^<imagefile^> ^<audiofile^> ^<outfile^>
	exit /b 0
)

%ffmpeg% -loop 1 -i %1 -i %2 -c:v libx264 -tune stillimage -c:a copy -strict experimental -shortest %3
