import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:serverpod_auth_core_server/session.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager.dart';
import 'package:serverpod_auth_core_server/src/common/integrations/token_manager_factory.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends TokenManager>(
  final TokenManagerFactory<T> Function() factoryBuilder,
) {
  group(
    'Given a token manager factory',
    () {
      late TokenManagerFactory<T> factory;
      late AuthUsers authUsers;

      setUp(() {
        factory = factoryBuilder();
        authUsers = const AuthUsers();
      });

      test(
        'when constructing a token manager the token manager should be constructed',
        () {
          final tokenManager = factory.construct(authUsers: authUsers);
          expect(tokenManager, isNotNull);
          expect(tokenManager, isA<T>());
        },
      );

      test(
        'when constructing multiple token managers the token managers should be unique',
        () {
          final tokenManager1 = factory.construct(authUsers: authUsers);
          final tokenManager2 = factory.construct(authUsers: authUsers);
          expect(tokenManager1, isNot(same(tokenManager2)));
        },
      );

      test(
        'when constructing with different authUsers instances, then different instances are created',
        () {
          const authUsers1 = AuthUsers();
          const authUsers2 = AuthUsers();
          final tokenManager1 = factory.construct(authUsers: authUsers1);
          final tokenManager2 = factory.construct(authUsers: authUsers2);
          expect(tokenManager1, isNot(same(tokenManager2)));
        },
      );
    },
  );
}

void main() {
  testSuite<FakeTokenManager>(
    () => FakeTokenManagerFactory(tokenStorage: FakeTokenStorage()),
  );

  testSuite<AuthSessionsTokenManager>(
    () => AuthSessionsTokenManagerFactory(
      AuthSessionsConfig(
        sessionKeyHashPepper: 'test-pepper',
      ),
    ),
  );

  testSuite<AuthenticationTokensTokenManager>(
    () => AuthenticationTokensTokenManagerFactory(
      AuthenticationTokenConfig(
        algorithm: HmacSha512AuthenticationTokenAlgorithmConfiguration(
          key: SecretKey('test-private-key-for-HS512'),
        ),
        refreshTokenHashPepper: 'test-pepper',
      ),
    ),
  );
}
