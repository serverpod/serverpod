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
}
