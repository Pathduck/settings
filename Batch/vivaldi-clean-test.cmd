@echo off
REM Vivaldi test profile launcher script
REM ====================================

set vivaldi_install=d:\bin\Vivaldi-stable\Application
set tmp_folder=%temp%\Vivaldi-test

echo Starting Vivaldi and waiting for exit...
%vivaldi_install%\vivaldi.exe --no-default-browser-check --user-data-dir=%tmp_folder%

choice /d Y /t 10 /m "Vivaldi exited, delete temp folder?"
if %errorlevel% equ 1 (rmdir /q /s %tmp_folder%)

echo Killing the update_notifier and removing it from Registry...
taskkill /f /im update_notifier.exe 2>NUL
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "Vivaldi Update Notifier" /f 2>NUL

echo Done!

pause
