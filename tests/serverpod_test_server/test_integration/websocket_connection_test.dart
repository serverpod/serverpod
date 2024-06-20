import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group('Given websocket connection with connected client', () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket;

    setUp(() async {
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverWebsocketUrl),
      );
      await webSocket.ready;
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test('when server is stopped then socket is closed.', () async {
      webSocket.stream.listen((event) {
        // Listen to the stream to keep it open.
      });
      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(webSocket.closeCode, isNotNull);
    });
  });

  group('Given multiple websocket connections with connected clients', () {
    var server = IntegrationTestServer.create();
    late WebSocketChannel webSocket1;
    late WebSocketChannel webSocket2;

    setUp(() async {
      await server.start();
      webSocket1 = WebSocketChannel.connect(
        Uri.parse(serverWebsocketUrl),
      );
      await webSocket1.ready;
      webSocket2 = WebSocketChannel.connect(
        Uri.parse(serverWebsocketUrl),
      );
      await webSocket2.ready;
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket1.sink.close();
      await webSocket2.sink.close();
    });

    test('when server is stopped then sockets are closed.', () async {
      webSocket1.stream.listen((event) {
        // Listen to the stream to keep it open.
      });
      webSocket2.stream.listen((event) {
        // Listen to the stream to keep it open.
      });
      // Await connection to be established and all handshakes to be done.
      await Future.delayed(Duration(seconds: 1));

      await server.shutdown(exitProcess: false);
      expect(webSocket1.closeCode, isNotNull);
      expect(webSocket2.closeCode, isNotNull);
    });
  });
}
