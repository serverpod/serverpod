import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import '../websocket_extensions.dart';

void main() {
  group(
      'Given a method websocket connection and an endpoint method connection with connected clients',
      () {
    var server = IntegrationTestServer.create();
    late WebSocket methodWebSocketConnection;
    late WebSocket endpointWebSocketConnection;

    setUp(() async {
      await server.start();
      methodWebSocketConnection = await WebSocket.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      endpointWebSocketConnection = await WebSocket.connect(
        Uri.parse(serverEndpointWebsocketUrl),
      );
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await methodWebSocketConnection.close();
      await endpointWebSocketConnection.close();
    });

    test('when server is stopped then sockets are closed.', () async {
      methodWebSocketConnection.textEvents.listen((event) {
        // Listen to the to keep it open.
      });
      endpointWebSocketConnection.textEvents.listen((event) {
        // Listen to the to keep it open.
      });

      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(methodWebSocketConnection.closeCode, isNotNull);
      expect(endpointWebSocketConnection.closeCode, isNotNull);
    });
  });
}

