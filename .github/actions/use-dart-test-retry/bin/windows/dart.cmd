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
if /I "%~1"=="test" goto run_test
"%SERVERPOD_REAL_DART%" %*
exit /b %ERRORLEVEL%

:run_test
"%SERVERPOD_REAL_DART%" "%SERVERPOD_RETRY_RUNNER%" --attempts 3 --retry-exit-codes 65 --timeout-seconds 0 -- "%SERVERPOD_REAL_DART%" %*
exit /b %ERRORLEVEL%
