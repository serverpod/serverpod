import 'package:serverpod_auth_core_server/jwt.dart';
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
}
