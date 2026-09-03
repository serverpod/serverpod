import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/commands/upgrade/upgrade_target.dart';
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
            installRoot: installRoot,
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
            installRoot: installRoot,
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

        expect(
          classifyInstallation(
            runningExecutable: canonicalize(dartExecutable),
            installRoot: canonicalize(p.join(root.path, 'install')),
          ),
          isNot(CliInstallationKind.source),
          reason:
              'These users need the deactivate hint, which only the '
              'foreign branch prints.',
        );
      },
    );
  });

  group('Given a stable installation and an open ended version range,', () {
    test(
      'when resolving the target on the stable channel, '
      'then no prerelease is selected',
      () {
        final stable = Version.parse('3.4.11');
        final newerStable = Version.parse('3.4.12');
        final releaseCandidate = Version.parse('4.0.0-rc.1');

        // Unlike ^3.4.0, this range has no upper bound to exclude against.
        expect(
          VersionConstraint.parse('>=3.4.0').allows(releaseCandidate),
          isTrue,
        );

        final target = resolveUpgradeTarget(
          current: stable,
          published: [stable, newerStable, releaseCandidate],
          channel: UpgradeChannel.stable,
          requested: VersionConstraint.parse('>=3.4.0'),
        )!;

        expect(target.version, newerStable);
      },
    );
  });

  group('Given a version constraint the upgrade command accepts,', () {
    for (final constraint in const [
      '4.0.0',
      '^4.0.0',
      '4.0.0-beta.4',
      'any',
      '>=4.0.0 <5.0.0',
      '>=4.0.0',
      '>4.0.0',
    ]) {
      test(
        'when "$constraint" reaches dart install, then it can be parsed',
        () {
          expect(() => VersionConstraint.parse(constraint), returnsNormally);

          expect(() => loadYaml(constraint), returnsNormally);
        },
      );
    }
  });

  group('Given a prerelease installation and a newer stable release,', () {
    test(
      'when the prompt names a version, '
      'then upgrading installs the version it named',
      () {
        final current = Version.parse('4.0.0-rc.1');
        final published = [
          Version.parse('3.4.12'),
          Version.parse('4.0.0'),
          Version.parse('4.1.0-beta.1'),
        ];

        // promptToUpdateIfNeeded asks for the latest stable release.
        final prompted = published
            .where((final version) => !version.isPreRelease)
            .reduce((final a, final b) => a > b ? a : b);
        expect(current < prompted, isTrue);

        final target = resolveUpgradeTarget(
          current: current,
          published: published,
          channel: UpgradeChannel.forVersion(current),
        )!;

        expect(target.version, prompted);
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
