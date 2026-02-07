@echo off
set nirsoft=D:\bin\NirsoftLauncher\NirSoft
:: DENON-AVRHD (ShortID)
%nirsoft%\multimonitortool.exe /SetPrimary "DON0040"
:: 7.1 Surround
%nirsoft%\soundvolumeview.exe /SetDefault "DENON-AVRHD" /SetSpeakersConfig "DENON-AVRHD" 0x63f 0x63f 0x63f
