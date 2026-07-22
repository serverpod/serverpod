@echo off
setlocal

if "%~1"=="" (
  echo Usage: run_windows_standard_user_test.cmd ^<prepared-launcher.cmd^>
  exit /b 2
)
if not exist "%~1" (
  echo ::error::prepared launcher does not exist: %~1
  exit /b 2
)
if not defined SERVERPOD_WINDOWS_TEST_USER (
  echo ::error::SERVERPOD_WINDOWS_TEST_USER is not set
  exit /b 2
)
if not defined SERVERPOD_WINDOWS_TEST_PASSWORD (
  echo ::error::SERVERPOD_WINDOWS_TEST_PASSWORD is not set
  exit /b 2
)
if not defined SERVERPOD_WINDOWS_TEST_LOG (
  echo ::error::SERVERPOD_WINDOWS_TEST_LOG is not set
  exit /b 2
)

set "LAUNCHER=%~f1"
psexec -accepteula -nobanner ^
  -u "%COMPUTERNAME%\%SERVERPOD_WINDOWS_TEST_USER%" ^
  -p "%SERVERPOD_WINDOWS_TEST_PASSWORD%" ^
  cmd /c "%LAUNCHER%"
set "RC=%errorlevel%"

if not exist "%SERVERPOD_WINDOWS_TEST_LOG%" (
  echo ::error::the standard-user test process produced no log at %SERVERPOD_WINDOWS_TEST_LOG%
  exit /b 1
)

type "%SERVERPOD_WINDOWS_TEST_LOG%"
exit /b %RC%
