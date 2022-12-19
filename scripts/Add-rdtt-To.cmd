@echo off
chcp 65001

SET IbName=%1
SET RepCf=%2

"c:\Program Files\1cv8\8.3.22.1709\bin\1cv8.exe" DESIGNER /S "app01\%IbName%" /AppAutoCheckVersion  /AppAutoCheckMode /ConfigurationRepositoryN "%IbName%" /ConfigurationRepositoryF "%RepCf%" /ConfigurationRepositoryF "tcp://app01/цм_ИнструментыРазработчика_cfe" -Extension "ИнструментыРазработчикаTormozit" ConfigurationRepositoryUpdateCfg  -Extension "ИнструментыРазработчикаTormozit" /Out"Add-rdtt-%IbName%.log"