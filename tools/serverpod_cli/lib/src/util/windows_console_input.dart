import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';

/// Enables virtual-terminal input on the Windows console so that special keys
/// (notably the arrow keys) are delivered to `stdin` as ANSI escape sequences.
///
/// Windows Terminal/ConPTY otherwise reports arrow keys as character-less key
/// events that `stdin.readByteSync()` discards, so an escape-sequence based
/// prompt never sees them. Enabling this mode makes the cursor keys arrive as
/// the same `ESC [ A` / `ESC [ B` sequences they do on POSIX terminals.
///
/// Returns the previous console mode to hand to
/// [restoreWindowsConsoleInputMode], or `null` if the mode could not be read
/// or changed (for example when stdin is not a console).
///
/// Only call this on Windows; the underlying `kernel32.dll` bindings (via
/// `package:win32`) are unavailable on other platforms.
int? enableWindowsVirtualTerminalInput() {
  final handle = GetStdHandle(STD_INPUT_HANDLE);
  final modePointer = calloc<Uint32>();
  try {
    if (GetConsoleMode(handle, modePointer) == 0) return null;

    final originalMode = modePointer.value;
    final result = SetConsoleMode(
      handle,
      originalMode | ENABLE_VIRTUAL_TERMINAL_INPUT,
    );
    return result == 0 ? null : originalMode;
  } finally {
    calloc.free(modePointer);
  }
}

/// Restores a console input mode previously captured by
/// [enableWindowsVirtualTerminalInput].
void restoreWindowsConsoleInputMode(int mode) {
  SetConsoleMode(GetStdHandle(STD_INPUT_HANDLE), mode);
}
