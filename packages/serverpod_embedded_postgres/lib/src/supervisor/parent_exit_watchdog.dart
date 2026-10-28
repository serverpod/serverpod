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
  // Capture identity while the launcher still owns the Process. Linux start
  // ticks are monotonic; procps' displayed start date moves with wall-clock
  // corrections (notably on WSL). macOS ps uses the recorded birth time.
  final postmasterIdentity = Platform.isWindows
      ? null
      : await _posixIdentity(identity.pid);
  final ownerIdentity = Platform.isWindows
      ? null
      : await _posixIdentity(identity.supervisorPid);
  if (!Platform.isWindows &&
      (postmasterIdentity == null || ownerIdentity == null)) {
    throw StateError('Cannot read PostgreSQL or owner process identity.');
  }
  if (Platform.isLinux &&
      verifyIdentity(identity) != IdentityMatch.matchesOurs) {
    throw StateError(
      'The postmaster identity changed before watchdog startup.',
    );
  }

  final environment = {
    'SERVERPOD_WATCH_OWNER': '${identity.supervisorPid}',
    'SERVERPOD_WATCH_POSTMASTER': '${identity.pid}',
    'SERVERPOD_WATCH_EXECUTABLE': identity.executable,
    'SERVERPOD_WATCH_LINUX': Platform.isLinux ? '1' : '0',
    'SERVERPOD_WATCH_POSTMASTER_IDENTITY': ?postmasterIdentity,
    'SERVERPOD_WATCH_OWNER_IDENTITY': ?ownerIdentity,
    if (!Platform.isWindows) ...{'LC_ALL': 'C', 'TZ': 'UTC'},
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
  } catch (error) {
    watcher.kill();
    final detail = await errors.timeout(
      const Duration(seconds: 1),
      onTimeout: () => '',
    );
    throw StateError(
      'Could not start the PostgreSQL parent-exit watchdog: $error. $detail',
    );
  } finally {
    await watcher.stdin.close();
  }
}

Future<String?> _posixIdentity(int processId) async {
  if (Platform.isLinux) {
    try {
      final stat = File('/proc/$processId/stat').readAsStringSync();
      // comm is parenthesized and can itself contain spaces and ')'.
      final fields = stat.substring(stat.lastIndexOf(')') + 2).split(' ');
      if (fields.first == 'Z' || fields.first == 'X') return null;
      return fields[19]; // Field 22: start ticks since boot.
    } on FileSystemException {
      return null;
    }
  }

  final result = await Process.run(
    '/bin/ps',
    ['-ww', '-p', '$processId', '-o', 'stat=', '-o', 'lstart=', '-o', 'args='],
    environment: {'LC_ALL': 'C', 'TZ': 'UTC'},
  );
  if (result.exitCode != 0) return null;
  final line = (result.stdout as String).trim();
  final separator = line.indexOf(RegExp(r'\s'));
  if (separator < 0 || line.startsWith('Z') || line.startsWith('X')) {
    return null;
  }
  return line.substring(separator).trim();
}

// Paths never appear in shell source or get compared to locale-rendered text.
// Linux uses only shell builtins to read procfs, so no procps installation is
// required. macOS compares two identically rendered snapshots from system ps.
const _posixWatchdog = r'''
set -f
process_identity() {
  if [ "$SERVERPOD_WATCH_LINUX" = 1 ]; then
    { IFS= read -r stat < "/proc/$1/stat"; } 2>/dev/null || return 1
    set -- ${stat##*) }
    case "$1" in Z|X) return 1 ;; esac
    shift 19
    printf '%s\n' "$1"
  else
    /bin/ps -ww -p "$1" -o stat= -o lstart= -o args= 2>/dev/null |
      while read -r state identity; do
        case "$state" in Z*|X*) return 1 ;; esac
        printf '%s\n' "$identity"
      done
  fi
}

postmaster="$SERVERPOD_WATCH_POSTMASTER"
owner="$SERVERPOD_WATCH_OWNER"
postmaster_identity="$SERVERPOD_WATCH_POSTMASTER_IDENTITY"
owner_identity="$SERVERPOD_WATCH_OWNER_IDENTITY"
if [ "$(process_identity "$postmaster")" != "$postmaster_identity" ]; then
  printf 'Postmaster exited or changed identity before watchdog startup.\n' >&2
  exit 1
fi
if ! /bin/sleep 0; then
  printf 'The parent-exit watchdog requires /bin/sleep.\n' >&2
  exit 1
fi
printf 'ready\n'
exec </dev/null >/dev/null 2>&1

while [ "$(process_identity "$postmaster")" = "$postmaster_identity" ]; do
  if [ -z "$owner_identity" ] || [ "$(process_identity "$owner")" != "$owner_identity" ]; then
    # PostgreSQL's fast shutdown disconnects clients and releases its sockets
    # and shared memory. Signal the original PID, never a replacement cluster
    # that may have acquired the same data directory in the meantime.
    if [ "$(process_identity "$postmaster")" = "$postmaster_identity" ]; then
      kill -INT "$postmaster"
    fi
    exit
  fi
  /bin/sleep 1 || exit 1
done
''';

// Holding Process handles prevents PID reuse while the watchdog is watching.
// pg_ctl kill delivers PostgreSQL's emulated SIGINT on Windows; terminating
// postgres.exe directly would skip PostgreSQL's backend and IPC cleanup.
const _windowsWatchdog = r'''
$ErrorActionPreference = 'Stop'
$postmaster = Get-Process -Id $env:SERVERPOD_WATCH_POSTMASTER
$null = $postmaster.Handle
if ([IO.Path]::GetFullPath($postmaster.Path) -ne
    [IO.Path]::GetFullPath($env:SERVERPOD_WATCH_EXECUTABLE)) {
  throw 'The postmaster image does not match the launched executable.'
}
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
