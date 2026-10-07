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
  late Serverpod server;
  late TestExceptionHandler exceptionHandler;
  late List<DiagnosticEventRecord<ExceptionEvent>> errors;
  late StreamSubscription<DiagnosticEventRecord<ExceptionEvent>>
  errorSubscription;

  setUpAll(() async {
    exceptionHandler = TestExceptionHandler();
    errors = [];
    errorSubscription = exceptionHandler.events.listen(errors.add);
    server = IntegrationTestServer.create(
      experimentalFeatures: ExperimentalFeatures(
        diagnosticEventHandlers: [exceptionHandler],
      ),
    );
    await server.startWithDatabase();
  });

  tearDownAll(() async {
    try {
      await server.shutdown(exitProcess: false).timeout(timeout);
    } finally {
      await exceptionHandler.eventsStreamController.close();
      await errorSubscription.cancel();
    }
  });

  group(
    'Given a broadcast stream and an output stream with a narrower cancellation future,',
    () {
      late Session observerSession;
      late WebSocket webSocket;
      late Completer<void> broadcastCanceled;
      late Completer<void> broadcastSessionClosed;
      late Completer<void> sourceCanceled;

      setUpAll(() async {
        observerSession = await server.createSession();
        addTearDown(observerSession.close);
        broadcastCanceled = Completer<void>();
        broadcastSessionClosed = Completer<void>();
        observerSession.messages.addListener(
          MethodStreaming.cancelStreamChannelName,
          (_) => broadcastCanceled.complete(),
        );
        observerSession.messages.addListener(
          MethodStreaming.sessionClosedChannelName,
          (_) => broadcastSessionClosed.complete(),
        );

        final source = Completer<StreamController<int>>();
        MethodStreaming.delayedStreamResponseController = source;
        addTearDown(
          () => MethodStreaming.delayedStreamResponseController = null,
        );
        sourceCanceled = Completer<void>();

        webSocket = await WebSocket.connect(
          Uri.parse(server.methodWebSocketUrl),
        );
        addTearDown(webSocket.tryClose);
        final opened = <UuidValue, Completer<void>>{};
        final subscription = webSocket.textEvents.listen((event) {
          final message = WebSocketMessage.fromJsonString(
            event,
            server.serializationManager,
          );
          if (message is OpenMethodStreamResponse) {
            opened[message.connectionId]!.complete();
          }
        });
        addTearDown(subscription.cancel);

        Future<void> openStream(
          String method,
          Map<String, dynamic> args,
        ) async {
          final id = const Uuid().v4obj();
          final ready = Completer<void>();
          opened[id] = ready;
          webSocket.sendText(
            OpenMethodStreamCommand.buildMessage(
              endpoint: 'methodStreaming',
              method: method,
              args: args,
              connectionId: id,
              inputStreams: [],
            ),
          );
          await ready.future.timeout(timeout);
        }

        await openStream('delayedStreamResponse', {'delay': 0});
        await openStream('getBroadcastStream', {});
        final controller = await source.future.timeout(timeout);
        controller.onCancel = () {
          sourceCanceled.complete();
          return Future.wait<void>([]);
        };
      });

      group('when the WebSocket disconnects and the server shuts down,', () {
        late List<DiagnosticEventRecord<ExceptionEvent>> teardownErrors;

        setUpAll(() async {
          // Disconnect without first sending CloseMethodStreamCommand.
          await webSocket.close();
          await Future.wait([
            sourceCanceled.future,
            broadcastCanceled.future,
            broadcastSessionClosed.future,
          ]).timeout(timeout);
          await observerSession.close();
          await server.shutdown(exitProcess: false).timeout(timeout);
          await exceptionHandler.eventsStreamController.close();
          teardownErrors = List.unmodifiable(errors);
        });

        test('then both endpoint streams are canceled.', () {
          expect(sourceCanceled.isCompleted, isTrue);
          expect(broadcastCanceled.isCompleted, isTrue);
        });

        test('then the endpoint session receives its close notification.', () {
          expect(broadcastSessionClosed.isCompleted, isTrue);
        });

        test(
          'then shutdown completes without diagnostic exceptions.',
          () {
            expect(teardownErrors, isEmpty);
          },
        );
      });
    },
  );
}
