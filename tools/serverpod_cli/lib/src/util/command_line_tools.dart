import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/logger/logger.dart';

class CommandLineTools {
  static Future<bool> dartPubGet(Directory dir) async {
    log.debug('Running `dart pub get` in ${dir.path}', newParagraph: true);

    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'dart',
      arguments: ['pub', 'get'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `dart pub get` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> flutterCreate(Directory dir) async {
    log.debug('Running `flutter create .` in ${dir.path}', newParagraph: true);

    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'flutter',
      arguments: ['create', '.'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `flutter create .` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> existsCommand(
    String command, [
    List<String> arguments = const [],
  ]) async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: command,
      arguments: arguments,
    );
    return exitCode == 0;
  }

  static Future<bool> isDockerRunning() async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'docker',
      arguments: ['info'],
    );
    return exitCode == 0;
  }

  static Future<bool> createTables(Directory dir, String name) async {
    log.debug(
      'If you run serverpod create for the first time, this can take '
      'a few minutes as Docker is downloading the images for '
      'Postgres. If you get stuck at this step, make sure that you '
      'have the latest version of Docker Desktop and that it is '
      'currently running.',
      type: TextLogType.hint,
    );
    var serverPath = p.join(dir.path, '${name}_server');

    if (!Platform.isWindows) {
      await _runProcessWithDefaultLogger(
        executable: 'chmod',
        arguments: ['u+x', 'setup-tables'],
        workingDirectory: serverPath,
      );
    }

    var exitCode = await _runProcessWithDefaultLogger(
      executable: Platform.isWindows
          ? p.join(serverPath, 'setup-tables.cmd')
          : './setup-tables',
      workingDirectory: serverPath,
    );

    if (exitCode != 0) {
      log.error('Failed to set up tables');
    } else {
      log.debug('Completed table setup');
    }

    log.debug('Cleaning up');
    await _runProcessWithDefaultLogger(
      executable: 'rm',
      arguments: ['setup-tables'],
      workingDirectory: serverPath,
    );

    await _runProcessWithDefaultLogger(
      executable: 'rm',
      arguments: ['setup-tables.cmd'],
      workingDirectory: serverPath,
    );

    return exitCode == 0;
  }

  static Future<bool> cleanupForWindows(Directory dir, String name) async {
    var serverPath = p.join(dir.path, '${name}_server');
    log.debug('Cleaning up');
    var file = File(p.join(serverPath, 'setup-tables'));
    try {
      await file.delete();
    } catch (e) {
      log.error('Failed cleanup: $e');
      log.error(
        'file: $file',
        type: const RawLogType(),
      );
      return false;
    }

    return true;
  }

  static Future<bool> startDockerContainer(Directory dir) async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'docker',
      arguments: ['compose', 'up', '--build', '--detach'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to start Docker container.');
      return false;
    }

    return true;
  }

  static Future<bool> stopDockerContainer(Directory dir) async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'docker',
      arguments: ['compose', 'stop'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to stop Docker container.');
      return false;
    }

    return true;
  }

  static Future<bool> applyMigrations(Directory dir, LogLevel logLevel) async {
    var exitCode = await _runProcessWithDefaultLogger(
      executable: 'dart',
      arguments: [
        'bin/main.dart',
        '--apply-migrations',
        '--role',
        'maintenance',
        if (logLevel == LogLevel.debug) ...[
          '--logging',
          'verbose',
        ],
      ],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to apply default database migration.');
      return false;
    }

    return true;
  }
}

Future<int> _runProcessWithDefaultLogger({
  required String executable,
  String? workingDirectory,
  List<String>? arguments,
}) async {
  var process = await Process.start(
    executable,
    arguments ?? [],
    workingDirectory: workingDirectory,
    runInShell: true,
  );

  process.stderr
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, type: const RawLogType()));
  process.stdout
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, type: const RawLogType()));

  return await process.exitCode;
}
