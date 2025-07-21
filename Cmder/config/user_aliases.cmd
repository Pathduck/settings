;= @echo off
;= rem Call DOSKEY and use this file as the macrofile
;= %SystemRoot%\system32\doskey /listsize=1000 /macrofile=%0%
;= rem In batch mode, jump to the end of the file
;= goto:eof
;= Add aliases below here
~=cd /d "%USERPROFILE%"
asn=sh "d:\bin\nettools\asn\asn" $*  
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
gh=git hist $*  
gl=git log --oneline --all --graph --decorate --color $*  
grep=grep --color --ignore-case $*  
gs=git status $*
gw=git whatchanged $*  
home=cd /d "%USERPROFILE%"
kill=pskill $*
la=ls -la --color=auto --group-directories-first $*
ll=ls -l --color=auto --group-directories-first $*
ls=ls --color=auto --group-directories-first $*
musify=node d:\bin\node\dl-musify.club\download_album.js $*  
mv=mv -i $*
ncat=D:\bin\nettools\Nmap\ncat.exe $*  
nginx=start /d d:\bin\Nginx /b d:\bin\Nginx\nginx.exe $*
nmap=D:\bin\nettools\Nmap\nmap.exe $*
nping=D:\bin\nettools\Nmap\nping.exe $*  
npp=d:\bin\Notepad++\notepad++.exe $*
pb=sh d:\bin\cygwin\usr\local\bin\pb $*  
putty=d:\bin\putty\putty.exe $*
pwd=cd
python=d:\bin\python\python.exe $*
rm=rm -i $*
shn=curl -F "shorten=$*" "https://envs.sh"  
sublime=d:\bin\Sublime\sublime_text.exe $*
sudo=gsudo $*  
tc=d:\bin\totalcmd\totalcmd.exe $*
top=d:\bin\tools\pmon.exe $*
tshark=d:\bin\Wireshark\tshark.exe $*
unalias=alias /d $1
vi=vim $*
winscp=d:\bin\WinSCP\winscp.exe $*
