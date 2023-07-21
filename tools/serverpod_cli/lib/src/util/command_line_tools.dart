import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/logger/logger.dart';

import 'windows.dart';

class CommandLineTools {
  static Future<void> dartPubGet(Directory dir) async {
    log.info(
      'Running `dart pub get` in ${dir.path}',
      newParagraph: true,
      style: const TextLog(),
    );

    var cf = _CommandFormatter('dart', ['pub', 'get']);
    var exitCode = await _runProcessWithLoggerAttached(
      executable: cf.command,
      arguments: cf.args,
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `dart pub get` in ${dir.path}');
    }
  }

  static Future<void> flutterCreate(Directory dir) async {
    log.info('Running `flutter create .` in ${dir.path}');

    var cf = _CommandFormatter('flutter', ['create', '.']);
    var exitCode = await _runProcessWithLoggerAttached(
      executable: cf.command,
      arguments: cf.args,
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `flutter create .` in ${dir.path}');
    }
  }

  static Future<bool> existsCommand(String command) async {
    if (Platform.isWindows) {
      var commandPath = WindowsUtil.commandPath(command);
      return commandPath != null;
    } else {
      var exitCode = await _runProcessWithLoggerAttached(
        executable: 'which',
        arguments: [command],
      );
      return exitCode == 0;
    }
  }

  static Future<bool> isDockerRunning() async {
    var exitCode = await _runProcessWithLoggerAttached(
      executable: 'docker',
      arguments: ['info'],
    );
    return exitCode == 0;
  }

  static Future<void> createTables(Directory dir, String name) async {
    var serverPath = p.join(dir.path, '${name}_server');
    log.info('Setting up Docker and default database tables in $serverPath');
    log.info(
      'If you run serverpod create for the first time, this can take '
      'a few minutes as Docker is downloading the images for '
      'Postgres. If you get stuck at this step, make sure that you '
      'have the latest version of Docker Desktop and that it is '
      'currently running.',
      style: const TextLog(type: TextLogType.hint),
    );
    late ProcessResult result;
    if (!Platform.isWindows) {
      await _runProcessWithLoggerAttached(
        executable: 'chmod',
        arguments: ['u+x', 'setup-tables'],
        workingDirectory: serverPath,
      );
    }

    var exitCode = await _runProcessWithLoggerAttached(
      executable: Platform.isWindows
          ? p.join(serverPath, 'setup-tables.cmd')
          : './setup-tables',
      workingDirectory: serverPath,
    );

    if (exitCode != 0) {
      log.error('Failed to set up tables');
    } else {
      log.info('Completed table setup');
    }

    log.info('Cleaning up');
    await _runProcessWithLoggerAttached(
      executable: 'rm',
      arguments: ['setup-tables'],
      workingDirectory: serverPath,
    );

    await _runProcessWithLoggerAttached(
      executable: 'rm',
      arguments: ['setup-tables.cmd'],
      workingDirectory: serverPath,
    );
  }

  static Future<void> cleanupForWindows(Directory dir, String name) async {
    var serverPath = p.join(dir.path, '${name}_server');
    log.info('Cleaning up');
    var file = File(p.join(serverPath, 'setup-tables'));
    try {
      await file.delete();
    } catch (e) {
      log.error('Failed cleanup: $e');
      log.error(
        'file: $file',
        style: const RawLog(),
      );
    }
  }
}

class _CommandFormatter {
  late final String command;
  late final List<String> args;

  _CommandFormatter(String command, this.args) {
    this.command = Platform.isWindows ? '$command.bat' : command;
  }

  @override
  String toString() {
    return 'CMD: $command ${args.join(' ')}';
  }
}

Future<int> _runProcessWithLoggerAttached({
  required String executable,
  String? workingDirectory,
  List<String>? arguments,
}) async {
  var process = await Process.start(
    executable,
    arguments ?? [],
    workingDirectory: workingDirectory,
  );

  process.stderr
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, style: const RawLog()));
  process.stdout
      .transform(utf8.decoder)
      .listen((data) => log.debug(data, style: const RawLog()));

  return await process.exitCode;
}
