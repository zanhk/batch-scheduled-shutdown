@echo off
setlocal enabledelayedexpansion

REM Check the number of arguments and set values accordingly
if "%~3"=="" (
    REM If log path is not provided, set logflag to 0
    set logflag=0
) else (
    set logflag=1
    set logpath=%~3
)

REM Set start and end hours from arguments, or default to 22 and 4 if not provided
set starthour=%~1
set endhour=%~2
if "%starthour%"=="" set starthour=22
if "%endhour%"=="" set endhour=4

REM Log the start time and parameters if logging is enabled
if !logflag! equ 1 (
    echo ----------------------- >> !logpath!
    echo SCRIPT STARTED AT: %date% %time% >> !logpath!
    echo Start Hour: !starthour! >> !logpath!
    echo End Hour: !endhour! >> !logpath!
    echo ----------------------- >> !logpath!
)

REM Get the current hour
for /f "tokens=1 delims=:" %%a in ('echo %time%') do set hour=%%a

REM Remove leading space if hour is less than 10
set hour=0!hour!
set hour=!hour:~-2!

REM Log the extracted hour if logging is enabled
if !logflag! equ 1 (
    echo Current Time: %date% %time% >> !logpath!
    echo Extracted Hour: !hour! >> !logpath!
)

REM Check the range
if !hour! geq !starthour! if !hour! lss !endhour! goto shutdown

REM Log that the time isn't in the shutdown range if logging is enabled
if !logflag! equ 1 (
    echo Decision: Time is not in shutdown range. Exiting. >> !logpath!
    echo ----------------------- >> !logpath!
)
exit

:shutdown
REM Log the shutdown decision if logging is enabled
if !logflag! equ 1 (
    echo Decision: Time is in shutdown range. Shutting down. >> !logpath!
    echo ----------------------- >> !logpath!
)
shutdown -s -t 10 -c "Shutting down because the time is between !starthour! and !endhour!."
exit
