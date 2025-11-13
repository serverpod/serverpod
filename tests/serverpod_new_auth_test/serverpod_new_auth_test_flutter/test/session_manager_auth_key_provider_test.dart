import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_client.dart';

import 'utils/test_storage.dart';

void main() {
  late Client client;
  late AuthSuccess jwtAuthSuccess;
  late AuthSuccess sasAuthSuccess;

  setUp(() async {
    client = Client('http://localhost:8080/')
      ..authSessionManager = ClientAuthSessionManager(storage: TestStorage());

    final testUserId = await client.authTest.createTestUser();

    jwtAuthSuccess = await client.authTest.createJwtToken(testUserId);
    sasAuthSuccess = await client.authTest.createSasToken(testUserId);
  });

  group('Given a ClientAuthSessionManager with no auth info available', () {
    test('when getting auth key provider delegate then it returns null.', () {
      final delegate = client.auth.authKeyProviderDelegate;

      expect(delegate, isNull);
    });

    test('when getting auth header value then it returns null.', () async {
      final result = await client.auth.authHeaderValue;

      expect(result, isNull);
    });

    test('when refreshing auth key then it returns skipped.', () async {
      final result = await client.auth.refreshAuthKey();

      expect(result, RefreshAuthKeyResult.skipped);
    });
  });

  group('Given a ClientAuthSessionManager with JWT auth info available', () {
    setUp(() async {
      await client.auth.updateSignedInUser(jwtAuthSuccess);
    });

    test('when getting auth key provider delegate '
        'then it returns JwtAuthKeyProvider.', () async {
      final delegate = client.auth.authKeyProviderDelegate;

      expect(delegate, isA<JwtAuthKeyProvider>());
    });

    test('when getting auth key provider delegate multiple times '
        'then the same JwtAuthKeyProvider instance is returned.', () async {
      final delegate1 = client.auth.authKeyProviderDelegate;
      final delegate2 = client.auth.authKeyProviderDelegate;

      expect(identical(delegate1, delegate2), isTrue);
    });

    test('when getting auth header value '
        'then it returns Bearer token from JWT provider.', () async {
      final result = await client.auth.authHeaderValue;

      expect(result, 'Bearer ${jwtAuthSuccess.token}');
    });
  });

  group('Given a ClientAuthSessionManager with non-expiring JWT auth info', () {
    setUp(() async {
      await client.auth.updateSignedInUser(jwtAuthSuccess);
    });

    test('when refreshing auth key without setting force parameter '
        'then it returns skipped.', () async {
      final result = await client.auth.refreshAuthKey();

      expect(result, RefreshAuthKeyResult.skipped);
    });

    test('when refreshing auth key with force parameter set to true '
        'then it returns success.', () async {
      final result = await client.auth.refreshAuthKey(force: true);

      expect(result, RefreshAuthKeyResult.success);
    });
  });

  group('Given a ClientAuthSessionManager with expiring JWT auth info', () {
    setUp(() async {
      await client.auth.updateSignedInUser(
        jwtAuthSuccess.copyWith(
          tokenExpiresAt: DateTime.now().toUtc().add(
            const Duration(seconds: 15),
          ),
        ),
      );
    });

    test('when refreshing auth key '
        'then it delegates to JWT provider and returns success.', () async {
      final result = await client.auth.refreshAuthKey();

      expect(result, RefreshAuthKeyResult.success);
    });
  });

  group('Given a ClientAuthSessionManager with SAS auth info available', () {
    setUp(() async {
      await client.auth.updateSignedInUser(sasAuthSuccess);
    });

    test('when getting auth key provider delegate '
        'then it returns SasAuthKeyProvider.', () async {
      final delegate = client.auth.authKeyProviderDelegate;

      expect(delegate, isA<SasAuthKeyProvider>());
    });

    test('when getting auth key provider delegate multiple times '
        'then the same SasAuthKeyProvider instance is returned.', () async {
      final delegate1 = client.auth.authKeyProviderDelegate;
      final delegate2 = client.auth.authKeyProviderDelegate;

      expect(identical(delegate1, delegate2), isTrue);
    });

    test('when getting auth header value '
        'then it returns Bearer token from SAS provider.', () async {
      final result = await client.auth.authHeaderValue;

      expect(result, 'Bearer ${sasAuthSuccess.token}');
    });

    test(
      'when refreshing auth key without setting force parameter '
      'then it returns skipped as SAS provider does not support refresh.',
      () async {
        final result = await client.auth.refreshAuthKey();

        expect(result, RefreshAuthKeyResult.skipped);
      },
    );

    test(
      'when refreshing auth key with force parameter set to true '
      'then it returns skipped as SAS provider does not support refresh.',
      () async {
        final result = await client.auth.refreshAuthKey(force: true);

        expect(result, RefreshAuthKeyResult.skipped);
      },
    );
  });

  group('Given auth strategy changes between JWT and SAS', () {
    test('when getting auth key provider delegate '
        'then each auth strategy gets its own provider instance.', () async {
      await client.auth.updateSignedInUser(jwtAuthSuccess);
      final jwtDelegate = client.auth.authKeyProviderDelegate;

      await client.auth.updateSignedInUser(sasAuthSuccess);
      final sasDelegate = client.auth.authKeyProviderDelegate;

      expect(jwtDelegate, isA<JwtAuthKeyProvider>());
      expect(sasDelegate, isA<SasAuthKeyProvider>());
    });

    test(
      'when getting auth key provider delegate multiple times '
      'then the same provider instance for each auth strategy is returned.',
      () async {
        await client.auth.updateSignedInUser(jwtAuthSuccess);
        final jwtDelegate = client.auth.authKeyProviderDelegate;

        await client.auth.updateSignedInUser(sasAuthSuccess);
        final sasDelegate = client.auth.authKeyProviderDelegate;

        await client.auth.updateSignedInUser(jwtAuthSuccess);
        final jwtDelegate2 = client.auth.authKeyProviderDelegate;

        await client.auth.updateSignedInUser(sasAuthSuccess);
        final sasDelegate2 = client.auth.authKeyProviderDelegate;

        expect(identical(jwtDelegate, jwtDelegate2), isTrue);
        expect(identical(sasDelegate, sasDelegate2), isTrue);
      },
    );
  });

  group('Given a ClientAuthSessionManager with custom provider delegates', () {
    late JwtAuthKeyProvider customJwtProvider;
    late SasAuthKeyProvider customSasProvider;
    late UsrAuthKeyProvider customUsrProvider;

    setUp(() {
      customJwtProvider = JwtAuthKeyProvider(
        getAuthInfo: () async => jwtAuthSuccess,
        onRefreshAuthInfo: (authSuccess) async {},
        refreshEndpoint: client.jwtRefresh,
      );

      customSasProvider = SasAuthKeyProvider(
        getAuthInfo: () async => sasAuthSuccess,
      );

      customUsrProvider = UsrAuthKeyProvider();

      client.authSessionManager = ClientAuthSessionManager(
        storage: TestStorage(),
        authKeyProviderDelegates: {
          AuthStrategy.jwt.name: customJwtProvider,
          AuthStrategy.session.name: customSasProvider,
          'custom': customUsrProvider,
        },
      );
    });

    test('when getting auth key provider delegate for JWT auth info '
        'then it returns the custom provider instance.', () async {
      await client.auth.updateSignedInUser(jwtAuthSuccess);
      final delegate = client.auth.authKeyProviderDelegate;

      expect(identical(delegate, customJwtProvider), isTrue);
    });

    test('when getting auth key provider delegate for SAS auth info '
        'then it returns the custom provider instance.', () async {
      await client.auth.updateSignedInUser(sasAuthSuccess);
      final delegate = client.auth.authKeyProviderDelegate;

      expect(identical(delegate, customSasProvider), isTrue);
    });

    test('when getting auth key provider delegate for custom auth info '
        'then it returns the custom provider instance.', () async {
      await client.auth.updateSignedInUser(
        sasAuthSuccess.copyWith(authStrategy: 'custom'),
      );

      final delegate = client.auth.authKeyProviderDelegate;

      expect(identical(delegate, customUsrProvider), isTrue);
    });

    test('when getting auth key provider delegate for unsupported auth info '
        'then it throws an exception.', () async {
      await client.auth.updateSignedInUser(
        sasAuthSuccess.copyWith(authStrategy: 'unsupported'),
      );

      await expectLater(
        () => client.auth.authKeyProviderDelegate,
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}

class UsrAuthKeyProvider implements ClientAuthKeyProvider {
  @override
  Future<String?> get authHeaderValue async => 'token';
}
