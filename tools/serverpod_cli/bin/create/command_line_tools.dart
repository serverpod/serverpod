import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import '../util/print.dart';

class CommandLineTools {
  static Future<void> dartPubGet(Directory dir) async {
    print('Running `dart pub get` in ${dir.path}');
    var result =
        await Process.run('dart', ['pub', 'get'], workingDirectory: dir.path);
    print(result.stdout);
  }

  static Future<void> flutterCreate(Directory dir) async {
    print('Running `flutter create` in ${dir.path}');
    try {
      /// For some reason flutter is not recognized by the Process.
      /// So we need to fetch the flutter path dynamically and use it to run flutter in windows.
      var _flutterPath = await Process.run('which', ['flutter']);
      var flutterPath = _flutterPath.stdout.toString().trim();
      var flutterPathList = flutterPath.split('/');
      if (Platform.isWindows) {
        flutterPathList.removeWhere((element) => element.isEmpty);
        flutterPathList.first = flutterPathList.first.toUpperCase() + ':';
        flutterPathList.last = flutterPathList.last + '.bat';
      }
      flutterPath =
          Platform.isWindows ? p.joinAll(flutterPathList) : flutterPath;
      var result = await Process.run(flutterPath, ['create', dir.path]);
      print(result.stdout);
    } on ProcessException catch (e) {
      stderr.write(e.message);
      return;
    }
  }

  static Future<bool> existsCommand(String command) async {
    var result = await Process.run('which', [command]);
    return result.exitCode == 0;
  }

  static Future<bool> isDockerRunning() async {
    var result = await Process.run('docker', ['info']);
    return result.exitCode == 0;
  }

  static Future<void> createTables(Directory dir, String name) async {
    var serverPath = p.join(dir.path, name + '_server');
    printww('Setting up Docker and default database tables in $serverPath');
    printww(
        'If you run serverpod create for the first time, this can take a few minutes as Docker is downloading the images for Postgres. If you get stuck at this step, make sure that you have the latest version of Docker Desktop and that it is currently running.');

    if (!Platform.isWindows) {
      var result = await Process.run(
        'chmod',
        ['u+x', 'setup-tables'],
        workingDirectory: serverPath,
      );
      print(result.stdout);

      var process = await Process.start(
        './setup-tables',
        [],
        workingDirectory: serverPath,
      );

      unawaited(stdout.addStream(process.stdout));
      unawaited(stderr.addStream(process.stderr));

      var exitCode = await process.exitCode;
      print('Completed table setup exit code: $exitCode');

      print('Cleaning up');
      result = await Process.run(
        'rm',
        ['setup-tables'],
        workingDirectory: serverPath,
      );
      print(result.stdout);
    }
  }
}
