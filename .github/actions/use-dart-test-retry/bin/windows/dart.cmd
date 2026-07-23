@echo off
setlocal EnableExtensions

if defined SERVERPOD_REAL_DART goto dispatch
>&2 echo The real Dart executable was not configured.
exit /b 1

:dispatch
if /I "%~1"=="test" goto run_test
"%SERVERPOD_REAL_DART%" %*
exit /b %ERRORLEVEL%

:run_test
set "max_attempts=3"
set "attempt=1"

:run_test_attempt
"%SERVERPOD_REAL_DART%" %*
set "exit_code=%ERRORLEVEL%"

if not "%exit_code%"=="65" exit /b %exit_code%
if "%attempt%"=="%max_attempts%" exit /b %exit_code%

set /a "attempt+=1"
set /a "delay=attempt-1"
echo dart test exited with code 65; retrying in case of a transient build-hook failure ^(attempt %attempt%/%max_attempts%^).
powershell.exe -NoLogo -NoProfile -NonInteractive -Command "Start-Sleep -Seconds %delay%"
goto run_test_attempt
