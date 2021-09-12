import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:serverpod_test_client/serverpod_test_client.dart';


void main() {
  var client = Client('http://localhost:8080/');

  setUp(() {
  });

  group('Basic websocket', () {

    test('Connect and send string', () async {
      await client.connectWebSocket();
      // await client.modules
      // await client.sendWebSocketString('Hello websocket');
    });

  });
}
