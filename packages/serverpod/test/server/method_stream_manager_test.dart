import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/websocket_request_handlers/helpers/method_stream_manager.dart';
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
  group('Given a method stream manager', () {
    late Serverpod pod;
    late MethodStreamManager manager;
    late List<StreamController<int>> controllers;
    late List<Session> sessions;
    late List<Completer<void>> cancellations;

    setUp(() {
      pod = Serverpod(
        [],
        internal.Protocol(),
        EmptyEndpoints(),
        config: ServerpodConfig(
          apiServer: ServerConfig(
            port: 0,
            publicScheme: 'http',
            publicHost: 'localhost',
            publicPort: 0,
          ),
        ),
      );
      manager = MethodStreamManager(request: null);
      controllers = [];
      sessions = [];
      cancellations = [];
    });

    tearDown(() async {
      for (final cancellation in cancellations) {
        if (!cancellation.isCompleted) cancellation.complete();
      }
      for (final controller in controllers) {
        await controller.close().timeout(const Duration(seconds: 10));
      }
      for (final session in sessions) {
        await session.close();
      }
      await pod.shutdown(exitProcess: false);
    });

    Future<void> openStream({
      Future<void> Function()? onCancel,
      FutureOr<void> Function(Session)? onSessionClose,
    }) async {
      final listening = Completer<void>();
      final controller = StreamController<int>(
        onListen: listening.complete,
        onCancel: onCancel,
      );
      controllers.add(controller);
      final session = await pod.createSession(enableLogging: false);
      sessions.add(session);
      if (onSessionClose != null) session.addWillCloseListener(onSessionClose);
      final endpoint = _Endpoint()..initialize(pod.server, 'test', null);
      manager.createStream(
        methodStreamCallContext: MethodStreamCallContext(
          method: MethodStreamConnector(
            name: 'stream',
            params: {},
            returnType: MethodStreamReturnType.streamType,
            streamParams: {},
            call: (_, _, _) => controller.stream,
          ),
          arguments: {},
          inputStreams: [],
          endpoint: endpoint,
          fullEndpointPath: 'test',
        ),
        methodStreamId: const Uuid().v4obj(),
        session: session,
      );
      await listening.future.timeout(const Duration(seconds: 5));
    }

    test('when there are no streams then closing completes', () async {
      await expectLater(manager.closeAllStreams(), completes);
    });

    test(
      'when cancellation returns Future<List<void>> then closing completes',
      () async {
        var canceled = false;
        var closed = false;
        await openStream(
          onCancel: () {
            canceled = true;
            return Future.wait<void>([]);
          },
          onSessionClose: (_) => closed = true,
        );

        await manager.closeAllStreams();

        expect(canceled, isTrue);
        expect(closed, isTrue);
      },
    );

    test(
      'when cancellation returns Future<void> then the session closes',
      () async {
        var closed = false;
        await openStream(
          onCancel: () async {},
          onSessionClose: (_) => closed = true,
        );

        await manager.closeAllStreams();

        expect(closed, isTrue);
      },
    );

    test(
      'when several streams are open then all are canceled concurrently',
      () async {
        final release = Completer<void>();
        cancellations.add(release);
        final allCanceled = Completer<void>();
        var canceled = 0;
        var closed = 0;
        for (var i = 0; i < 3; i++) {
          await openStream(
            onCancel: () {
              if (++canceled == 3) allCanceled.complete();
              return Future.wait<void>([release.future]);
            },
            onSessionClose: (_) => closed++,
          );
        }

        final closing = manager.closeAllStreams();
        await allCanceled.future.timeout(const Duration(seconds: 5));
        expect(closed, 0);
        release.complete();
        await closing;

        expect(canceled, 3);
        expect(closed, 3);
      },
    );

    test(
      'when cancellation times out then the session closes only once',
      () async {
        final release = Completer<void>();
        cancellations.add(release);
        var closed = 0;
        var canceled = 0;
        await openStream(
          onCancel: () {
            canceled++;
            return Future.wait<void>([release.future]);
          },
          onSessionClose: (_) => closed++,
        );

        await manager.closeAllStreams().timeout(const Duration(seconds: 10));

        expect(release.isCompleted, isFalse);
        expect(canceled, 1);
        expect(closed, 1);
        release.complete();
        // Controller completion waits for the cancellation chain to settle.
        await controllers.single.done;
        expect(closed, 1);
      },
    );

    test(
      'when cancellation fails then closing propagates the same error',
      () async {
        final error = StateError('cancellation failed');
        var closed = false;
        await openStream(
          onCancel: () => Future<void>.error(error),
          onSessionClose: (_) => closed = true,
        );

        await expectLater(manager.closeAllStreams(), throwsA(same(error)));
        expect(closed, isTrue);
      },
    );
  });
}

class _Endpoint extends Endpoint {}
