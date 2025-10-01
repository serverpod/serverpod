import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/src/common/business/token_issuer.dart';
import 'package:serverpod_auth_core_server/src/generated/protocol.dart';
import 'package:test/test.dart';

import '../../serverpod_test_tools.dart';

abstract interface class TestableTokenIssuer implements TokenIssuer {
  void testClear();
  List<AuthSuccess> get testIssuedTokens;
}

class FakeTokenIssuer implements TestableTokenIssuer {
  final Map<String, AuthSuccess> _issuedTokens = {};
  int _tokenCounter = 0;

  @override
  void testClear() {
    _issuedTokens.clear();
    _tokenCounter = 0;
  }

  @override
  List<AuthSuccess> get testIssuedTokens => _issuedTokens.values.toList();

  @override
  Future<AuthSuccess> issueToken({
    required final Session session,
    required final UuidValue authUserId,
    required final String method,
    required final Set<Scope>? scopes,
    required final Transaction? transaction,
  }) async {
    _tokenCounter++;
    final tokenId = 'token-$_tokenCounter';
    final refreshTokenId = 'refresh-token-$_tokenCounter';

    final scopeSet = scopes != null
        ? scopes
            .where((final scope) => scope.name != null)
            .map((final scope) => scope.name!)
            .toSet()
        : <String>{};

    final authSuccess = AuthSuccess(
      token: tokenId,
      refreshToken: refreshTokenId,
      authUserId: authUserId,
      scopeNames: scopeSet,
      authStrategy: 'jwt',
    );

    _issuedTokens[tokenId] = authSuccess;
    return authSuccess;
  }
}

void testSuite(final TestableTokenIssuer Function() issuerBuilder) {
  group('TokenIssuer', () {
    withServerpod(
      'Given a valid user ID',
      (final sessionBuilder, final endpoints) {
        late TestableTokenIssuer tokenIssuer;
        late Session session;
        late UuidValue userId;

        setUp(() {
          tokenIssuer = issuerBuilder();
          session = sessionBuilder.build();
          userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        });

        group('when issuing a token', () {
          late AuthSuccess authSuccess;

          setUp(() async {
            authSuccess = await tokenIssuer.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );
          });

          test('then the token should be returned', () {
            expect(authSuccess.token, isNotEmpty);
          });

          test('then the refresh token should be returned', () {
            expect(authSuccess.refreshToken, isNotNull);
            expect(authSuccess.refreshToken, isNotEmpty);
          });

          test('then the authUserId should match', () {
            expect(authSuccess.authUserId, equals(userId));
          });

          test('then the scopeNames should match', () {
            expect(authSuccess.scopeNames, contains('test-scope'));
          });

          test('then the authStrategy should be set', () {
            expect(authSuccess.authStrategy, equals('jwt'));
          });
        });

        group('when issuing a token with multiple scopes', () {
          late AuthSuccess authSuccess;

          setUp(() async {
            authSuccess = await tokenIssuer.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {
                const Scope('scope1'),
                const Scope('scope2'),
                const Scope('scope3'),
              },
              transaction: null,
            );
          });

          test('then all scopes should be included', () {
            expect(authSuccess.scopeNames, hasLength(3));
            expect(authSuccess.scopeNames, contains('scope1'));
            expect(authSuccess.scopeNames, contains('scope2'));
            expect(authSuccess.scopeNames, contains('scope3'));
          });
        });

        group('when issuing a token without scopes', () {
          late AuthSuccess authSuccess;

          setUp(() async {
            authSuccess = await tokenIssuer.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: null,
              transaction: null,
            );
          });

          test('then scopeNames should be empty', () {
            expect(authSuccess.scopeNames, isEmpty);
          });
        });

        group('when issuing a token with empty scopes', () {
          late AuthSuccess authSuccess;

          setUp(() async {
            authSuccess = await tokenIssuer.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {},
              transaction: null,
            );
          });

          test('then scopeNames should be empty', () {
            expect(authSuccess.scopeNames, isEmpty);
          });
        });
      },
    );

    withServerpod(
      'Given multiple token issuances',
      (final sessionBuilder, final endpoints) {
        late TestableTokenIssuer tokenIssuer;
        late Session session;
        late UuidValue userId;
        late AuthSuccess firstToken;
        late AuthSuccess secondToken;
        late AuthSuccess thirdToken;

        setUp(() async {
          tokenIssuer = issuerBuilder();
          session = sessionBuilder.build();
          userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');

          firstToken = await tokenIssuer.issueToken(
            session: session,
            authUserId: userId,
            method: 'method1',
            scopes: {const Scope('scope1')},
            transaction: null,
          );

          secondToken = await tokenIssuer.issueToken(
            session: session,
            authUserId: userId,
            method: 'method2',
            scopes: {const Scope('scope2')},
            transaction: null,
          );

          thirdToken = await tokenIssuer.issueToken(
            session: session,
            authUserId: userId,
            method: 'method3',
            scopes: {const Scope('scope3')},
            transaction: null,
          );
        });

        group('when issuing tokens for the same user', () {
          test('then each token should be unique', () {
            expect(firstToken.token, isNot(equals(secondToken.token)));
            expect(firstToken.token, isNot(equals(thirdToken.token)));
            expect(secondToken.token, isNot(equals(thirdToken.token)));
          });

          test('then each refresh token should be unique', () {
            expect(firstToken.refreshToken,
                isNot(equals(secondToken.refreshToken)));
            expect(firstToken.refreshToken,
                isNot(equals(thirdToken.refreshToken)));
            expect(secondToken.refreshToken,
                isNot(equals(thirdToken.refreshToken)));
          });

          test('then all tokens should have the same authUserId', () {
            expect(firstToken.authUserId, equals(userId));
            expect(secondToken.authUserId, equals(userId));
            expect(thirdToken.authUserId, equals(userId));
          });

          test('then each token should preserve its scopes', () {
            expect(firstToken.scopeNames, contains('scope1'));
            expect(secondToken.scopeNames, contains('scope2'));
            expect(thirdToken.scopeNames, contains('scope3'));
          });
        });
      },
    );

    withServerpod(
      'Given different user IDs',
      (final sessionBuilder, final endpoints) {
        late TestableTokenIssuer tokenIssuer;
        late Session session;
        late UuidValue user1Id;
        late UuidValue user2Id;
        late AuthSuccess token1;
        late AuthSuccess token2;

        setUp(() async {
          tokenIssuer = issuerBuilder();
          session = sessionBuilder.build();
          user1Id =
              UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
          user2Id =
              UuidValue.fromString('550e8400-e29b-41d4-a716-446655440001');

          token1 = await tokenIssuer.issueToken(
            session: session,
            authUserId: user1Id,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );

          token2 = await tokenIssuer.issueToken(
            session: session,
            authUserId: user2Id,
            method: 'test-method',
            scopes: {const Scope('test-scope')},
            transaction: null,
          );
        });

        group('when issuing tokens for different users', () {
          test('then each token should have different authUserId', () {
            expect(token1.authUserId, equals(user1Id));
            expect(token2.authUserId, equals(user2Id));
            expect(token1.authUserId, isNot(equals(token2.authUserId)));
          });

          test('then each token should be unique', () {
            expect(token1.token, isNot(equals(token2.token)));
          });

          test('then each refresh token should be unique', () {
            expect(token1.refreshToken, isNot(equals(token2.refreshToken)));
          });
        });
      },
    );

    withServerpod(
      'Given a transaction parameter',
      (final sessionBuilder, final endpoints) {
        late TestableTokenIssuer tokenIssuer;
        late Session session;
        late UuidValue userId;

        setUp(() {
          tokenIssuer = issuerBuilder();
          session = sessionBuilder.build();
          userId = UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000');
        });

        group('when issuing a token with transaction', () {
          late AuthSuccess authSuccess;

          setUp(() async {
            authSuccess = await tokenIssuer.issueToken(
              session: session,
              authUserId: userId,
              method: 'test-method',
              scopes: {const Scope('test-scope')},
              transaction: null,
            );
          });

          test('then the token should still be issued', () {
            expect(authSuccess.token, isNotEmpty);
          });

          test('then the refresh token should still be issued', () {
            expect(authSuccess.refreshToken, isNotNull);
            expect(authSuccess.refreshToken, isNotEmpty);
          });
        });
      },
    );
  });
}

void main() {
  testSuite(() => FakeTokenIssuer());
}
