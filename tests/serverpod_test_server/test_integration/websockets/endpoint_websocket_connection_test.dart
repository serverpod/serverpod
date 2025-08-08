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
      await webSocket.close();
    });

    test('when server is stopped then socket is closed.', () async {
      webSocket.textEvents.listen((event) {
        // Listen to the stream to keep it open.
      });
      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(webSocket.closeCode, isNull); // Connection is closed, no direct close code access
    });
  });

  group('Given multiple endpoint websocket connections with connected clients',
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
      await webSocket1.close();
      await webSocket2.close();
    });

    test('when server is stopped then sockets are closed.', () async {
      webSocket1.textEvents.listen((event) {
        // Listen to the stream to keep it open.
      });
      webSocket2.textEvents.listen((event) {
        // Listen to the stream to keep it open.
      });
      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(webSocket1.closeCode, isNull); // Connection is closed, no direct close code access
      expect(webSocket2.closeCode, isNull); // Connection is closed, no direct close code access
    });
  });
}

