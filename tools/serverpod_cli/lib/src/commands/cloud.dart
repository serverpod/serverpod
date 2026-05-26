import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:async/async.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/sdk_path.dart';
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

    StreamSubscription<List<int>>? stdinSubscription;
    stdinSubscription = stdin.listen(
      (data) {
        try {
          process.stdin.add(data);
        } on StateError {
          stdinSubscription?.cancel();
        } on IOException {
          stdinSubscription?.cancel();
        }
      },
      cancelOnError: true,
      onError: (_) {},
    );

    try {
      await Future.wait([
        stdout.addStream(process.stdout),
        stderr.addStream(process.stderr),
      ]);
    } finally {
      await stdinSubscription.cancel();
      await _closeProcessStdin(process.stdin);
      await sigSubscription.cancel();
    }

    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }
}

Future<Process> _startScloudProcess(
  List<String> args, {
  required bool installIfMissing,
}) async {
  try {
    return await Process.start(
      'scloud',
      args,
      workingDirectory: Directory.current.path,
    );
  } on ProcessException catch (exception) {
    if (installIfMissing) {
      await _installScloud();
      return _startScloudProcess(args, installIfMissing: false);
    }

    log.error(
      'Failed to start Serverpod Cloud CLI: ${exception.message}',
    );
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }
}

Future<void> _installScloud() async {
  final dartExecutable = p.join(getSdkPath(), 'bin', 'dart');
  log.info('Installing Serverpod Cloud CLI...');
  final installProcess = await Process.start(dartExecutable, [
    'install',
    'serverpod_cloud_cli',
  ]);
  installProcess.stdout.transform(const Utf8Decoder()).listen(log.debug);
  installProcess.stderr.transform(const Utf8Decoder()).listen(log.error);
  if (await installProcess.exitCode != 0) {
    log.error('Failed to install Serverpod Cloud CLI.');
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }
}

Future<void> _closeProcessStdin(IOSink sink) async {
  try {
    await sink.close();
  } on StateError {
    // The child may already have closed stdin.
  } on IOException {
    // Ignore broken pipe errors during shutdown.
  }
}
