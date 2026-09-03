import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

Directory _createTempDirectory() {
  final directory = Directory.systemTemp.createTempSync('serverpod_upgrade');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

void main() {
  group('Given an AOT compiled program calling runDartInstall,', () {
    late String probe;

    setUpAll(() {
      final directory = Directory.systemTemp.createTempSync('dart_install');
      probe = p.join(
        directory.path,
        Platform.isWindows ? 'probe.exe' : 'probe',
      );
      final result = Process.runSync(Platform.resolvedExecutable, [
        'compile',
        'exe',
        p.join(
          'test',
          'util',
          'fixtures',
          'dart_install_probe.dart',
        ),
        '-o',
        probe,
      ]);
      expect(result.exitCode, 0, reason: '${result.stdout}${result.stderr}');
    });

    tearDownAll(() {
      final directory = Directory(p.dirname(probe));
      if (directory.existsSync()) directory.deleteSync(recursive: true);
    });

    /// Non-zero means runDartInstall threw rather than returning a result.
    int runProbe(final Map<String, String> environment) {
      final result = Process.runSync(
        probe,
        const [],
        environment: environment,
      );
      printOnFailure('${result.stdout}${result.stderr}');
      return result.exitCode;
    }

    test(
      'when DART_SDK points at a directory with no SDK in it, '
      'then the failed install is reported',
      () {
        expect(
          runProbe({'DART_SDK': p.join(p.separator, 'nonexistent', 'sdk')}),
          0,
        );
      },
    );

    test(
      'when dart on PATH is a wrapper script, '
      'then the failed install is reported',
      () {
        final shimDirectory = _createTempDirectory();
        final shim = p.join(
          shimDirectory.path,
          Platform.isWindows ? 'dart.bat' : 'dart',
        );
        final realDart = Platform.resolvedExecutable;

        if (Platform.isWindows) {
          File(shim).writeAsStringSync('@ECHO OFF\r\n"$realDart" %*\r\n');
        } else {
          File(shim).writeAsStringSync('#!/bin/sh\nexec "$realDart" "\$@"\n');
          Process.runSync('chmod', ['755', shim]);
        }

        expect(runProbe({'DART_SDK': '', 'PATH': shimDirectory.path}), 0);
      },
    );
  });
}
