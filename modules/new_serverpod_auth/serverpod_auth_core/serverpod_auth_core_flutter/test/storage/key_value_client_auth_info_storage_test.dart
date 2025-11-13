import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

import '../test_utils/storage_delegate.dart';

void main() {
  const key = 'test_key';
  late TestKeyValueAuthInfoStorage storage;

  group('Given a KeyValueClientAuthInfoStorage created with default key', () {
    const defaultKey = 'serverpod_auth_success_key';

    setUp(() {
      storage = TestKeyValueAuthInfoStorage.create();
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
  });

  group('Given a KeyValueClientAuthInfoStorage created with custom key', () {
    const customKey = 'custom_auth_key';

    setUp(() {
      storage = TestKeyValueAuthInfoStorage.create(
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

  group('Given an uninitialized KeyValueClientAuthInfoStorage', () {
    setUp(() {
      storage = TestKeyValueAuthInfoStorage.create(authSuccessStorageKey: key);
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

  group('Given a KeyValueClientAuthInfoStorage with data in storage', () {
    setUp(() async {
      storage = TestKeyValueAuthInfoStorage.create(authSuccessStorageKey: key);
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
    'Given a KeyValueClientAuthInfoStorage with invalid JSON data in storage, when calling get then it throws an exception.',
    () async {
      storage = TestKeyValueAuthInfoStorage.create(authSuccessStorageKey: key);

      await storage.delegate.set(key, 'invalid-json');

      await expectLater(() => storage.get(), throwsA(isA<Exception>()));
    },
  );

  group('Given storage operations that throw exceptions', () {
    setUp(() {
      storage = TestKeyValueAuthInfoStorage.create();
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

/// A [KeyValueClientAuthInfoStorage] implementation for testing that exposes
/// the underlying delegate instance.
class TestKeyValueAuthInfoStorage extends KeyValueClientAuthInfoStorage {
  TestKeyValueAuthInfoStorage._({
    required super.keyValueStorage,
    super.authSuccessStorageKey,
  });

  TestKeyValueStorage get delegate => keyValueStorage as TestKeyValueStorage;

  static TestKeyValueAuthInfoStorage create({String? authSuccessStorageKey}) {
    final testStorage = TestKeyValueAuthInfoStorage._(
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
