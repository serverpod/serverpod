import 'dart:async';
import 'dart:io';

import '../util/print.dart';

class CommandLineTools {
  static late String flutterCommand;

  static Future<void> dartPubGet(Directory dir) async {
    print('Running `dart pub get` in ${dir.path}');
    var result = await Process.run(
      'dart',
      ['pub', 'get'],
      workingDirectory: dir.path,
    );
    print(result.stdout);
  }

  static Future<void> flutterCreate(Directory dir) async {
    print('Running `$flutterCommand create` in ${dir.path}');

    if (!dir.existsSync()) {
      print('Directory ${dir.path} doesn\'t exists');
      exit(1);
    }

    var result = await Process.run(
      flutterCommand,
      [
        if (flutterCommand == 'fvm') 'flutter',
        'create',
        '.',
      ],
      workingDirectory: dir.path,
    );
    print(result.stdout);
  }

  static Future<bool> existsCommand(String command) async {
    var result = await Process.run('which', [command]);
    return result.exitCode == 0;
  }

  static Future<void> createTables(Directory dir, String name) async {
    var serverPath = '${dir.path}/${name}_server';
    printww('Setting up Docker and default database tables in $serverPath');
    printww(
        'If you run serverpod create for the first time, this can take a few minutes as Docker is downloading the images for Postgres. If you get stuck at this step, make sure that you have the latest version of Docker Desktop and that it is currently running.');

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
