import 'dart:async';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/dap_proxy_server.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

/// Responsible for launching the flutter app.
class FlutterProcess {
  FlutterProcess({
    required String flutterPackageDir,
    required int debugAdapterProxyPort,
    required int debugAdapterControlPort,
    required List<String> args,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  }) : _flutterPackageDir = flutterPackageDir,
       _args = args,
       _dapProxy = DapProxyServer(
         proxyPort: debugAdapterProxyPort,
         controlPort: debugAdapterControlPort,
         stderrSink: stderrSink,
         stdoutSink: stdoutSink,
       );

  final String _flutterPackageDir;
  final DapProxyServer _dapProxy;
  final List<String> _args;

  /// Starts the debug adapter proxy server and launches
  /// the flutter app on successful start.
  Future<void> start() async {
    final success = await _dapProxy.start();
    if (!success) {
      log.error('Unable to start flutter debug adapter');
      return;
    }

    final result = _parseArgs(_args);
    final deviceId = result['device-id'] ?? result['d'];

    await log.progress('Launching flutter app', () async {
      return await _dapProxy.launchFlutterApp(
        projectRootPath: _flutterPackageDir,
        deviceId: deviceId,
        args: _args,
      );
    });
  }

  Map<String, dynamic> _parseArgs(List<String> args) {
    final result = <String, dynamic>{};

    for (var i = 0; i < args.length; i++) {
      final arg = args[i];

      // --optionName=value
      if (arg.startsWith('--') && arg.contains('=')) {
        final parts = arg.substring(2).split('=');
        final key = parts.first;
        final value = parts.last;

        result[key] = value;
      }
      // -optionName value
      else if (arg.startsWith('-')) {
        final key = arg.substring(1);

        if (i + 1 < args.length && !args[i + 1].startsWith('-')) {
          result[key] = args[++i];
        }
      }
    }

    return result;
  }

  /// Stops the debug adapter proxy server.
  /// This also terminates the flutter app.
  Future<void> stop() async {
    await _dapProxy.stop();
  }
}
