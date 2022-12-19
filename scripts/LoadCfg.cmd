@echo off
chcp 65001

@SET ver1C=8.3.22.1709
@SET Exe="c:\Program Files\1cv8\%ver1C%\bin\1cv8.exe"
@SET SQL=windows-advance
@SET APP=app01
@SET SqlUsr=sa
@SET SqlPwd=240192Zfsobluk
@SET DbName=%1
@SET Cf=%2
@SET LogFile="LoadCfg-%DbName%.log"
@SET ConnectionStr=%APP%\%DbName%

echo Запущена загрузка CF в базу: [%DbName%]
%Exe% CONFIG  /S"%ConnectionStr%" /LoadCfg%Cf% /Out"%LogFile%.log"
@TYPE %LogFile%
