:: Script to share file with Jotta
@echo off
tasklist | find /I "jottad.exe" >nul || ( start D:\bin\Jotta\jottad.exe & timeout 1 )
jotta archive %* --share --clipboard --nogui
