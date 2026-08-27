import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:async/async.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/dart_install.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Forwards to the Serverpod Cloud CLI (`scloud`).
class CloudCommand extends ServerpodCommand {
  CloudCommand() : super(options: []);

  final ArgParser _cloudArgParser = ArgParser.allowAnything();

  @override
  ArgParser get argParser => _cloudArgParser;

  @override
  final name = 'cloud';

  @override
  final description =
      'Manage Serverpod Cloud projects through the Serverpod Cloud.';

  @override
  String get invocation => 'serverpod cloud <scloud-args>';

  @override
  Configuration resolveConfiguration(ArgResults? argResults) {
    return Configuration.resolveNoExcept(
      options: options,
      argResults: argResults,
      env: envVariables,
      ignoreUnexpectedPositionalArgs: true,
    );
  }

  @override
  Future<void> runWithConfig(Configuration commandConfig) async {
    final scloudArgs = argResults?.rest ?? [];

    final process = await _startScloudProcess(
      scloudArgs,
      installIfMissing: true,
    );

    final sigSubscription =
        StreamGroup.merge(
          [
            ProcessSignal.sigint,
            if (!Platform.isWindows) ProcessSignal.sigterm,
          ].map((signal) => signal.watch()),
        ).listen((signal) {
          process.kill(signal);
        });

    try {
      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw ExitException(exitCode);
      }
    } finally {
      await sigSubscription.cancel();
    }
  }
}

Future<Process> _startScloudProcess(
  List<String> args, {
  required bool installIfMissing,
}) async {
  final scloudExecutable = getScloudExecutablePath();

  if (!File(scloudExecutable).existsSync()) {
    if (installIfMissing) {
      await _installScloud();
      return _startScloudProcess(args, installIfMissing: false);
    }

    log.error(
      'Failed to start Serverpod Cloud CLI: '
      'executable not found at $scloudExecutable',
    );
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }

  try {
    return await Process.start(
      scloudExecutable,
      args,
      workingDirectory: Directory.current.path,
      mode: ProcessStartMode.inheritStdio,
    );
  } on ProcessException catch (exception) {
    log.error(
      'Failed to start Serverpod Cloud CLI: ${exception.message}',
    );
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }
}

Future<void> _installScloud() async {
  final result = await runDartInstall(
    'serverpod_cloud_cli',
    message: 'Installing Serverpod Cloud CLI',
  );
  if (result.success) return;

  final details = result.errorOutput;
  log.error(
    'Failed to install Serverpod Cloud CLI.'
    '${details.isEmpty ? '' : '\n$details'}',
  );
  throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
}

/// Resolves the full path to the Serverpod Cloud CLI (`scloud`) executable.
///
/// Tries in order:
/// 1. The `dart install` bin directory (where `_installScloud` places it)
/// 2. The legacy pub-cache bin directory
///
/// Returns the preferred `dart install` path even when the executable is
/// missing so callers can trigger installation.
String getScloudExecutablePath() {
  final name = Platform.isWindows ? 'scloud.bat' : 'scloud';

  final dartInstallPath = dartInstalledExecutable('scloud');
  if (File(dartInstallPath).existsSync()) {
    return dartInstallPath;
  }

  final pubCachePath = p.join(_resolvePubCacheBinDirectory(), name);
  if (File(pubCachePath).existsSync()) {
    return pubCachePath;
  }

  return dartInstallPath;
}

String _resolvePubCacheBinDirectory() {
  final pubCache = Platform.environment['PUB_CACHE'];
  if (pubCache != null && pubCache.isNotEmpty) {
    return p.join(pubCache, 'bin');
  }

  if (Platform.isWindows) {
    final localAppData = Platform.environment['LOCALAPPDATA'];
    if (localAppData != null && localAppData.isNotEmpty) {
      return p.join(localAppData, 'Pub', 'Cache', 'bin');
    }
  }

  return p.join(Platform.environment['HOME'] ?? '', '.pub-cache', 'bin');
}
