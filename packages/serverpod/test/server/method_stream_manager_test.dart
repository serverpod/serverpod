import 'dart:async';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/generated/protocol.dart' as internal;
import 'package:serverpod/src/server/websocket_request_handlers/helpers/method_stream_manager.dart';
import 'package:test/test.dart';

import 'test_helpers/empty_endpoints.dart';

void main() {
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

  Future<StreamController<int>> openStream({
    Future<void> Function()? onCancel,
    FutureOr<void> Function(Session)? onSessionClose,
    Map<String, StreamParameterDescription> inputParameters = const {},
    void Function(Map<String, Stream<dynamic>>)? onInputStreams,
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
          streamParams: inputParameters,
          call: (_, _, streams) {
            onInputStreams?.call(streams);
            return controller.stream;
          },
        ),
        arguments: {},
        inputStreams: inputParameters.values.toList(),
        endpoint: endpoint,
        fullEndpointPath: 'test',
      ),
      methodStreamId: const Uuid().v4obj(),
      session: session,
    );
    await listening.future.timeout(const Duration(seconds: 5));

    return controller;
  }

  test(
    'Given a manager without open streams, '
    'when all streams are closed, '
    'then closing completes.',
    () async {
      await expectLater(manager.closeAllStreams(), completes);
    },
  );

  group(
    'Given an output stream whose cancellation returns Future<List<void>>,',
    () {
      late bool canceled;
      late bool closed;

      setUp(() async {
        canceled = false;
        closed = false;
        await openStream(
          onCancel: () {
            canceled = true;
            return Future.wait<void>([]);
          },
          onSessionClose: (_) => closed = true,
        );
      });

      test(
        'when all streams are closed, '
        'then the stream is canceled and its session closes.',
        () async {
          await manager.closeAllStreams();

          expect(canceled, isTrue);
          expect(closed, isTrue);
        },
      );
    },
  );

  group('Given an output stream whose cancellation returns Future<void>,', () {
    late bool closed;

    setUp(() async {
      closed = false;
      await openStream(
        onCancel: () async {},
        onSessionClose: (_) => closed = true,
      );
    });

    test(
      'when all streams are closed, '
      'then the session closes.',
      () async {
        await manager.closeAllStreams();

        expect(closed, isTrue);
      },
    );
  });

  group('Given three output streams with blocked cancellation futures,', () {
    late Completer<void> release;
    late Completer<void> allCanceled;
    late int canceled;
    late int closed;

    setUp(() async {
      release = Completer<void>();
      cancellations.add(release);
      allCanceled = Completer<void>();
      canceled = 0;
      closed = 0;
      for (var i = 0; i < 3; i++) {
        await openStream(
          onCancel: () {
            if (++canceled == 3) allCanceled.complete();
            return Future.wait<void>([release.future]);
          },
          onSessionClose: (_) => closed++,
        );
      }
    });

    group('when all streams are closed and cancellation is released,', () {
      late int canceledBeforeRelease;
      late int closedBeforeRelease;

      setUp(() async {
        final closing = manager.closeAllStreams();
        await allCanceled.future.timeout(const Duration(seconds: 5));
        canceledBeforeRelease = canceled;
        closedBeforeRelease = closed;
        release.complete();
        await closing;
      });

      test('then every cancellation starts before any is released.', () {
        expect(canceledBeforeRelease, 3);
        expect(closedBeforeRelease, 0);
      });

      test('then every stream is canceled and every session closes.', () {
        expect(canceled, 3);
        expect(closed, 3);
      });
    });
  });

  group(
    'Given an output stream with cancellation blocked beyond the close timeout,',
    () {
      late Completer<void> release;
      late StreamController<int> controller;
      late int closed;
      late int canceled;

      setUp(() async {
        release = Completer<void>();
        cancellations.add(release);
        closed = 0;
        canceled = 0;
        controller = await openStream(
          onCancel: () {
            canceled++;
            return Future.wait<void>([release.future]);
          },
          onSessionClose: (_) => closed++,
        );
      });

      group('when all streams are closed and cancellation is released,', () {
        late bool cancellationCompletedBeforeRelease;
        late int closedBeforeRelease;
        late int canceledBeforeRelease;

        setUp(() async {
          await manager.closeAllStreams().timeout(const Duration(seconds: 10));
          cancellationCompletedBeforeRelease = release.isCompleted;
          closedBeforeRelease = closed;
          canceledBeforeRelease = canceled;
          release.complete();
          await controller.done;
        });

        test('then the session closes before cancellation completes.', () {
          expect(cancellationCompletedBeforeRelease, isFalse);
          expect(canceledBeforeRelease, 1);
          expect(closedBeforeRelease, 1);
        });

        test(
          'then late cancellation does not repeat session-close notifications.',
          () {
            expect(closed, 1);
          },
        );
      });
    },
  );

  group('Given an output stream whose cancellation fails,', () {
    late StateError error;
    late bool closed;

    setUp(() async {
      error = StateError('cancellation failed');
      closed = false;
      await openStream(
        onCancel: () => Future<void>.error(error),
        onSessionClose: (_) => closed = true,
      );
    });

    test(
      'when all streams are closed, '
      'then the same error propagates after the session closes.',
      () async {
        await expectLater(manager.closeAllStreams(), throwsA(same(error)));

        expect(closed, isTrue);
      },
    );
  });

  group(
    'Given an active input stream and an output stream with a narrower cancellation future,',
    () {
      late Completer<void> inputClosed;
      late bool outputCanceled;
      late bool sessionClosed;

      setUp(() async {
        inputClosed = Completer<void>();
        outputCanceled = false;
        sessionClosed = false;
        await openStream(
          inputParameters: {
            'input': StreamParameterDescription<int>(
              name: 'input',
              nullable: false,
            ),
          },
          onInputStreams: (streams) {
            final subscription = streams['input']!.listen(
              (_) {},
              onDone: inputClosed.complete,
            );
            addTearDown(subscription.cancel);
          },
          onCancel: () {
            outputCanceled = true;
            return Future.wait<void>([]);
          },
          onSessionClose: (_) => sessionClosed = true,
        );
      });

      group('when all streams are closed,', () {
        setUp(() async {
          await manager.closeAllStreams();
          await inputClosed.future.timeout(const Duration(seconds: 5));
        });

        test('then the input stream finishes.', () {
          expect(inputClosed.isCompleted, isTrue);
        });

        test('then the output stream is canceled and its session closes.', () {
          expect(outputCanceled, isTrue);
          expect(sessionClosed, isTrue);
        });
      });
    },
  );

  group('Given one failing cancellation and another blocked cancellation,', () {
    late StateError error;
    late Completer<void> release;
    late Completer<void> failedSessionClosed;
    late Completer<void> blockedCancellationStarted;
    late bool blockedSessionClosed;

    setUp(() async {
      error = StateError('first cancellation failed');
      release = Completer<void>();
      cancellations.add(release);
      failedSessionClosed = Completer<void>();
      blockedCancellationStarted = Completer<void>();
      blockedSessionClosed = false;
      await openStream(
        onCancel: () => Future<List<void>>.error(error),
        onSessionClose: (_) => failedSessionClosed.complete(),
      );
      await openStream(
        onCancel: () {
          blockedCancellationStarted.complete();
          return Future.wait<void>([release.future]);
        },
        onSessionClose: (_) => blockedSessionClosed = true,
      );
    });

    group('when all streams are closed and cancellation is released,', () {
      late Object? caughtError;
      late bool closingCompletedBeforeRelease;
      late bool blockedSessionClosedBeforeRelease;

      setUp(() async {
        caughtError = null;
        var closingCompleted = false;
        final closing = manager.closeAllStreams().then<void>(
          (_) => closingCompleted = true,
          onError: (Object error) {
            caughtError = error;
            closingCompleted = true;
          },
        );
        await Future.wait([
          failedSessionClosed.future,
          blockedCancellationStarted.future,
        ]).timeout(const Duration(seconds: 5));
        // Let the failed cancellation propagate before observing whether
        // closeAllStreams is still waiting for the other stream.
        await Future<void>.delayed(Duration.zero);
        closingCompletedBeforeRelease = closingCompleted;
        blockedSessionClosedBeforeRelease = blockedSessionClosed;
        release.complete();
        await closing;
      });

      test('then closing waits for the remaining cancellation.', () {
        expect(closingCompletedBeforeRelease, isFalse);
        expect(blockedSessionClosedBeforeRelease, isFalse);
      });

      test('then both sessions close and the original error propagates.', () {
        expect(failedSessionClosed.isCompleted, isTrue);
        expect(blockedSessionClosed, isTrue);
        expect(caughtError, same(error));
      });
    });
  });
}

class _Endpoint extends Endpoint {}
