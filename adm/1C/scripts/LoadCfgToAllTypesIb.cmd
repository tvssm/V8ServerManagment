@echo off
@chcp 65001

CALL LoadCfg.cmd %1 %2
CALL LoadCfg.cmd %1_test %2
CALL LoadCfg.cmd %1_demo %2
CALL LoadCfg.cmd %1_typical %2