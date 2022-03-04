import 'dart:io';

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
    print('Setting up default database tables in $serverPath');

    await Process.run(
      'chmod',
      ['u+x', 'setup-tables'],
      workingDirectory: serverPath,
    );

    var result = await Process.run(
      './setup-tables',
      [],
      workingDirectory: serverPath,
    );
    print(result.stdout);

    print('Cleaning up');
    result = await Process.run(
      'rm',
      ['setup-tables'],
      workingDirectory: serverPath,
    );
    print(result.stdout);
  }
}
