import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:serverpod_auth_idp_server/providers/firebase.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  final tokenManagerConfig = ServerSideSessionsConfig(
    sessionKeyHashPepper: 'test-pepper-long-enough',
  );

  setUp(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [
        const FirebaseIdpConfig(
          credentials: FirebaseServiceAccountCredentials(
            projectId: 'project',
          ),
        ),
      ],
    );
  });

  tearDown(() async {
    AuthServices.set(
      tokenManagerBuilders: [tokenManagerConfig],
      identityProviderBuilders: [],
    );
  });

  withServerpod(
    'Given an unauthenticated session',
    (final sessionBuilder, final endpoints) {
      test(
        'when calling hasAccount then it returns false',
        () async {
          final result = await endpoints.firebaseAccount.hasAccount(
            sessionBuilder,
          );
          expect(result, isFalse);
        },
      );
    },
  );

  withServerpod('Given an authenticated session but no Firebase account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late TestSessionBuilder session;

    setUp(() async {
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          const Uuid().v4obj().uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns false',
      () async {
        final result = await endpoints.firebaseAccount.hasAccount(session);
        expect(result, isFalse);
      },
    );
  });

  withServerpod('Given an authenticated session with a Firebase account', (
    final sessionBuilder,
    final endpoints,
  ) {
    late AuthUserModel authUser;
    late TestSessionBuilder session;

    setUp(() async {
      final setupSession = sessionBuilder.build();
      authUser = await const AuthUsers().create(setupSession);
      await FirebaseAccount.db.insertRow(
        setupSession,
        FirebaseAccount(
          userIdentifier: 'firebase-id-${const Uuid().v4()}',
          authUserId: authUser.id,
          email: 'test-${const Uuid().v4()}@gmail.com',
        ),
      );
      session = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          authUser.id.uuid,
          {},
        ),
      );
    });

    test(
      'when calling hasAccount then it returns true',
      () async {
        final result = await endpoints.firebaseAccount.hasAccount(session);
        expect(result, isTrue);
      },
    );
  });
}
