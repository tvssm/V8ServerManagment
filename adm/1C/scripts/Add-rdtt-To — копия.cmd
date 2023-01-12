@echo off
chcp 65001

SET IbName=%1
SET RepCf=%2

"c:\Program Files\1cv8\8.3.22.1709\bin\1cv8.exe" DESIGNER /S "app01\%IbName%" /AppAutoCheckVersion  /AppAutoCheckMode /ConfigurationRepositoryF "%RepCf%" /LoadCfg "c:\Development\cf_cfe\ИнструментыРазработчикаTormozit.cfe" -Extension "ИнструментыРазработчикаTormozit" /ConfigurationRepositoryF "tcp://app01/цм_ИнструментыРазработчика_cfe" -Extension "ИнструментыРазработчикаTormozit" /ConfigurationRepositoryN "%IbName%"" /Out"Add-rdtt-%IbName%.log"