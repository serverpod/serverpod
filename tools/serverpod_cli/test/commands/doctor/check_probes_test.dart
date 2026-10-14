import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/doctor/dart_sdk_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/flutter_check.dart';
import 'package:serverpod_cli/src/doctor/git_check.dart';
import 'package:test/test.dart';

/// The Dart VM running these tests, standing in for an SDK's `dart`.
final _realDart = Platform.resolvedExecutable;

/// The SDK root [_realDart] lives in, two levels above `bin/dart`.
final _realSdkRoot = p.dirname(p.dirname(_realDart));

Directory _createTempDirectory() {
  final directory = Directory.systemTemp.createTempSync('serverpod_probes');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

/// A fake PATH holding only [directory].
Map<String, String> _pathWith(final Directory directory) => {
  'PATH': directory.path,
};

/// Writes an executable [name] into [directory] that prints [lines] and
/// exits with [exitCode]: a batch file on Windows, a shell script elsewhere.
void _writeFakeExecutable(
  final Directory directory, {
  required final String name,
  final List<String> lines = const [],
  final int exitCode = 0,
}) {
  if (Platform.isWindows) {
    File(p.join(directory.path, '$name.bat')).writeAsStringSync(
      [
        '@echo off',
        for (final line in lines) 'echo $line',
        'exit /b $exitCode',
      ].join('\r\n'),
    );
    return;
  }

  final file = File(p.join(directory.path, name))
    ..writeAsStringSync(
      [
        '#!/bin/sh',
        if (lines.isNotEmpty) ...["cat <<'EOF'", ...lines, 'EOF'],
        'exit $exitCode',
      ].join('\n'),
    );
  Process.runSync('chmod', ['755', file.path]);
}

/// Writes a `dart` launcher into [directory] that hands over to [_realDart],
/// the way version managers do from outside the SDK.
void _writeDelegatingDartLauncher(final Directory directory) {
  if (Platform.isWindows) {
    File(p.join(directory.path, 'dart.bat')).writeAsStringSync(
      ['@echo off', '"$_realDart" %*', 'exit /b %ERRORLEVEL%'].join('\r\n'),
    );
    return;
  }

  final file = File(p.join(directory.path, 'dart'))
    ..writeAsStringSync('#!/bin/sh\nexec "$_realDart" "\$@"\n');
  Process.runSync('chmod', ['755', file.path]);
}

void main() {
  test(
    'Given a flutter on PATH that reports its version, '
    'when probing, then the status is ready with the reported SDK root',
    () async {
      final bin = _createTempDirectory();
      final root = p.join(bin.path, 'flutter-sdk');
      _writeFakeExecutable(
        bin,
        name: 'flutter',
        lines: [
          jsonEncode({
            'frameworkVersion': '3.47.7',
            'channel': 'stable',
            'flutterRoot': root,
          }),
        ],
      );

      final result = await FlutterCheck.probe(environment: _pathWith(bin));

      expect(result.status, DoctorStatus.ready, reason: result.message);
      expect(result.version, '3.47.7');
      expect(result.path, root);
    },
  );

  test(
    'Given a flutter on PATH that fails to run, '
    'when probing, then the status is unknown',
    () async {
      final bin = _createTempDirectory();
      _writeFakeExecutable(bin, name: 'flutter', exitCode: 1);

      final result = await FlutterCheck.probe(environment: _pathWith(bin));

      expect(result.status, DoctorStatus.unknown);
    },
  );

  test(
    'Given no flutter on PATH, when probing, then the status is missing',
    () async {
      final result = await FlutterCheck.probe(
        environment: _pathWith(_createTempDirectory()),
      );

      expect(result.status, DoctorStatus.missing);
    },
  );

  test(
    'Given a git on PATH that reports its version, '
    'when probing, then the status is ready with that version',
    () async {
      final bin = _createTempDirectory();
      _writeFakeExecutable(
        bin,
        name: 'git',
        lines: ['git version 2.44.0'],
      );

      final result = await GitCheck.probe(environment: _pathWith(bin));

      expect(result.status, DoctorStatus.ready, reason: result.message);
      expect(result.version, '2.44.0');
    },
  );

  test(
    'Given a git on PATH that fails to run, '
    'when probing, then the status is unknown',
    () async {
      final bin = _createTempDirectory();
      _writeFakeExecutable(bin, name: 'git', exitCode: 1);

      final result = await GitCheck.probe(environment: _pathWith(bin));

      expect(result.status, DoctorStatus.unknown);
    },
  );

  test(
    'Given a dart launcher outside the SDK that runs the SDK bundled with '
    'Flutter, when probing, then the status is ready with the real SDK '
    'executable as path',
    () async {
      final bin = _createTempDirectory();
      _writeDelegatingDartLauncher(bin);

      final result = await DartSdkCheck.probe(
        flutterRoot: _realSdkRoot,
        environment: _pathWith(bin),
      );

      expect(result.status, DoctorStatus.ready, reason: result.message);
      expect(p.equals(result.path!, _realDart), isTrue, reason: result.path);
      expect(result.version, isNotNull);
    },
  );

  test(
    'Given a dart launcher that runs an SDK other than the one bundled with '
    'Flutter, when probing, then the status is misconfigured',
    () async {
      final bin = _createTempDirectory();
      _writeDelegatingDartLauncher(bin);
      final otherFlutterRoot = _createTempDirectory();

      final result = await DartSdkCheck.probe(
        flutterRoot: otherFlutterRoot.path,
        environment: _pathWith(bin),
      );

      expect(result.status, DoctorStatus.misconfigured, reason: result.message);
      expect(result.remedy, contains(bin.path));
    },
  );

  test(
    'Given a dart on PATH that fails to run, '
    'when probing, then the status is unknown',
    () async {
      final bin = _createTempDirectory();
      _writeFakeExecutable(bin, name: 'dart', exitCode: 1);

      final result = await DartSdkCheck.probe(environment: _pathWith(bin));

      expect(result.status, DoctorStatus.unknown);
    },
  );
}
