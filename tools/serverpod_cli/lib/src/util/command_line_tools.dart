import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cli_tools/cli_tools.dart';
import 'package:serverpod_cli/src/util/sdk_resolver.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

class CommandLineTools {
  /// Holds error messages to be flushed at a later time.
  /// This is typically used to replay logs to the terminal
  /// after exiting the tui's alternate screen
  /// but before killing the Dart process.
  static final List<String> _errorBuffer = [];

  /// Logs a message with error level and adds it to the error buffer.
  static void _logError(String message) {
    _errorBuffer.add(message);
    log.error(message);
  }

  /// Log all messages in the error buffer with error level.
  static void flushErrors() {
    _errorBuffer.forEach(log.error);
    _errorBuffer.clear();
  }

  /// Resolves [dir] with `flutter pub get` whenever a Flutter SDK is
  /// available, falling back to `dart pub get`. Generated workspaces can
  /// require the Flutter SDK even without a Flutter app (development-mode
  /// dependency_overrides pull in serverpod_flutter), and plain `dart pub`
  /// only finds the SDK when dart itself is the Flutter-embedded binary -
  /// not the case with a standalone Dart install or version managers like
  /// puro.
  static Future<bool> pubGet(Directory dir) async {
    final flutter = await sdkResolver.flutterSdk;
    return flutter != null ? flutterPubGet(dir) : dartPubGet(dir);
  }

  static Future<bool> dartPubGet(Directory dir) async {
    log.debug('Running `dart pub get` in ${dir.path}', newParagraph: true);

    final dart = await sdkResolver.dartSdk;
    var exitCode = await _runProcessWithDefaultLogger(
      executable: dartExecutableIn(dart.root),
      arguments: ['pub', 'get'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      _logError('Failed to run `dart pub get` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> flutterPubGet(Directory dir) async {
    log.debug('Running `flutter pub get` in ${dir.path}', newParagraph: true);

    final executable = await _flutterExecutableOrReport('pub get');
    if (executable == null) return false;

    var exitCode = await _runProcessWithDefaultLogger(
      executable: executable,
      arguments: ['pub', 'get'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      _logError('Failed to run `flutter pub get` in ${dir.path}');
      return false;
    }

    return true;
  }

  static Future<bool> flutterCreate(Directory dir) async {
    log.debug('Running `flutter create .` in ${dir.path}', newParagraph: true);

    final executable = await _flutterExecutableOrReport('create');
    if (executable == null) return false;

    var exitCode = await _runProcessWithDefaultLogger(
      executable: executable,
      arguments: ['create', '.'],
      workingDirectory: dir.path,
    );

    if (exitCode != 0) {
      _logError('Failed to run `flutter create .` in ${dir.path}');
      return false;
    }

    return true;
  }

  /// The resolved `flutter` executable, or `null` after reporting that no
  /// Flutter SDK could be found.
  static Future<String?> _flutterExecutableOrReport(String step) async {
    final flutter = await sdkResolver.flutterSdk;
    if (flutter != null) return flutterExecutableIn(flutter.root);

    _logError(
      'Cannot run `flutter $step`: no Flutter SDK found.',
    );
    return null;
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
