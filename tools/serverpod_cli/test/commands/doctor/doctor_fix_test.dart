import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_fix.dart';
import 'package:serverpod_cli/src/util/sdk_resolver.dart'
    show flutterExecutableIn;
import 'package:test/test.dart';

final _home = p.join(p.separator, 'home', 'dev');
final _managedBin = p.join(_home, '.local', 'state', 'Dart', 'install', 'bin');
final _managedExecutable = p.join(_managedBin, 'serverpod');

CliInstallation _installation({required final bool onPath}) => CliInstallation(
  kind: CliInstallationKind.managed,
  runningExecutable: _managedExecutable,
  managedExecutable: _managedExecutable,
  executableOnPath: onPath ? _managedExecutable : null,
  pathResolvesToManaged: onPath,
);

Directory _createTempDirectory() {
  final directory = Directory.systemTemp.createTempSync('serverpod_fix');
  addTearDown(() => directory.deleteSync(recursive: true));
  return directory;
}

/// A `~/.serverpod` directory, holding a Flutter SDK the installer put there
/// when [withFlutter].
String _createServerpodDirectory({required final bool withFlutter}) {
  final directory = _createTempDirectory().path;
  if (withFlutter) {
    File(flutterExecutableIn(managedFlutterRootIn(directory)))
      ..createSync(recursive: true)
      ..writeAsStringSync('');
  }
  return directory;
}

void main() {
  test(
    'Given a Flutter the installer put under ~/.serverpod and a managed CLI, '
    'when choosing PATH entries, then both bin directories are added, '
    'Flutter first',
    () {
      final serverpodDirectory = _createServerpodDirectory(withFlutter: true);

      final entries = pathEntriesToAdd(
        installation: _installation(onPath: false),
        managedExecutableExists: true,
        serverpodDirectory: serverpodDirectory,
      );

      expect(entries, [
        p.join(managedFlutterRootIn(serverpodDirectory), 'bin'),
        _managedBin,
      ]);
    },
  );

  test(
    'Given no Flutter under ~/.serverpod, '
    'when choosing PATH entries, then only the managed CLI is added',
    () {
      final entries = pathEntriesToAdd(
        installation: _installation(onPath: false),
        managedExecutableExists: true,
        serverpodDirectory: _createServerpodDirectory(withFlutter: false),
      );

      expect(entries, [_managedBin]);
    },
  );

  test(
    'Given a managed CLI that PATH already selects, '
    'when choosing PATH entries, then its bin directory is still added so a '
    'rerun from a shell that sourced the env file produces the same file',
    () {
      final entries = pathEntriesToAdd(
        installation: _installation(onPath: true),
        managedExecutableExists: true,
        serverpodDirectory: _createServerpodDirectory(withFlutter: false),
      );

      expect(entries, [_managedBin]);
    },
  );

  test(
    'Given no managed CLI installed yet, '
    'when choosing PATH entries, then its bin directory is not added',
    () {
      final entries = pathEntriesToAdd(
        installation: _installation(onPath: false),
        managedExecutableExists: false,
        serverpodDirectory: _createServerpodDirectory(withFlutter: false),
      );

      expect(entries, isEmpty);
    },
  );

  test('Given zsh as the login shell, when picking the startup file, '
      'then it is .zshrc', () {
    expect(
      startupFileFor(shell: '/bin/zsh', home: _home)?.path,
      p.join(_home, '.zshrc'),
    );
  });

  test('Given bash as the login shell, when picking the startup file, '
      'then it is .bashrc', () {
    expect(
      startupFileFor(shell: '/usr/bin/bash', home: _home)?.path,
      p.join(_home, '.bashrc'),
    );
  });

  test('Given fish as the login shell, when picking the startup file, '
      'then there is none', () {
    expect(startupFileFor(shell: '/usr/bin/fish', home: _home), isNull);
  });

  test('Given no login shell, when picking the startup file, '
      'then there is none', () {
    expect(startupFileFor(shell: null, home: _home), isNull);
  });

  group('Given two PATH entries, when writing the env file,', () {
    late String content;

    setUp(() {
      final envFile = File(p.join(_createTempDirectory().path, 'env.sh'));
      writeEnvFile(envFile, ['/a/bin', '/b c/bin']);
      content = envFile.readAsStringSync();
    });

    test('then each entry is guarded against being on PATH already', () {
      expect(content, contains('*:"/a/bin":*) ;;'));
      expect(content, contains('*:"/b c/bin":*) ;;'));
    });

    test('then each entry is exported first on PATH', () {
      expect(content, contains('export PATH="/a/bin":"\${PATH}"'));
      expect(content, contains('export PATH="/b c/bin":"\${PATH}"'));
    });
  });

  test(
    'Given entries not yet on PATH, when building the PATH a sourced shell '
    'has, then each is prepended in turn, as sourcing the env file does',
    () {
      expect(
        pathWith(['/a/bin', '/b/bin'], '/usr/bin:/bin'),
        '/b/bin:/a/bin:/usr/bin:/bin',
      );
    },
  );

  test(
    'Given an entry already on PATH behind another directory, when building '
    'the PATH a sourced shell has, then it stays where it is',
    () {
      expect(
        pathWith(['/a/bin'], '/usr/bin:/a/bin:/bin'),
        '/usr/bin:/a/bin:/bin',
      );
    },
  );

  test(
    'Given an empty PATH, when building the PATH a sourced shell has, '
    'then it is the entries alone',
    () {
      expect(pathWith(['/a/bin'], ''), '/a/bin');
    },
  );

  test(
    'Given an env file with two entries, when writing it again with one, '
    'then the dropped entry is gone',
    () {
      final envFile = File(p.join(_createTempDirectory().path, 'env.sh'));
      writeEnvFile(envFile, ['/a/bin', '/b c/bin']);

      writeEnvFile(envFile, ['/a/bin']);

      expect(envFile.readAsStringSync(), isNot(contains('/b c/bin')));
    },
  );

  test(
    'Given an env file under the home directory, '
    'when building its source line, then it is relative to \$HOME',
    () {
      final line = sourceLineFor(
        File(p.join(_home, '.serverpod', 'env.sh')),
        home: _home,
      );

      expect(line, '. "\$HOME/${p.join('.serverpod', 'env.sh')}"');
    },
  );

  group('Given a startup file that does not source the env file,', () {
    late String home;
    late File startupFile;
    late File envFile;

    setUp(() {
      home = _createTempDirectory().path;
      startupFile = File(p.join(home, '.zshrc'))
        ..writeAsStringSync('export EDITOR=vim\n');
      envFile = File(p.join(home, '.serverpod', 'env.sh'));
    });

    test('when checking whether it sources the env file, then it does not', () {
      expect(startupFileSources(startupFile, envFile, home: home), isFalse);
    });

    group('when sourcing the env file twice,', () {
      late bool changedFirst;
      late bool changedSecond;
      late String content;

      setUp(() {
        changedFirst = ensureSourced(startupFile, envFile, home: home);
        changedSecond = ensureSourced(startupFile, envFile, home: home);
        content = startupFile.readAsStringSync();
      });

      test('then only the first time changes the file', () {
        expect(changedFirst, isTrue);
        expect(changedSecond, isFalse);
      });

      test('then the file sources the env file', () {
        expect(startupFileSources(startupFile, envFile, home: home), isTrue);
      });

      test('then the existing content is kept', () {
        expect(content, startsWith('export EDITOR=vim\n'));
      });

      test('then the marker and the source line appear once', () {
        expect(envFileMarker.allMatches(content), hasLength(1));
        expect(
          sourceLineFor(envFile, home: home).allMatches(content),
          hasLength(1),
        );
      });
    });
  });
}
