import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given AuthenticatedTestToolsEndpoint',
    (endpoints, session) {
      test(
          'when not authenticated and calling returnsString then throws UnauthenticatedEndpointCallTestException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.unauthenticated());

        final result =
            endpoints.authenticatedTestTools.returnsString(session, "Hello");
        await expectLater(
            result, throwsA(isA<UnauthenticatedEndpointCallTestException>()));
      });

      test(
          'when not having sufficient access scopes and calling returnsString then throws InsufficientEndpointAccessTestException',
          () async {
        session = session.copyWith(
          authentication: AuthenticationOverride.authenticationInfo(1234, {}),
        );

        final result =
            endpoints.authenticatedTestTools.returnsString(session, "Hello");
        await expectLater(
            result, throwsA(isA<InsufficientEndpointAccessTestException>()));
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
          'when not authenticated and calling returnsStream then throws UnauthenticatedEndpointCallTestException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.unauthenticated());

        final result =
            endpoints.authenticatedTestTools.returnsStream(session, 3).toList();
        await expectLater(
            result, throwsA(isA<UnauthenticatedEndpointCallTestException>()));
      });

      test(
          'when not having sufficient access scopes and calling returnsStream then throws InsufficientEndpointAccessTestException',
          () async {
        session = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
          1234,
          {},
        ));

        final result =
            endpoints.authenticatedTestTools.returnsStream(session, 3).toList();
        await expectLater(
            result, throwsA(isA<InsufficientEndpointAccessTestException>()));
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
    },
    runMode: ServerpodRunMode.production,
  );
}
