import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_providers/jwt_provider.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_providers/sas_provider.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../jwt/utils/authentication_token_secrets_mock.dart';
import '../../serverpod_test_tools.dart';

void main() {
  setUpAll(() {
    final secrets = AuthenticationTokenSecretsMock()
      ..setHs512Algorithm()
      ..refreshTokenHashPepper = 'test-pepper';
    AuthenticationTokens.secretsTestOverride = secrets;
  });

  tearDownAll(() {
    AuthenticationTokens.secretsTestOverride = null;
  });

  group('TokenIssuer implementations', () {
    withServerpod(
      'Given JWT and SAS token issuers',
      (final sessionBuilder, final endpoints) {
        late Session session;
        late UuidValue authUserId;
        late TokenIssuer jwtIssuer;
        late TokenIssuer sasIssuer;

        setUp(() async {
          session = sessionBuilder.build();
          jwtIssuer = JwtTokenIssuer();
          sasIssuer = SasTokenIssuer();

          final authUser = await AuthUsers.create(session);
          authUserId = authUser.id;
        });

        group('JwtTokenIssuer', () {
          test('should issue JWT tokens with refresh tokens', () async {
            final result = await jwtIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            expect(result.token, isNotEmpty);
            expect(result.refreshToken, isNotNull);
            expect(result.refreshToken, isNotEmpty);
            expect(result.authUserId, equals(authUserId));
            expect(result.scopeNames, contains('test-scope'));
            expect(result.authStrategy, equals(AuthStrategy.jwt));
          });

          test('should create RefreshToken in database', () async {
            await jwtIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            final refreshTokens = await RefreshToken.db.find(
              session,
              where: (final t) => t.authUserId.equals(authUserId),
            );

            expect(refreshTokens, hasLength(1));
            expect(refreshTokens.first.method, equals('test-method'));
            expect(refreshTokens.first.authUserId, equals(authUserId));
          });

          test('should handle null scopes by using user scopes', () async {
            final result = await jwtIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: null,
              transaction: null,
            );

            expect(result.scopeNames, isEmpty);
          });
        });

        group('SASTokenIssuer', () {
          test('should issue session tokens without refresh tokens', () async {
            final result = await sasIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            expect(result.token, isNotEmpty);
            expect(result.refreshToken, isNull);
            expect(result.authUserId, equals(authUserId));
            expect(result.scopeNames, contains('test-scope'));
            expect(result.authStrategy, equals(AuthStrategy.session));
          });

          test('should create AuthSession in database', () async {
            await sasIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            final authSessions = await AuthSession.db.find(
              session,
              where: (final t) => t.authUserId.equals(authUserId),
            );

            expect(authSessions, hasLength(1));
            expect(authSessions.first.method, equals('test-method'));
            expect(authSessions.first.authUserId, equals(authUserId));
          });

          test('should handle null scopes by using user scopes', () async {
            final result = await sasIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: null,
              transaction: null,
            );

            expect(result.scopeNames, isEmpty);
          });
        });

        group('TokenIssuer interface compliance', () {
          test('should return different token types for different issuers',
              () async {
            final jwtResult = await jwtIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            final sasResult = await sasIssuer.issueToken(
              session: session,
              authUserId: authUserId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );

            expect(jwtResult.authStrategy, equals(AuthStrategy.jwt));
            expect(sasResult.authStrategy, equals(AuthStrategy.session));
            expect(jwtResult.refreshToken, isNotNull);
            expect(sasResult.refreshToken, isNull);
          });

          test('should handle transactions properly', () async {
            await session.db.transaction((final transaction) async {
              await jwtIssuer.issueToken(
                session: session,
                authUserId: authUserId,
                method: 'test-method',
                scopes: {const Scope('test-scope')},
                transaction: transaction,
              );

              await sasIssuer.issueToken(
                session: session,
                authUserId: authUserId,
                method: 'test-method',
                scopes: {const Scope('test-scope')},
                transaction: transaction,
              );
            });

            final refreshTokens = await RefreshToken.db.find(session);
            final authSessions = await AuthSession.db.find(session);

            expect(refreshTokens, hasLength(1));
            expect(authSessions, hasLength(1));
          });
        });
      },
    );
  });
}
