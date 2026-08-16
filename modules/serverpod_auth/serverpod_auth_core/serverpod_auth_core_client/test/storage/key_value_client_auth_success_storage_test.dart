import 'package:test/test.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import '../test_utils/storage_delegate.dart';

void main() {
  const key = 'test_key';
  late TestKeyValueAuthSuccessStorage storage;

  group(
    'Given a KeyValueClientAuthSuccessStorage created with default key',
    () {
      const defaultKey = 'serverpod_auth_success_key';

      setUp(() {
        storage = TestKeyValueAuthSuccessStorage.create();
      });

      test('when calling set then it uses the default key.', () async {
        await storage.set(_authSuccess);

        expect(await storage.delegate.get(defaultKey), isNotNull);
      });

      test('when calling get then it uses the default key.', () async {
        await storage.delegate.set(defaultKey, _authSuccess.toString());

        final result = await storage.get();

        expect(result, isNotNull);
      });
    },
  );

  group('Given a KeyValueClientAuthSuccessStorage created with custom key', () {
    const customKey = 'custom_auth_key';

    setUp(() {
      storage = TestKeyValueAuthSuccessStorage.create(
        authSuccessStorageKey: customKey,
      );
    });

    test('when calling set then it uses the custom key', () async {
      await storage.set(_authSuccess);

      expect(await storage.delegate.get(customKey), isNotNull);
    });

    test('when calling get then it uses the custom key.', () async {
      await storage.delegate.set(customKey, _authSuccess.toString());

      final result = await storage.get();

      expect(result, isNotNull);
    });
  });

  group('Given an uninitialized KeyValueClientAuthSuccessStorage', () {
    setUp(() {
      storage = TestKeyValueAuthSuccessStorage.create(
        authSuccessStorageKey: key,
      );
    });

    test('when calling get then it returns null', () async {
      final result = await storage.get();

      expect(result, isNull);
    });

    test(
      'when calling set with AuthSuccess data then it encodes and stores the data as JSON string.',
      () async {
        await storage.set(_authSuccess);

        final value = await storage.delegate.get(key);

        expect(value, _authSuccess.toString());
      },
    );
  });

  group('Given a KeyValueClientAuthSuccessStorage with data in storage', () {
    setUp(() async {
      storage = TestKeyValueAuthSuccessStorage.create(
        authSuccessStorageKey: key,
      );
      await storage.delegate.set(key, _authSuccess.toString());
    });

    test(
      'when decoding stored value then original object is returned.',
      () async {
        final value = await storage.delegate.get(key);

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
    'Given a KeyValueClientAuthSuccessStorage with invalid JSON data in storage, when calling get then it throws an exception.',
    () async {
      storage = TestKeyValueAuthSuccessStorage.create(
        authSuccessStorageKey: key,
      );

      await storage.delegate.set(key, 'invalid-json');

      await expectLater(() => storage.get(), throwsA(isA<Exception>()));
    },
  );

  group('Given storage operations that throw exceptions', () {
    setUp(() {
      storage = TestKeyValueAuthSuccessStorage.create();
    });

    test('when calling set then it propagates the exception.', () async {
      storage.delegate.setOverride = () => throw Exception('Error on set');

      await expectLater(
        () => storage.set(_authSuccess),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error on set'),
          ),
        ),
      );
    });

    test('when calling get then it propagates the exception.', () async {
      storage.delegate.getOverride = () => throw Exception('Error on get');

      await expectLater(
        () => storage.get(),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Error on get'),
          ),
        ),
      );
    });
  });
}

/// A [KeyValueClientAuthSuccessStorage] implementation for testing that exposes
/// the underlying delegate instance.
class TestKeyValueAuthSuccessStorage extends KeyValueClientAuthSuccessStorage {
  TestKeyValueAuthSuccessStorage._({
    required super.keyValueStorage,
    super.authSuccessStorageKey,
  });

  TestKeyValueStorage get delegate => keyValueStorage as TestKeyValueStorage;

  static TestKeyValueAuthSuccessStorage create({
    String? authSuccessStorageKey,
  }) {
    final testStorage = TestKeyValueAuthSuccessStorage._(
      keyValueStorage: TestKeyValueStorage(),
      authSuccessStorageKey: authSuccessStorageKey,
    );
    return testStorage;
  }
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session.name,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
