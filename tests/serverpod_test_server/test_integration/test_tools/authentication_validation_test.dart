import 'dart:async';

import 'package:serverpod/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given AuthenticatedTestToolsEndpoint',
    (endpoints, session) {
      test(
          'when not authenticated and calling returnsString then throws ServerpodUnauthenticatedException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.unauthenticated());

        final result =
            endpoints.authenticatedTestTools.returnsString(session, "Hello");
        await expectLater(
            result, throwsA(isA<ServerpodUnauthenticatedException>()));
      });

      test(
          'when not having sufficient access scopes and calling returnsString then throws ServerpodInsufficientAccessException',
          () async {
        session = session.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1234, {}),
        );

        final result =
            endpoints.authenticatedTestTools.returnsString(session, "Hello");
        await expectLater(
            result, throwsA(isA<ServerpodInsufficientAccessException>()));
      });

      test('when authorized and calling returnsString then echoes string',
          () async {
        session = session.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            1234,
            {Scope('user')},
          ),
        );

        final result = await endpoints.authenticatedTestTools
            .returnsString(session, "Hello");
        expect(result, "Hello");
      });

      test(
          'when not authenticated and calling returnsStream then throws ServerpodUnauthenticatedException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.unauthenticated());

        final result =
            endpoints.authenticatedTestTools.returnsStream(session, 3).toList();
        await expectLater(
            result, throwsA(isA<ServerpodUnauthenticatedException>()));
      });

      test(
          'when not having sufficient access scopes and calling returnsStream then throws ServerpodInsufficientAccessException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
          1234,
          {},
        ));

        final result =
            endpoints.authenticatedTestTools.returnsStream(session, 3).toList();
        await expectLater(
            result, throwsA(isA<ServerpodInsufficientAccessException>()));
      });

      test('when authorized and calling returnsStream then returns a stream',
          () async {
        session = session.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(
            1234,
            {Scope('user')},
          ),
        );

        final result = await endpoints.authenticatedTestTools
            .returnsStream(session, 3)
            .toList();
        expect(result, [0, 1, 2]);
      });

      group('when connected to an authenticated streaming method', () {
        late Completer<dynamic> streamClosedCompleter;
        late Completer<int> valueReceivedCompleter;
        late StreamController<int> inStream;

        var authenticatedUserId = 1;

        setUp(() async {
          streamClosedCompleter = Completer<dynamic>();
          inStream = StreamController<int>();
          Stream<int> outStream;
          var authenticatedSession = session.copyWith(
            authentication:
                AuthenticationOverride.authenticationInfo(1, {Scope('user')}),
          );
          outStream = endpoints.authenticatedTestTools.intEchoStream(
            authenticatedSession,
            inStream.stream,
          );

          valueReceivedCompleter = Completer<int>();
          outStream.listen((event) {
            if (valueReceivedCompleter.isCompleted) {
              return;
            }
            valueReceivedCompleter.complete(event);
          }, onError: (e) {
            streamClosedCompleter.complete(e);
          });

          inStream.add(1);
          // Validate that the stream works
          await valueReceivedCompleter.future;
          assert(valueReceivedCompleter.isCompleted);
        });

        test(
            'and the authenticated user is revoked then stream is closed with ServerpodUnauthenticatedException.',
            () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationUser(),
            ),
            completion(true),
          );

          await expectLater(
            streamClosedCompleter.future.timeout(
              Duration(seconds: 5),
            ),
            completes,
          );
          var exception = await streamClosedCompleter.future;
          expect(exception, isA<ServerpodUnauthenticatedException>());
          expect(() => inStream.stream.first, throwsA(isA<StateError>()));
        });

        test(
            'and the required scope for an endpoint is revoked then stream is closed with ServerpodInsufficientAccessException.',
            () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationScope(scopes: ['user']),
            ),
            completion(true),
          );

          await expectLater(
            streamClosedCompleter.future.timeout(
              Duration(seconds: 5),
            ),
            completes,
          );
          var exception = await streamClosedCompleter.future;
          expect(exception, isA<ServerpodInsufficientAccessException>());
        });
      });

      group('when connected to two authenticated streaming methods', () {
        late Completer<dynamic> streamClosedCompleter1;
        late Completer<int> valueReceivedCompleter1;
        late StreamController<int> inStream1;

        late Completer<dynamic> streamClosedCompleter2;
        late Completer<int> valueReceivedCompleter2;
        late StreamController<int> inStream2;

        var authenticatedUserId = 1;

        setUp(() async {
          streamClosedCompleter1 = Completer<dynamic>();
          inStream1 = StreamController<int>();
          Stream<int> outStream;

          var authenticatedSession = session.copyWith(
            authentication:
                AuthenticationOverride.authenticationInfo(1, {Scope('user')}),
          );

          outStream = endpoints.authenticatedTestTools
              .intEchoStream(authenticatedSession, inStream1.stream);
          valueReceivedCompleter1 = Completer<int>();
          outStream.listen((event) {
            if (valueReceivedCompleter1.isCompleted) {
              return;
            }
            valueReceivedCompleter1.complete(event);
          }, onError: (e) {
            streamClosedCompleter1.complete(e);
          });

          inStream1.add(1);
          // Validate that the stream works
          await valueReceivedCompleter1.future.timeout(Duration(seconds: 5));
          assert(valueReceivedCompleter1.isCompleted);

          streamClosedCompleter2 = Completer<dynamic>();
          inStream2 = StreamController<int>();
          Stream<int> outStream2;

          outStream2 = endpoints.authenticatedTestTools
              .intEchoStream(authenticatedSession, inStream2.stream);
          valueReceivedCompleter2 = Completer<int>();
          outStream2.listen((event) {
            if (valueReceivedCompleter2.isCompleted) {
              return;
            }
            valueReceivedCompleter2.complete(event);
          }, onError: (e) {
            streamClosedCompleter2.complete(e);
          });

          inStream2.add(1);
          // Validate that the stream works
          await valueReceivedCompleter2.future.timeout(Duration(seconds: 5));
          assert(valueReceivedCompleter2.isCompleted);
        });

        test(
            'and the authenticated user is revoked then streams are closed with ServerpodUnauthenticatedException.',
            () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationUser(),
            ),
            completion(true),
          );

          await expectLater(
            streamClosedCompleter1.future.timeout(Duration(seconds: 5)),
            completes,
          );
          var exception = await streamClosedCompleter1.future;
          expect(exception, isA<ServerpodUnauthenticatedException>());

          await expectLater(
            streamClosedCompleter2.future.timeout(Duration(seconds: 5)),
            completes,
          );
          exception = await streamClosedCompleter2.future;
          expect(exception, isA<ServerpodUnauthenticatedException>());
        });

        test(
            'and the required scope for an endpoint is revoked then streams are closed with ServerpodInsufficientAccessException.',
            () async {
          await expectLater(
            session.messages.authenticationRevoked(
              authenticatedUserId,
              RevokedAuthenticationScope(scopes: ['user']),
            ),
            completion(true),
          );

          await expectLater(
            streamClosedCompleter1.future,
            completes,
          );
          var exception = await streamClosedCompleter1.future;
          expect(exception, isA<ServerpodInsufficientAccessException>());

          await expectLater(
            streamClosedCompleter2.future,
            completes,
          );
          exception = await streamClosedCompleter2.future;
          expect(exception, isA<ServerpodInsufficientAccessException>());
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );
}
