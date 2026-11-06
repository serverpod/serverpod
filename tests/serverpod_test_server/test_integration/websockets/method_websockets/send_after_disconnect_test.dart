import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/endpoints/method_streaming.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';

import '../../diagnostics/test_exception_handler.dart';
import '../websocket_extensions.dart';

void main() {
  const timeout = Duration(seconds: 15);
  const blockingToken = 'block-until-released';

  group(
    'Given an open method stream and a method websocket handler that is busy '
    'authenticating another open stream command,',
    () {
      late Serverpod server;
      late TestExceptionHandler exceptionHandler;
      late List<DiagnosticEventRecord<ExceptionEvent>> errors;
      late StreamSubscription<DiagnosticEventRecord<ExceptionEvent>>
      errorSubscription;
      late WebSocket webSocket;
      late StreamController<int> sourceController;
      late Completer<void> authenticationStarted;
      late Completer<void> releaseAuthentication;

      setUpAll(() async {
        authenticationStarted = Completer<void>();
        releaseAuthentication = Completer<void>();
        exceptionHandler = TestExceptionHandler();
        errors = [];
        errorSubscription = exceptionHandler.events.listen(errors.add);
        server = IntegrationTestServer.create(
          // Holds the websocket handler inside an await while it processes
          // an open stream command, so the client can disconnect before the
          // server gets to send anything else.
          authenticationHandler: (session, token) async {
            if (token == blockingToken) {
              authenticationStarted.complete();
              await releaseAuthentication.future;
            }
            return null;
          },
          experimentalFeatures: ExperimentalFeatures(
            diagnosticEventHandlers: [exceptionHandler],
          ),
        );
        await server.startWithDatabase();

        final source = Completer<StreamController<int>>();
        MethodStreaming.delayedStreamResponseController = source;
        addTearDown(
          () => MethodStreaming.delayedStreamResponseController = null,
        );

        webSocket = await WebSocket.connect(
          Uri.parse(server.methodWebSocketUrl),
        );
        addTearDown(webSocket.tryClose);

        final streamId = const Uuid().v4obj();
        final opened = Completer<void>();
        final subscription = webSocket.textEvents.listen((event) {
          final message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          if (message is OpenMethodStreamResponse &&
              message.connectionId == streamId) {
            opened.complete();
          }
        });
        addTearDown(subscription.cancel);

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: 'methodStreaming',
            method: 'delayedStreamResponse',
            args: {'delay': 10},
            connectionId: streamId,
            inputStreams: [],
          ),
        );
        await opened.future.timeout(timeout);
        sourceController = await source.future.timeout(timeout);

        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: 'methodStreaming',
            method: 'simpleStream',
            args: {},
            connectionId: const Uuid().v4obj(),
            inputStreams: [],
            authentication: wrapAsBearerAuthHeaderValue(blockingToken),
          ),
        );
        await authenticationStarted.future.timeout(timeout);
      });

      tearDownAll(() async {
        if (!releaseAuthentication.isCompleted) {
          releaseAuthentication.complete();
        }
        await errorSubscription.cancel();
      });

      group(
        'when the client disconnects and the server then sends on the closed socket,',
        () {
          late List<DiagnosticEventRecord<ExceptionEvent>> recordedErrors;

          setUpAll(() async {
            await webSocket.close();
            // Give the server side of the connection time to observe the
            // close frame, so the socket is closed when it next sends.
            await Future.delayed(const Duration(milliseconds: 200));

            // Emitting a value makes the server try to send it to the client
            // that has already disconnected.
            sourceController.add(42);
            releaseAuthentication.complete();

            await server.shutdown(exitProcess: false).timeout(timeout);
            await exceptionHandler.eventsStreamController.close();
            recordedErrors = List.unmodifiable(errors);
          });

          test(
            'then no WebSocketConnectionClosed diagnostic event is reported.',
            () {
              expect(
                recordedErrors.map((r) => r.event.exception),
                isNot(contains(isA<WebSocketConnectionClosed>())),
              );
            },
          );
        },
      );
    },
  );
}
