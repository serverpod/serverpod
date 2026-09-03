import 'dart:convert';
import 'dart:io';

import 'package:dart_data_home/dart_data_home.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/process_io.dart';

/// The directory `dart install` keeps its executables and app bundles in.
String get dartInstallRoot => getDartDataHome('install');

/// The directory `dart install` writes executables to.
String get dartInstallBinDirectory => p.join(dartInstallRoot, 'bin');

/// The executable `dart install` writes for the package executable [name].
String dartInstalledExecutable(final String name) =>
    p.join(dartInstallBinDirectory, Platform.isWindows ? '$name.bat' : name);

/// The outcome of a `dart install` run.
typedef DartInstallResult = ({bool success, String errorOutput});

/// Runs `dart install <descriptor>` behind a progress spinner labeled
/// [message], leaving the reporting of both outcomes to the caller.
Future<DartInstallResult> runDartInstall(
  final String descriptor, {
  required final String message,
}) async {
  final errorOutput = StringBuffer();

  final success = await log.progress(message, () async {
    log.debug('Running `dart install $descriptor`...');
    final process = await Process.start(dartExecutablePath, [
      'install',
      descriptor,
    ]);
    process.stdout.transform(const Utf8Decoder()).listen(log.debug);
    final stderrDone = process.stderr
        .transform(const Utf8Decoder())
        .forEach(errorOutput.write);
    final exitCode = await process.exitCode;
    await stderrDone;
    return exitCode == 0;
  });

  return (success: success, errorOutput: errorOutput.toString().trim());
}
