import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import 'websocket_extensions.dart';

void main() {
  group('Given endpoint websocket connection with connected client', () {
    var server = IntegrationTestServer.create();
    late WebSocket webSocket;

    setUp(() async {
      await server.start();
      webSocket = await WebSocket.connect(
        Uri.parse(serverEndpointWebsocketUrl),
      );
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.tryClose();
    });

    test('when server is stopped then socket is closed.', () async {
      var isClosed = false;
      webSocket.textEvents.listen(
        (event) {
          // Listen to the stream to keep it open.
        },
        onDone: () {
          isClosed = true;
        },
      );
      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(isClosed, isTrue);
    });
  });

  group(
    'Given multiple endpoint websocket connections with connected clients',
    () {
      var server = IntegrationTestServer.create();
      late WebSocket webSocket1;
      late WebSocket webSocket2;

      setUp(() async {
        await server.start();
        webSocket1 = await WebSocket.connect(
          Uri.parse(serverEndpointWebsocketUrl),
        );
        webSocket2 = await WebSocket.connect(
          Uri.parse(serverEndpointWebsocketUrl),
        );
      });

      tearDown(() async {
        await server.shutdown(exitProcess: false);
        await webSocket1.tryClose();
        await webSocket2.tryClose();
      });

      test('when server is stopped then sockets are closed.', () async {
        var isClosed1 = false;
        var isClosed2 = false;
        webSocket1.textEvents.listen(
          (event) {
            // Listen to the stream to keep it open.
          },
          onDone: () {
            isClosed1 = true;
          },
        );
        webSocket2.textEvents.listen(
          (event) {
            // Listen to the stream to keep it open.
          },
          onDone: () {
            isClosed2 = true;
          },
        );
        // Await connection to be established and all handshakes to be done.
        await Future.delayed(Duration(seconds: 1));

        await server.shutdown(exitProcess: false);
        expect(isClosed1, isTrue);
        expect(isClosed2, isTrue);
      });
    },
  );
}
