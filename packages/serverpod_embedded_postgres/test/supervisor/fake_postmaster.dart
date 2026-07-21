/// Test-only stand-in for the PostgreSQL postmaster.
///
/// Spawned by stale-lock-repair tests as
/// `dart fake_postmaster.dart -D <pgdata>`. Stays alive until terminated.
/// SIGTERM/SIGINT trigger a clean exit on POSIX; on Windows the tests kill it
/// via `Process.killPid(pid, ProcessSignal.sigterm)`, which maps to
/// TerminateProcess and needs no in-process listener.
library;

import 'dart:io';

Future<void> main(List<String> args) async {
  // POSIX only: `ProcessSignal.sigterm.watch()` throws on Windows (only SIGINT
  // and SIGHUP are watchable there - Serverpod's own server guards it the same
  // way). Registering it unconditionally crashed this stand-in during startup,
  // which raced the spawning test's liveness check and made the Windows
  // stale-lock-repair suite flaky. On Windows, TerminateProcess kills us with
  // no handler needed, so simply block.
  if (!Platform.isWindows) {
    ProcessSignal.sigterm.watch().listen((_) => exit(0));
    ProcessSignal.sigint.watch().listen((_) => exit(0));
  }
  // An uncompleted Future alone does not keep every supported Dart VM's event
  // loop alive. A pending timer does, so this stand-in remains a live process
  // until the spawning test terminates it.
  while (true) {
    await Future<void>.delayed(const Duration(hours: 1));
  }
}
