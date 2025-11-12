import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import 'websocket_extensions.dart';

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
      await webSocket.tryClose();
      await server.shutdown(exitProcess: false);
    });

    test('when server is stopped then socket is closed.', () async {
      var isClosed = false;
      webSocket.textEvents.listen(
        (event) {
          // Listen to keep it open.
        },
        onDone: () {
          isClosed = true;
        },
      );

      await server.shutdown(exitProcess: false);
      expect(isClosed, isTrue);
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

      webSocket.sendText(
        OpenMethodStreamCommand.buildMessage(
          endpoint: endpoint,
          method: 'intEchoStream',
          args: {},
          inputStreams: ['stream'],
          connectionId: const Uuid().v4obj(),
        ),
      );
    });

    tearDown(() async {
      await webSocket.tryClose();
      await server.shutdown(exitProcess: false);
    });

    test('when server is shut down then socket is closed.', () async {
      var isClosed = false;
      webSocket.textEvents.listen(
        (event) {
          // Listen to keep it open.
        },
        onDone: () {
          isClosed = true;
        },
      );

      await expectLater(
        server
            .shutdown(exitProcess: false)
            .timeout(Duration(seconds: 10))
            .catchError((error) => fail('Failed to shut down server.')),
        completes,
      );
      expect(isClosed, isTrue);
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

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: 'delayedStreamResponse',
            args: {'delay': 20},
            inputStreams: [],
            connectionId: const Uuid().v4obj(),
          ),
        );
      });

      tearDown(() async {
        await webSocket.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test('when server is shut down then socket is closed.', () async {
        var isClosed = false;
        webSocket.textEvents.listen(
          (event) {
            // Listen to keep it open.
          },
          onDone: () {
            isClosed = true;
          },
        );

        await expectLater(
          server
              .shutdown(exitProcess: false)
              .timeout(Duration(seconds: 10))
              .catchError((error) => fail('Failed to shut down server.')),
          completes,
        );
        expect(isClosed, isTrue);
      });
    },
  );

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

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: endpoint,
            method: 'delayedPausedInputStream',
            args: {'delay': 20},
            inputStreams: ['stream'],
            connectionId: const Uuid().v4obj(),
          ),
        );
      });

      tearDown(() async {
        await webSocket.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test('when server is shut down then socket is closed.', () async {
        var isClosed = false;
        webSocket.textEvents.listen(
          (event) {
            // Listen to keep it open.
          },
          onDone: () {
            isClosed = true;
          },
        );

        await expectLater(
          server
              .shutdown(exitProcess: false)
              .timeout(Duration(seconds: 10))
              .catchError((error) => fail('Failed to shut down server.')),
          completes,
        );
        expect(isClosed, isTrue);
      });
    },
  );

  group(
    'Given multiple method websocket connections with connected clients',
    () {
      var server = IntegrationTestServer.create();
      late WebSocket webSocket1;
      late WebSocket webSocket2;

      setUp(() async {
        await server.start();
        webSocket1 = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );
        webSocket2 = await WebSocket.connect(
          Uri.parse(serverMethodWebsocketUrl),
        );
      });

      tearDown(() async {
        await webSocket1.tryClose();
        await webSocket2.tryClose();
        await server.shutdown(exitProcess: false);
      });

      test('when server is stopped then sockets are closed.', () async {
        var isClosed1 = false;
        var isClosed2 = false;
        webSocket1.textEvents.listen(
          (event) {
            // Listen to keep it open.
          },
          onDone: () {
            isClosed1 = true;
          },
        );
        webSocket2.textEvents.listen(
          (event) {
            // Listen to keep it open.
          },
          onDone: () {
            isClosed2 = true;
          },
        );

        await server.shutdown(exitProcess: false);
        expect(isClosed1, isTrue);
        expect(isClosed2, isTrue);
      });
    },
  );
}
