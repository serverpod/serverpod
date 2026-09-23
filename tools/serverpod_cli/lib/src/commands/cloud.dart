import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:async/async.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/util/dart_install.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// The exit codes `scloud` uses to hand its self-update over to the launcher.
abstract final class ScloudExitCode {
  /// `scloud` needs a breaking update that it could not install itself.
  static const int updateRequired = 69;

  /// `scloud` installed an update and the command must be run again with
  /// the new version.
  static const int updatedRerunRequired = 75;
}

/// The environment variables `scloud` reads from its launcher.
abstract final class ScloudEnvironment {
  /// The command name `scloud` shows in its user-facing text.
  static const String baseCommand = 'SERVERPOD_CLOUD_BASE_COMMAND';

  /// Makes `scloud` exit with [ScloudExitCode.updatedRerunRequired] after
  /// updating itself, instead of rerunning the command in a nested process.
  static const String exitOnUpdated = 'SERVERPOD_CLOUD_EXIT_ON_UPDATED';
}

/// The command name shown to users who invoke `scloud` through this command.
const scloudBaseCommand = 'serverpod cloud';

/// Starts `scloud` with [args] and [environment], and returns its exit code.
typedef ScloudStarter =
    Future<int> Function(
      List<String> args, {
      required Map<String, String> environment,
    });

/// Installs the latest `scloud`, throwing [ExitException] on failure.
typedef ScloudInstaller = Future<void> Function();

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

    final exitCode = await runScloud(
      scloudArgs,
      start: _startScloud,
      install: _installScloud,
    );

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }
}

/// Runs `scloud` with [args] and returns the exit code of its last launch.
///
/// The first launch asks `scloud` to exit instead of rerunning itself after
/// a self-update, so that only one process inherits the terminal at a time.
/// Exit code [ScloudExitCode.updatedRerunRequired] relaunches the command
/// once. Exit code [ScloudExitCode.updateRequired] installs the latest
/// `scloud` with [install] first, then relaunches once.
Future<int> runScloud(
  List<String> args, {
  required ScloudStarter start,
  required ScloudInstaller install,
}) async {
  final exitCode = await start(
    args,
    environment: {
      ScloudEnvironment.baseCommand: scloudBaseCommand,
      ScloudEnvironment.exitOnUpdated: 'true',
    },
  );

  switch (exitCode) {
    case ScloudExitCode.updatedRerunRequired:
      log.debug(
        'Serverpod Cloud CLI updated itself, running the command again.',
      );
    case ScloudExitCode.updateRequired:
      log.debug(
        'Serverpod Cloud CLI requires an update it could not install itself, '
        'installing it.',
      );
      await install();
    default:
      return exitCode;
  }

  return start(
    args,
    environment: {ScloudEnvironment.baseCommand: scloudBaseCommand},
  );
}

Future<int> _startScloud(
  List<String> args, {
  required Map<String, String> environment,
}) async {
  final process = await _startScloudProcess(
    args,
    environment: environment,
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
    return await process.exitCode;
  } finally {
    await sigSubscription.cancel();
  }
}

Future<Process> _startScloudProcess(
  List<String> args, {
  required Map<String, String> environment,
  required bool installIfMissing,
}) async {
  final scloudExecutable = getScloudExecutablePath();

  if (!File(scloudExecutable).existsSync()) {
    if (installIfMissing) {
      await _installScloud();
      return _startScloudProcess(
        args,
        environment: environment,
        installIfMissing: false,
      );
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
      environment: environment,
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
/// 2. The legacy pub-cache bin directory, when it can be located
///
/// Returns the preferred `dart install` path even when the executable is
/// missing so callers can trigger installation.
String getScloudExecutablePath() {
  final name = Platform.isWindows ? 'scloud.bat' : 'scloud';

  final dartInstallPath = dartInstalledExecutable('scloud');
  if (File(dartInstallPath).existsSync()) {
    return dartInstallPath;
  }

  final pubCache = pubCacheDirectory;
  if (pubCache != null) {
    final pubCachePath = p.join(pubCache, 'bin', name);
    if (File(pubCachePath).existsSync()) {
      return pubCachePath;
    }
  }

  return dartInstallPath;
}
