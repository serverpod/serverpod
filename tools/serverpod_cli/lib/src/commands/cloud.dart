import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:async/async.dart';
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:dart_data_home/dart_data_home.dart';
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
        stdout.addStream(_replaceScloudInOutput(process.stdout)),
        stderr.addStream(_replaceScloudInOutput(process.stderr)),
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
    );
  } on ProcessException catch (exception) {
    log.error(
      'Failed to start Serverpod Cloud CLI: ${exception.message}',
    );
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }
}

Future<void> _installScloud() async {
  final dartExecutable = p.join(getSdkPath(), 'bin', 'dart');
  final success = await log.progress(
    'Installing Serverpod Cloud CLI...',
    () async {
      final installProcess = await Process.start(dartExecutable, [
        'install',
        'serverpod_cloud_cli',
      ]);

      installProcess.stdout.transform(const Utf8Decoder()).listen(log.debug);
      installProcess.stderr.transform(const Utf8Decoder()).listen(log.error);

      return (await installProcess.exitCode) == 0;
    },
  );

  if (!success) {
    log.error('Failed to install Serverpod Cloud CLI.');
    throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
  }
}

/// Rewrites [scloud] branding in child process output for the parent CLI.
Stream<List<int>> _replaceScloudInOutput(Stream<List<int>> stream) async* {
  var pending = '';

  await for (final chunk in stream.transform(const Utf8Decoder())) {
    pending += chunk;

    final lastSpace = pending.lastIndexOf(' ');
    if (lastSpace == -1) {
      continue;
    }

    final emit = pending.substring(0, lastSpace + 1);
    pending = pending.substring(lastSpace + 1);
    yield _encodeReplacingScloudInText(emit);
  }

  if (pending.isNotEmpty) {
    yield _encodeReplacingScloudInText(pending);
  }
}

List<int> _encodeReplacingScloudInText(String text) {
  return utf8.encode(
    text.replaceAllMapped(
      RegExp(r'''(["' ])scloud(["' ])?'''),
      (match) => '${match.group(1)}serverpod cloud${match.group(2) ?? ''}',
    ),
  );
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

  final dartInstallPath = p.join(getDartDataHome('install'), 'bin', name);
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
