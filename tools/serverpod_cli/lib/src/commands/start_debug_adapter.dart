import 'dart:io';

import 'package:config/config.dart';
import 'package:serverpod_cli/src/commands/start/dap_proxy_server.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Options for the `start-debug-adapter` command.
enum StartDebugAdapterOption<V> implements OptionDefinition<V> {
  proxyPort(
    IntOption(
      argName: 'proxy-port',
      argAbbrev: 'p',
      defaultsTo: 9000,
      helpText:
          'The port where the flutter debug adapter proxy server will listen.',
    ),
  ),
  controlPort(
    IntOption(
      argName: 'control-port',
      argAbbrev: 'c',
      defaultsTo: 4567,
      helpText:
          'The port where the flutter debug adapter control server will listen.',
    ),
  ),
  ;

  const StartDebugAdapterOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// Command to start the flutter debug adapter with the proxy and control servers
/// for interacting with the adapter.
class StartDebugAdapterCommand
    extends ServerpodCommand<StartDebugAdapterOption> {
  @override
  final name = 'start-debug-adapter';

  @override
  final description =
      'Starts a Flutter debug adapter and a proxy server to interact with the adapter.';

  StartDebugAdapterCommand() : super(options: StartDebugAdapterOption.values);

  @override
  Future<void> runWithConfig(
    final Configuration<StartDebugAdapterOption> commandConfig,
  ) async {
    final port = commandConfig.value(StartDebugAdapterOption.proxyPort);
    final controlPort = commandConfig.value(
      StartDebugAdapterOption.controlPort,
    );

    // Written to match VS Code's task begin pattern
    stdout.writeln('Starting flutter debug adapter');

    final proxy = DapProxyServer(proxyPort: port, controlPort: controlPort);

    final success = await log.progress(
      'Starting flutter debug adapter proxy server...',
      () async => await proxy.start(),
    );

    // Written to match VS Code's task end pattern
    if (success) stdout.writeln('Flutter debug adapter ready');

    await proxy.exitFuture;
  }
}
