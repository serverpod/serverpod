import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/endpoints/method_streaming.dart';
import 'package:serverpod_test_server/test_util/test_serverpod.dart';
import 'package:test/test.dart';
import 'package:web_socket/web_socket.dart';

import '../../diagnostics/test_exception_handler.dart';
import '../websocket_extensions.dart';

void main() {
  test(
    'Given active method streams when the websocket disconnects '
    'then streams, sessions and the server close without teardown errors',
    () async {
      const timeout = Duration(seconds: 15);
      final exceptionHandler = TestExceptionHandler();
      final errors = <DiagnosticEventRecord<ExceptionEvent>>[];
      final errorSubscription = exceptionHandler.events.listen(errors.add);
      final server = IntegrationTestServer.create(
        experimentalFeatures: ExperimentalFeatures(
          diagnosticEventHandlers: [exceptionHandler],
        ),
      );
      addTearDown(() async {
        try {
          await server.shutdown(exitProcess: false).timeout(timeout);
        } finally {
          await exceptionHandler.eventsStreamController.close();
          await errorSubscription.cancel();
        }
      });
      await server.startWithDatabase();

      final session = await server.createSession();
      addTearDown(session.close);
      final broadcastCanceled = Completer<void>();
      final broadcastSessionClosed = Completer<void>();
      session.messages.addListener(
        MethodStreaming.cancelStreamChannelName,
        (_) => broadcastCanceled.complete(),
      );
      session.messages.addListener(
        MethodStreaming.sessionClosedChannelName,
        (_) => broadcastSessionClosed.complete(),
      );

      final source = Completer<StreamController<int>>();
      MethodStreaming.delayedStreamResponseController = source;
      addTearDown(() => MethodStreaming.delayedStreamResponseController = null);
      final sourceCanceled = Completer<void>();

      final webSocket = await WebSocket.connect(
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

      for (final method in ['delayedStreamResponse', 'getBroadcastStream']) {
        final id = const Uuid().v4obj();
        final ready = Completer<void>();
        opened[id] = ready;
        webSocket.sendText(
          OpenMethodStreamCommand.buildMessage(
            endpoint: 'methodStreaming',
            method: method,
            args: method == 'delayedStreamResponse' ? {'delay': 0} : {},
            connectionId: id,
            inputStreams: [],
          ),
        );
        await ready.future.timeout(timeout);
      }
      final controller = await source.future.timeout(timeout);
      controller.onCancel = () {
        sourceCanceled.complete();
        // Preserve a narrower runtime type through the controller's cancel path.
        return Future.wait<void>([]);
      };

      // Disconnect the transport without first sending CloseMethodStreamCommand.
      await webSocket.close();
      await Future.wait([
        sourceCanceled.future,
        broadcastCanceled.future,
        broadcastSessionClosed.future,
      ]).timeout(timeout);
      await session.close();
      await server.shutdown(exitProcess: false).timeout(timeout);
      await exceptionHandler.eventsStreamController.close();

      expect(errors, isEmpty);
    },
  );
}
