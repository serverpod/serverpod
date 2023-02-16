import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'print.dart';
import 'windows.dart';

class CommandLineTools {
  static void dartPubGet(Directory dir) {
    print('Running `dart pub get` in ${dir.path}');
    var cf = _CommandFormatter('dart', ['pub', 'get']);
    var result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );
    print(result.stdout);
  }

  static void flutterCreate(Directory dir) {
    print('Running `flutter create .` in ${dir.path}');
    var cf = _CommandFormatter('flutter', ['create', '.']);
    var result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );
    print(result.stdout);
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
    var tablesFileName = Platform.isWindows ? 'setup-tables.cmd' : 'setup-tables';
    printww('Setting up Docker and default database tables in $serverPath');
    printww(
        'If you run serverpod create for the first time, this can take a few minutes as Docker is downloading the images for Postgres. If you get stuck at this step, make sure that you have the latest version of Docker Desktop and that it is currently running.');
    late ProcessResult result;
    if (!Platform.isWindows) {
      result = await Process.run(
        'chmod',
        ['u+x', tablesFileName],
        workingDirectory: serverPath,
      );
      print(result.stdout);
    }

    var process = await Process.start(
      /// Windows has an issue with running batch file directly without the complete path.
      /// Related ticket: https://github.com/dart-lang/sdk/issues/31291
      Platform.isWindows
          ? p.join(serverPath, tablesFileName)
          : './$tablesFileName',
      [],
      workingDirectory: serverPath,
    );

    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));

    var exitCode = await process.exitCode;
    print('Completed table setup exit code: $exitCode');
    await cleanup(serverPath, name, tablesFileName);
  }

  static Future<void> cleanup(String dirPath, String name, String fileName) async {
    var serverPath = p.join(dirPath, '${name}_server');
    print('Cleaning up');
    var file = File(p.join(serverPath, fileName));
    try {
      await file.delete();
    } catch (e) {
      print('Failed cleanup: $e');
      print('file: $file');
      return;
    }
    print('Clean up done');
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
