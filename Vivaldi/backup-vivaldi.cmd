@echo off
set "vivaldi_dir=%localappdata%\Vivaldi\User Data\Default"
set "backup_dir=%documents%\Settings\Vivaldi\backup"
set "temp_dir=%temp%\Vivaldi-backup-%random%"

:: Define ANSI Colors
SET "OFF=[0m"
SET "RED=[91m"
SET "GREEN=[92m"
SET "CYAN=[96m"

:: Create backup dir
if not exist "%backup_dir%" (
	echo Creating backup directory...
	mkdir "%backup_dir%"
)

:: CD to Vivaldi profile
pushd .
cd /d "%vivaldi_dir%"

:: Copy files to temp
echo %CYAN%Copying files...%OFF%
for %%F in (
    Bookmarks
    Preferences
    "Secure Preferences"
    Notes
    "Web Data"
	mainmenu.json
	contextmenu.json
    "..\Local State"
) do xcopy /qyi "%%~F" "%temp_dir%\" >nul ^
|| echo %RED%ERROR: Copy of %%F failed. %OFF%

:: Copy custom SD thumbnails
echo %CYAN%Copying SyncedFiles folder...%OFF%
xcopy /qy "%vivaldi_dir%\SyncedFiles" "%temp_dir%\SyncedFiles\" >nul ^
|| echo %RED%ERROR: Copy of SyncedFiles failed. %OFF%

:: Export settings JSON
echo %CYAN%Exporting Vivaldi settings to JSON...%OFF%
jq '.vivaldi' "%temp_dir%\Preferences" > "%backup_dir%\vivaldi-settings.json" ^
|| echo %RED%ERROR: Export using 'jq' failed.%OFF%

:: SQL Backup
echo %CYAN%Creating SQL backups...%OFF%
sqlite3 "%temp_dir%\Web Data" ".dump keywords" > "%backup_dir%\keywords.sql"
sqlite3 "%temp_dir%\Web Data" -line "select short_name, keyword, url, suggest_url, image_url, search_url_post_params, suggest_url_post_params, image_url_post_params from keywords;" > "%backup_dir%\keywords.txt"
sqlite3 "%temp_dir%\Web Data" -markdown "select short_name, keyword, url, suggest_url, image_url, search_url_post_params, suggest_url_post_params, image_url_post_params from keywords;" > "%backup_dir%\keywords.md"

:: Compress temp files with 7z
echo %CYAN%Creating archive:%OFF%
7z u "%backup_dir%\Profile-backup.7z" "%temp_dir%\*" | findstr "archive"

:: Cleanup
echo %CYAN%Deleting temp dir:%OFF% %temp_dir%
rmdir /q /s "%temp_dir%"

echo %GREEN%Done. %OFF%
popd
pause
GOTO :EOF
