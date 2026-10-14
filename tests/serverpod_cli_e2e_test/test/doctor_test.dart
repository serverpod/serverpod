@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

/// The parent environment with PATH replaced by [path], so the CLI finds no
/// tools at all. The key is matched case-insensitively for Windows.
Map<String, String> _environmentWithPath(final String path) => {
  for (final entry in Platform.environment.entries)
    if (entry.key.toUpperCase() != 'PATH') entry.key: entry.value,
  'PATH': path,
  'SERVERPOD_HOME': serverpodHome,
};

void main() {
  group('Given the compiled CLI with no tools on PATH,', () {
    late ProcessResult result;

    setUp(() async {
      result = await Process.run(
        await compiledServerpodCliExe,
        ['doctor', '--json', '--no-analytics'],
        workingDirectory: d.sandbox,
        environment: _environmentWithPath(d.sandbox),
        includeParentEnvironment: false,
      );
    });

    test(
      'when running doctor, then it still runs and reports the SDKs as '
      'missing with a failing exit code',
      () {
        expect(result.exitCode, 1, reason: result.stderr as String);

        final report = jsonDecode(result.stdout as String) as Map;
        expect(report['schemaVersion'], 1);
        expect(report['ready'], isFalse);

        final checks = report['checks'] as List;
        final statusById = {
          for (final check in checks.cast<Map>())
            check['id'] as String: check['status'] as String,
        };
        expect(statusById['flutter'], 'missing');
        expect(statusById['dart'], 'missing');
        expect(statusById['serverpod'], 'missing');
        expect(statusById['git'], 'missing');
      },
    );
  });

  group('Given the compiled CLI with a fresh, empty home directory,', () {
    late Directory home;
    late ProcessResult result;

    setUp(() async {
      home = Directory(d.sandbox).createTempSync('home');
      result = await Process.run(
        await compiledServerpodCliExe,
        ['doctor', '--json', '--no-analytics'],
        workingDirectory: d.sandbox,
        environment: {
          for (final entry in Platform.environment.entries)
            if (!const {
              'HOME',
              'USERPROFILE',
            }.contains(entry.key.toUpperCase()))
              entry.key: entry.value,
          'HOME': home.path,
          'USERPROFILE': home.path,
          'SERVERPOD_HOME': serverpodHome,
        },
        includeParentEnvironment: false,
      );
    });

    test(
      'when running doctor, then stdout is only the JSON report and nothing '
      'is written to the profile',
      () {
        expect(
          () => jsonDecode(result.stdout as String),
          returnsNormally,
          reason: result.stdout as String,
        );
        expect(
          Directory(p.join(home.path, '.serverpod')).existsSync(),
          isFalse,
          reason: 'Doctor must not create the run counter or user ID.',
        );
      },
    );
  });

  group('Given the compiled CLI with the inherited PATH,', () {
    late ProcessResult result;

    setUp(() async {
      result = await runServerpod(
        ['doctor'],
        workingDirectory: d.sandbox,
        implicitArgs: ['--no-analytics'],
      );
    });

    test(
      'when running doctor, then every check is reported in order',
      () {
        final output = result.stdout as String;
        expect(
          output,
          stringContainsInOrder([
            '] Flutter:',
            '] Dart SDK:',
            '] Serverpod CLI:',
            '] Git:',
            '] Network:',
          ]),
          reason: result.stderr as String,
        );
      },
    );
  });
}
