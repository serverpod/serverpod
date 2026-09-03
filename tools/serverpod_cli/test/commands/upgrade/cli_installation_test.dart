import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:test/test.dart';

/// The name `dart install` gives the Serverpod executable on this platform.
final _executableName = Platform.isWindows ? 'serverpod.bat' : 'serverpod';

final _installRoot = p.join(p.separator, 'data-home', 'install');

final _managedExecutable = p.join(_installRoot, 'bin', 'serverpod');

final _globalPackagesRoot = p.join(
  p.separator,
  'pub-cache',
  'global_packages',
);

final _sourceScript = p.join(
  p.separator,
  'checkout',
  'bin',
  'serverpod_cli.dart',
);

String _pathVariable(final List<String> directories) =>
    directories.join(Platform.isWindows ? ';' : ':');

Directory _createTempDirectory() {
  final directory = Directory.systemTemp.createTempSync('serverpod_upgrade');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

String _createExecutable(final Directory directory) {
  final path = p.join(directory.path, _executableName);
  File(path).writeAsStringSync('');
  return path;
}

/// Resolves a path the way [CliInstallation.resolve] does before classifying.
String _canonicalize(final String path) {
  try {
    return File(path).resolveSymbolicLinksSync();
  } catch (_) {
    return p.canonicalize(path);
  }
}

/// Builds the tree `dart install` leaves behind, and returns the bundle
/// executable it installed.
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
  group('Given several directories on PATH containing the executable,', () {
    test(
      'when looking up the executable, '
      'then the one in the first matching directory is returned',
      () {
        final first = _createTempDirectory();
        final second = _createTempDirectory();
        final expected = _createExecutable(first);
        _createExecutable(second);

        final found = findExecutableOnPath(
          'serverpod',
          environment: {
            'PATH': _pathVariable(['', first.path, second.path]),
          },
        );

        expect(found, expected);
      },
    );
  });

  group('Given no directory on PATH contains the executable,', () {
    test('when looking up the executable, then null is returned', () {
      final directory = _createTempDirectory();

      final found = findExecutableOnPath(
        'serverpod',
        environment: {
          'PATH': _pathVariable([directory.path]),
        },
      );

      expect(found, isNull);
    });

    test('when PATH is not set, then null is returned', () {
      expect(findExecutableOnPath('serverpod', environment: {}), isNull);
    });
  });

  group('Given the running executable is the one an upgrade replaces,', () {
    test('when classifying the installation, then it is managed', () {
      expect(
        classifyInstallation(
          runningExecutable: _managedExecutable,
          runningScript: '',
          installRoot: _installRoot,
          globalPackagesRoot: _globalPackagesRoot,
        ),
        CliInstallationKind.managed,
      );
    });
  });

  group('Given the running executable is another serverpod executable,', () {
    test('when classifying the installation, then it is foreign', () {
      expect(
        classifyInstallation(
          runningExecutable: p.join(
            p.separator,
            'pub-cache',
            'bin',
            'serverpod',
          ),
          runningScript: '',
          installRoot: _installRoot,
          globalPackagesRoot: _globalPackagesRoot,
        ),
        CliInstallationKind.foreign,
      );
    });
  });

  group('Given the CLI runs through the Dart VM,', () {
    test('when classifying the installation, then it is a source checkout', () {
      expect(
        classifyInstallation(
          runningExecutable: p.join(p.separator, 'dart-sdk', 'bin', 'dart'),
          runningScript: _sourceScript,
          installRoot: _installRoot,
          globalPackagesRoot: _globalPackagesRoot,
        ),
        CliInstallationKind.source,
      );
    });
  });

  group('Given a pub global binstub started the Dart VM,', () {
    test('when naming the executable that ran, then the binstub is named', () {
      final binstub = p.join(p.separator, 'pub-cache', 'bin', 'serverpod');

      final installation = CliInstallation(
        kind: CliInstallationKind.foreign,
        runningExecutable: p.join(p.separator, 'dart-sdk', 'bin', 'dart'),
        managedExecutable: _managedExecutable,
        executableOnPath: binstub,
        pathResolvesToManaged: false,
      );

      expect(installation.invokedExecutable, binstub);
    });
  });

  group('Given a serverpod executable dart install does not manage,', () {
    test('when naming the executable that ran, then it is named', () {
      final stray = p.join(p.separator, 'usr', 'local', 'bin', 'serverpod');

      final installation = CliInstallation(
        kind: CliInstallationKind.foreign,
        runningExecutable: stray,
        managedExecutable: _managedExecutable,
        executableOnPath: _managedExecutable,
        pathResolvesToManaged: true,
      );

      expect(installation.invokedExecutable, stray);
    });
  });

  group('Given a binstub and the binary it wraps,', () {
    test(
      'when comparing the executables, then the platform extension is ignored',
      () {
        expect(
          isSameExecutable(
            p.join(p.separator, 'install', 'bin', 'serverpod.bat'),
            p.join(p.separator, 'install', 'bin', 'serverpod'),
          ),
          isTrue,
        );
      },
    );

    test(
      'when the executables are in different directories, '
      'then they do not match',
      () {
        expect(
          isSameExecutable(
            p.join(p.separator, 'install', 'bin', 'serverpod'),
            p.join(p.separator, 'pub-cache', 'bin', 'serverpod'),
          ),
          isFalse,
        );
      },
    );
  });

  group('Given an executable dart install put on PATH,', () {
    late String bundleExecutable;
    late Directory binDirectory;
    late String installRoot;

    setUp(() {
      final root = _createTempDirectory();
      bundleExecutable = _createAppBundle(root);
      installRoot = _canonicalize(p.join(root.path, 'install'));
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
            runningExecutable: _canonicalize(bundleExecutable),
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
            runningExecutable: _canonicalize(bundleExecutable),
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
        final root = _createTempDirectory();

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
            runningExecutable: _canonicalize(dartExecutable),
            runningScript: _canonicalize(snapshot),
            installRoot: _canonicalize(p.join(root.path, 'install')),
            globalPackagesRoot: _canonicalize(globalPackages.path),
          ),
          isNot(CliInstallationKind.source),
          reason:
              'These users need the deactivate hint, which only the '
              'foreign branch prints.',
        );
      },
    );
  });
}
