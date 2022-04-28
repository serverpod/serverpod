import 'dart:async';
import 'dart:io';

import 'print.dart';
import 'windows.dart';

class CommandLineTools {
  static void dartPubGet(Directory dir) {
    print('Running `dart pub get` in ${dir.path}');
    _CommandFormatter cf = _CommandFormatter('dart', <String>['pub', 'get']);
    ProcessResult result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );
    print(result.stdout);
  }

  static void flutterCreate(Directory dir) {
    print('Running `flutter create .` in ${dir.path}');
    _CommandFormatter cf = _CommandFormatter('flutter', <String>['create', '.']);
    ProcessResult result = Process.runSync(
      cf.command,
      cf.args,
      workingDirectory: dir.path,
    );
    print(result.stdout);
  }

  static Future<bool> existsCommand(String command) async {
    if (Platform.isWindows) {
      String? commandPath = WindowsUtil.commandPath(command);
      return commandPath != null;
    } else {
      ProcessResult result = await Process.run('which', <String>[command]);
      return result.exitCode == 0;
    }
  }

  static Future<bool> isDockerRunning() async {
    ProcessResult result = await Process.run('docker', <String>['info']);
    return result.exitCode == 0;
  }

  static Future<void> createTables(Directory dir, String name) async {
    String serverPath = '${dir.path}/${name}_server';
    printww('Setting up Docker and default database tables in $serverPath');
    printww(
        'If you run serverpod create for the first time, this can take a few minutes as Docker is downloading the images for Postgres. If you get stuck at this step, make sure that you have the latest version of Docker Desktop and that it is currently running.');

    ProcessResult result = await Process.run(
      'chmod',
      <String>['u+x', 'setup-tables'],
      workingDirectory: serverPath,
    );
    print(result.stdout);

    Process process = await Process.start(
      './setup-tables',
      <String>[],
      workingDirectory: serverPath,
    );

    unawaited(stdout.addStream(process.stdout));
    unawaited(stderr.addStream(process.stderr));

    int exitCode = await process.exitCode;
    print('Completed table setup exit code: $exitCode');

    print('Cleaning up');
    result = await Process.run(
      'rm',
      <String>['setup-tables'],
      workingDirectory: serverPath,
    );
    print(result.stdout);
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
