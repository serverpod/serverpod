import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
import 'package:serverpod_cli/src/update_prompt/prompt_to_update.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

/// Mirrors the private `_canonicalize` in `cli_installation.dart`.
String canonicalize(final String path) {
  try {
    return File(path).resolveSymbolicLinksSync();
  } catch (_) {
    return p.canonicalize(path);
  }
}

Directory _tempDirectory() {
  final directory = Directory.systemTemp.createTempSync('upgrade_probe');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

/// Builds the tree `dart install` leaves behind
String _createAppBundle(final Directory root) {
  final bundleBin = Directory(
    p.join(
      root.path,
      'install',
      'app-bundles',
      'serverpod_cli',
      'hosted',
      '4.0.0-rc.1',
      'bundle',
      'bin',
    ),
  )..createSync(recursive: true);

  final executable = p.join(bundleBin.path, 'serverpod');
  File(executable).writeAsStringSync('');
  return executable;
}

void main() {
  group('Given an executable dart install put on PATH,', () {
    late String bundleExecutable;
    late Directory binDirectory;
    late String installRoot;

    setUp(() {
      final root = _tempDirectory();
      bundleExecutable = _createAppBundle(root);
      installRoot = canonicalize(p.join(root.path, 'install'));
      binDirectory = Directory(p.join(root.path, 'install', 'bin'))
        ..createSync(recursive: true);
    });

    test(
      'when the bin entry is a symlink, as on macOS and Linux, '
      'then an upgrade replaces the running executable',
      () {
        final managed = p.join(binDirectory.path, 'serverpod');
        Link(managed).createSync(bundleExecutable);

        expect(
          classifyInstallation(
            runningExecutable: canonicalize(bundleExecutable),
            runningScript: '',
            installRoot: installRoot,
            globalPackagesRoot: null,
          ),
          CliInstallationKind.managed,
        );
      },
    );

    test(
      'when the bin entry is a .bat wrapper, as on Windows, '
      'then an upgrade replaces the running executable',
      () {
        // emulate pkg/dartdev/lib/src/install/file_system.dart (not symlink)
        final managed = p.join(binDirectory.path, 'serverpod.bat');
        File(managed).writeAsStringSync(
          '@ECHO OFF\n'
          'REM target_file_path_marker\n'
          '"$bundleExecutable" %*\n'
          'EXIT /B %ERRORLEVEL%\n',
        );

        expect(
          classifyInstallation(
            runningExecutable: canonicalize(bundleExecutable),
            runningScript: '',
            installRoot: installRoot,
            globalPackagesRoot: null,
          ),
          CliInstallationKind.managed,
        );
      },
    );
  });

  group('Given the CLI was started by a pub global binstub,', () {
    test(
      'when classifying the installation, '
      'then it is not reported as a source checkout',
      () {
        final root = _tempDirectory();

        final sdkBin = Directory(p.join(root.path, 'dart-sdk', 'bin'))
          ..createSync(recursive: true);
        final dartExecutable = p.join(sdkBin.path, 'dart');
        File(dartExecutable).writeAsStringSync('');

        final pubCacheBin = Directory(p.join(root.path, '.pub-cache', 'bin'))
          ..createSync(recursive: true);
        File(p.join(pubCacheBin.path, 'serverpod')).writeAsStringSync(
          '#!/usr/bin/env sh\n'
          'dart pub global run serverpod_cli:serverpod_cli "\$@"\n',
        );

        final globalPackages = Directory(
          p.join(root.path, '.pub-cache', 'global_packages'),
        )..createSync(recursive: true);
        final snapshotDirectory = Directory(
          p.join(globalPackages.path, 'serverpod_cli', 'bin'),
        )..createSync(recursive: true);
        final snapshot = p.join(
          snapshotDirectory.path,
          'serverpod_cli.dart-3.13.2.snapshot',
        );
        File(snapshot).writeAsStringSync('');

        expect(
          classifyInstallation(
            runningExecutable: canonicalize(dartExecutable),
            runningScript: canonicalize(snapshot),
            installRoot: canonicalize(p.join(root.path, 'install')),
            globalPackagesRoot: canonicalize(globalPackages.path),
          ),
          isNot(CliInstallationKind.source),
          reason:
              'These users need the deactivate hint, which only the '
              'foreign branch prints.',
        );
      },
    );
  });

  group('Given a value passed to --version,', () {
    late UpgradeCommand command;

    setUp(() => command = UpgradeCommand());

    Iterable<Object?> errorsFor(final String value) => command
        .resolveConfiguration(command.argParser.parse(['--version', value]))
        .errors;

    for (final value in const [
      '4.0.0',
      '4.0.0-beta.4',
      '4.0.0+1',
      '1.2.3-rc.1+build.5',
    ]) {
      test('when "$value" is given, then dart install can parse it too', () {
        expect(errorsFor(value), isEmpty);
        expect(() => loadYaml(value), returnsNormally);
      });
    }

    for (final value in const [
      '>=4.0.0 <5.0.0',
      '>=4.0.0',
      '>4.0.0',
      '^4.0.0',
      'any',
    ]) {
      test('when the constraint "$value" is given, then it is rejected', () {
        expect(errorsFor(value), isNotEmpty);
      });
    }
  });

  group('Given a prerelease installation and a newer stable release,', () {
    test(
      'when the prompt names a version, '
      'then upgrading installs the version it named',
      () {
        final current = Version.parse('4.0.0-rc.1');
        final newestStable = Version.parse('4.0.0');
        final newestPrerelease = Version.parse('4.1.0-beta.1');
        final published = [
          Version.parse('3.4.12'),
          newestStable,
          newestPrerelease,
        ];

        final prompted = latestVersionToPrompt(current, published);

        final target = resolveUpgradeTarget(
          current: current,
          published: published,
          channel: UpgradeChannel.forVersion(current),
        )!;

        expect(prompted, target.version);
        expect(prompted, newestPrerelease);
        expect(current < prompted!, isTrue);
      },
    );
  });

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
          'commands',
          'upgrade',
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
        final shimDirectory = _tempDirectory();
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
