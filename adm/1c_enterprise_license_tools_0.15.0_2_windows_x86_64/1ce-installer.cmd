@echo off

rem  ----------------------------------------------------------------------------
rem Installer launcher
rem
rem Required environment variables:
rem JAVA_HOME - location of a Java installation directory.
rem Optional environment variables:
rem E1C_INSTALLER_OPTS - additional Java options
rem  ----------------------------------------------------------------------------

rem Automatically check & get admin rights
NET FILE 1>NUL 2>NUL
if %errorlevel% EQU 0 goto gotPrivileges

setlocal
rem Create and run a temporary VBScript to elevate this batch file
set _batchFile=%~f0
set _Args=%*
rem double up any quotes
set _batchFile=""%_batchFile:"=%""
if not [%1]==[] Set _Args=%_Args:"=""%
set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%_%RANDOM%.vbs"
ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
ECHO UAC.ShellExecute "cmd", "/c ""%_batchFile% %_Args%""", "", "runas", 0 >> "%vbsGetPrivileges%"
ECHO Set FSO=CreateObject^("Scripting.FileSystemObject"^) >> "%vbsGetPrivileges%"
ECHO FSO.DeleteFile "%vbsGetPrivileges%", true >> "%vbsGetPrivileges%"
"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%"
endlocal
exit /B

:gotPrivileges
setlocal & pushd .
cd /d %~dp0
REM Run shell as admin

set START_CMD=start "1C:Enterprise Installer"
set JAVA_EXE=java.exe
set JAVAW_EXE=javaw.exe
set INSTALLER_MAIN="com._1c.installer.ui.fx.app.InstallerFxApp"
set SCRIPT_DIR=%~dp0
set DATE_TIME=
call:get_date_time "DATE_TIME"

rem Escaping "%", "!" symbols in path
setlocal DisableDelayedExpansion
set "SCRIPT_DIR=%SCRIPT_DIR:!=^^^^^^^^^^!%"
endlocal
setlocal EnableDelayedExpansion EnableExtensions

if ERRORLEVEL 1 (
    echo Unexpected error. Unable to enable extensions.
    goto error
)

set "SCRIPT_DIR=!SCRIPT_DIR:%%=^^^^%%!"
if %SCRIPT_DIR:~-1%==\ set SCRIPT_DIR=%SCRIPT_DIR:~0,-1%
endlocal

set "SCRIPT_DIR=%SCRIPT_DIR:^^^^^^^^^^!=!%"

if not defined E1C_INSTALLER_SOURCE (
  set E1C_INSTALLER_SOURCE="%SCRIPT_DIR%"
)

setlocal EnableDelayedExpansion EnableExtensions

if not defined E1C_INSTALLER_LOGS (
    set E1C_INSTALLER_LOGS=%TEMP%
)

if defined JAVA_HOME (
    set "NEW_JAVA_HOME=%JAVA_HOME:"=%"
    if not exist "!NEW_JAVA_HOME!\bin\!JAVA_EXE!" (
        echo.
        echo Error: "!NEW_JAVA_HOME!\bin\!JAVA_EXE!" is not found.
        echo Please set the JAVA_HOME environment variable to the location of your Java installation.
        echo.
        goto error
    )
    set INSTALLER_JAVA="!NEW_JAVA_HOME!\bin\%JAVA_EXE%"
    set INSTALLER_JAVAW="!NEW_JAVA_HOME!\bin\%JAVAW_EXE%"
) else (
    for %%X in (%JAVA_EXE%) do (set FOUND_JAVA=%%~$PATH:X)
    if defined FOUND_JAVA (
        set INSTALLER_JAVA="!FOUND_JAVA!"
    ) else (
        echo.
        echo Error: JAVA_HOME environment variable is not set and Java is not found in PATH.
        echo Please set the JAVA_HOME environment variable to the location of your Java installation.
        echo.
        goto error
    )

    for %%X in (%JAVAW_EXE%) do (set FOUND_JAVAW=%%~$PATH:X)
    if defined FOUND_JAVAW (
        set INSTALLER_JAVAW="!FOUND_JAVAW!"
    )
)

setlocal DisableDelayedExpansion

rem Java 9+ support
for /f "tokens=3" %%g in ('%INSTALLER_JAVA% -version 2^>^&1 ^| findstr /i version') do (
    set JAVAVER=%%g
)
set JAVAVER=%JAVAVER:"=%

for /f "delims=. tokens=1-3" %%v in ("%JAVAVER%") do (
    if %%v GEQ 9 (
        set "JAVA9_OPTS=--add-opens java.base/java.lang=ALL-UNNAMED -Djavax.xml.bind.JAXBContextFactory=org.eclipse.persistence.jaxb.JAXBContextFactory"
    )
)

rem Configure xml context factory
set "JAVA_OPTS_ADDS= "

rem Check whether we can use additional java options
if defined E1C_INSTALLER_OPTS (
    set JAVA_OPTS_ADDS=%JAVA_OPTS_ADDS% %E1C_INSTALLER_OPTS%
)

set "ENABLE_HEAP_DUMP_ON_OUT_OF_MEMORY_ERROR=false"
set "SET_HEAP_DUMP_PATH=false"
set "SET_ON_ERROR=false"

if "%JAVA_OPTS_ADDS:-XX:HeapDumpPath=%" == "%JAVA_OPTS_ADDS%" (
    if "%JAVA_OPTS_ADDS:-HeapDumpOnOutOfMemoryError=%" == "%JAVA_OPTS_ADDS%" (
       set "SET_HEAP_DUMP_PATH=true"
    )
)

if "%JAVA_OPTS_ADDS:HeapDumpOnOutOfMemoryError=%" == "%JAVA_OPTS_ADDS%" (
    set "ENABLE_HEAP_DUMP_ON_OUT_OF_MEMORY_ERROR=true"
)

if "%JAVA_OPTS_ADDS:-XX:ErrorFile=%" == "%JAVA_OPTS_ADDS%" (
    set "SET_ON_ERROR=true"
)

if "%ENABLE_HEAP_DUMP_ON_OUT_OF_MEMORY_ERROR%" == "true" (
    set JAVA_OPTS_ADDS=%JAVA_OPTS_ADDS% -XX:+HeapDumpOnOutOfMemoryError
)
if "%SET_HEAP_DUMP_PATH%" == "true" (
    if not exist "%E1C_INSTALLER_LOGS%\1ce-installer-crash" (
        mkdir "%E1C_INSTALLER_LOGS%\1ce-installer-crash"
    )

    set JAVA_OPTS_ADDS=%JAVA_OPTS_ADDS% -XX:HeapDumpPath=^"%E1C_INSTALLER_LOGS%\1ce-installer-crash\oome-memory-dump-%DATE_TIME%"
)
if "%SET_ON_ERROR%" == "true" (
    if not exist "%E1C_INSTALLER_LOGS%\1ce-installer-crash" (
        mkdir "%E1C_INSTALLER_LOGS%\1ce-installer-crash"
    )

    set JAVA_OPTS_ADDS=%JAVA_OPTS_ADDS% -XX:ErrorFile="%E1C_INSTALLER_LOGS%\1ce-installer-crash\fatal-error-%%p.log"
)

set CLASSPATH="%SCRIPT_DIR%\lib\*"

%START_CMD% %INSTALLER_JAVAW% %JAVA9_OPTS% %JAVA_OPTS_ADDS% -cp %CLASSPATH% %INSTALLER_MAIN% %*
set ERROR_CODE=%ERRORLEVEL%
goto end

:error
rem -- If error occurred - place a flag
set ERROR_CODE=1
goto end

:get_date_time
SETLOCAL
for /f "tokens=2 delims==" %%G in ('%windir%\System32\wbem\wmic os get localdatetime /value') do set datetime=%%G
rem -- вывод вида 20171225150255.825000+180

set year=%datetime:~0,4%
set month=%datetime:~4,2%
set day=%datetime:~6,2%
set hour=%datetime:~8,2%
set minute=%datetime:~10,2%
set second=%datetime:~12,2%
( ENDLOCAL & set "%~1=%year%%month%%day%T%hour%%minute%%second%"
)
goto:eof

rem Exit
:end
if %ERRORLEVEL% neq 0 (
    if %ERROR_CODE% neq 0 (
        set ERROR_CODE=ERRORLEVEL
    )
)
cmd /C exit /B %ERROR_CODE%
