import 'dart:async';
import 'dart:convert';
import 'dart:io';

/// A fake `flutter run --machine` process used by the `serverpod start` E2E
/// test. It publishes a delayed VM-service URI and answers enough VM Service
/// Protocol requests to exercise an IDE connection through Serverpod's proxy.
Future<void> main(List<String> args) async {
  // FlutterProcess probes `flutter --version --machine` before invoking the
  // tool. Returning valid JSON without flutterRoot makes it use this executable
  // directly for the subsequent `flutter run` invocation.
  if (args.contains('--version')) {
    stdout.writeln('{}');
    return;
  }

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.transform(WebSocketTransformer()).listen(_serveVmServiceClient);

  _emitMachineEvent('app.start', {'appId': 'fake-flutter-app'});
  await _waitForDebugPortGate();

  final wsUri = 'ws://${server.address.address}:${server.port}/ws';
  _emitMachineEvent('app.debugPort', {
    'wsUri': wsUri,
    'port': server.port,
  });
  _emitMachineEvent('app.started', {});

  final stopped = Completer<void>();
  void stop(ProcessSignal _) {
    if (!stopped.isCompleted) stopped.complete();
  }

  final signalSubscriptions = <StreamSubscription<ProcessSignal>>[
    ProcessSignal.sigint.watch().listen(stop),
    if (!Platform.isWindows) ProcessSignal.sigterm.watch().listen(stop),
  ];

  await stopped.future;
  await server.close(force: true);
  await Future.wait(
    signalSubscriptions.map((subscription) => subscription.cancel()),
  );
}

Future<void> _waitForDebugPortGate() async {
  final gatePath = Platform.environment['FAKE_FLUTTER_DEBUG_PORT_GATE'];
  if (gatePath == null || gatePath.isEmpty) return;

  final gate = File(gatePath);
  final deadline = DateTime.now().add(const Duration(seconds: 30));
  while (!gate.existsSync()) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Debug-port gate was not opened: $gatePath');
    }
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

void _emitMachineEvent(String event, Map<String, Object?> params) {
  stdout.writeln(
    jsonEncode([
      {'event': event, 'params': params},
    ]),
  );
}

void _serveVmServiceClient(WebSocket socket) {
  socket.listen((data) {
    if (data is! String) return;

    final Object? decoded;
    try {
      decoded = jsonDecode(data);
    } on FormatException {
      return;
    }
    if (decoded is! Map) return;

    final id = decoded['id'];
    final method = decoded['method'];
    if (id == null || method is! String) return;

    final Object result = switch (method) {
      'getVersion' => {
        'type': 'Version',
        'major': 4,
        'minor': 20,
        // The E2E test asserts this marker to prove the response came from
        // this upstream service rather than being synthesized by the proxy.
        'servedBy': 'fake-flutter-vm-service',
      },
      'getVM' => {
        'type': 'VM',
        'name': 'fake-flutter-vm',
        'architectureBits': 64,
        'hostCPU': 'fake',
        'operatingSystem': Platform.operatingSystem,
        'targetCPU': 'fake',
        'version': Platform.version,
        'pid': pid,
        'startTime': 0,
        'isolates': [
          {
            'type': '@Isolate',
            'id': 'isolates/1',
            'name': 'main',
            'number': '1',
            'isSystemIsolate': false,
            'isolateGroupId': 'isolateGroups/1',
          },
        ],
        'systemIsolates': <Object>[],
        'isolateGroups': <Object>[],
        'systemIsolateGroups': <Object>[],
      },
      _ => {'type': 'Success'},
    };

    socket.add(
      jsonEncode({'jsonrpc': '2.0', 'id': id, 'result': result}),
    );
  });
}
