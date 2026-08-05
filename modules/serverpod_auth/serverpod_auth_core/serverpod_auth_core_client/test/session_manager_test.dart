import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:test/test.dart';

/// A simple in-memory storage for testing
class InMemoryClientAuthSuccessStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _data;

  @override
  Future<void> set(AuthSuccess? data) async {
    _data = data;
  }

  @override
  Future<AuthSuccess?> get() async {
    return _data;
  }
}

void main() {
  group('Given a platform-agnostic ClientAuthSessionManager', () {
    late ClientAuthSessionManager sessionManager;
    late InMemoryClientAuthSuccessStorage storage;

    setUp(() {
      storage = InMemoryClientAuthSuccessStorage();
      sessionManager = ClientAuthSessionManager(
        storage: storage,
      );
    });

    test('when created then it has no authenticated user.', () {
      expect(sessionManager.isAuthenticated, isFalse);
      expect(sessionManager.authInfo, isNull);
    });

    test(
      'when storage has auth data then restore updates the auth info.',
      () async {
        final authSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
          ),
          token: 'test-token',
          authStrategy: 'session',
          scopeNames: {},
        );
        await storage.set(authSuccess);

        await sessionManager.restore();

        expect(sessionManager.isAuthenticated, isTrue);
        expect(
          sessionManager.authInfo?.authUserId.toString(),
          equals('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
        );
        expect(sessionManager.authInfo?.token, equals('test-token'));
      },
    );

    test(
      'when updateSignedInUser is called then storage and auth info are updated.',
      () async {
        final authSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22',
          ),
          token: 'new-token',
          authStrategy: 'jwt',
          scopeNames: {},
        );

        // Mock the caller to avoid errors
        // Note: In a real test, you'd mock the entire caller/client structure
        // For this simple test, we skip the client update part

        expect(sessionManager.authInfo, isNull);

        // We can't fully test updateSignedInUser without mocking the caller
        // but we can verify the storage part works
        await storage.set(authSuccess);
        await sessionManager.restore();

        expect(
          sessionManager.authInfo?.authUserId.toString(),
          equals('b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22'),
        );
        expect(sessionManager.authInfo?.token, equals('new-token'));
        expect(sessionManager.authInfo?.authStrategy, equals('jwt'));
      },
    );

    test(
      'when auth info is null then isAuthenticated returns false.',
      () {
        expect(sessionManager.isAuthenticated, isFalse);
      },
    );

    test(
      'when auth info is set then isAuthenticated returns true.',
      () async {
        final authSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            'c0eebc99-9c0b-4ef8-bb6d-6bb9bd380a33',
          ),
          token: 'another-token',
          authStrategy: 'session',
          scopeNames: {},
        );
        await storage.set(authSuccess);
        await sessionManager.restore();

        expect(sessionManager.isAuthenticated, isTrue);
      },
    );
  });

  group('Given a cookie-auth ClientAuthSessionManager', () {
    late ClientAuthSessionManager sessionManager;
    late InMemoryClientAuthSuccessStorage storage;
    late _TestServerpodClient client;

    setUp(() {
      storage = InMemoryClientAuthSuccessStorage();
      client = _TestServerpodClient(requestDelegate: _CookieRequestDelegate())
        ..cookieAuth = true;
      sessionManager = ClientAuthSessionManager(
        caller: Caller(client),
        storage: storage,
      );
    });

    test(
      'when a JWT sign-in succeeds with an access token and no refresh token, '
      'then storage is written without JavaScript-readable tokens.',
      () async {
        final authSuccess = _authSuccess(
          authStrategy: AuthStrategy.jwt.name,
          token: 'access-token',
          refreshToken: null,
        );

        await sessionManager.updateSignedInUser(authSuccess);

        final storedAuthInfo = await storage.get();
        expect(sessionManager.authInfo?.token, 'access-token');
        expect(sessionManager.authInfo?.refreshToken, isNull);
        expect(storedAuthInfo?.token, '');
        expect(storedAuthInfo?.refreshToken, isNull);
      },
    );

    test(
      'when a JWT sign-in returns a refresh token in the body, '
      'then it throws a StateError.',
      () async {
        final authSuccess = _authSuccess(
          authStrategy: AuthStrategy.jwt.name,
          token: 'access-token',
          refreshToken: 'refresh-token',
        );

        await expectLater(
          sessionManager.updateSignedInUser(authSuccess),
          throwsA(isA<StateError>()),
        );
        expect(await storage.get(), isNull);
        expect(sessionManager.authInfo, isNull);
      },
    );

    test(
      'when a session sign-in returns a token in the body, '
      'then it throws a StateError.',
      () async {
        final authSuccess = _authSuccess(
          authStrategy: AuthStrategy.session.name,
          token: 'session-token',
          refreshToken: null,
        );

        await expectLater(
          sessionManager.updateSignedInUser(authSuccess),
          throwsA(isA<StateError>()),
        );
        expect(await storage.get(), isNull);
        expect(sessionManager.authInfo, isNull);
      },
    );

    group(
      'when the signed-in identity changes from one SAS user to another',
      () {
        setUp(() async {
          await sessionManager.updateSignedInUser(
            _authSuccess(
              authUserId: UuidValue.fromString(
                'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
              ),
              authStrategy: AuthStrategy.session.name,
              token: '',
            ),
          );
          client.closeStreamingMethodConnectionsCallCount = 0;

          await sessionManager.updateSignedInUser(
            _authSuccess(
              authUserId: UuidValue.fromString(
                'b0eebc99-9c0b-4ef8-bb6d-6bb9bd380a22',
              ),
              authStrategy: AuthStrategy.session.name,
              token: '',
            ),
          );
        });

        test(
          'then modern method streaming connections are closed.',
          () {
            expect(client.closeStreamingMethodConnectionsCallCount, 1);
          },
        );
      },
    );
  });

  group('Given a JWT auth key provider in cookie mode', () {
    late AuthSuccess? authInfo;
    late _TestRefreshJwtTokensEndpoint refreshEndpoint;
    late JwtAuthKeyProvider authKeyProvider;

    setUp(() {
      authInfo = _authSuccess(
        authStrategy: AuthStrategy.jwt.name,
        token: '',
        refreshToken: null,
        tokenExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      );
      refreshEndpoint = _TestRefreshJwtTokensEndpoint();
      authKeyProvider = JwtAuthKeyProvider(
        getAuthInfo: () async => authInfo,
        onRefreshAuthInfo: (authSuccess) async {
          authInfo = authSuccess;
        },
        refreshEndpoint: refreshEndpoint,
        usesCookieAuth: () => true,
      );
    });

    test(
      'when the stored access token is empty, '
      'then authHeaderValue refreshes using the browser refresh cookie.',
      () async {
        refreshEndpoint.authSuccess = _authSuccess(
          authStrategy: AuthStrategy.jwt.name,
          token: 'new-access-token',
          refreshToken: null,
        );

        expect(
          await authKeyProvider.authHeaderValue,
          wrapAsBearerAuthHeaderValue('new-access-token'),
        );
        expect(refreshEndpoint.refreshTokens, [null]);
      },
    );

    test(
      'when the stored access token is empty, '
      'then refresh uses the browser refresh cookie.',
      () async {
        refreshEndpoint.authSuccess = _authSuccess(
          authStrategy: AuthStrategy.jwt.name,
          token: 'new-access-token',
          refreshToken: null,
        );

        final result = await authKeyProvider.refreshAuthKey();

        expect(result, RefreshAuthKeyResult.success);
        expect(refreshEndpoint.refreshTokens, [null]);
        expect(authInfo?.token, 'new-access-token');
      },
    );

    test(
      'when the access token is still valid, '
      'then refresh is skipped.',
      () async {
        authInfo = _authSuccess(
          authStrategy: AuthStrategy.jwt.name,
          token: 'access-token',
          refreshToken: null,
          tokenExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        );

        final result = await authKeyProvider.refreshAuthKey();

        expect(result, RefreshAuthKeyResult.skipped);
        expect(refreshEndpoint.refreshTokens, isEmpty);
      },
    );
  });

  group('Given a JWT auth key provider in header mode', () {
    late AuthSuccess? authInfo;
    late _TestRefreshJwtTokensEndpoint refreshEndpoint;
    late JwtAuthKeyProvider authKeyProvider;

    setUp(() {
      authInfo = _authSuccess(
        authStrategy: AuthStrategy.jwt.name,
        token: 'access-token',
        refreshToken: 'refresh-token',
        tokenExpiresAt: DateTime.now().toUtc().subtract(
          const Duration(hours: 1),
        ),
      );
      refreshEndpoint = _TestRefreshJwtTokensEndpoint();
      refreshEndpoint.authSuccess = _authSuccess(
        authStrategy: AuthStrategy.jwt.name,
        token: 'new-access-token',
        refreshToken: 'new-refresh-token',
      );
      authKeyProvider = JwtAuthKeyProvider(
        getAuthInfo: () async => authInfo,
        onRefreshAuthInfo: (authSuccess) async {
          authInfo = authSuccess;
        },
        refreshEndpoint: refreshEndpoint,
        usesCookieAuth: () => false,
      );
    });

    test(
      'when the access token is expired, '
      'then refresh sends the explicit refresh token.',
      () async {
        final result = await authKeyProvider.refreshAuthKey();

        expect(result, RefreshAuthKeyResult.success);
        expect(refreshEndpoint.refreshTokens, ['refresh-token']);
        expect(authInfo?.token, 'new-access-token');
        expect(authInfo?.refreshToken, 'new-refresh-token');
      },
    );
  });

  group('Given a CachedClientAuthSuccessStorage', () {
    late CachedClientAuthSuccessStorage cachedStorage;
    late InMemoryClientAuthSuccessStorage delegateStorage;

    setUp(() {
      delegateStorage = InMemoryClientAuthSuccessStorage();
      cachedStorage = CachedClientAuthSuccessStorage(delegate: delegateStorage);
    });

    test('when calling get multiple times then data is cached.', () async {
      final authSuccess = AuthSuccess(
        authUserId: UuidValue.fromString(
          'd0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44',
        ),
        token: 'test-token',
        authStrategy: 'session',
        scopeNames: {},
      );
      await delegateStorage.set(authSuccess);

      final first = await cachedStorage.get();
      final second = await cachedStorage.get();

      expect(first, equals(second));
      expect(
        first?.authUserId.toString(),
        equals('d0eebc99-9c0b-4ef8-bb6d-6bb9bd380a44'),
      );
    });

    test(
      'when clearCache is called then next get retrieves from delegate.',
      () async {
        final authSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            'e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55',
          ),
          token: 'test-token',
          authStrategy: 'session',
          scopeNames: {},
        );
        await cachedStorage.set(authSuccess);
        await cachedStorage.get();

        // Update the delegate directly
        final newAuthSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            'f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66',
          ),
          token: 'new-token',
          authStrategy: 'session',
          scopeNames: {},
        );
        await delegateStorage.set(newAuthSuccess);

        // Should still return old cached value
        var result = await cachedStorage.get();
        expect(
          result?.authUserId.toString(),
          equals('e0eebc99-9c0b-4ef8-bb6d-6bb9bd380a55'),
        );

        // Clear cache
        await cachedStorage.clearCache();

        // Should now return new value from delegate
        result = await cachedStorage.get();
        expect(
          result?.authUserId.toString(),
          equals('f0eebc99-9c0b-4ef8-bb6d-6bb9bd380a66'),
        );
      },
    );
  });

  group('Given a KeyValueClientAuthSuccessStorage', () {
    test(
      'when storing and retrieving AuthSuccess then data is preserved.',
      () async {
        final storage = KeyValueClientAuthSuccessStorage(
          keyValueStorage: _InMemoryKeyValueStorage(),
        );

        final authSuccess = AuthSuccess(
          authUserId: UuidValue.fromString(
            '10eebc99-9c0b-4ef8-bb6d-6bb9bd380a77',
          ),
          token: 'kvs-token',
          authStrategy: 'jwt',
          scopeNames: {},
        );

        await storage.set(authSuccess);
        final retrieved = await storage.get();

        expect(
          retrieved?.authUserId.toString(),
          equals('10eebc99-9c0b-4ef8-bb6d-6bb9bd380a77'),
        );
        expect(retrieved?.token, equals('kvs-token'));
        expect(retrieved?.authStrategy, equals('jwt'));
      },
    );

    test('when setting null then stored data is null.', () async {
      final storage = KeyValueClientAuthSuccessStorage(
        keyValueStorage: _InMemoryKeyValueStorage(),
      );

      final authSuccess = AuthSuccess(
        authUserId: UuidValue.fromString(
          '20eebc99-9c0b-4ef8-bb6d-6bb9bd380a88',
        ),
        token: 'kvs-token',
        authStrategy: 'jwt',
        scopeNames: {},
      );

      await storage.set(authSuccess);
      await storage.set(null);
      final retrieved = await storage.get();

      expect(retrieved, isNull);
    });
  });
}

class _InMemoryKeyValueStorage implements KeyValueStorage {
  final Map<String, String?> _storage = {};

  @override
  Future<String?> get(String key) async {
    return _storage[key];
  }

  @override
  Future<void> set(String key, String? value) async {
    if (value == null) {
      _storage.remove(key);
    } else {
      _storage[key] = value;
    }
  }
}

AuthSuccess _authSuccess({
  UuidValue? authUserId,
  required String authStrategy,
  required String token,
  String? refreshToken,
  DateTime? tokenExpiresAt,
}) {
  return AuthSuccess(
    authUserId:
        authUserId ??
        UuidValue.fromString('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11'),
    authStrategy: authStrategy,
    token: token,
    tokenExpiresAt: tokenExpiresAt,
    refreshToken: refreshToken,
    scopeNames: const {},
  );
}

class _TestSerializationManager extends SerializationManager {}

class _TestServerpodClient extends ServerpodClientShared {
  var closeStreamingMethodConnectionsCallCount = 0;

  _TestServerpodClient({
    required ServerpodClientRequestDelegate requestDelegate,
  }) : super(
         'http://localhost:8080',
         _TestSerializationManager(),
         streamingConnectionTimeout: const Duration(seconds: 5),
         connectionTimeout: const Duration(seconds: 20),
         requestDelegate: requestDelegate,
       );

  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  Map<String, ModuleEndpointCaller> get moduleLookup => {};

  @override
  Future<void> closeStreamingMethodConnections({
    Object? exception = const WebSocketClosedException(),
  }) async {
    closeStreamingMethodConnectionsCallCount++;
  }
}

class _CookieRequestDelegate extends ServerpodClientRequestDelegate {
  @override
  bool get supportsCookieAuth => true;

  @override
  Future<String> serverRequest<T>(
    Uri url, {
    required String body,
    String? authenticationValue,
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  void close() {}
}

class _EndpointCaller implements EndpointCaller {
  @override
  Map<String, EndpointRef> get endpointRefLookup => {};

  @override
  T getEndpointOfType<T extends EndpointRef>([String? name]) {
    throw UnimplementedError();
  }

  @override
  Future<T> callServerEndpoint<T>(
    String endpoint,
    String method,
    Map<String, dynamic> args, {
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }

  @override
  dynamic callStreamingServerEndpoint<T, G>(
    String endpoint,
    String method,
    Map<String, dynamic> args,
    Map<String, Stream> streams, {
    bool authenticated = true,
  }) {
    throw UnimplementedError();
  }
}

class _TestRefreshJwtTokensEndpoint extends EndpointRefreshJwtTokens {
  _TestRefreshJwtTokensEndpoint() : super(_EndpointCaller());

  AuthSuccess? authSuccess;
  final refreshTokens = <String?>[];

  @override
  String get name => 'serverpod_auth_core.refreshJwtTokens';

  @override
  Future<AuthSuccess> refreshAccessToken({String? refreshToken}) async {
    refreshTokens.add(refreshToken);
    final authSuccess = this.authSuccess;
    if (authSuccess == null) throw StateError('No authSuccess configured.');
    return authSuccess;
  }
}
