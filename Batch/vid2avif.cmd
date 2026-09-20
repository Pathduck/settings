:: Description: Video to AVIF converter
:: By: Pathduck
:: Version: 1.0
:: Url: https://github.com/Pathduck/vid2avif/
:: License: GNU General Public License v3.0 (GPLv3)
@echo off

:: Enable delayed variable expension
setlocal enabledelayedexpansion

:: Define ANSI Colors
set "off=[0m"
set "red=[91m"
set "green=[32m"
set "yellow=[33m"
set "blue=[94m"
set "cyan=[96m"

:: Check for blank input or help commands
if "%~1"=="" goto :help_message
if "%~1"=="-?" goto :help_message
if "%~1"=="/?" goto :help_message
if "%~1"=="--help" goto :help_message

:: Check if FFmpeg exists on PATH, if not exit
where /q ffmpeg.exe || ( echo %red%FFmpeg not found in PATH, please install it first%off% & goto :EOF )

:: Assign input and output
set "input=%~1"
set "output=%~n1"

:: Validate input file
if not exist "%input%" (
	echo %red%Input file not found: !input! %off%
	goto :EOF
)

:: Clearing input vars and setting defaults
set "fps=15"
set "scale=-1"
set "filetype=avif"
set "loglevel=error"
set "start_time="
set "end_time="
set "crop="
set "picswitch="
set "playswitch="

:varin
:: Parse Arguments, first shift input one left
shift
:parse_loop
if not "%~1"=="" (
	if "%~1"=="-o" set "output=%~dpn2" & shift
	if "%~1"=="-r" set "scale=%~2" & shift
	if "%~1"=="-f" set "fps=%~2" & shift
	if "%~1"=="-s" set "start_time=%~2" & shift
	if "%~1"=="-e" set "end_time=%~2" & shift
	if "%~1"=="-v" set "loglevel=%~2" & shift
	if "%~1"=="-x" set "crop=%~2" & shift
	if "%~1"=="-p" set "picswitch=1"
	if "%~1"=="-y" set "playswitch=1"
	shift & goto :parse_loop
)

:safchek
:: Validate if output file is set and not starts with a -
if "%output%"=="" ( echo %red%Missing value for -o%off% & goto :EOF )
for %%f in ("%output%") do set "out_base=%%~nf"
if defined out_base (
	if "!out_base:~0,1!"=="-" ( echo %red%Missing value for -o%off% & goto :EOF )
)

:: Validate if output is a directory; strip trailing slash and use input filename
if exist "%output%\*" (
	if "%output:~-1%"=="\" set "output=%output:~0,-1%"
	for %%f in ("!input!") do set "filename=%%~nf"
	set "output=!output!\!filename!"
)

:: Set output file extension
set "output=%output%.%filetype%"

:: Validate Clipping
if defined start_time (
	if defined end_time set "trim=-ss !start_time! -to !end_time!"
	if not defined end_time (
		echo %red%End time ^(-e^) is required when Start time ^(-s^) is specified.%off%
		goto :EOF
	)
)
if defined end_time (
	if not defined start_time (
		echo %red%Start time ^(-s^) is required when End time ^(-e^) is specified.%off%
		goto :EOF
	)
)

:: Validate Framerate
if "!fps!"=="-" (
	set "fps=source_fps"
) else if !fps! lss 1 (
	echo  %red%Framerate ^(-f^) must be greater than 0.%off%
	goto :EOF
)

:script_start
:: Putting together filters
set "filters=fps=%fps%"
if defined crop ( set "filters=%filters%,crop=%crop%" )
set "filters=%filters%,scale=%scale%:-1:flags=lanczos+accurate_rnd+full_chroma_int"

:: FFplay preview
if defined playswitch (
:: Check if ffplay exists on PATH, if not exit
	where /q ffplay.exe || ( echo %red%FFplay not found in PATH, please install it first%off% & goto :EOF )

	for /f "delims=" %%a in ('ffplay -version') do (
		if not defined ffplay_version ( set "ffplay_version=%%a" 
		 ) else if not defined ffplay_build ( set "ffplay_build=%%a" )
	)
	echo %yellow%!ffplay_version!%off%
	echo %yellow%!ffplay_build!%off%

	if not defined start_time set "start_time=0"
	if not defined end_time set "end_time=3"
	ffplay -v %loglevel% -i "%input%" -vf "%filters%" -an -loop 0 -ss !start_time! -t !end_time!
	goto :EOF
)

:: Storing FFmpeg version string
for /f "delims=" %%a in ('ffmpeg -version') do (
	if not defined ffmpeg_version ( set "ffmpeg_version=%%a"
	) else if not defined ffmpeg_build ( set "ffmpeg_build=%%a" )
)

:: Displaying FFmpeg version string and output file
echo %yellow%!ffmpeg_version!%off%
echo %yellow%!ffmpeg_build!%off%
echo %green%Output file:%off% !output!

:: Setting variables to put the encode command together
set "type_opts=-crf 30 -cpu-used 4 -row-mt 1 -tiles 2x2 -pix_fmt yuv420p"

:: Executing the encoding command
echo %green%Encoding animation...%off%
ffmpeg -v %loglevel% %trim% -i "%input%" ^
-vf "%filters%" -an ^
-f %filetype% %type_opts% -loop 0 -plays 0 -y "%output%"

:: Checking if file was created and cleaning up if not
if not exist "%output%" (
	echo echo %red%Failed to generate animation: !output! not found.%off%
	goto :cleanup
)

:: Open output file if picswitch is set
if defined picswitch start "" "%output%"

:cleanup
:: Cleaning up
echo %green%Done.%off%
endlocal
goto :EOF

:help_message
:: Print usage message
echo %green%Video to AVIF converter v1.0%off%
echo %blue%By Pathduck%off%
echo:
echo %green%Usage:%off%
echo %~n0 [input_file] [arguments]
echo:
echo %green%Arguments:%off%
echo  -o  Output file. Default is the same as input file, sans extension
echo  -r  Resize output width in pixels. Default is original input size
echo  -f  Framerate of output, or '-' to use input framerate (default 15)
echo  -s  Start time of the animation (HH:MM:SS.MS)
echo  -e  End time of the animation (HH:MM:SS.MS)
echo  -x  Crop the input video (out_w:out_h:x:y)
echo  -y  Preview animation using FFplay (part of FFmpeg)
echo      Useful for testing cropping, but will not use exact start/end time
echo  -p  Opens the resulting animation in the default image viewer
echo  -v  Set FFmpeg log level (default: error)
goto :EOF
