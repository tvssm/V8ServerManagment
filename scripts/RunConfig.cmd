rem @echo off
@chcp 65001

@SET ver1C=8.3.22.1709
@SET Exe="c:\Program Files\1cv8\%ver1C%\bin\1cv8.exe"
@SET APP=app01
@SET IbName=%APP%\%1
@SET RunMode=DESIGNER

@IF [%2]==[] SET RunMode=DESIGNER
@IF NOT [%2]==[] SET RunMode=%2
ECHO "Запускаю базу %IbName%" в режиме %RunMode%
%Exe% %RunMode% /S%IbName% /AppAutoCheckVersion  /AppAutoCheckMode /NАдминистратор /P %3