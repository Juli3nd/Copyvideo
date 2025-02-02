@echo off

:: Force remapping Y: (network drive)
net use Y: /delete >nul 2>&1
net use Y: \\SERVER\SHARE /persistent:yes

:: Ensure the log directory exists
if not exist "Y:\logs" mkdir "Y:\logs"

:: Retrieve date in YYYY-MM-DD format
for /f "tokens=1 delims=." %%a in ('wmic os get localdatetime ^| find "."') do set datetime=%%a
set "logdate=%datetime:~0,4%-%datetime:~4,2%"

:: Define log file path
set "logfile=Y:\logs\%logdate%.log"

:: Debug: Display path
echo Writing log to: %logfile%

:: Test writing to Y: before running robocopy
echo Test > "%logfile%"
if %errorlevel% neq 0 (
    echo ERROR: Cannot write to log file!
    pause
    exit /b
)

:: Run robocopy
robocopy "A:\Dossier_Source" "Y:\Dossier_Destination" /XO /LOG:"%logfile%" /V /TS /NC /NP

echo Log file: %logfile%
echo Copy process completed.

pause
