@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

set PID=%~1
set INTERVAL=1
SET "MEMORY="

echo "Timestamp","Memory Usage (KB)"

for /l %%n in () do (
	for /f "tokens=5 delims=," %%i in ('tasklist /FO CSV /FI "PID eq %PID%"') do set MEMORY=%%~i
	echo "%TIME%","%MEMORY%"
	sleep %INTERVAL%
)