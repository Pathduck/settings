:: Script to share file with Jotta
@echo off

:: Check if input parameter is provided
if "%~1"=="" (
    echo Usage: %~nx0 ^<file_or_folder_path^>
    exit /b 1
)

set "input=%~1"

:: Check if jottad is running, if not start it
tasklist /fi "imagename eq jottad.exe" | findstr /i "jottad.exe" >nul || ( start "" "D:\bin\Jotta\jottad.exe" & timeout 1 )

:: Strip trailing wildcard patterns (\*.* or /*.*)
if "%input:~-4%"=="\*.*" set "input=%input:~0,-4%"
if "%input:~-4%"=="/*.*" set "input=%input:~0,-4%"

:: Strip trailing single wildcards or dots (\* , /* , \. , /.)
if "%input:~-2%"=="\*" set "input=%input:~0,-2%"
if "%input:~-2%"=="/*" set "input=%input:~0,-2%"
if "%input:~-2%"=="\." set "input=%input:~0,-2%"
if "%input:~-2%"=="/." set "input=%input:~0,-2%"

:: Strip trailing slashes (\ or /)
if "%input:~-1%"=="\" set "input=%input:~0,-1%"
if "%input:~-1%"=="/" set "input=%input:~0,-1%"

:: Get the full path and filename from input
for /f "delims=" %%A in ("%input%") do (
    set "fullpath=%%~fA"
    set "filename=%%~nxA"
)

:: Result
echo Absolute Path  : "%fullpath%"
echo Filename/Folder: "%filename%"

jotta archive "%fullpath%" --share --clipboard --nogui --remote="Shares/%filename%"
