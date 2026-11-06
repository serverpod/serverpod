@Timeout(Duration(minutes: 5))
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli_e2e_test/src/run_serverpod.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;

/// The parent environment with PATH replaced by [path], so the CLI finds no
/// tools at all. The key is matched case-insensitively for Windows.
Map<String, String> _environmentWithPath(String path) => {
  for (final entry in Platform.environment.entries)
    if (entry.key.toUpperCase() != 'PATH') entry.key: entry.value,
  'PATH': path,
  'SERVERPOD_HOME': serverpodHome,
};

/// A fresh home with a fake Flutter under `~/.serverpod` that reports its own
/// root, and a managed CLI as `dart install` leaves it, with `.zshrc` as the
/// startup file.
class _ManagedHome {
  final Directory _home;
  final String flutterRoot;
  final String dartDataHome;

  /// An empty directory, so PATH can hold something other than Flutter.
  final String emptyBin;

  _ManagedHome._(
    this._home, {
    required this.flutterRoot,
    required this.dartDataHome,
    required this.emptyBin,
  });

  String get flutterBin => p.join(flutterRoot, 'bin');
  File get envFile => File(p.join(_home.path, '.serverpod', 'env.sh'));
  File get zshrc => File(p.join(_home.path, '.zshrc'));
  File get zprofile => File(p.join(_home.path, '.zprofile'));

  static Future<_ManagedHome> create() async {
    final home = Directory.systemTemp.createTempSync('serverpod_doctor_home');
    File(p.join(home.path, '.zshrc')).writeAsStringSync('export EDITOR=vim\n');

    final flutterRoot = p.join(home.path, '.serverpod', 'flutter');
    final machineJson = jsonEncode({
      'frameworkVersion': '3.47.7',
      'channel': 'stable',
      'flutterRoot': flutterRoot,
    });
    // printf is a shell builtin: the CLI's PATH in these tests has no /usr/bin.
    final flutter = File(p.join(flutterRoot, 'bin', 'flutter'))
      ..createSync(recursive: true)
      ..writeAsStringSync("#!/bin/sh\nprintf '%s\\n' '$machineJson'\n");
    await Process.run('chmod', ['755', flutter.path]);

    final dartDataHome = p.join(home.path, 'dart-data');
    File(p.join(dartDataHome, 'install', 'bin', 'serverpod'))
      ..createSync(recursive: true)
      ..writeAsStringSync('');

    final emptyBin = Directory(p.join(home.path, 'empty-bin'))..createSync();

    return _ManagedHome._(
      home,
      flutterRoot: flutterRoot,
      dartDataHome: dartDataHome,
      emptyBin: emptyBin.path,
    );
  }

  /// Runs `doctor --fix --yes` as a zsh user whose PATH holds [path] only.
  Future<ProcessResult> fix({required List<String> path}) async => Process.run(
    await compiledServerpodCliExe,
    ['doctor', '--fix', '--yes', '--no-analytics'],
    workingDirectory: _home.path,
    environment: {
      for (final entry in Platform.environment.entries)
        if (!const {
          'HOME',
          'USERPROFILE',
          'PATH',
          'SHELL',
          'DART_DATA_HOME',
        }.contains(entry.key.toUpperCase()))
          entry.key: entry.value,
      'HOME': _home.path,
      'USERPROFILE': _home.path,
      'PATH': path.join(':'),
      'SHELL': '/bin/zsh',
      'DART_DATA_HOME': dartDataHome,
      'SERVERPOD_HOME': serverpodHome,
    },
    includeParentEnvironment: false,
  );

  void delete() => _home.deleteSync(recursive: true);
}

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
      late _ManagedHome home;
      late ProcessResult first;
      late ProcessResult second;

      setUpAll(() async {
        home = await _ManagedHome.create();
        first = await home.fix(path: [home.flutterBin, home.emptyBin]);
        second = await home.fix(path: [home.flutterBin, home.emptyBin]);
      });

      tearDownAll(() => home.delete());

      test('then the env file puts the managed Flutter on PATH', () {
        expect(
          home.envFile.existsSync(),
          isTrue,
          reason: '${first.stdout}${first.stderr}',
        );
        expect(home.envFile.readAsStringSync(), contains(home.flutterRoot));
      });

      test('then the env file puts the managed CLI on PATH', () {
        expect(
          home.envFile.readAsStringSync(),
          contains(p.join(home.dartDataHome, 'install')),
        );
      });

      test('then .zshrc keeps its content and sources the env file once', () {
        final rc = home.zshrc.readAsStringSync();
        expect(rc, startsWith('export EDITOR=vim\n'));
        expect('. "\$HOME/.serverpod/env.sh"'.allMatches(rc), hasLength(1));
      });

      test('then .zprofile is created and sources the env file once, so '
          'login shells get the PATH too', () {
        expect(home.zprofile.existsSync(), isTrue);
        expect(
          '. "\$HOME/.serverpod/env.sh"'.allMatches(
            home.zprofile.readAsStringSync(),
          ),
          hasLength(1),
        );
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

  group(
    'Given a home where doctor --fix already wrote the env file, '
    'when running doctor --fix --yes again from a shell whose PATH has no '
    'Flutter,',
    () {
      late _ManagedHome home;
      late String envBefore;
      late ProcessResult rerun;

      setUpAll(() async {
        home = await _ManagedHome.create();
        await home.fix(path: [home.flutterBin, home.emptyBin]);
        envBefore = home.envFile.readAsStringSync();
        rerun = await home.fix(path: [home.emptyBin]);
      });

      tearDownAll(() => home.delete());

      test('then the env file still puts the managed Flutter on PATH', () {
        expect(envBefore, contains(home.flutterRoot));
        expect(
          home.envFile.readAsStringSync(),
          envBefore,
          reason: '${rerun.stdout}${rerun.stderr}',
        );
      });

      test('then doctor reports nothing to change', () {
        expect(rerun.stdout, contains('Nothing for --fix to change.'));
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
