import 'dart:async';
import 'dart:io';

import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_client/src/client_method_stream_manager.dart';
import 'package:serverpod_client/src/method_stream/method_stream_connection_details.dart';
import 'package:serverpod_client/src/method_stream/method_stream_manager_exceptions.dart';
import 'package:test/test.dart';

import '../test_utils/method_stream_connection_details_builder.dart';
import '../test_utils/test_web_socket_server.dart';

class TestSerializationManager extends SerializationManager {}

void main() async {
  test(
      'Given no websocket server when attempting to connect then WebSocketConnectException is thrown.',
      () {
    var streamManager = ClientMethodStreamManager(
      connectionTimeout: const Duration(milliseconds: 100),
      webSocketHost: Uri.parse('ws://localhost:12345'),
      serializationManager: TestSerializationManager(),
    );

    expect(
      () => streamManager.openMethodStream(
        MethodStreamConnectionDetailsBuilder().build(),
      ),
      throwsA(isA<WebSocketConnectException>()),
    );
  });

  group('Given non responsive websocket server', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    late int pingCommandsReceived;
    setUp(() async {
      pingCommandsReceived = 0;
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            pingCommandsReceived++;
            // Do nothing
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() async => await closeServer());

    test(
        'when trying to open method stream then ConnectionAttemptTimedOutException is thrown.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      expect(
        () => streamManager.openMethodStream(
          MethodStreamConnectionDetailsBuilder().build(),
        ),
        throwsA(isA<ConnectionAttemptTimedOutException>()),
      );
    });

    test(
        'when trying to open multiple method streams then a connection attempt is made for each method stream.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      Future<void> openMethodStream() async => streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder().build(),
          );

      await Future.wait([
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
      ]).onError<ConnectionAttemptTimedOutException>(
        (error, stackTrace) => Future.value([]),
      );

      expect(pingCommandsReceived, 5);
    });
  });

  group('Given websocket server that completes initialization sequence', () {
    Completer<Uri> callbackUrlFuture;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    late int pingCommandsReceived;
    setUp(() async {
      pingCommandsReceived = 0;
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              TestSerializationManager(),
            );
            if (message is PingCommand) {
              pingCommandsReceived++;
              webSocket.add(PongCommand.buildMessage());
            } else if (message is OpenMethodStreamCommand) {
              webSocket.add(OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.success,
              ));
            }
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() async => await closeServer());
    test(
        'when trying to open multiple method streams at once then single connection is validated using ping commands.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      Future<void> openMethodStream() async => streamManager.openMethodStream(
            MethodStreamConnectionDetailsBuilder().build(),
          );

      await Future.wait([
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
        openMethodStream(),
      ]);
      expect(pingCommandsReceived, 1);
    });
  });

  group(
      'Given websocket server that completes initialization sequence with error',
      () {
    Completer<Uri> callbackUrlFuture;
    late Completer<void> webSocketClosed;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    setUp(() async {
      webSocketClosed = Completer<void>();
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              TestSerializationManager(),
            );
            if (message is PingCommand) {
              webSocket.add(PongCommand.buildMessage());
            } else if (message is OpenMethodStreamCommand) {
              webSocket.add(OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.endpointNotFound,
              ));
            }
          }, onDone: () {
            webSocketClosed.complete();
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() async => await closeServer());
    test(
        'when trying to open method stream then websocket connection is closed.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      expect(
        () => streamManager.openMethodStream(
          MethodStreamConnectionDetailsBuilder().build(),
        ),
        throwsA(isA<OpenMethodStreamException>()),
      );

      await expectLater(webSocketClosed.future, completes);
    });
  });

  group(
      'Given websocket server that completes initialization sequence and then closes method stream',
      () {
    Completer<Uri> callbackUrlFuture;
    late Completer<void> webSocketClosed;
    late Uri webSocketHost;
    late Future<void> Function() closeServer;
    setUp(() async {
      webSocketClosed = Completer<void>();
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          webSocket.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              TestSerializationManager(),
            );
            if (message is PingCommand) {
              webSocket.add(PongCommand.buildMessage());
            } else if (message is OpenMethodStreamCommand) {
              webSocket.add(OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.success,
              ));

              webSocket.add(
                CloseMethodStreamCommand.buildMessage(
                  endpoint: message.endpoint,
                  connectionId: message.connectionId,
                  method: message.method,
                  reason: CloseReason.done,
                ),
              );
            }
          }, onDone: () {
            webSocketClosed.complete();
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      webSocketHost = await callbackUrlFuture.future;
    });

    tearDown(() async => await closeServer());
    test('when opening method stream then websocket connection is closed.',
        () async {
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      await streamManager.openMethodStream(
        MethodStreamConnectionDetailsBuilder().build(),
      );

      await expectLater(webSocketClosed.future, completes);
    });
  });

  group('Given open method streaming connection', () {
    Completer<Uri> callbackUrlFuture;
    late WebSocket testWebSocket;
    late Completer<void> webSocketClosed;
    late Future<void> Function() closeServer;
    late MethodStreamConnectionDetails streamConnectionDetails;
    setUp(() async {
      webSocketClosed = Completer<void>();
      callbackUrlFuture = Completer<Uri>();
      closeServer = await TestWebSocketServer.startServer(
        webSocketHandler: (webSocket) {
          testWebSocket = webSocket;
          webSocket.listen((event) {
            var message = WebSocketMessage.fromJsonString(
              event,
              TestSerializationManager(),
            );
            if (message is PingCommand) {
              webSocket.add(PongCommand.buildMessage());
            } else if (message is OpenMethodStreamCommand) {
              webSocket.add(OpenMethodStreamResponse.buildMessage(
                connectionId: message.connectionId,
                endpoint: message.endpoint,
                method: message.method,
                responseType: OpenMethodStreamResponseType.success,
              ));
            }
          }, onDone: () {
            webSocketClosed.complete();
          });
        },
        onConnected: (host) {
          callbackUrlFuture.complete(host);
        },
      );

      var webSocketHost = await callbackUrlFuture.future;
      var streamManager = ClientMethodStreamManager(
        connectionTimeout: const Duration(milliseconds: 100),
        webSocketHost: webSocketHost,
        serializationManager: TestSerializationManager(),
      );

      streamConnectionDetails = MethodStreamConnectionDetailsBuilder().build();
      await streamManager.openMethodStream(
        streamConnectionDetails,
      );
    });

    tearDown(() async => await closeServer());
    test(
        'when websocket connection is closed then outbound stream is closed with exception.',
        () async {
      var errorCompleter = Completer();
      var outputController = streamConnectionDetails.outputController;
      outputController.stream.listen(
        (e) {
          // ignore
        },
        onError: (e, s) => errorCompleter.complete(e),
      );

      await testWebSocket.close();
      await expectLater(webSocketClosed.future, completes);
      await expectLater(errorCompleter.future, completes);
      var error = await errorCompleter.future;
      expect(error, isA<ServerpodClientException>());
    });
  });
}
