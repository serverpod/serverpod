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
}
