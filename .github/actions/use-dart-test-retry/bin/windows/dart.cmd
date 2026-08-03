@echo off
setlocal EnableExtensions

if defined SERVERPOD_REAL_DART goto dispatch
>&2 echo The real Dart executable was not configured.
exit /b 1

:dispatch
if not defined SERVERPOD_RETRY_RUNNER (
  >&2 echo The retry runner was not configured.
  exit /b 1
)
if "%SERVERPOD_DART_RETRY_ACTIVE%"=="1" goto passthrough
if /I "%~1"=="test" goto run_with_retry
if /I "%~1"=="run" goto run_with_retry
if /I "%~1"=="build" goto run_with_retry

:passthrough
"%SERVERPOD_REAL_DART%" %*
exit /b %ERRORLEVEL%

:run_with_retry
"%SERVERPOD_REAL_DART%" "%SERVERPOD_RETRY_RUNNER%" --attempts 3 --retry-exit-codes 65,255 --retry-output-contains "Error: Running build hooks failed." --timeout-seconds 0 -- "%SERVERPOD_REAL_DART%" %*
exit /b %ERRORLEVEL%
