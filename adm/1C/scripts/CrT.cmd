@echo off
chcp 65001

set restoresrv=MyServer
set sqluser=sa
set sqlpassw=240192Zfsobluk
set v8ver=8.3.22.1709

set restoreddb=MyDataBase
"%ProgramFiles%\1cv8\%v8ver%\bin\1cv8.exe" createinfobase Srvr=%restoresrv%;Ref=%restoreddb%;SQLSrvr=%restoresrv%;DBMS=MSSQLServer;SQLDB=%restoreddb%;SQLUID=%sqluser%;SQLPwd=%sqlpassw%;SQLYOffs=2000;CrSQLDB=n;DB=%restoreddb% /AddInList %restoreddb% /Out"CreateDB-%1.log"
@TYPE "CreateDB-%1.log"
