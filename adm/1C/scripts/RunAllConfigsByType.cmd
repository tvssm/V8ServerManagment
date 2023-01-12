@echo off
@chcp 65001

@for /f "usebackq tokens=*" %%a in ("ConfigTypes.txt") do (call RunConfig.cmd %1%%~a >> RunAllConfigsByType.log)
@TYPE RunAllConfigsByType.log