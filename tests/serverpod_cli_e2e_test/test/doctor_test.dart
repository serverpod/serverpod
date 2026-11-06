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

  group(
    'Given a fresh home with a Serverpod-managed Flutter and a managed CLI '
    'that is not on PATH, when running doctor --fix --yes twice as a zsh user,',
    () {
      late Directory home;
      late File envFile;
      late File zshrc;
      late ProcessResult first;
      late ProcessResult second;

      setUpAll(() async {
        home = Directory.systemTemp.createTempSync('serverpod_doctor_home');
        envFile = File(p.join(home.path, '.serverpod', 'env.sh'));
        zshrc = File(p.join(home.path, '.zshrc'))
          ..writeAsStringSync('export EDITOR=vim\n');

        // A fake Flutter under ~/.serverpod that reports its own root.
        final flutterRoot = p.join(home.path, '.serverpod', 'flutter');
        final flutterBin = Directory(p.join(flutterRoot, 'bin'))
          ..createSync(recursive: true);
        final machineJson = jsonEncode({
          'frameworkVersion': '3.47.7',
          'channel': 'stable',
          'flutterRoot': flutterRoot,
        });
        // printf is a shell builtin: the CLI's PATH below has no /usr/bin.
        final flutter = File(p.join(flutterBin.path, 'flutter'))
          ..writeAsStringSync("#!/bin/sh\nprintf '%s\n' '$machineJson'\n");
        await Process.run('chmod', ['755', flutter.path]);

        // A managed CLI, as `dart install` would leave it, off PATH.
        final dartDataHome = p.join(home.path, 'dart-data');
        final managedBin = Directory(p.join(dartDataHome, 'install', 'bin'))
          ..createSync(recursive: true);
        File(p.join(managedBin.path, 'serverpod')).writeAsStringSync('');

        // PATH holds only the managed Flutter and an empty directory.
        final emptyBin = Directory(p.join(home.path, 'empty-bin'))
          ..createSync();
        final environment = {
          for (final entry in Platform.environment.entries)
            if (!const {
              'HOME',
              'USERPROFILE',
              'PATH',
              'SHELL',
              'DART_DATA_HOME',
            }.contains(entry.key.toUpperCase()))
              entry.key: entry.value,
          'HOME': home.path,
          'USERPROFILE': home.path,
          'PATH': [flutterBin.path, emptyBin.path].join(':'),
          'SHELL': '/bin/zsh',
          'DART_DATA_HOME': dartDataHome,
          'SERVERPOD_HOME': serverpodHome,
        };

        Future<ProcessResult> fix() async => Process.run(
          await compiledServerpodCliExe,
          ['doctor', '--fix', '--yes', '--no-analytics'],
          workingDirectory: home.path,
          environment: environment,
          includeParentEnvironment: false,
        );
        first = await fix();
        second = await fix();
      });

      tearDownAll(() => home.deleteSync(recursive: true));

      test('then the env file puts the managed Flutter on PATH', () {
        expect(
          envFile.existsSync(),
          isTrue,
          reason: '${first.stdout}${first.stderr}',
        );
        expect(
          envFile.readAsStringSync(),
          contains(p.join(home.path, '.serverpod', 'flutter')),
        );
      });

      test('then the env file puts the managed CLI on PATH', () {
        expect(
          envFile.readAsStringSync(),
          contains(p.join(home.path, 'dart-data', 'install')),
        );
      });

      test('then .zshrc keeps its content and sources the env file once', () {
        final rc = zshrc.readAsStringSync();
        expect(rc, startsWith('export EDITOR=vim\n'));
        expect('. "\$HOME/.serverpod/env.sh"'.allMatches(rc), hasLength(1));
      });

      test('then the first run re-checks with the new PATH and finds the '
          'managed CLI', () {
        expect(first.stdout, contains('[✓] Serverpod CLI:'));
      });

      test('then the second run proposes no changes', () {
        expect(second.stdout, isNot(contains('Doctor will write')));
      });
    },
    skip: Platform.isWindows ? '--fix is not supported on Windows.' : null,
  );

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
