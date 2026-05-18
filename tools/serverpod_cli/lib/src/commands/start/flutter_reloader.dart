import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/dap_proxy_commands.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';

enum _FlutterReloadStatus {
  success,
  error,
  timeout
  ;

  const _FlutterReloadStatus();

  factory _FlutterReloadStatus.fromString(String data) {
    return _FlutterReloadStatus.values.firstWhere(
      (e) => data.contains(e.name),
      orElse: () => _FlutterReloadStatus.error,
    );
  }
}

/// Responsible for reloading/restarting a running flutter app.
/// [FlutterReloader] connects to a control port exposed by the
/// [DapProxyServer] and sends structured commands for hot reload
/// and hot restart.
class FlutterReloader {
  FlutterReloader({
    required this.debugAdapterControlPort,
    required this.flutterAppInfoPath,
  });

  /// The port to connect to for sending hot reload
  /// and restart commands to the debug adapter.
  final int debugAdapterControlPort;

  /// Path to the file to watch for reconnection signal.
  /// When this file is modified, [FlutterReloader] will
  /// attempt to reconnect to to [debugAdapterControlPort].
  final String flutterAppInfoPath;

  Socket? _debugAdapterControlSocket;
  Stream<List<int>>? _socketStream;
  StreamSubscription? _fileStreamSubscription;

  /// Establishes a connection to [debugAdapterControlPort]
  /// and watches for reconnection signal.
  Future<void> start() async {
    const maxAttempts = 100;
    const delay = Duration(seconds: 1);

    for (var i = 0; i < maxAttempts; i++) {
      try {
        _debugAdapterControlSocket ??= await Socket.connect(
          InternetAddress.anyIPv4,
          debugAdapterControlPort,
        );
        final socket = _debugAdapterControlSocket!;
        _socketStream = socket.asBroadcastStream().cast<List<int>>();

        // These events are produced before `serverpod start` is aborted
        // when there is an already running server.
        // This allows the running process to reconnect
        // to the debug adapter when the Flutter app is launched again from the IDE
        _fileStreamSubscription = File(flutterAppInfoPath)
            .watch(events: FileSystemEvent.create | FileSystemEvent.modify)
            .listen((event) async {
              await stop();
              log.info('Reconnecting to debug adapter control server');
              await start();
            });

        log.info('Connected to debug adapter control server');
        return;
      } catch (_) {}
      await Future<void>.delayed(delay);
    }
  }

  Future<_FlutterReloadStatus> _sendCommand(String command) async {
    final stream = _socketStream;
    final socket = _debugAdapterControlSocket;
    if (stream == null || socket == null) return _FlutterReloadStatus.error;

    socket.writeln(command);

    final completer = Completer<_FlutterReloadStatus>();
    final sub = stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((data) {
          if (data.contains(command)) {
            final status = _FlutterReloadStatus.fromString(data);
            if (!completer.isCompleted) completer.complete(status);
          }
        });

    return completer.future
        .timeout(
          const Duration(seconds: 1),
          onTimeout: () => _FlutterReloadStatus.timeout,
        )
        .whenComplete(() => sub.cancel());
  }

  /// Sends hot reload command to the debug adapter.
  Future<void> reload() async {
    final status = await _sendCommand(DapProxyCommands.hotReload);
    final message = switch (status) {
      _FlutterReloadStatus.success => '✓ Flutter app reloaded.',
      _FlutterReloadStatus.error => 'Flutter app hot reload failed.',
      _FlutterReloadStatus.timeout => 'Flutter app hot reload timed out.',
    };

    _logForStatus(message, status);
  }

  /// Sends hot restart command to the debug adapter.
  Future<void> restart() async {
    final status = await _sendCommand(DapProxyCommands.hotRestart);
    final message = switch (status) {
      _FlutterReloadStatus.success => '✓ Flutter app restarted.',
      _FlutterReloadStatus.error => 'Flutter app hot restart failed.',
      _FlutterReloadStatus.timeout => 'Flutter app hot restart timed out.',
    };
    _logForStatus(message, status);
  }

  void _logForStatus(String message, _FlutterReloadStatus status) {
    if (status == _FlutterReloadStatus.success) {
      log.info(message);
    } else {
      log.error(message);
    }
  }

  /// Closes the connection to [debugAdapterControlPort]
  /// and cleans up held resources.
  Future<void> stop() async {
    await _fileStreamSubscription?.cancel();
    _debugAdapterControlSocket?.destroy();
    _debugAdapterControlSocket = null;
  }
}
