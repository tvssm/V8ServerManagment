rem @echo off
chcp 65001

SET IbName=%1

@for /f "usebackq tokens=*" %%a in ("ConfigTypes.txt") do call Add-rdtt-To.cmd %1%%~a %IbName%