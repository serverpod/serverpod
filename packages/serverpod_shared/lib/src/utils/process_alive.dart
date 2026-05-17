import 'dart:ffi';
import 'dart:io';

import 'package:win32/win32.dart' as win32;

// libc is statically linked into every Dart binary on POSIX, so we can
// resolve kill(2) directly out of the process image - no shared-library
// load. Used by [isProcessAlive] for a non-delivering liveness probe
// (signal 0 doesn't actually deliver).
final int Function(int pid, int sig) _libcKill = Platform.isWindows
    ? (_, _) => throw UnsupportedError('libc kill is POSIX-only')
    : DynamicLibrary.process()
          .lookupFunction<Int32 Function(Int32, Int32), int Function(int, int)>(
            'kill',
          );

/// Whether [pid] currently refers to a live process on this host.
///
/// Use this for PIDs read from disk (pidfiles, supervisor records, foreign
/// subtree members). For subprocesses you spawned, prefer holding the
/// [Process] instance and awaiting [Process.exitCode] - no PID-recycling
/// race, reactive on exit.
///
/// POSIX: `kill(pid, 0)` (non-delivering probe). EPERM (cross-user PID
/// recycling) is reported as dead - a non-issue on a single-user dev box.
///
/// Windows: `OpenProcess(PROCESS_QUERY_LIMITED_INFORMATION, ...)` returns a
/// handle iff the PID is assigned, with no ACL grant required.
bool isProcessAlive(int pid) {
  if (Platform.isWindows) {
    var handle = win32.OpenProcess(
      win32.PROCESS_QUERY_LIMITED_INFORMATION,
      win32.FALSE,
      pid,
    );
    if (handle == 0) return false;
    win32.CloseHandle(handle);
    return true;
  }
  return _libcKill(pid, 0) == 0;
}
