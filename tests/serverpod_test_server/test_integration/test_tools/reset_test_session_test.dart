import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import 'serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given no explicit resetTestSessions configuration when having multiple test cases',
    (endpoints, session) {
      group('when copying the session in the first test', () {
        late TestSession newSession;

        test(
            'then first test has modified newSession that should be reset due to default resetTestSessions.afterEach configuration',
            () async {
          newSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );

          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test(
            'then the second test has the reset newSession due to default resetTestSessions.afterEach configuration',
            () async {
          await expectLater(newSession.authenticationInfo, completion(isNull));
        });
      });
    },
    runMode: ServerpodRunMode.production,
  );

  withServerpod(
    'Given resetTestSessions set to afterEach',
    (endpoints, session) {
      group('when copying the session in setUpAll', () {
        late TestSession newSession;
        setUpAll(() async {
          newSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );
        });

        test('then the first test has the modified newSession', () async {
          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test('then the second test has the reset newSession', () async {
          await expectLater(newSession.authenticationInfo, completion(isNull));
        });
      });

      group('when copying the session in setUp', () {
        late TestSession newSession;
        setUp(() async {
          newSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );
        });

        test('then the first test has the modified newSession', () async {
          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test('then the second test has the modified newSession', () async {
          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });
      });

      group('when copying the session in the first test', () {
        late TestSession newSession;

        test('then the first test has the modified newSession', () async {
          newSession = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {},
            ),
          );

          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test('then the second test has the reset newSession', () async {
          await expectLater(newSession.authenticationInfo, completion(isNull));
        });
      });
    },
    resetTestSessions: ResetTestSessions.afterEach,
    runMode: ServerpodRunMode.production,
  );

  withServerpod(
    'Given resetTestSessions set to afterAll',
    (endpoints, session) {
      group('when modifying the session in setUpAll', () {
        setUpAll(() async {
          session = session.copyWith(
            authentication: AuthenticationOverride.authenticationInfo(
              123,
              {Scope('user')},
            ),
          );
        });

        test('then the first test has the modified session', () async {
          await expectLater(
            session.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });

        test('then the second test also has the modified session', () async {
          await expectLater(
            session.authenticationInfo,
            completion((a) => a.userId == 123),
          );
        });
      });

      group('when copying the session in the first test', () {
        late TestSession newSession;

        test('then the first test has the modified newSession', () async {
          newSession = session.copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
            333,
            {},
          ));

          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 333),
          );
        });

        test('then the second test has the reset newSession', () async {
          await expectLater(
            newSession.authenticationInfo,
            completion((a) => a.userId == 333),
          );
        });
      });
    },
    resetTestSessions: ResetTestSessions.afterAll,
    runMode: ServerpodRunMode.production,
  );
}
