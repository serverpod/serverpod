import 'dart:async';
import 'dart:io';

import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/serverpod_command.dart';
import 'package:serverpod_cli/src/config/config.dart'
    show ServerpodProjectNotFoundException;
import 'package:serverpod_cli/src/runner/runner_discovery.dart';
import 'package:serverpod_cli/src/runner/runner_manifest.dart';
import 'package:serverpod_cli/src/runner/runner_paths.dart';
import 'package:serverpod_cli/src/runner/runner_stage.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Options for the `status` command.
enum StatusOption<V> implements OptionDefinition<V> {
  directory(
    StringOption(
      argName: 'directory',
      argAbbrev: 'd',
      helpText:
          'The server directory (defaults to auto-detect from current '
          'directory).',
    ),
  ),
  ;

  const StatusOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Prints the state and addresses of the runner for one server project.
///
/// Reads `.dart_tool/serverpod/runner.json` and probes the socket it names, so
/// a manifest left behind by a crashed runner is reported as not running
/// rather than as a live stack.
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

    final resolution = await resolveRunner(serverDir.path);
    switch (resolution) {
      case NoRunner(:final staleManifest):
        log.info('Not running.');
        if (staleManifest case RunnerManifest(:final pid, :final exitCode?)) {
          log.info(
            'The last runner (pid $pid) stopped during startup with exit '
            'code $exitCode; its output is in '
            '${serverpodRunnerLogPath(serverDir.absolute.path)}.',
          );
        } else if (staleManifest != null) {
          log.info(
            'A manifest from a previous run is still present '
            '(pid ${staleManifest.pid}); `serverpod start` will replace it.',
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
      log.info('  Servers:    not yet published');
    } else {
      _printIfSet('  API:       ', servers.api);
      _printIfSet('  Insights:  ', servers.insights);
      _printIfSet('  Web:       ', servers.web);
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

  void _printIfSet(String label, String? value) {
    if (value == null) return;
    log.info('$label $value');
  }

  String _onOff(bool value) => value ? 'on' : 'off';
}

/// Resolves the server directory for a runner client command.
///
/// [explicit] is the `--directory` value when given. Prompting is off: these
/// commands are the ones an agent runs, and a blocked prompt in a
/// non-interactive session reads as a hang.
Future<Directory> resolveServerDirectory(String? explicit) async {
  try {
    return await ServerDirectoryFinder.findOrPrompt(
      startDir: (explicit != null && explicit.isNotEmpty)
          ? Directory(explicit)
          : null,
      interactive: false,
    );
  } on ServerpodProjectNotFoundException catch (e) {
    log.error('${e.message}\nPass --directory <path> to point at one.');
    throw ExitException.error();
  }
}
