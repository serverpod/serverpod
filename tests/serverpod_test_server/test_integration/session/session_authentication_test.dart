import 'package:serverpod/serverpod.dart';
import 'package:serverpod/src/server/session.dart';
import 'package:test/test.dart';

import '../test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod(
    'Given a session with no authentication',
    (sessionBuilder, endpoints) {
      late Session session;

      setUp(() async {
        session = await sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.unauthenticated(),
            )
            .buildWithAuthentication();
      });

      tearDown(() async {
        await session.close();
      });

      test(
        'when authenticated getter is accessed then it returns null',
        () {
          expect(session.authenticated, isNull);
        },
      );

      test(
        'when isUserSignedIn is checked then it returns false',
        () {
          expect(session.isUserSignedIn, isFalse);
        },
      );
    },
  );

  withServerpod(
    'Given a session with valid authentication',
    (sessionBuilder, endpoints) {
      const userId = '12345';
      late Session session;

      setUp(() async {
        session = await sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                userId,
                {Scope.admin},
              ),
            )
            .buildWithAuthentication();
      });

      tearDown(() async {
        await session.close();
      });

      test(
        'when authenticated is accessed then it contains user info',
        () {
          var authInfo = session.authenticated;
          expect(authInfo, isNotNull);
          expect(authInfo?.userIdentifier, equals(userId));
          expect(authInfo?.scopes, contains(Scope.admin));
        },
      );

      test(
        'when isUserSignedIn is checked then it returns true',
        () {
          expect(session.isUserSignedIn, isTrue);
        },
      );
    },
  );

  withServerpod(
    'Given a session with authentication',
    (sessionBuilder, endpoints) {
      const userId = 'user-1';
      late Session session;

      setUp(() async {
        session = await sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                userId,
                {},
              ),
            )
            .buildWithAuthentication();
      });

      tearDown(() async {
        await session.close();
      });

      test(
        'when updateAuthenticationKey is called with null then authentication is cleared',
        () async {
          expect(session.authenticated, isNotNull);

          await session.updateAuthenticationKey(null);

          expect(session.authenticated, isNull);
        },
      );
    },
  );

  withServerpod(
    'Given a session with authentication and an authenticationHandler',
    (sessionBuilder, endpoints) {
      const initialUserId = 'user-1';
      const newUserId = 'user-2';
      late Session session;

      setUp(() async {
        session = await sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                initialUserId,
                {},
              ),
            )
            .buildWithAuthentication();

        session.server.authenticationHandler = (session, key) async {
          if (key == 'new-key') {
            return AuthenticationInfo(newUserId, {});
          }
          return null;
        };
      });

      tearDown(() async {
        await session.close();
      });

      group('when updateAuthenticationKey is called with a new key', () {
        setUp(() async {
          await session.updateAuthenticationKey('new-key');
        });

        test('then authenticated user is updated to new user', () {
          expect(session.authenticated?.userIdentifier, equals(newUserId));
        });
      });
    },
  );

  withServerpod(
    'Given a session with authentication and no authenticationHandler',
    (sessionBuilder, endpoints) {
      const initialUserId = 'user-1';
      late Session session;

      setUp(() async {
        session = await sessionBuilder
            .copyWith(
              authentication: AuthenticationOverride.authenticationInfo(
                initialUserId,
                {},
              ),
            )
            .buildWithAuthentication();
      });

      tearDown(() async {
        await session.close();
      });

      group('when updateAuthenticationKey is called with null', () {
        late AuthenticationInfo? authBeforeUpdate;

        setUp(() async {
          authBeforeUpdate = session.authenticated;
        });

        test('then authentication was populated before update', () {
          expect(authBeforeUpdate, isNotNull);
        });

        test('then authentication is cleared after update', () async {
          await session.updateAuthenticationKey(null);
          expect(session.authenticated, isNull);
        });
      });
    },
  );
}
