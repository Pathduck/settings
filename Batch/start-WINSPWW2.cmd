@echo off
set nirsoft=D:\bin\NirsoftLauncher\NirSoft
%nirsoft%\nircmd.exe setdisplay 1920 1080 32
start /D f:\games\WinSPWW2 f:\games\WinSPWW2\winSPWW2.exe
pause
%nirsoft%\nircmd.exe setdisplay 2560 1440 32
