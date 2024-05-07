import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group("Given a Serverpod server when fetching an object, ", () {
    late http.Response response;

    setUpAll(() async {
      response = await http.post(
        Uri.parse("${serverUrl}jsonProtocol"),
        body: jsonEncode({"method": "getJsonForProtocol"}),
      );
    });

    test('then it should return status code 200', () {
      expect(
        response.statusCode,
        200,
      );
    });

    test('then it should contain the "nested" key', () {
      Map jsonMap = jsonDecode(response.body);
      expect(
        jsonMap,
        contains('nested'),
      );
    });
  });

  group(
      "Given a Serverpod server when fetching an object with server only field, ",
      () {
    late http.Response response;

    setUpAll(() async {
      response = await http.post(
        Uri.parse("${serverUrl}jsonProtocol"),
        body: jsonEncode({"method": "getJsonForProtocol"}),
      );
    });

    test('then the nested object should not contain server-only field', () {
      Map jsonMap = jsonDecode(response.body);
      Map nestedMap = jsonMap['nested'];
      expect(
        nestedMap,
        isNot(contains('serverOnlyScope')),
      );
    });
  });

  group(
      "Given a Serverpod server with WebSocket connection, when listening for a serialized object, ",
      () {
    late dynamic message;

    setUpAll(() async {
      WebSocketChannel websocket = WebSocketChannel.connect(
        Uri.parse(serverWebsocketUrl),
      );
      message = await websocket.stream.asBroadcastStream().first;
      await websocket.sink.close();
    });

    test(
      'then the server should respond with a string message',
      () async {
        expect(message, isA<String>());
      },
    );

    test(
      'then the serialized response JSON body should contain "object" key',
      () async {
        Map responseMap = jsonDecode(message);
        expect(responseMap, contains('object'));
      },
    );

    test(
      'then the "object" JSON inside serialized response body should contain "data" key',
      () async {
        Map responseMap = jsonDecode(message);
        Map objectMap = responseMap['object'];
        expect(objectMap, contains('data'));
      },
    );
  });

  group(
    "Given a Serverpod server with WebSocket connection, when listening for a serialized object with server only field, ",
    () {
      late dynamic message;

      setUpAll(() async {
        WebSocketChannel websocket = WebSocketChannel.connect(
          Uri.parse(serverWebsocketUrl),
        );
        message = await websocket.stream.asBroadcastStream().first;
        await websocket.sink.close();
      });

      test(
        'then the serialized object should not contain server-only field',
        () async {
          Map? nestedMap = jsonDecode(message)['object']?['data']?['nested'];
          expect(nestedMap, isNot(contains('serverOnlyScope')));
        },
      );
    },
  );
}
