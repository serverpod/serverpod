import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as client_auth;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as server_auth;
import 'package:serverpod_auth_idp_server/core.dart' hide AuthSuccess;
import 'package:serverpod_auth_test_client/serverpod_auth_test_client.dart';
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  late Client client;
  late InMemoryClientAuthSuccessStorage delegateStorage;
  late client_auth.CachedClientAuthSuccessStorage cachedStorage;
  late client_auth.AuthSuccess oldAuthSuccess;
  late client_auth.AuthSuccess newAuthSuccess;

  final jwtConfig = server_auth.JwtConfig(
    refreshTokenHashPepper: 'test-pepper-jwt-cached-storage-integration',
    algorithm: server_auth.JwtAlgorithm.hmacSha512(
      SecretKey('test-private-key-for-HS512'),
    ),
  );

  setUp(() async {
    delegateStorage = InMemoryClientAuthSuccessStorage();
    cachedStorage = client_auth.CachedClientAuthSuccessStorage(
      delegate: delegateStorage,
    );
  });

  withServerpod(
    'Given JWT auth, a client with cached storage and an expiring refresh token that is changed directly on the storage layer to a non-expiring refresh token ',
    (final sessionBuilder, final endpoints) {
      setUp(() async {
        final session = sessionBuilder.build();
        final pod = session.serverpod;
        pod.initializeAuthServices(tokenManagerBuilders: [jwtConfig]);

        client = Client('http://localhost:${session.server.port}/')
          ..authSessionManager = client_auth.ClientAuthSessionManager(
            storage: cachedStorage,
          );

        final userId = await client.authTest.createTestUser();
        oldAuthSuccess = await client.authTest.createJwtToken(userId);

        // Rotate the refresh token to simulate a refresh from other tab
        newAuthSuccess = await client.jwtRefresh.refreshAccessToken(
          refreshToken: oldAuthSuccess.refreshToken!,
        );

        await client.auth.updateSignedInUser(
          oldAuthSuccess.copyWith(
            tokenExpiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
          ),
        );

        // Modify the refresh token directly on the storage layer to a token
        // that is not expiring
        await delegateStorage.set(
          newAuthSuccess.copyWith(
            tokenExpiresAt: DateTime.now().add(const Duration(minutes: 10)),
          ),
        );

        // Verify that the cached refresh token is the old one
        expect(oldAuthSuccess.refreshToken, isNot(newAuthSuccess.refreshToken));
        expect(client.auth.authInfo?.refreshToken, oldAuthSuccess.refreshToken);
      });

      group('when calling refresh ', () {
        late RefreshAuthKeyResult refreshResult;
        setUp(() async {
          refreshResult = await client.auth.refreshAuthKey();
        });

        test(
          'then it uses the refresh token from the storage and returns skipped since the it is not expiring.',
          () async {
            expect(refreshResult, RefreshAuthKeyResult.skipped);
          },
        );

        test(
          'then the cached refresh is now the non-expiring refresh token.',
          () async {
            expect(
              client.auth.authInfo?.refreshToken,
              newAuthSuccess.refreshToken,
            );
          },
        );
      });
    },
  );

  withServerpod(
    'Given JWT auth, a client with cached storage and an expiring refresh token that is changed directly on the storage layer to a another expiring refresh token ',
    (final sessionBuilder, final endpoints) {
      setUp(() async {
        final session = sessionBuilder.build();
        final pod = session.serverpod;
        pod.initializeAuthServices(tokenManagerBuilders: [jwtConfig]);

        client = Client('http://localhost:${session.server.port}/')
          ..authSessionManager = client_auth.ClientAuthSessionManager(
            storage: cachedStorage,
          );

        final userId = await client.authTest.createTestUser();
        oldAuthSuccess = await client.authTest.createJwtToken(userId);

        // Rotate the refresh token to simulate a refresh from other tab
        newAuthSuccess = await client.jwtRefresh.refreshAccessToken(
          refreshToken: oldAuthSuccess.refreshToken!,
        );

        await client.auth.updateSignedInUser(
          oldAuthSuccess.copyWith(
            tokenExpiresAt: DateTime.now().subtract(const Duration(seconds: 1)),
          ),
        );

        // Modify the refresh token directly on the storage layer to a token
        // that is expiring soon
        await delegateStorage.set(
          newAuthSuccess.copyWith(
            tokenExpiresAt: DateTime.now().add(const Duration(seconds: 2)),
          ),
        );

        // Verify that the cached refresh token is the old one
        expect(oldAuthSuccess.refreshToken, isNot(newAuthSuccess.refreshToken));
        expect(client.auth.authInfo?.refreshToken, oldAuthSuccess.refreshToken);
      });

      group('when calling refresh ', () {
        late RefreshAuthKeyResult refreshResult;
        setUp(() async {
          refreshResult = await client.auth.refreshAuthKey();
        });

        test('then it returns success.', () async {
          expect(refreshResult, RefreshAuthKeyResult.success);
        });

        test(
          'then the new refresh is rotated and a new refresh token is returned.',
          () async {
            expect(
              client.auth.authInfo?.refreshToken,
              isNot(oldAuthSuccess.refreshToken),
            );
            expect(
              client.auth.authInfo?.refreshToken,
              isNot(newAuthSuccess.refreshToken),
            );
          },
        );
      });
    },
  );
}

/// In-memory backing store for [client_auth.ClientAuthSuccessStorage] used to
/// simulate shared persistence (e.g. browser local storage) without mocks.
class InMemoryClientAuthSuccessStorage
    implements client_auth.ClientAuthSuccessStorage {
  client_auth.AuthSuccess? _data;

  @override
  Future<void> set(final client_auth.AuthSuccess? data) async {
    _data = data;
  }

  @override
  Future<client_auth.AuthSuccess?> get() async {
    return _data;
  }
}
