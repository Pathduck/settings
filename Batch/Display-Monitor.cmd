@echo off
set nirsoft=D:\bin\NirsoftLauncher\NirSoft
:: ROG PG279Q (Serial#)
%nirsoft%\multimonitortool.exe /SetPrimary "#ASNIGyfCQB3d"
:: Stereo
%nirsoft%\soundvolumeview.exe /SetDefault "Digital Audio" /SetSpeakersConfig "Digital Audio" 0x3 0x0 0x0
