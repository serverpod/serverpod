import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';
import 'websocket_extensions.dart';

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
        await methodWebSocketConnection.tryClose();
        await endpointWebSocketConnection.tryClose();
      });

      test('when server is stopped then sockets are closed.', () async {
        var methodIsClosed = false;
        var endpointIsClosed = false;
        methodWebSocketConnection.textEvents.listen(
          (event) {
            // Listen to the to keep it open.
          },
          onDone: () {
            methodIsClosed = true;
          },
        );
        endpointWebSocketConnection.textEvents.listen(
          (event) {
            // Listen to the to keep it open.
          },
          onDone: () {
            endpointIsClosed = true;
          },
        );

        // Await connection to be established and all handshakes to be done.
        await Future.delayed(Duration(seconds: 1));

        await server.shutdown(exitProcess: false);
        expect(methodIsClosed, isTrue);
        expect(endpointIsClosed, isTrue);
      });
    },
  );
}
