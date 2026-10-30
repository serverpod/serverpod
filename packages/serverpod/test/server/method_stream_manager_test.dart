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
  late List<String> events;

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
    events = [];
    manager = MethodStreamManager(
      request: null,
      onOutputStreamValue: (_, value, _) => events.add('value:$value'),
      onOutputStreamClosed: (_, reason, _) =>
          events.add('closed:${reason?.name}'),
    );
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
    UuidValue? methodStreamId,
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
      methodStreamId: methodStreamId ?? const Uuid().v4obj(),
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
      late UuidValue methodStreamId;

      setUp(() async {
        canceled = false;
        closed = false;
        methodStreamId = const Uuid().v4obj();
        await openStream(
          methodStreamId: methodStreamId,
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

      test(
        'when the individual stream is closed, '
        'then the stream is canceled and its session closes.',
        () async {
          await manager.closeStream(
            endpoint: 'test',
            method: 'stream',
            methodStreamId: methodStreamId,
            reason: CloseReason.done,
          );

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

  group('Given an open output stream,', () {
    late StreamController<int> controller;
    late UuidValue methodStreamId;

    setUp(() async {
      methodStreamId = const Uuid().v4obj();
      controller = await openStream(methodStreamId: methodStreamId);
    });

    test(
      'when the stream is closed while the endpoint emits a value, '
      'then no value is delivered after the stream is reported closed.',
      () async {
        final closing = manager.closeStream(
          endpoint: 'test',
          method: 'stream',
          methodStreamId: methodStreamId,
          reason: CloseReason.done,
        );
        controller.add(1);
        await closing;
        await Future<void>.delayed(Duration.zero);

        expect(events, ['closed:done']);
      },
    );
  });

  group(
    'Given an output generator waiting for input with asynchronous final cleanup,',
    () {
      late UuidValue methodStreamId;
      late Completer<void> producerFinished;
      late Completer<void> releaseCleanup;
      late Completer<void> sessionClosing;
      late Completer<void> releaseSession;
      late int sessionsClosed;

      setUp(() async {
        methodStreamId = const Uuid().v4obj();
        producerFinished = Completer<void>();
        releaseCleanup = Completer<void>();
        sessionClosing = Completer<void>();
        releaseSession = Completer<void>();
        sessionsClosed = 0;
        final waitingForInput = Completer<void>();
        final session = await pod.createSession(enableLogging: false);
        sessions.add(session);
        session.addWillCloseListener((_) async {
          sessionsClosed++;
          sessionClosing.complete();
          await releaseSession.future;
        });
        final endpoint = _Endpoint()..initialize(pod.server, 'test', null);
        final input = StreamParameterDescription<int>(
          name: 'input',
          nullable: false,
        );
        manager.createStream(
          methodStreamCallContext: MethodStreamCallContext(
            method: MethodStreamConnector(
              name: 'stream',
              params: {},
              returnType: MethodStreamReturnType.streamType,
              streamParams: {'input': input},
              call: (_, _, streams) async* {
                try {
                  waitingForInput.complete();
                  await for (final value in streams['input']!) {
                    yield value;
                  }
                } finally {
                  producerFinished.complete();
                  await releaseCleanup.future;
                }
              },
            ),
            arguments: {},
            inputStreams: [input],
            endpoint: endpoint,
            fullEndpointPath: 'test',
          ),
          methodStreamId: methodStreamId,
          session: session,
        );
        addTearDown(() async {
          if (!releaseCleanup.isCompleted) releaseCleanup.complete();
          if (!releaseSession.isCompleted) releaseSession.complete();
          await manager.closeAllStreams();
        });
        await waitingForInput.future.timeout(const Duration(seconds: 5));
      });

      group(
        'when its output closes and concurrent closes join the cleanup,',
        () {
          late List<String> completedBeforeRelease;
          late List<String> completedBeforeSessionRelease;
          late int sessionsClosedBeforeRelease;
          late List<String> completed;

          setUp(() async {
            completed = [];
            final closing = manager
                .closeStream(
                  endpoint: 'test',
                  method: 'stream',
                  methodStreamId: methodStreamId,
                  reason: CloseReason.error,
                )
                .then((_) => completed.add('first'));
            // Closing this output alone must unblock the generator's input.
            // Do not let closeAllStreams supply that missing cleanup for it.
            await producerFinished.future.timeout(const Duration(seconds: 5));
            final repeated = manager
                .closeStream(
                  endpoint: 'test',
                  method: 'stream',
                  methodStreamId: methodStreamId,
                  reason: CloseReason.done,
                )
                .then((_) => completed.add('repeated'));
            final disconnected = manager.closeAllStreams().then(
              (_) => completed.add('all'),
            );
            // Allow an incorrectly unjoined close to settle before observing it.
            await Future<void>.delayed(Duration.zero);
            completedBeforeRelease = [...completed];
            sessionsClosedBeforeRelease = sessionsClosed;
            releaseCleanup.complete();
            await sessionClosing.future.timeout(const Duration(seconds: 5));
            await Future<void>.delayed(Duration.zero);
            completedBeforeSessionRelease = [...completed];
            releaseSession.complete();
            await Future.wait([closing, repeated, disconnected]);
          });

          test(
            'then input closure unblocks the producer before the timeout.',
            () {
              expect(producerFinished.isCompleted, isTrue);
              expect(events, ['closed:error']);
              expect(manager.openInputStreamCount, 0);
              expect(manager.openOutputStreamCount, 0);
            },
          );

          test('then every close awaits the producer and session cleanup.', () {
            expect(completedBeforeRelease, isEmpty);
            expect(completedBeforeSessionRelease, isEmpty);
            expect(sessionsClosedBeforeRelease, 0);
            expect(completed, unorderedEquals(['first', 'repeated', 'all']));
            expect(sessionsClosed, 1);
          });
        },
      );
    },
  );

  group('Given an output stream whose cancellation never completes,', () {
    late UuidValue methodStreamId;

    setUp(() async {
      final release = Completer<void>();
      cancellations.add(release);
      methodStreamId = const Uuid().v4obj();
      await openStream(
        methodStreamId: methodStreamId,
        onCancel: () => release.future,
      );
    });

    test(
      'when the stream is closed, '
      'then closing completes and the stream is reported closed.',
      () async {
        await expectLater(
          manager
              .closeStream(
                endpoint: 'test',
                method: 'stream',
                methodStreamId: methodStreamId,
                reason: CloseReason.done,
              )
              .timeout(const Duration(seconds: 9)),
          completes,
        );

        expect(events, ['closed:done']);
      },
    );
  });
}

class _Endpoint extends Endpoint {}
