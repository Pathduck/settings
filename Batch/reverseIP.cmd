@echo off
REM Reverse IP lookup script

set hostlist=%*
if not defined hostlist (
	echo Usage: reverseIP [hostlist]
) else (
	dig +short %hostlist% | xargs -l dig +short -x
)
