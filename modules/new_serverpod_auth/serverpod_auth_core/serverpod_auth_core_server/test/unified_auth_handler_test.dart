import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/unified.dart';
import 'package:test/test.dart';

import 'jwt/utils/authentication_token_secrets_mock.dart';
import 'serverpod_test_tools.dart';
import 'session/test_utils.dart';

void main() {
  final authSessionConfig =
      AuthSessionsConfig(sessionKeyHashPepper: 'test-pepper');

  final authSessions = AuthSessions(
    config: authSessionConfig,
  );

  AuthConfig.set(
    primaryTokenManager: AuthSessionsTokenManager(
      config: authSessionConfig,
    ),
    identityProviders: [],
  );
  withServerpod('Given a valid SAS session and a valid JWT token,',
      (final sessionBuilder, final endpoints) {
    late Session session;
    late AuthSuccess sasAuthSuccess;
    late AuthSuccess jwtAuthSuccess;

    setUp(() async {
      AuthenticationTokens.secretsTestOverride =
          AuthenticationTokenSecretsMock()
            ..setHs512Algorithm()
            ..refreshTokenHashPepper = 'some pepper 123';

      session = sessionBuilder.build();

      sasAuthSuccess = (await authSessions.createSession(
        session,
        authUserId: await createAuthUser(session),
        scopes: {const Scope('sas')},
        method: 'test',
      ));

      jwtAuthSuccess = await AuthenticationTokens.createTokens(
        session,
        authUserId: await createAuthUser(session),
        scopes: {const Scope('jwt')},
        method: 'test',
      );
    });

    test(
        'when calling with a SAS key, then it validates the SAS key and returns its AuthenticationInfo.',
        () async {
      final authInfo = await UnifiedAuthTokens.authenticationHandler(
        session,
        sasAuthSuccess.token,
      );

      expect(authInfo, isNotNull);
      expect(authInfo!.authUserId, sasAuthSuccess.authUserId);
      expect(authInfo.scopes, {const Scope('sas')});
    });

    test(
        'when calling with a JWT token, then it validates the JWT token and returns its AuthenticationInfo.',
        () async {
      final authInfo = await UnifiedAuthTokens.authenticationHandler(
        session,
        jwtAuthSuccess.token,
      );

      expect(authInfo, isNotNull);
      expect(authInfo!.authUserId, jwtAuthSuccess.authUserId);
      expect(authInfo.scopes, {const Scope('jwt')});
    });

    test('when calling with a completely invalid key, then it returns null.',
        () async {
      final authInfo = await UnifiedAuthTokens.authenticationHandler(
        session,
        'completely-invalid-key',
      );

      expect(authInfo, isNull);
    });
  });
}
