import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'pg_ctl.dart';
import 'process_identity.dart';

/// Starts an independent watchdog for the owning VM, not the calling isolate.
///
/// Signal handlers do not run on normal VM exit or SIGKILL. A pipe to the
/// calling isolate is insufficient too: the test runner can dispose that
/// isolate while other suites still use its postmaster. The watchdog instead
/// observes the OS processes, and exits when the original postmaster exits.
Future<void> watchParentExit(ProcessIdentity identity) async {
  final environment = {
    'SERVERPOD_WATCH_OWNER': '${identity.supervisorPid}',
    'SERVERPOD_WATCH_POSTMASTER': '${identity.pid}',
    'SERVERPOD_WATCH_EXECUTABLE': identity.executable,
    'SERVERPOD_WATCH_DATA': identity.dataDir,
    'SERVERPOD_WATCH_PG_CTL': pgCtlForPostgresExecutable(
      identity.executable,
    ).path,
  };

  final watcher = await Process.start(
    Platform.isWindows ? 'powershell.exe' : '/bin/sh',
    Platform.isWindows
        ? ['-NoProfile', '-NonInteractive', '-Command', _windowsWatchdog]
        : ['-c', _posixWatchdog],
    environment: environment,
    // Survive both isolate disposal and terminal signals. No Dart executable
    // or package sources are needed, including in an AOT-compiled application.
    mode: ProcessStartMode.detachedWithStdio,
  );

  final errors = watcher.stderr.transform(utf8.decoder).join();
  try {
    final ready = await watcher.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .first
        .timeout(const Duration(seconds: 10));
    if (ready != 'ready') {
      throw StateError('Unexpected parent-exit watchdog response: $ready');
    }
  } catch (_) {
    watcher.kill();
    final detail = await errors.timeout(
      const Duration(seconds: 1),
      onTimeout: () => '',
    );
    throw StateError(
      'Could not start the PostgreSQL parent-exit watchdog: $detail',
    );
  } finally {
    await watcher.stdin.close();
  }
}

// Match start time AND command line, rather than just testing PID existence.
// This also treats a zombie owner as exited and avoids following recycled PIDs.
// Paths travel through the environment, never through shell interpolation.
const _posixWatchdog = r'''
process_identity() {
  ps -ww -p "$1" -o stat= -o lstart= -o args= 2>/dev/null |
    while read -r state identity; do
      case "$state" in Z*) return 1 ;; esac
      printf '%s\n' "$identity"
    done
}

postmaster="$SERVERPOD_WATCH_POSTMASTER"
owner="$SERVERPOD_WATCH_OWNER"
postmaster_identity=$(process_identity "$postmaster")
case "$postmaster_identity" in
  *" $SERVERPOD_WATCH_EXECUTABLE -D $SERVERPOD_WATCH_DATA") ;;
  *) exit 1 ;;
esac
owner_identity=$(process_identity "$owner")
printf 'ready\n'
exec </dev/null >/dev/null 2>&1

while [ "$(process_identity "$postmaster")" = "$postmaster_identity" ]; do
  if [ -z "$owner_identity" ] || [ "$(process_identity "$owner")" != "$owner_identity" ]; then
    # PostgreSQL's fast shutdown disconnects clients and releases its sockets
    # and shared memory. Signal the original PID, never a replacement cluster
    # that may have acquired the same data directory in the meantime.
    kill -INT "$postmaster"
    exit
  fi
  sleep 1
done
''';

// Holding Process handles prevents PID reuse while the watchdog is watching.
// pg_ctl kill delivers PostgreSQL's emulated SIGINT on Windows; terminating
// postgres.exe directly would skip PostgreSQL's backend and IPC cleanup.
const _windowsWatchdog = r'''
$ErrorActionPreference = 'Stop'
$postmaster = Get-Process -Id $env:SERVERPOD_WATCH_POSTMASTER
$null = $postmaster.Handle
if ($postmaster.Path -ne $env:SERVERPOD_WATCH_EXECUTABLE) { exit 1 }
$owner = Get-Process -Id $env:SERVERPOD_WATCH_OWNER -ErrorAction SilentlyContinue
if ($null -ne $owner) { $null = $owner.Handle }
[Console]::WriteLine('ready')
while (-not $postmaster.HasExited) {
  if ($null -eq $owner -or $owner.WaitForExit(1000)) {
    if (-not $postmaster.HasExited) {
      & $env:SERVERPOD_WATCH_PG_CTL kill INT $env:SERVERPOD_WATCH_POSTMASTER
    }
    break
  }
}
''';
