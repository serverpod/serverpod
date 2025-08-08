import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';

void main() {
  group('Given method websocket connection with connected client', () {
    var server = IntegrationTestServer.create();
    late WebSocket webSocket;

    setUp(() async {
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
    });

    tearDown(() async {
      await webSocket.close();
      await server.shutdown(exitProcess: false);
    });

    test('when server is stopped then socket is closed.', () async {
      webSocket.textEvents.listen((event) {
        // Listen to keep it open.
      });

      await server.shutdown(exitProcess: false);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group('Given method websocket connection with connected method stream', () {
    var server = IntegrationTestServer.create();
    late WebSocket webSocket;
    var endpoint = 'methodStreaming';

    setUp(() async {
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      webSocket.sendText(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: 'intEchoStream',
        args: {},
        inputStreams: ['stream'],
        connectionId: const Uuid().v4obj(),
      ));
    });

    tearDown(() async {
      await webSocket.close();
      await server.shutdown(exitProcess: false);
    });

    test('when server is shut down then socket is closed.', () async {
      webSocket.textEvents.listen((event) {
        // Listen to keep it open.
      });

      await expectLater(
          server
              .shutdown(exitProcess: false)
              .timeout(Duration(seconds: 10))
              .catchError((error) => fail('Failed to shut down server.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group(
      'Given method websocket connection with connected method stream with never listened input stream',
      () {
    var server = IntegrationTestServer.create();
    late WebSocket webSocket;
    var endpoint = 'methodStreaming';

    setUp(() async {
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      webSocket.sendText(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: 'delayedStreamResponse',
        args: {'delay': 20},
        inputStreams: [],
        connectionId: const Uuid().v4obj(),
      ));
    });

    tearDown(() async {
      await webSocket.close();
      await server.shutdown(exitProcess: false);
    });

    test('when server is shut down then socket is closed.', () async {
      webSocket.textEvents.listen((event) {
        // Listen to keep it open.
      });

      await expectLater(
          server
              .shutdown(exitProcess: false)
              .timeout(Duration(seconds: 10))
              .catchError((error) => fail('Failed to shut down server.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group(
      'Given method websocket connection with connected method stream with paused input stream',
      () {
    var server = IntegrationTestServer.create();
    late WebSocket webSocket;
    var endpoint = 'methodStreaming';

    setUp(() async {
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );

      webSocket.sendText(OpenMethodStreamCommand.buildMessage(
        endpoint: endpoint,
        method: 'delayedPausedInputStream',
        args: {'delay': 20},
        inputStreams: ['stream'],
        connectionId: const Uuid().v4obj(),
      ));
    });

    tearDown(() async {
      await webSocket.close();
      await server.shutdown(exitProcess: false);
    });

    test('when server is shut down then socket is closed.', () async {
      webSocket.textEvents.listen((event) {
        // Listen to keep it open.
      });

      await expectLater(
          server
              .shutdown(exitProcess: false)
              .timeout(Duration(seconds: 10))
              .catchError((error) => fail('Failed to shut down server.')),
          completes);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group('Given multiple method websocket connections with connected clients',
      () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket1;
    late WebSocketChannel webSocket2;

    setUp(() async {
      await server.start();
      webSocket1 = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      webSocket2 = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await Future.wait([webSocket1.ready, webSocket2.ready]);
    });

    tearDown(() async {
      await webSocket1.sink.close();
      await webSocket2.sink.close();
      await server.shutdown(exitProcess: false);
    });

    test('when server is stopped then sockets are closed.', () async {
      webSocket1.stream.listen((event) {
        // Listen to keep it open.
      });
      webSocket2.stream.listen((event) {
        // Listen to keep it open.
      });

      await server.shutdown(exitProcess: false);
      expect(webSocket1.closeCode, isNotNull);
      expect(webSocket2.closeCode, isNotNull);
    });
  });
}

extension on WebSocket {
  Stream<String> get textEvents => events
      .where((e) => e is TextDataReceived)
      .cast<TextDataReceived>()
      .map((e) => e.text);
}
