import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:serverpod_test_server/test_util/config.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  group('Given method websocket connection', () {
    late Serverpod server;
    late WebSocketChannel webSocket;

    setUp(() async {
      server = IntegrationTestServer.create();
      await server.start();
      webSocket = WebSocketChannel.connect(
        Uri.parse(serverMethodWebsocketUrl),
      );
      await webSocket.ready;
    });

    tearDown(() async {
      await server.shutdown(exitProcess: false);
      await webSocket.sink.close();
    });

    test(
        'when a open method stream command with an invalid endpoint is sent then OpenMethodStreamResponse type "endpointNotFound" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'this is not an existing endpoint',
        method: 'method',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.endpointNotFound,
          ));
    });

    test(
        'when a open method stream command with an invalid endpoint method is sent then OpenMethodStreamResponse type "endpointNotFound" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'this is not an existing method',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.endpointNotFound,
          ));
    });

    test(
        'when a open method stream command is sent to a method call endpoint then OpenMethodStreamResponse type "endpointNotFound" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'methodCallEndpoint',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.endpointNotFound,
          ));
    });

    test(
        'when a valid open method stream command is sent then OpenMethodStreamResponse type "success" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'simpleStream',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.success,
          ));
    });

    test(
        'when a open method stream command is sent without required argument then OpenMethodStreamResponse type "invalidArguments" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'simpleStreamWithParameter',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.invalidArguments,
          ));
    });

    test(
        'when a open method stream command is sent with required argument then OpenMethodStreamResponse type "success" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'simpleStreamWithParameter',
        args: {'value': 42},
        connectionId: const Uuid().v4obj(),
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.success,
          ));
    });

    test(
        'when a open method stream command is sent to a method with a streaming argument then OpenMethodStreamResponse type "success" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'methodStreaming',
        method: 'simpleInputReturnStream',
        args: {},
        connectionId: const Uuid().v4obj(),
      ));

      var response = webSocket.stream.first;
      await expectLater(
        response.timeout(Duration(seconds: 5)),
        completion(isA<String>()),
        reason: 'Expected a response from the server.',
      );

      var message = WebSocketMessage.fromJsonString(await response as String);
      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.success,
          ));
    });

    test(
        'when a open method stream command is sent to an authenticated endpoint without an authentication token then OpenMethodStreamResponse type "authenticationFailed" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'authenticatedMethodStreaming',
        method: 'simpleStream',
        args: {},
        connectionId: const Uuid().v4obj(),
        // No authentication token is provided
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.authenticationFailed,
          ));
    });

    test(
        'when a open method stream command is sent to an authenticated endpoint with an invalid authentication token then OpenMethodStreamResponse type "authenticationFailed" is received.',
        () async {
      webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
        endpoint: 'authenticatedMethodStreaming',
        method: 'simpleStream',
        args: {},
        connectionId: const Uuid().v4obj(),
        authentication: 'invalid token',
      ));

      var response = await webSocket.stream.first as String;
      var message = WebSocketMessage.fromJsonString(response);

      expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.authenticationFailed,
          ));
    });

    group(
        'when an authenticated open method stream command is sent to an authenticated endpoint with insufficient scopes',
        () {
      late String token;
      setUp(() async {
        var session = await server.createSession();
        // Missing required "Admin" scope
        var authKey = await UserAuthentication.signInUser(session, 1, 'test');
        session.close();
        token = '${authKey.id}:${authKey.key}';
      });

      tearDown(() async {
        var session = await server.createSession();
        AuthKey.db.deleteWhere(session, where: (_) => Constant.bool(true));
        session.close();
      });

      test(
          'then OpenMethodStreamResponse type "authorizationDeclined" is received.',
          () async {
        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: 'authenticatedMethodStreaming',
          method: 'simpleStream',
          args: {},
          connectionId: const Uuid().v4obj(),
          authentication: token,
        ));

        var response = await webSocket.stream.first as String;
        var message = WebSocketMessage.fromJsonString(response);

        expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.authorizationDeclined,
          ),
        );
      });
    });

    group(
        'when an authenticated open method stream command with sufficient privilege is sent to an authenticated endpoint',
        () {
      late String token;
      setUp(() async {
        var session = await server.createSession();
        var authKey = await UserAuthentication.signInUser(
          session,
          1,
          'test',
          scopes: {Scope.admin}, // Scope required by the endpoint
        );
        session.close();
        token = '${authKey.id}:${authKey.key}';
      });

      tearDown(() async {
        var session = await server.createSession();
        AuthKey.db.deleteWhere(session, where: (_) => Constant.bool(true));
        session.close();
      });

      test('then OpenMethodStreamResponse type "success" is received.',
          () async {
        webSocket.sink.add(OpenMethodStreamCommand.buildMessage(
          endpoint: 'authenticatedMethodStreaming',
          method: 'simpleStream',
          args: {},
          connectionId: const Uuid().v4obj(),
          authentication: token,
        ));

        var response = await webSocket.stream.first as String;
        var message = WebSocketMessage.fromJsonString(response);

        expect(
          message,
          isA<OpenMethodStreamResponse>().having(
            (m) => m.responseType,
            'responseType',
            OpenMethodStreamResponseType.success,
          ),
        );
      });
    });
  });
}
