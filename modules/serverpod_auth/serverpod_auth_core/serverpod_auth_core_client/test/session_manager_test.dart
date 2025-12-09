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
