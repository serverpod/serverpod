import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:ci/ci.dart' as ci;
import 'package:cli_tools/cli_tools.dart';
import 'package:config/config.dart';
import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/scripts/script.dart';
import 'package:serverpod_cli/src/scripts/scripts.dart';
import 'package:serverpod_cli/src/util/server_directory_finder.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

import '../runner/serverpod_command_runner.dart';

/// Options for the `run` command.
enum RunOption<V> implements OptionDefinition<V> {
  scriptName(
    StringOption(
      argName: 'script',
      argPos: 0,
      helpText: 'The name of the script to run.',
    ),
  ),
  list(
    FlagOption(
      argName: 'list',
      argAbbrev: 'l',
      defaultsTo: false,
      helpText: 'List all available scripts.',
    ),
  );

  const RunOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Command to run scripts defined in the `serverpod_scripts` section
/// of pubspec.yaml.
class RunCommand extends ServerpodCommand<RunOption> {
  @override
  final name = 'run';

  @override
  final description =
      'Run a script defined in the serverpod_scripts section of pubspec.yaml.';

  @override
  String get invocation => 'serverpod run <script-name>';

  RunCommand() : super(options: RunOption.values);

  @override
  Future<void> runWithConfig(
    Configuration<RunOption> commandConfig,
  ) async {
    final listScripts = commandConfig.value(RunOption.list);
    final scriptName = commandConfig.optionalValue(RunOption.scriptName);

    // Get interactive flag from global configuration
    final interactive =
        serverpodRunner.globalConfiguration.optionalValue(
          GlobalOption.interactive,
        ) ??
        !ci.isCI;

    // Find pubspec.yaml
    final serverDir = await ServerDirectoryFinder.findOrPrompt(
      startDir: Directory.current,
      interactive: interactive,
    );
    final pubspecFile = File(p.join(serverDir.path, 'pubspec.yaml'));

    // Parse scripts
    final Scripts scripts;
    try {
      scripts = Scripts.fromPubspecFile(pubspecFile);
    } on ScriptsParseException catch (e) {
      log.error('Error parsing serverpod_scripts:\n$e');
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    if (scripts.isEmpty) {
      log.error(
        'No scripts defined in pubspec.yaml. '
        'Add a serverpod_scripts section with your scripts.',
      );
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    // List scripts if --list flag or no script name provided
    if (listScripts || scriptName == null) {
      _listScripts(scripts);
      return;
    }

    // Find and execute the script
    final script = scripts[scriptName];
    if (script == null) {
      log.error('Script "$scriptName" not found.');
      _listScripts(scripts);
      throw ExitException(ServerpodCommand.commandInvokedCannotExecute);
    }

    final workingDirectory = pubspecFile.parent.path;
    final exitCode = await _executeScript(script, workingDirectory);

    if (exitCode != 0) {
      throw ExitException(exitCode);
    }
  }

  void _listScripts(Scripts scripts) {
    log.info('Available scripts:');
    for (final script in scripts.values) {
      log.info('  ${script.name}: ${script.command}');
    }
  }

  Future<int> _executeScript(Script script, String workingDirectory) async {
    log.info('Running "${script.name}": ${script.command}');

    final shell = Platform.isWindows ? 'cmd' : 'bash';
    final shellArg = Platform.isWindows ? '/c' : '-c';

    // NOTE: We invoke a shell instead of the script.command directly (with
    // runInShell: true). This avoid a lot of edge cases regarding quoting,
    // repeated spaces, etc.
    final process = await Process.start(
      shell,
      [shellArg, script.command],
      workingDirectory: workingDirectory,
    );

    // Forward signals to child process
    final sigSubscription =
        StreamGroup.merge(
          [
            ProcessSignal.sigint,
            ProcessSignal.sigterm,
          ].map((s) => s.watch()).toList(),
        ).listen((s) {
          process.kill(s);
        });

    // Forward stdin to the child process
    final stdinSubscription = stdin.listen(
      process.stdin.add,
      cancelOnError: true,
      onError: (_) {}, // extremely unlikely, but why not
    );

    // Stream output directly to terminal
    await [
      stdout.addStream(process.stdout),
      stderr.addStream(process.stderr),
    ].wait;
    await process.stdin.close();
    await stdinSubscription.cancel();
    await sigSubscription.cancel();

    return process.exitCode;
  }
}
