import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group(
      'Given a method websocket connection and an endpoint method connection with connected clients',
      () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel methodWebSocketConnection;
    late WebSocketChannel endpointWebSocketConnection;

    setUp(() async {
      await server.start();
      methodWebSocketConnection = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      endpointWebSocketConnection = WebSocketChannel.connect(
        Uri.parse(serverEndpointWebsocketUrl),
      );
      await Future.wait([
        methodWebSocketConnection.ready,
        endpointWebSocketConnection.ready,
      ]);
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await methodWebSocketConnection.sink.close();
      await endpointWebSocketConnection.sink.close();
    });

    test('when server is stopped then sockets are closed.', () async {
      methodWebSocketConnection.stream.listen((event) {
        // Listen to the to keep it open.
      });
      endpointWebSocketConnection.stream.listen((event) {
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
