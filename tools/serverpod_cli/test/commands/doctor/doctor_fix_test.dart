import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/upgrade/cli_installation.dart';
import 'package:serverpod_cli/src/doctor/doctor_check.dart';
import 'package:serverpod_cli/src/doctor/doctor_fix.dart';
import 'package:test/test.dart';

final _home = p.join(p.separator, 'home', 'dev');
final _serverpodDirectory = p.join(_home, '.serverpod');
final _managedFlutter = p.join(_serverpodDirectory, 'flutter');
final _userFlutter = p.join(p.separator, 'opt', 'flutter');
final _managedBin = p.join(_home, '.local', 'state', 'Dart', 'install', 'bin');
final _managedExecutable = p.join(_managedBin, 'serverpod');

DoctorCheckResult _flutter(final String root) => DoctorCheckResult(
  id: 'flutter',
  title: 'Flutter',
  status: DoctorStatus.ready,
  path: root,
  message: 'ready',
);

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

void main() {
  test(
    'Given a Flutter the installer put under ~/.serverpod and a managed CLI '
    'not on PATH, when choosing PATH entries, then both bin directories are '
    'added, Flutter first',
    () {
      final entries = pathEntriesToAdd(
        results: [_flutter(_managedFlutter)],
        installation: _installation(onPath: false),
        managedExecutableExists: true,
        serverpodDirectory: _serverpodDirectory,
      );

      expect(entries, [p.join(_managedFlutter, 'bin'), _managedBin]);
    },
  );

  test(
    'Given a Flutter the user manages elsewhere, '
    'when choosing PATH entries, then it is left alone',
    () {
      final entries = pathEntriesToAdd(
        results: [_flutter(_userFlutter)],
        installation: _installation(onPath: false),
        managedExecutableExists: true,
        serverpodDirectory: _serverpodDirectory,
      );

      expect(entries, [_managedBin]);
    },
  );

  test(
    'Given a managed CLI that PATH already selects, '
    'when choosing PATH entries, then its bin directory is not added',
    () {
      final entries = pathEntriesToAdd(
        results: [_flutter(_userFlutter)],
        installation: _installation(onPath: true),
        managedExecutableExists: true,
        serverpodDirectory: _serverpodDirectory,
      );

      expect(entries, isEmpty);
    },
  );

  test(
    'Given no managed CLI installed yet, '
    'when choosing PATH entries, then its bin directory is not added',
    () {
      final entries = pathEntriesToAdd(
        results: const [],
        installation: _installation(onPath: false),
        managedExecutableExists: false,
        serverpodDirectory: _serverpodDirectory,
      );

      expect(entries, isEmpty);
    },
  );

  test(
    'Given zsh, bash, fish, and no login shell, '
    'when picking the startup file, then only zsh and bash get one',
    () {
      expect(
        startupFileFor(shell: '/bin/zsh', home: _home)?.path,
        p.join(_home, '.zshrc'),
      );
      expect(
        startupFileFor(shell: '/usr/bin/bash', home: _home)?.path,
        p.join(_home, '.bashrc'),
      );
      expect(startupFileFor(shell: '/usr/bin/fish', home: _home), isNull);
      expect(startupFileFor(shell: null, home: _home), isNull);
    },
  );

  test(
    'Given two PATH entries, '
    'when writing the env file, then each is exported once, guarded against '
    'being on PATH already, and a rewrite replaces the content',
    () {
      final envFile = File(p.join(_createTempDirectory().path, 'env.sh'));

      writeEnvFile(envFile, ['/a/bin', '/b c/bin']);
      final first = envFile.readAsStringSync();
      writeEnvFile(envFile, ['/a/bin']);
      final second = envFile.readAsStringSync();

      expect(first, contains('*:"/a/bin":*) ;;'));
      expect(first, contains('export PATH="/a/bin":"\${PATH}"'));
      expect(first, contains('export PATH="/b c/bin":"\${PATH}"'));
      expect(second, isNot(contains('/b c/bin')));
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

  test(
    'Given a startup file, '
    'when sourcing the env file twice, then the line is appended once with '
    'its marker and existing content is kept',
    () {
      final home = _createTempDirectory();
      final startupFile = File(p.join(home.path, '.zshrc'))
        ..writeAsStringSync('export EDITOR=vim\n');
      final envFile = File(p.join(home.path, '.serverpod', 'env.sh'));

      final changedFirst = ensureSourced(startupFile, envFile, home: home.path);
      final changedSecond = ensureSourced(
        startupFile,
        envFile,
        home: home.path,
      );
      final content = startupFile.readAsStringSync();

      expect(changedFirst, isTrue);
      expect(changedSecond, isFalse);
      expect(content, startsWith('export EDITOR=vim\n'));
      expect(envFileMarker.allMatches(content), hasLength(1));
      expect(
        sourceLineFor(envFile, home: home.path).allMatches(content),
        hasLength(1),
      );
    },
  );
}
