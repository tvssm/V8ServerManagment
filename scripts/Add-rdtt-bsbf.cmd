@echo off
chcp 65001
SET  IbName=bsbf
"c:\Program Files\1cv8\8.3.22.1709\bin\1cv8.exe" DESIGNER /S "app01\%IbName%" /AppAutoCheckVersion  /AppAutoCheckMode "/ConfigurationRepositoryF "tcp://app01/%IbName%" /ConfigurationRepositoryF "tcp://app01/цм_bsbf_ОтладчикЗащиты_cfe" /ConfigurationRepositoryN "bsbf" /ConfigurationRepositoryF "tcp://app01/цм_ИнструментыРазработчика_cfe" /ConfigurationRepositoryUnbindCfg -Extension "ИнструментыРазработчикаTormozit" /LoadCfg "c:\Development\cf_cfe\ИнструментыРазработчикаTormozit.cfe" -Extension "ИнструментыРазработчикаTormozit" /Out"Add-rdtt-%IbName%.log"