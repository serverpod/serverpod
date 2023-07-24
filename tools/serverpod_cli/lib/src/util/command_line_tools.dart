import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/logger/logger.dart';

import 'windows.dart';

class CommandLineTools {
  static Future<bool> dartPubGet(Directory dir) async {
    log.debug('Running `dart pub get` in ${dir.path}', newParagraph: true);

    var cf = _CommandFormatter('dart', ['pub', 'get']);
    var exitCode = await _runProcessWithDefaultLogger(
      executable: cf.command,
      arguments: cf.args,
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

    var cf = _CommandFormatter('flutter', ['create', '.']);
    var exitCode = await _runProcessWithDefaultLogger(
      executable: cf.command,
      arguments: cf.args,
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      log.error('Failed to run `flutter create .` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> existsCommand(String command) async {
    if (Platform.isWindows) {
      var commandPath = WindowsUtil.commandPath(command);
      return commandPath != null;
    } else {
      var exitCode = await _runProcessWithDefaultLogger(
        executable: 'which',
        arguments: [command],
      );
      return exitCode == 0;
    }
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
        style: const RawLog(),
      );
      return false;
    }

    return true;
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

Future<int> _runProcessWithDefaultLogger({
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
