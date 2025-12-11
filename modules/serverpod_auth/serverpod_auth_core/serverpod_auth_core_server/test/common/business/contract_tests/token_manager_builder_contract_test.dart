import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

import '../fakes/fakes.dart';

void testSuite<T extends TokenManager>(
  final TokenManagerBuilder<T> Function() createTokenManagerBuilder,
) {
  group(
    'Given a token manager builder',
    () {
      late TokenManagerBuilder<T> builder;
      late AuthUsers authUsers;

      setUp(() {
        builder = createTokenManagerBuilder();
        authUsers = const AuthUsers();
      });

      test(
        'when building a token manager the token manager should be built',
        () {
          final tokenManager = builder.build(authUsers: authUsers);
          expect(tokenManager, isNotNull);
          expect(tokenManager, isA<T>());
        },
      );

      test(
        'when building multiple token managers the token managers should be unique',
        () {
          final tokenManager1 = builder.build(authUsers: authUsers);
          final tokenManager2 = builder.build(authUsers: authUsers);
          expect(tokenManager1, isNot(same(tokenManager2)));
        },
      );

      test(
        'when building with different authUsers instances, then different instances are created',
        () {
          const authUsers1 = AuthUsers();
          const authUsers2 = AuthUsers();
          final tokenManager1 = builder.build(authUsers: authUsers1);
          final tokenManager2 = builder.build(authUsers: authUsers2);
          expect(tokenManager1, isNot(same(tokenManager2)));
        },
      );
    },
  );
}

void main() {
  testSuite<FakeTokenManager>(
    () => FakeTokenManagerBuilder(tokenStorage: FakeTokenStorage()),
  );

  testSuite<ServerSideSessionsTokenManager>(
    () => ServerSideSessionsConfig(
      sessionKeyHashPepper: 'test-pepper',
    ),
  );

  testSuite<JwtTokenManager>(
    () => JwtConfig(
      algorithm: HmacSha512JwtAlgorithmConfiguration(
        key: SecretKey('test-private-key-for-HS512'),
      ),
      refreshTokenHashPepper: 'test-pepper',
    ),
  );
}
