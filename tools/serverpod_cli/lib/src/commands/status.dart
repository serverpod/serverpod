import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/runner_options.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/config/config.dart'
    show ServerpodProjectNotFoundException;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:serverpod_shared/serverpod_shared.dart' show ServerpodAddresses;

/// Options for the `status` command.
enum StatusOption<V> implements OptionDefinition<V> {
  directory<String>(clientDirectoryOption),
  ;

  const StatusOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// The `serverpod runner status` command, which prints the runner's state.
class StatusCommand extends ServerpodCommand<StatusOption> {
  @override
  final name = 'status';

  @override
  final description =
      "Print the development stack's state and addresses for this project.";

  @override
  String get invocation => 'serverpod runner status';

  StatusCommand() : super(options: StatusOption.values);

  @override
  Future<void> runWithConfig(Configuration<StatusOption> commandConfig) async {
    final serverDir = await resolveServerDirectory(
      commandConfig.optionalValue(StatusOption.directory),
    );

    final resolution = await resolveRunnerOrExit(serverDir.path);
    switch (resolution) {
      case NoRunner(staleManifest: final manifest?, lockHeld: true):
        log.info(
          'A runner (pid ${manifest.pid}) holds the project but is not '
          'answering: it is shutting down, or busy. '
          '`serverpod runner stop` stops it.',
        );

      case NoRunner(:final staleManifest):
        log.info('Not running.');
        if (staleManifest case RunnerManifest(:final pid, :final exitCode?)) {
          log.info(
            'The last runner (pid $pid) stopped with exit code $exitCode. '
            'Its output is in '
            '${serverpodRunnerLogPath(serverDir.absolute.path)}.',
          );
        } else if (staleManifest != null) {
          log.info(
            'The last runner (pid ${staleManifest.pid}) exited without '
            'shutting down.',
          );
        }
        log.info('Start it with `serverpod start`.');

      case IncompatibleRunner(:final message):
        log.warning(message);

      case LiveRunner(:final manifest, :final versionWarning):
        if (versionWarning != null) log.warning(versionWarning);
        _printManifest(manifest, serverDir.absolute.path);
    }
  }

  void _printManifest(RunnerManifest manifest, String serverDir) {
    final state = switch (manifest.stage) {
      RunnerStage.starting => 'Starting',
      RunnerStage.running => 'Running',
      RunnerStage.degraded => 'Up, but the project failed to build',
      RunnerStage.stopping => 'Stopping',
    };
    log.info('$state (pid ${manifest.pid}, CLI ${manifest.cliVersion}).');

    final servers = manifest.servers;
    if (servers == null) {
      log.info('  Servers:    ${_unpublishedServers(manifest.ports)}');
    } else {
      printServerUris(servers);
    }

    final vmService = manifest.vmService;
    if (vmService != null) {
      _printIfSet('  VM service:', vmService.proxy);
    }

    log.info('  Attach:     serverpod runner attach');
    log.info('  Logs:       ${serverpodRunnerLogPath(serverDir)}');

    final docker = manifest.docker;
    if (docker != null) {
      log.info(
        '  Docker:     project "${docker.project}"'
        '${docker.startedByRunner ? ' (started by this runner)' : ''}',
      );
    }

    final config = manifest.config;
    final serverArgs = config.serverArgs.isEmpty
        ? ''
        : ', server args: ${config.serverArgs.join(' ')}';
    log.info(
      '  Config:     watch ${_onOff(config.watch)}, '
      'flutter ${_onOff(config.flutter)}$serverArgs',
    );
  }

  String _onOff(bool value) => value ? 'on' : 'off';
}

/// Resolves the server directory for a runner command, or exits with a hint.
///
/// Never prompts, since an agent's blocked prompt looks like a hang.
Future<Directory> resolveServerDirectory(
  String? explicit, {
  String flag = '--directory',
}) async {
  try {
    return await ServerDirectoryFinder.findOrPrompt(
      startDir: (explicit != null && explicit.isNotEmpty)
          ? Directory(explicit)
          : null,
      interactive: false,
    );
  } on ServerpodProjectNotFoundException catch (e) {
    log.error('${e.message}\nPass $flag <path> to point at one.');
    throw ExitException.error();
  }
}

/// Resolves the runner for [serverDir], or exits with why it is unreachable.
///
/// An overlong socket path is a setup problem, not an internal error.
Future<RunnerResolution> resolveRunnerOrExit(String serverDir) async {
  try {
    return await resolveRunner(serverDir);
  } on SocketException catch (e) {
    log.error(e.message);
    throw ExitException.error();
  }
}

/// Prints the addresses a runner published, one line per server.
void printServerUris(ServerpodAddresses servers) {
  _printIfSet('  API:       ', servers.api);
  _printIfSet('  Insights:  ', servers.insights);
  _printIfSet('  Web:       ', servers.web);
}

void _printIfSet(String label, String? value) {
  if (value == null) return;
  log.info('$label $value');
}

String _unpublishedServers(Map<String, int>? claimed) => switch (claimed) {
  null => 'not yet published',
  final ports when ports.isEmpty =>
    'not yet published, binding ephemeral ports',
  final ports =>
    'not yet published, claiming '
        '${ports.entries.map((e) => '${e.key} ${e.value}').join(', ')}',
};
