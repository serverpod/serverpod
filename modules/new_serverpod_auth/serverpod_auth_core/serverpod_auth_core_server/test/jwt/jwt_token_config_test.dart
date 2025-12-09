import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:test/test.dart';

void main() {
  test(
    'Given empty refresh token hash pepper when creating a JwtConfig then an error is thrown.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a refresh token hash pepper that is less than 10 characters when creating a JwtConfig then an error is thrown.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '123456789',
        ),
        throwsA(isA<ArgumentError>()),
      );
    },
  );

  test(
    'Given a valid refresh token hash pepper when creating a JwtConfig then the JwtConfig is created successfully.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
            SecretKey('test-private-key-for-HS512'),
          ),
          refreshTokenHashPepper: '1234567890',
        ),
        isNotNull,
      );
    },
  );

  test(
    'Given valid fallback refresh token hash peppers when creating a JwtConfig then the JwtConfig is created successfully.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
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
    'Given empty fallback refresh token hash peppers list when creating a JwtConfig then the JwtConfig is created successfully.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
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
    'Given invalid fallback refresh token hash pepper when creating a JwtConfig then an error is thrown.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
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
    'Given empty fallback refresh token hash pepper when creating a JwtConfig then an error is thrown.',
    () {
      expect(
        () => JwtConfig(
          algorithm: JwtAlgorithm.hmacSha512(
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
