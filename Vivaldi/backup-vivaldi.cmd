@echo off
set vivaldi_dir="%localappdata%\Vivaldi\User Data\Default"
set backup_dir="%documents%\Settings\Vivaldi\backup"

cd /d %vivaldi_dir%

zip -u %backup_dir%\Profile.zip Bookmarks Preferences "Secure Preferences" Notes "Web Data"

xcopy /qy contextmenu.json %backup_dir%
xcopy /qy mainmenu.json %backup_dir%

jq '.vivaldi' Preferences > %backup_dir%\vivaldi-settings.json

xcopy /qy "Web Data" %backup_dir%
sqlite3 "%backup_dir%\Web Data" -line "select short_name, keyword, url, suggest_url, image_url, search_url_post_params, suggest_url_post_params, image_url_post_params from keywords;" > %backup_dir%\keywords.txt
sqlite3 "%backup_dir%\Web Data" -markdown "select short_name, keyword, url, suggest_url, image_url, search_url_post_params, suggest_url_post_params, image_url_post_params from keywords;" > %backup_dir%\keywords.md
sqlite3 "%backup_dir%\Web Data" ".dump keywords" > %backup_dir%\keywords.sql
del %backup_dir%\"Web Data"
