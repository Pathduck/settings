;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
~=cd /d "%USERPROFILE%"
asn=sh "d:\bin\nettools\asn\asn" $*
cb=curl -s -F "reqtype=fileupload" -F "fileToUpload=@$*" "https://catbox.moe/user/api.php"  
cd=cd /d $*
clear=cls
cmderr=cd /d "%CMDER_ROOT%"
cp=cp -i $*
curl=d:\bin\cygwin\bin\curl.exe $*
e=explorer $*
egrep=grep -E $*
far=d:\bin\FarManager\Far.exe $*
ga=git add -A $*
gc=git commit $*
gg=global /V /1 /E .git $*
gl=git hist $*
grep=grep --color --ignore-case $*
gs=git status $*
gw=git hist --raw --no-merges $*
home=cd /d "%USERPROFILE%"
kill=pskill $*
la=ls -la --color=auto --group-directories-first $*
ll=ls -l --color=auto --group-directories-first $*
ls=ls --color=auto --group-directories-first $*
musify=node --no-deprecation d:\bin\node\dl-musify.club\download_album.js $*
mv=mv -i $*
nginx=start /d d:\bin\Nginx /b d:\bin\Nginx\nginx.exe $*
npp=d:\bin\Notepad++\notepad++.exe $*
pb=curl -sF "files[]=@$1" "https://qu.ax/upload.php" $B jq -r '.files[].url'  
putty=d:\bin\putty\putty.exe $*
pwd=cd
python=d:\bin\python\python.exe $*
rm=rm -i $*
shn=curl -F "format=simple" -F "url=$1" "https://is.gd/create.php"  
sublime=d:\bin\Sublime\sublime_text.exe $*
sudo=gsudo $*
tc=d:\bin\totalcmd\totalcmd.exe $*
top=ntop -s "CPU%" $*  
tree=d:\bin\cygwin\bin\tree.exe  
tshark=d:\bin\Wireshark\tshark.exe $*
unalias=alias /d $1
vi=vim $*
winscp=d:\bin\WinSCP\winscp.exe $*
