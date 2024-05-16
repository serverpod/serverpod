import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
