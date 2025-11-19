import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  const key = 'test_key';
  late TestSecureKeyValueStorage storage;

  group('Given a SecureClientAuthInfoStorage created with default key', () {
    const defaultKey = 'serverpod_auth_success_key';

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create();
    });

    test('when calling set then it uses the default key.', () async {
      await storage.set(_authSuccess);

      expect(await storage.delegate.read(key: defaultKey), isNotNull);
    });

    test('when calling get then it uses the default key.', () async {
      await storage.delegate.write(
        key: defaultKey,
        value: _authSuccess.toString(),
      );

      final result = await storage.get();

      expect(result, isNotNull);
    });
  });

  group('Given a SecureClientAuthInfoStorage created with custom key', () {
    const customKey = 'custom_auth_key';

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create(
        authSuccessStorageKey: customKey,
      );
    });

    test('when calling set then it uses the custom key', () async {
      await storage.set(_authSuccess);

      expect(await storage.delegate.read(key: customKey), isNotNull);
    });

    test('when calling get then it uses the custom key.', () async {
      await storage.delegate.write(
        key: customKey,
        value: _authSuccess.toString(),
      );

      final result = await storage.get();

      expect(result, isNotNull);
    });
  });

  group('Given an uninitialized SecureClientAuthInfoStorage', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create(authSuccessStorageKey: key);
    });

    test('when calling get then it returns null', () async {
      final result = await storage.get();

      expect(result, isNull);
    });

    test(
      'when calling set with AuthSuccess data then it encodes and stores the data as JSON string.',
      () async {
        await storage.set(_authSuccess);

        final value = await storage.delegate.read(key: key);

        expect(value, _authSuccess.toString());
      },
    );
  });

  group('Given a SecureClientAuthInfoStorage with data in storage', () {
    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create(authSuccessStorageKey: key);
      await storage.delegate.write(key: key, value: _authSuccess.toString());
    });

    test(
      'when decoding stored value then original object is returned.',
      () async {
        final value = await storage.delegate.read(key: key);

        expect(value, isNotNull);
        expect(() => Protocol().decode<AuthSuccess>(value!), returnsNormally);

        final decoded = Protocol().decode<AuthSuccess>(value!);
        expect(decoded.toString(), _authSuccess.toString());
      },
    );

    test('when calling get then data is retrieved from storage', () async {
      final result = await storage.get();

      expect(result, isNotNull);
      expect(result!.toString(), _authSuccess.toString());
    });

    test(
      'when calling set with a new AuthSuccess data then new data replaces old stored data.',
      () async {
        final authSuccessNew = _authSuccess.copyWith(token: 'different-token');
        await storage.set(authSuccessNew);

        final stored = await storage.get();

        expect(stored.toString(), authSuccessNew.toString());
      },
    );

    test('when calling set with null then stored data is null.', () async {
      await storage.set(null);

      final stored = await storage.get();

      expect(stored, isNull);
    });
  });

  test(
    'Given a SecureClientAuthInfoStorage with invalid JSON data in storage, when calling get then it throws an exception.',
    () async {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create(authSuccessStorageKey: key);

      await storage.delegate.write(key: key, value: 'invalid-json');

      await expectLater(() => storage.get(), throwsA(isA<Exception>()));
    },
  );
}

/// A [SecureClientAuthInfoStorage] implementation for testing that exposes the
/// underlying delegate instance.
class TestSecureKeyValueStorage extends SecureClientAuthInfoStorage {
  late final FlutterSecureStorage delegate;

  /// Creates a new [FlutterSecureKeyValueStorage].
  TestSecureKeyValueStorage._({
    super.secureStorage,
    super.authSuccessStorageKey,
  });

  static TestSecureKeyValueStorage create({String? authSuccessStorageKey}) {
    const delegate = FlutterSecureStorage();
    final testStorage = TestSecureKeyValueStorage._(
      secureStorage: delegate,
      authSuccessStorageKey: authSuccessStorageKey,
    );
    testStorage.delegate = delegate;
    return testStorage;
  }
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session.name,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
