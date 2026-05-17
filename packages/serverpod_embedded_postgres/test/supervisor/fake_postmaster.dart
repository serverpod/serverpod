/// Test-only stand-in for the PostgreSQL postmaster.
///
/// Spawned by stale-lock-repair tests as
/// `dart fake_postmaster.dart -D <pgdata>`. Stays alive until terminated.
/// SIGTERM/SIGINT trigger a clean exit on POSIX; on Windows
/// `Process.killPid(pid, ProcessSignal.sigterm)` maps to TerminateProcess
/// and there is no in-process listener to fire, but the result (process
/// dies) is the same.
library;

import 'dart:async';
import 'dart:io';

Future<void> main(List<String> args) async {
  ProcessSignal.sigterm.watch().listen((_) => exit(0));
  if (!Platform.isWindows) {
    ProcessSignal.sigint.watch().listen((_) => exit(0));
  }
  await Completer<void>().future;
}
