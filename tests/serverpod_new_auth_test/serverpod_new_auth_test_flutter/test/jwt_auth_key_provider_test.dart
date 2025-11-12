import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

void main() {
  late Client client;
  late JwtAuthKeyProvider provider;
  late AuthSuccess? storedAuthInfo;
  late TestEndpointRefreshJwtToken refreshEndpoint;
  late AuthSuccess jwtAuthSuccess;
  late RefreshAuthKeyResult result;
  late Object? clientReceivedException;

  setUp(() async {
    client = Client(
      'http://localhost:8080/',
      onFailedCall: (_, error, __) {
        clientReceivedException = error;
      },
    );
    refreshEndpoint = TestEndpointRefreshJwtToken(client);
    clientReceivedException = null;

    provider = JwtAuthKeyProvider(
      getAuthInfo: () async => storedAuthInfo,
      onRefreshAuthInfo: (authSuccess) async {
        storedAuthInfo = authSuccess;
      },
      refreshEndpoint: refreshEndpoint,
      refreshJwtTokenBefore: const Duration(seconds: 30),
    );

    final testUserId = await client.authTest.createTestUser();
    jwtAuthSuccess = await client.authTest.createJwtToken(testUserId);
  });

  group('Given a JwtAuthKeyProvider with no auth info available', () {
    setUp(() {
      storedAuthInfo = null;
    });

    test('when getting auth header value then it returns null.', () async {
      final result = await provider.authHeaderValue;

      expect(result, isNull);
    });

    group('when refreshing auth key', () {
      setUp(() async {
        result = await provider.refreshAuthKey();
      });

      test('then it does not call the refresh function.', () async {
        expect(refreshEndpoint.callCount, 0);
      });

      test('then it returns skipped.', () async {
        expect(result, RefreshAuthKeyResult.skipped);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo, isNull);
      });
    });
  });

  test('Given a JwtAuthKeyProvider with valid auth info available '
      'when getting auth header value '
      'then it returns Bearer token format.', () async {
    storedAuthInfo = jwtAuthSuccess;

    final result = await provider.authHeaderValue;

    expect(result, 'Bearer ${jwtAuthSuccess.token}');
  });

  group('Given a JwtAuthKeyProvider with auth info that has no expiration time '
      'when refreshing auth key ', () {
    setUp(() async {
      storedAuthInfo = jwtAuthSuccess.copyWith()..tokenExpiresAt = null;
      result = await provider.refreshAuthKey();
    });

    test('then it does not call the refresh function.', () async {
      expect(refreshEndpoint.callCount, 0);
    });

    test('then it returns skipped as it does not expire.', () async {
      expect(result, RefreshAuthKeyResult.skipped);
    });

    test('then it does not update auth info.', () async {
      expect(storedAuthInfo?.token, jwtAuthSuccess.token);
    });
  });

  group(
    'Given a JwtAuthKeyProvider with auth info that has distant future expiration time',
    () {
      setUp(() async {
        storedAuthInfo = jwtAuthSuccess.expiringIn(const Duration(minutes: 5));
      });

      group('when refreshing auth key without setting force parameter', () {
        setUp(() async {
          result = await provider.refreshAuthKey();
        });

        test('then it does not call the refresh function.', () async {
          expect(refreshEndpoint.callCount, 0);
        });

        test('then it returns skipped as it is not about to expire.', () async {
          expect(result, RefreshAuthKeyResult.skipped);
        });

        test('then it does not update auth info.', () async {
          expect(storedAuthInfo?.token, jwtAuthSuccess.token);
        });
      });

      group('when refreshing auth key with force parameter set to true', () {
        setUp(() async {
          result = await provider.refreshAuthKey(force: true);
        });

        test('then it calls the refresh function.', () async {
          expect(refreshEndpoint.callCount, 1);
        });

        test('then refreshAuthKey returns success.', () async {
          expect(result, RefreshAuthKeyResult.success);
        });

        test('then it updates auth info.', () async {
          expect(storedAuthInfo?.token, isNotNull);
          expect(storedAuthInfo?.token, isNot(jwtAuthSuccess.token));
        });
      });
    },
  );

  group('Given a JwtAuthKeyProvider with auth info that is about to expire '
      'when refreshing auth key', () {
    setUp(() async {
      storedAuthInfo = jwtAuthSuccess.expiringIn(const Duration(seconds: 15));

      result = await provider.refreshAuthKey();
    });

    test('then it calls the refresh function once.', () async {
      expect(refreshEndpoint.callCount, 1);
    });

    test('then refreshAuthKey returns success.', () async {
      expect(result, RefreshAuthKeyResult.success);
    });

    test('then it rotates the refresh token.', () async {
      expect(storedAuthInfo?.refreshToken, isNotNull);
      expect(storedAuthInfo?.refreshToken, isNot(jwtAuthSuccess.refreshToken));
    });

    test('then it updates auth info.', () async {
      expect(storedAuthInfo?.token, isNotNull);
      expect(storedAuthInfo?.token, isNot(jwtAuthSuccess.token));
    });
  });

  group(
    'Given a JwtAuthKeyProvider with auth info that has a past expiration time '
    'when refreshing auth key',
    () {
      setUp(() async {
        storedAuthInfo = jwtAuthSuccess.expiringIn(-const Duration(minutes: 5));

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then refreshAuthKey returns success.', () async {
        expect(result, RefreshAuthKeyResult.success);
      });

      test('then it rotates the refresh token.', () async {
        expect(storedAuthInfo?.refreshToken, isNotNull);
        expect(
          storedAuthInfo?.refreshToken,
          isNot(jwtAuthSuccess.refreshToken),
        );
      });

      test('then it updates auth info.', () async {
        expect(storedAuthInfo?.token, isNotNull);
        expect(storedAuthInfo?.token, isNot(jwtAuthSuccess.token));
      });
    },
  );

  group(
    'Given a JwtAuthKeyProvider with auth info containing a malformed refresh token '
    'when refreshing auth key',
    () {
      setUp(() async {
        storedAuthInfo = jwtAuthSuccess.expiring.copyWith(
          refreshToken: 'malformed',
        );

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then it throws RefreshTokenMalformedException.', () async {
        expect(clientReceivedException, isA<RefreshTokenMalformedException>());
      });

      test('then refreshAuthKey returns failedUnauthorized.', () async {
        expect(result, RefreshAuthKeyResult.failedUnauthorized);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo?.token, jwtAuthSuccess.token);
      });
    },
  );

  group(
    'Given a JwtAuthKeyProvider with auth info containing a non-existing refresh token '
    'when refreshing auth key',
    () {
      setUp(() async {
        await client.authTest.deleteJwtRefreshTokens(jwtAuthSuccess.authUserId);
        storedAuthInfo = jwtAuthSuccess.expiring;

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then it throws RefreshTokenNotFoundException.', () async {
        expect(clientReceivedException, isA<RefreshTokenNotFoundException>());
      });

      test('then refreshAuthKey returns failedUnauthorized.', () async {
        expect(result, RefreshAuthKeyResult.failedUnauthorized);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo?.token, jwtAuthSuccess.token);
      });
    },
  );

  group(
    'Given a JwtAuthKeyProvider with auth info that contains an expired refresh token '
    'when refreshing auth key',
    () {
      setUp(() async {
        storedAuthInfo = jwtAuthSuccess.expiring;
        refreshEndpoint.simulateException = RefreshTokenExpiredException();

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then refreshAuthKey returns failedUnauthorized.', () async {
        expect(result, RefreshAuthKeyResult.failedUnauthorized);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo?.token, jwtAuthSuccess.token);
      });
    },
  );

  group(
    'Given a JwtAuthKeyProvider with auth info containing a refresh token with an invalid secret '
    'when refreshing auth key',
    () {
      setUp(() async {
        var refreshToken = jwtAuthSuccess.refreshToken!;
        var secret = refreshToken.split(':').last;
        var invalidSecret = base64Encode(utf8.encode('invalid secret'));
        storedAuthInfo = jwtAuthSuccess.expiring.copyWith(
          refreshToken: refreshToken.replaceAll(secret, invalidSecret),
        );

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then it throws RefreshTokenInvalidSecretException.', () async {
        expect(
          clientReceivedException,
          isA<RefreshTokenInvalidSecretException>(),
        );
      });

      test('then refreshAuthKey returns failedUnauthorized.', () async {
        expect(result, RefreshAuthKeyResult.failedUnauthorized);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo?.token, jwtAuthSuccess.token);
      });
    },
  );

  group(
    'Given a JwtAuthKeyProvider with auth info that contains a valid refresh token, but refresh endpoint throws an unrelated exception '
    'when refreshing auth key',
    () {
      setUp(() async {
        storedAuthInfo = jwtAuthSuccess.expiring;
        refreshEndpoint.simulateException = Exception('Unrelated exception');

        result = await provider.refreshAuthKey();
      });

      test('then it calls the refresh function.', () async {
        expect(refreshEndpoint.callCount, 1);
      });

      test('then refreshAuthKey returns failedOther.', () async {
        expect(result, RefreshAuthKeyResult.failedOther);
      });

      test('then it does not update auth info.', () async {
        expect(storedAuthInfo?.token, jwtAuthSuccess.token);
      });
    },
  );
}

class TestEndpointRefreshJwtToken extends EndpointJwtRefresh {
  TestEndpointRefreshJwtToken(super.caller);

  int callCount = 0;

  /// For testing exceptions that are not possible to trigger from the client.
  Exception? simulateException;

  @override
  Future<AuthSuccess> refreshAccessToken({required String refreshToken}) async {
    callCount++;
    if (simulateException != null) throw simulateException!;
    return super.refreshAccessToken(refreshToken: refreshToken);
  }
}

extension on AuthSuccess {
  AuthSuccess expiringIn(Duration duration) =>
      copyWith(tokenExpiresAt: DateTime.now().toUtc().add(duration));

  AuthSuccess get expiring => expiringIn(const Duration(seconds: 15));
}
