import 'package:serverpod_auth_core_server/jwt.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given empty refresh token hash pepper when creating an AuthenticationTokenConfig then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a refresh token hash pepper that is less than 10 characters when creating an AuthenticationTokenConfig then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '123456789',
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a valid refresh token hash pepper when creating an AuthenticationTokenConfig then the AuthenticationTokenConfig is created successfully.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
        ),
        isNotNull,
      );
    },
  );

  test(
    'Given valid fallback refresh token hash peppers when creating an AuthenticationTokenConfig then the AuthenticationTokenConfig is created successfully.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
          fallbackRefreshTokenHashPeppers: ['old-pepper-1', 'old-pepper-2'],
        ),
        returnsNormally,
      );
    },
  );

  test(
    'Given empty fallback refresh token hash peppers list when creating an AuthenticationTokenConfig then the AuthenticationTokenConfig is created successfully.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
          fallbackRefreshTokenHashPeppers: [],
        ),
        returnsNormally,
      );
    },
  );

  test(
    'Given invalid fallback refresh token hash pepper when creating an AuthenticationTokenConfig then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
          fallbackRefreshTokenHashPeppers: ['valid-pepper', 'short'],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given empty fallback refresh token hash pepper when creating an AuthenticationTokenConfig then an error is thrown.',
    () {
      expect(
        () => AuthenticationTokenConfig(
          algorithm: AuthenticationTokenAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
          fallbackRefreshTokenHashPeppers: [''],
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );
}
