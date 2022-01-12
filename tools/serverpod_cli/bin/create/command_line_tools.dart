import 'dart:io';

class CommandLineTools {
  static Future<void> dartPubGet(Directory dir) async {
    print('Running `dart pub get` in ${dir.path}');
    var result =
        await Process.run('dart', ['pub', 'get'], workingDirectory: dir.path);
    print(result.stdout);
  }

  static Future<void> flutterCreate(Directory dir) async {
    print('Running `flutter create` in ${dir.path}');
    var result = await Process.run('flutter', ['create', '.'],
        workingDirectory: dir.path);
    print(result.stdout);
  }

  static Future<bool> existsCommand(String command) async {
    var result = await Process.run('command', ['-v', command]);
    return result.exitCode == 0;
  }
}
