rem Starts Aria2 WebUI
@echo off
set Aria2=D:\bin\Aria2
set Aria2WebUI=%Aria2%\webui-aria2

start %Aria2%\aria2c --enable-rpc --rpc-listen-all --rpc-secret secret
start %Aria2WebUI%\docs\index.html

