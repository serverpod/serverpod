import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:serverpod_cli/src/commands/start/dap_proxy_commands.dart';
import 'package:serverpod_cli/src/util/serverpod_cli_logger.dart';
import 'package:super_string/super_string.dart';

/// A proxy server for connecting to a Flutter debug adapter.
/// [DapProxyServer] also exposes a control server which
/// non-Flutter clients can connect to and send structured commands
/// for hot reload/restart.
/// Typically, `serverpod start` connects to this control server
/// to enable hot reload/restart from the tui.
class DapProxyServer {
  final int proxyPort;
  final int controlPort;
  final void Function(String) _infoWriter;
  final void Function(String) _errorWriter;

  ServerSocket? _dapServer;
  ServerSocket? _controlServer;
  StreamSubscription? _stdoutSub;
  StreamSubscription? _stderrSub;
  StreamSubscription? _clientPacketsSub;
  StreamSubscription? _debugAdapterPacketsSub;
  StreamSubscription? _controlSub;
  StreamSubscription? _sigtermSub;
  Stream<List<int>>? _stdoutStream;

  final _outputReplacementRegex = RegExp(r'Content-Length:\s+\d+');

  Process? _flutterAdapterProcess;

  final _exitCompleter = Completer<void>();
  Future<void> get exitFuture => _exitCompleter.future;

  int _nextSeq = 1;

  DapProxyServer({
    required this.proxyPort,
    required this.controlPort,
    IOSink? stdoutSink,
    IOSink? stderrSink,
  }) : _infoWriter = stdoutSink != null ? stdoutSink.writeln : log.info,
       _errorWriter = stderrSink != null ? stderrSink.writeln : log.error;

  /// Close sockets with active connections at [proxyPort] and [controlPort], if any.
  Future<void> _stopIfStarted() {
    return Future.wait(
      [proxyPort, controlPort].map((port) async {
        try {
          final sock = await Socket.connect(InternetAddress.anyIPv4, port);
          sock.writeln(DapProxyCommands.stop);
          // Wait for the server to respond to the command.
          await Future.delayed(const Duration(seconds: 1));
        } catch (_) {}
      }),
    );
  }

  /// Starts the proxy server.
  ///
  /// Runs flutter debug adapter in a process,
  /// then pipes writes to the proxy socket into the debug adapter's stdin.
  /// Typically, the `FlutterProcess` from `serverpod start` writes
  /// structured commands (reload, restart)
  /// to the control socket at [controlPort] which produces DAP-formatted
  /// commands that are piped to the debug adapter's stdin.
  Future<bool> start() async {
    try {
      await _stopIfStarted();
      _infoWriter('Starting Flutter debug adapter');

      final process = await Process.start('flutter', ['debug_adapter']);

      _flutterAdapterProcess = process;

      if (!Platform.isWindows) {
        _sigtermSub = ProcessSignal.sigterm.watch().listen(
          (_) => process.kill(),
        );
      }

      final stream = process.stdout.asBroadcastStream();
      _stdoutStream = stream;

      _stdoutSub = stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((data) {
            try {
              if (!data.contains('"event":"output"')) return;

              final decoded = Map.from(
                jsonDecode(data.replaceAll(_outputReplacementRegex, '')),
              );
              final message = Map.from(decoded['body'])['output'] as String;
              _infoWriter(message);
            } catch (_) {}
          });

      _stderrSub = process.stderr.transform(utf8.decoder).listen((e) {
        _errorWriter(e);
      });

      _controlServer = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        controlPort,
      );

      _infoWriter('DAP control server listening on :$controlPort');

      _controlServer?.listen(_handleControlConnection);

      _dapServer = await ServerSocket.bind(InternetAddress.anyIPv4, proxyPort);

      _infoWriter('DAP proxy server listening on :$proxyPort');

      _dapServer?.listen(_handleClientConnection);

      unawaited(process.exitCode.then((_) async => await stop()));

      return true;
    } catch (e) {
      _errorWriter('Error starting DAP proxy server: $e');
    }
    return false;
  }

  void _handleClientConnection(Socket socket) {
    final stdoutStream = _stdoutStream;
    if (stdoutStream == null) return;

    final process = _flutterAdapterProcess;
    if (process == null) return;

    _infoWriter('DAP client connected');

    final broadcastSock = socket.asBroadcastStream().cast<List<int>>();

    broadcastSock
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          if (line == DapProxyCommands.stop) stop();
        });

    final clientPackets = DapPacketReader(broadcastSock);
    final debugAdapterPackets = DapPacketReader(stdoutStream);

    _clientPacketsSub = clientPackets.stream.listen((data) {
      final command = data['command'];
      _infoWriter('Client Packet: $data');
      _infoWriter(
        'Client -> Flutter: ${data['command'] ?? data['event']}',
      );

      _writeData(process.stdin, data);

      if (command == 'disconnect') {
        stop();
      }
    });

    _debugAdapterPacketsSub = debugAdapterPackets.stream.listen((data) {
      _infoWriter('Flutter Packet: $data');
      _infoWriter(
        'Flutter -> Client: ${data['command'] ?? data['event']}',
      );

      _writeData(socket, data);
    });

    socket.done.then((_) async {
      _infoWriter('DAP client disconnected');
      _flutterAdapterProcess?.kill();
      _flutterAdapterProcess = null;
    });
  }

  void _handleControlConnection(Socket socket) {
    _infoWriter('DAP proxy control client connected');

    _controlSub = socket
        .cast<List<int>>()
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
          switch (line) {
            case DapProxyCommands.stop:
              stop();
              break;

            case DapProxyCommands.hotReload:
              _performHotReload(socket);
              break;

            case DapProxyCommands.hotRestart:
              _performHotRestart(socket);
              break;

            default:
              socket.writeln('Unknown command');
          }
        });
  }

  /// Waits for response to [command] or [event].
  Future<bool> _waitForResponseOrEvent({
    String? command,
    String? event,
    Duration timeLimit = const Duration(seconds: 1),
  }) async {
    final stream = _stdoutStream;
    final process = _flutterAdapterProcess;
    if (stream == null || process == null) return false;

    final completer = Completer<bool>();

    final sub = stream.transform(utf8.decoder).listen((data) {
      if (data.contains('terminated')) {
        if (!completer.isCompleted) completer.complete(false);
      }

      if (command != null) {
        if (data.containsAll([
          '"type":"response"',
          '"command":"$command"',
          '"success":true',
        ])) {
          if (!completer.isCompleted) completer.complete(true);
        }
      }

      if (event != null) {
        if (data.containsAll(['"type":"event"', '"event":"$event"'])) {
          if (!completer.isCompleted) completer.complete(true);
        }
      }
    });

    return completer.future
        .timeout(timeLimit, onTimeout: () => false)
        .whenComplete(() => sub.cancel());
  }

  /// Launches flutter app on device with id
  /// [deviceId] using the debug adapter.
  Future<bool> launchFlutterApp({
    required String deviceId,
    required String projectRootPath,
    List<String> args = const [],
  }) async {
    final process = _flutterAdapterProcess;
    if (process == null) return false;

    final initializationRequest = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'initialize',
      'arguments': {
        'clientID': 'serverpod',
        'clientName': 'Serverpod',
        'adapterID': 'dart',
        'pathFormat': 'path',
        'locale': 'en',
        // Required to receive progress events for hot reload and restart
        'supportsProgressReporting': true,
      },
    };

    _writeData(process.stdin, initializationRequest);

    bool launchSuccess = await _waitForResponseOrEvent(
      event: 'initialized',
    );

    final launchRequest = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'launch',
      'arguments': {
        'deviceId': deviceId,
        'cwd': projectRootPath,
        'projectRootPath': projectRootPath,
        'args': args,
        'toolArgs': ['-d', deviceId],
      },
    };

    _writeData(process.stdin, launchRequest);

    final configurationRequest = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'configurationDone',
    };

    _writeData(process.stdin, configurationRequest);
    launchSuccess &= await _waitForResponseOrEvent(
      command: 'configurationDone',
    );

    final threadsRequest = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'threads',
    };

    _writeData(process.stdin, threadsRequest);

    final result = await _waitForProgress(
      'launch',
      timeLimit: const Duration(minutes: 3),
    );

    launchSuccess &= result == success;

    return launchSuccess;
  }

  static const success = 'success';
  static const failure = 'error';
  static const timeout = 'timeout';

  /// Waits for progress to end for [event].
  ///
  /// Returns a Future that:
  /// - resolves to 'success'
  ///   when progress ends for [event].
  /// - resolves to 'timeout'
  ///   when [timeLimit] is reached before progress ends.
  /// - resolves to 'failure' when the debug adapter is terminated.
  Future<String> _waitForProgress(
    String event, {
    Duration timeLimit = const Duration(seconds: 1),
  }) async {
    final stream = _stdoutStream;
    final process = _flutterAdapterProcess;
    if (stream == null || process == null) return failure;

    final completer = Completer<String>();

    final sub = stream.transform(utf8.decoder).listen((data) {
      // progressEnd indicates progress tracking has ended.
      // The payload contains the tracked progressId
      // which will contain the event name.
      if (data.contains('progressEnd') && data.contains(event)) {
        if (!completer.isCompleted) completer.complete(success);
      }

      if (data.contains('terminated')) {
        if (!completer.isCompleted) completer.complete(failure);
      }
    });

    return completer.future
        .timeout(timeLimit, onTimeout: () async => timeout)
        .whenComplete(() => sub.cancel());
  }

  /// Sends hot reload request to the debug adapter.
  Future<void> _performHotReload(Socket socket) async {
    final process = _flutterAdapterProcess;
    if (process == null) return;

    final request = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'hotReload',
      'arguments': {},
    };

    _writeData(process.stdin, request);
    final status = await _waitForProgress('hotReload');
    socket.writeln('${DapProxyCommands.hotReload}: $status');
  }

  /// Sends hot restart request to the debug adapter.
  Future<void> _performHotRestart(Socket socket) async {
    final process = _flutterAdapterProcess;
    if (process == null) return;

    final request = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'hotRestart',
      'arguments': {},
    };

    _writeData(process.stdin, request);
    final status = await _waitForProgress('hotRestart');
    socket.writeln('${DapProxyCommands.hotRestart}: $status');
  }

  void _killFlutterApp() {
    final process = _flutterAdapterProcess;
    if (process == null) return;

    final request = {
      'seq': _nextSeq++,
      'type': 'request',
      'command': 'terminate',
      'arguments': {'restart': false},
    };

    _writeData(process.stdin, request);
  }

  /// Writes [data] to [sink].
  void _writeData(IOSink sink, Map<String, dynamic> data) {
    final jsonString = jsonEncode(data);
    final bytes = utf8.encode(jsonString);

    sink.write('Content-Length: ${bytes.length}\r\n');
    sink.write('\r\n');
    sink.add(bytes);
  }

  Future<void> _cleanup() async {
    final process = _flutterAdapterProcess;
    if (process != null) {
      _killFlutterApp();
      process.kill();
      _flutterAdapterProcess = null;
    }

    await _dapServer?.close();
    await _controlServer?.close();
    await _stdoutSub?.cancel();
    await _stderrSub?.cancel();
    await _clientPacketsSub?.cancel();
    await _debugAdapterPacketsSub?.cancel();
    await _controlSub?.cancel();
    await _sigtermSub?.cancel();
    _dapServer = null;
    _controlServer = null;
    _stdoutSub = null;
    _stderrSub = null;
    _clientPacketsSub = null;
    _debugAdapterPacketsSub = null;
    _controlSub = null;
    _sigtermSub = null;
  }

  /// Cleanup resources and stop server.
  Future<void> stop() async {
    await _cleanup();
    if (!_exitCompleter.isCompleted) {
      _exitCompleter.complete();
    }
  }
}

final _contentLengthRegex = RegExp(r'Content-Length: (\d+)');

class DapPacketReader {
  final Stream<List<int>> _stream;

  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get stream => _controller.stream;

  DapPacketReader(this._stream) {
    _start();
  }

  void _start() async {
    final iterator = StreamIterator(_stream);

    final buffer = <int>[];

    while (await iterator.moveNext()) {
      buffer.addAll(iterator.current);

      while (true) {
        final headerEnd = _indexOfHeaderEnd(buffer);

        if (headerEnd == -1) break;

        final headerBytes = buffer.sublist(0, headerEnd);
        final contentLength = _parseContentLength(utf8.decode(headerBytes));

        if (contentLength == null) {
          throw Exception('Missing Content-Length header');
        }

        final packetStart = headerEnd + 4;

        if (buffer.length < packetStart + contentLength) break;

        final bodyBytes = buffer.sublist(
          packetStart,
          packetStart + contentLength,
        );

        final body = jsonDecode(utf8.decode(bodyBytes));

        _controller.add(body);

        buffer.removeRange(0, packetStart + contentLength);
      }
    }
  }

  int _indexOfHeaderEnd(List<int> bytes) {
    for (var i = 0; i < bytes.length - 3; i++) {
      if (bytes[i] == 13 &&
          bytes[i + 1] == 10 &&
          bytes[i + 2] == 13 &&
          bytes[i + 3] == 10) {
        return i;
      }
    }

    return -1;
  }

  int? _parseContentLength(String header) {
    final match = _contentLengthRegex.firstMatch(header);
    if (match == null) return null;
    return int.parse(match.group(1)!);
  }
}
