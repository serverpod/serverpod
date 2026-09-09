import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
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
/// Windows: waits zero milliseconds on the process handle. A process object
/// is signalled the moment the process exits, and outlives it for as long as
/// anyone holds a handle to it - the parent that spawned it, most often - so
/// opening a handle only says the PID is still assigned, not that anything is
/// running behind it. The wait needs `PROCESS_SYNCHRONIZE`, which the owner
/// is granted; a process of another user reads as dead, as EPERM does.
bool isProcessAlive(int pid) {
  if (Platform.isWindows) {
    return _withProcessHandle(pid, (handle) {
          final win32.Win32Result(value: signalled) = win32.WaitForSingleObject(
            handle,
            0,
          );
          return signalled == win32.WAIT_TIMEOUT;
        }, access: win32.PROCESS_SYNCHRONIZE) ??
        false;
  }
  return _libcKill(pid, 0) == 0;
}

/// Absolute path to the executable image of the process at [pid], or null
/// when the process is gone, inaccessible, or the host has no cheap way to
/// resolve it.
///
/// Linux: reads `/proc/<pid>/exe` (always points at the original executable
/// even after rename/delete). Windows: `QueryFullProcessImageNameW` via
/// `package:win32`. macOS returns null - `proc_pidpath` via FFI is doable
/// but not yet wired; macOS identity checks fall back to argv matching.
String? readProcessExecutable(int pid) {
  if (Platform.isWindows) return _readWindowsImagePath(pid);
  if (Platform.isLinux) {
    try {
      return Link('/proc/$pid/exe').targetSync();
    } on FileSystemException {
      return null;
    }
  }
  return null;
}

String? _readWindowsImagePath(int pid) {
  return _withProcessHandle(pid, (handle) {
    // 32768 wide chars covers the extended-path limit (Win10+).
    const capacity = 32768;
    final buffer = win32.PWSTR(calloc<Uint16>(capacity).cast());
    final sizePtr = calloc<Uint32>()..value = capacity;
    try {
      final win32.Win32Result(value: success) = win32.QueryFullProcessImageName(
        handle,
        win32.PROCESS_NAME_WIN32,
        buffer,
        sizePtr,
      );
      if (!success) return null;
      return buffer.toDartString(length: sizePtr.value);
    } finally {
      calloc
        ..free(buffer)
        ..free(sizePtr);
    }
  });
}

/// Opens a handle to [pid] carrying `PROCESS_QUERY_LIMITED_INFORMATION` and
/// [access], runs [body] with it, and closes the handle. Returns null when the
/// PID is unassigned. Windows-only.
T? _withProcessHandle<T>(
  int pid,
  T? Function(win32.HANDLE handle) body, {
  win32.PROCESS_ACCESS_RIGHTS access = const win32.PROCESS_ACCESS_RIGHTS(0),
}) {
  final win32.Win32Result(value: handle) = win32.OpenProcess(
    win32.PROCESS_QUERY_LIMITED_INFORMATION | access,
    false,
    pid,
  );
  if (!handle.isValid) return null;
  try {
    return body(handle);
  } finally {
    win32.CloseHandle(handle);
  }
}
