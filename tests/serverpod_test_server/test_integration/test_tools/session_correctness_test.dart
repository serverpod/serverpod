import 'dart:async';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_test_server/src/endpoints/test_tools.dart';
import 'package:serverpod_test_server/test_util/mock_stdout.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given calling endpoint returning Future',
    (sessionBuilder, endpoints) {
      group('when using the same session between two calls', () {
        late UuidValue sessionId1;
        late UuidValue sessionId2;

        setUp(() async {
          sessionId1 = await endpoints.testTools.returnsSessionId(
            sessionBuilder,
          );
          sessionId2 = await endpoints.testTools.returnsSessionId(
            sessionBuilder,
          );
        });

        test('then session id is unique in each endpoint call', () async {
          expect(sessionId1, isNot(sessionId2));
        });
      });

      test(
        "when method is returning the session's `endpoint` and `method` properties then the correct name and method is returned",
        () async {
          var [endpoint, method] = await endpoints.testTools
              .returnsSessionEndpointAndMethod(sessionBuilder);
          expect(endpoint, 'testTools');
          expect(method, 'returnsSessionEndpointAndMethod');
        },
      );

      test(
        'when method logs to session then can be observered in stdout',
        () async {
          var stdout = MockStdout();
          await IOOverrides.runZoned(
            () async {
              await endpoints.testTools.logMessageWithSession(
                sessionBuilder.copyWith(
                  enableLogging: true,
                ),
              );
            },
            stdout: () => stdout,
            stderr: () => stdout,
          );

          expect(
            stdout.output,
            contains('"message":"test session log in endpoint"'),
          );
        },
      );

      group('when method throws an exception', () {
        late Future future;

        setUp(() async {
          TestToolsEndpoint.willCloseListenerCalled = Completer();
          future = endpoints.testTools.addWillCloseListenerToSessionAndThrow(
            sessionBuilder.copyWith(
              enableLogging: true,
            ),
          );
        });

        tearDown(() async {
          TestToolsEndpoint.willCloseListenerCalled = null;
        });

        test(
          'then the session is closed so that the `willCloseListener` is called',
          () async {
            try {
              await future;
            } catch (_) {}

            await expectLater(
              TestToolsEndpoint.willCloseListenerCalled?.future,
              completes,
            );
          },
        );
      });
    },
  );

  withServerpod(
    'Given calling endpoint returning Stream',
    (sessionBuilder, endpoints) {
      group('when using the same session between two calls', () {
        late Stream<UuidValue> sessionId1Stream;
        late Stream<UuidValue> sessionId2Stream;

        setUp(() async {
          sessionId1Stream = await endpoints.testTools
              .returnsSessionIdFromStream(sessionBuilder);
          sessionId2Stream = await endpoints.testTools
              .returnsSessionIdFromStream(sessionBuilder);
        });

        test('then session id is unique in each endpoint call', () async {
          var sessionId1 = await sessionId1Stream.first;
          var sessionId2 = await sessionId2Stream.first;
          expect(sessionId1, isNot(sessionId2));
        });
      });

      test(
        "when method is returning the session's `endpoint` and `method` properties then the correct name and method is returned",
        () async {
          var [endpoint, method] = await endpoints.testTools
              .returnsSessionEndpointAndMethodFromStream(sessionBuilder)
              .take(2)
              .toList();

          expect(endpoint, 'testTools');
          expect(method, 'returnsSessionEndpointAndMethodFromStream');
        },
      );

      group('when method throws an exception', () {
        late Stream stream;

        setUp(() async {
          TestToolsEndpoint.willCloseListenerCalled = Completer();
          stream = endpoints.testTools
              .addWillCloseListenerToSessionIntStreamMethodAndThrow(
                sessionBuilder.copyWith(
                  enableLogging: true,
                ),
              );
        });

        tearDown(() async {
          TestToolsEndpoint.willCloseListenerCalled = null;
        });

        test(
          'then the session is closed so that the `willCloseListener` is called',
          () async {
            try {
              await stream.take(1);
            } catch (_) {}
            await flushEventQueue();

            await expectLater(
              TestToolsEndpoint.willCloseListenerCalled?.future,
              completes,
            );
          },
        );
      });
    },
  );
}
