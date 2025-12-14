import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cli_tools/cli_tools.dart';
import 'package:path/path.dart' as path;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

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

  static Future<bool> flutterBuild(Directory dir, Directory serverDir) async {
    log.debug('Running `flutter build` in ${dir.path}', newParagraph: true);

    // Unfortunately, we can't use the `-o` flag directly because of an error
    // that happens on windows. Issue is tracked by in flutter
    // repository here: https://github.com/flutter/flutter/issues/157886
    var flutterBuildExitCode = await _runProcessWithDefaultLogger(
      executable: 'flutter',
      arguments: [
        'build',
        'web',
        '--base-href',
        '/app/',
        '--wasm',
      ],
      workingDirectory: dir.path,
    );

    if (flutterBuildExitCode != 0) {
      log.error('Failed to run `flutter build` in ${dir.path}');
      return false;
    }

    log.debug('Copying Flutter web app to server project.', newParagraph: true);
    var copyExitCode = await _runProcessWithDefaultLogger(
      executable: 'mv',
      arguments: [
        path.join(dir.path, 'build', 'web'),
        path.join(serverDir.path, 'web', 'app'),
      ],
      workingDirectory: dir.path,
    );

    if (copyExitCode != 0) {
      log.error('Failed to copy Flutter web app to server project.');
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
