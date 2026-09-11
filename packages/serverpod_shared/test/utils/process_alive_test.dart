import 'dart:io';

import 'package:serverpod_shared/process_io.dart';
import 'package:test/test.dart';
import 'package:win32/win32.dart' as win32;

void main() {
  group('Given a child process on Windows,', () {
    test(
      'when it exits while another handle to it stays open, '
      'then it reads as dead rather than as an assigned PID',
      () async {
        // Waits for a line on stdin, so it is still running while we look.
        final child = await Process.start('cmd', ['/c', 'set /p unused=']);
        final win32.Win32Result(value: handle) = win32.OpenProcess(
          win32.PROCESS_QUERY_LIMITED_INFORMATION,
          false,
          child.pid,
        );
        addTearDown(() => win32.CloseHandle(handle));
        expect(handle.isValid, isTrue);
        expect(isProcessAlive(child.pid), isTrue);

        await child.stdin.close();
        await child.exitCode;

        expect(isProcessAlive(child.pid), isFalse);
      },
      skip: !Platform.isWindows,
    );
  });
}
