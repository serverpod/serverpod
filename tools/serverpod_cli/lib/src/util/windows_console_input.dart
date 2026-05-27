import 'dart:ffi';

import 'package:ffi/ffi.dart';

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
/// Only call this on Windows; the `kernel32.dll` bindings are loaded lazily
/// and are unavailable on other platforms.
int? enableWindowsVirtualTerminalInput() {
  final handle = _getStdHandle(_stdInputHandle);
  final modePointer = calloc<Uint32>();
  try {
    if (_getConsoleMode(handle, modePointer) == 0) return null;

    final originalMode = modePointer.value;
    final result = _setConsoleMode(
      handle,
      originalMode | _enableVirtualTerminalInput,
    );
    return result == 0 ? null : originalMode;
  } finally {
    calloc.free(modePointer);
  }
}

/// Restores a console input mode previously captured by
/// [enableWindowsVirtualTerminalInput].
void restoreWindowsConsoleInputMode(int mode) {
  _setConsoleMode(_getStdHandle(_stdInputHandle), mode);
}

const int _stdInputHandle = -10;
const int _enableVirtualTerminalInput = 0x0200;

typedef _GetStdHandleC = IntPtr Function(Uint32 nStdHandle);
typedef _GetStdHandleDart = int Function(int nStdHandle);

typedef _GetConsoleModeC =
    Int32 Function(
      IntPtr hConsoleHandle,
      Pointer<Uint32> lpMode,
    );
typedef _GetConsoleModeDart =
    int Function(
      int hConsoleHandle,
      Pointer<Uint32> lpMode,
    );

typedef _SetConsoleModeC = Int32 Function(IntPtr hConsoleHandle, Uint32 dwMode);
typedef _SetConsoleModeDart = int Function(int hConsoleHandle, int dwMode);

final DynamicLibrary _kernel32 = DynamicLibrary.open('kernel32.dll');

final _getStdHandle = _kernel32
    .lookupFunction<_GetStdHandleC, _GetStdHandleDart>('GetStdHandle');
final _getConsoleMode = _kernel32
    .lookupFunction<_GetConsoleModeC, _GetConsoleModeDart>('GetConsoleMode');
final _setConsoleMode = _kernel32
    .lookupFunction<_SetConsoleModeC, _SetConsoleModeDart>('SetConsoleMode');
