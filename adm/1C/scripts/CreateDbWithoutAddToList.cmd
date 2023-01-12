@echo off
chcp 65001

SET ver1C=8.3.22.1709
SET Exe="c:\Program Files\1cv8\%ver1C%\bin\1cv8.exe"
set SQL=windows-advance
set APP=app01
set SqlUsr=sa
set SqlPwd=240192Zfsobluk
set DbName=%1
SET DbTemplate=%2

SET ConnectionStr=Srvr=%APP%;Ref=%DbName%;DBMS=MSSQLServer;SQLSrvr=%SQL%;SQLDB=%DbName%;SQLUID=%SqlUsr%;SQLPwd=%SqlPwd%;CrSQLDB=Y

echo Запущено создание SQL базы. Имя ИБ на SQL и APP 1C: [%DbName%]
%Exe% CREATEINFOBASE %ConnectionStr% /Out"CreateDB-%1.log"
TYPE "CreateDB-%1.log"
