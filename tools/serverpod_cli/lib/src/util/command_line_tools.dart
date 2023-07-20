import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/logger/logger.dart';

import 'windows.dart';

class CommandLineTools {
  static void dartPubGet(Directory dir) {
    log.info(
      'Running `dart pub get` in ${dir.path}',
      newParagraph: true,
      style: const TextLog(),
    );
    var cf = _CommandFormatter('dart', ['pub', 'get']);
    var result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );

    log.debug(result.stdout, style: const RawLog());

    if (result.exitCode != 0) {
      log.error(result.stderr, style: const RawLog());
    }
  }

  static void flutterCreate(Directory dir) {
    log.info('Running `flutter create .` in ${dir.path}');
    var cf = _CommandFormatter('flutter', ['create', '.']);
    var result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );

    log.debug(result.stdout, style: const RawLog());

    if (result.exitCode != 0) {
      log.error(result.stderr, style: const RawLog());
    }
  }

  static Future<bool> existsCommand(String command) async {
    if (Platform.isWindows) {
      var commandPath = WindowsUtil.commandPath(command);
      return commandPath != null;
    } else {
      var result = await Process.run('which', [command]);
      return result.exitCode == 0;
    }
  }

  static Future<bool> isDockerRunning() async {
    var result = await Process.run('docker', ['info']);
    return result.exitCode == 0;
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
      result = await Process.run(
        'chmod',
        ['u+x', 'setup-tables'],
        workingDirectory: serverPath,
      );
      log.debug(
        result.stdout,
        newParagraph: true,
        style: const RawLog(),
      );

      if (result.exitCode != 0) {
        log.error(result.stderr, style: const RawLog());
      }
    }

    var process = await Process.start(
      /// Windows has an issue with running batch file directly without the
      /// complete path.
      /// Related ticket: https://github.com/dart-lang/sdk/issues/31291
      Platform.isWindows
          ? p.join(serverPath, 'setup-tables.cmd')
          : './setup-tables',
      [],
      workingDirectory: serverPath,
    );

    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));

    var exitCode = await process.exitCode;
    log.info('Completed table setup exit code: $exitCode');

    log.info('Cleaning up');
    result = await Process.run(
      'rm',
      ['setup-tables'],
      workingDirectory: serverPath,
    );
    log.debug(
      result.stdout,
      newParagraph: true,
      style: const RawLog(),
    );

    if (result.exitCode != 0) {
      log.error(result.stderr, style: const RawLog());
    }

    result = await Process.run(
      'rm',
      ['setup-tables.cmd'],
      workingDirectory: serverPath,
    );
    log.debug(
      result.stdout,
      newParagraph: true,
      style: const RawLog(),
    );

    if (result.exitCode != 0) {
      log.error(result.stderr, style: const RawLog());
    }
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
