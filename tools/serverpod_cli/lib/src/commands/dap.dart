import 'dart:async';
import 'dart:io';

import 'package:config/config.dart';
import 'package:dds/dap.dart';
import 'package:serverpod_cli/src/dap/serverpod_debug_adapter.dart';
import 'package:serverpod_cli/src/runner/serverpod_command.dart';

/// Options for the `dap` command. Currently mirrors the subset of
/// `dart debug_adapter`'s options that we forward to the underlying adapter.
enum DapOption<V> implements OptionDefinition<V> {
  ipv6(
    FlagOption(
      argName: 'ipv6',
      defaultsTo: false,
      negatable: false,
      helpText: 'Whether to bind DAP/VM Service connections to IPv6 addresses.',
    ),
  )
  ;

  const DapOption(this.option);

  @override
  final ConfigOptionBase<V> option;
}

/// `serverpod dap` - spawns a Debug Adapter Protocol server on stdin/stdout
/// for editors (currently the serverpod VS Code extension).
///
/// Hidden because end users invoke it via launch.json, not directly.
class DapCommand extends ServerpodCommand<DapOption> {
  static const String commandName = 'dap';

  @override
  final name = commandName;

  @override
  bool get hidden => true;

  @override
  final description =
      'Start a Debug Adapter Protocol server for serverpod, intended to be '
      'launched by an editor as the debug adapter for `type: "serverpod"`.';

  DapCommand() : super(options: DapOption.values);

  @override
  Future<void> runWithConfig(Configuration<DapOption> commandConfig) async {
    final ipv6 = commandConfig.value(DapOption.ipv6);

    // The non-blocking sink can fail mid-flush when the editor disconnects;
    // the failure is benign at shutdown. Match `dart debug_adapter`'s
    // behaviour and swallow it explicitly.
    unawaited(stdout.nonBlocking.done.catchError((Object _) {}));

    final channel = ByteStreamServerChannel(stdin, stdout.nonBlocking, null);
    ServerpodDebugAdapter(
      channel,
      ipv6: ipv6,
      onError: (e) => stderr.writeln(
        'Input could not be parsed as a Debug Adapter Protocol message.\n'
        'The `serverpod dap` command is intended to be invoked by an editor '
        'using the Debug Adapter Protocol.\n\n'
        '$e',
      ),
    );

    await channel.closed;
  }
}
