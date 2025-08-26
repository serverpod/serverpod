import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  group('Given a KeyValueClientAuthInfoStorage implementation', () {
    late TestKeyValueStorage storage;

    setUp(() {
      storage = TestKeyValueStorage();
    });

    group('when calling setOnStorage with AuthSuccess data', () {
      setUp(() async {
        await storage.setOnStorage(_authSuccess);
      });

      test('then it encodes and stores the data as JSON string', () async {
        expect(storage.lastSetValue, isA<String>());
        expect(() => Protocol().decode<AuthSuccess>(storage.lastSetValue!),
            returnsNormally);
      });

      test('then decoding the stored value returns the original object',
          () async {
        final decoded = Protocol().decode<AuthSuccess>(storage.lastSetValue!);
        expect(decoded.toString(), _authSuccess.toString());
      });
    });

    test('when calling setOnStorage with null then it stores null value',
        () async {
      await storage.setOnStorage(null);

      expect(storage.lastSetValue, isNull);
    });

    test(
        'when calling getFromStorage with stored data then it decodes and returns the AuthSuccess object',
        () async {
      await storage.setOnStorage(_authSuccess);

      final result = await storage.getFromStorage();

      expect(result, isNotNull);
      expect(result!.toString(), _authSuccess.toString());
    });

    test('when calling getFromStorage with no stored data then it returns null',
        () async {
      final result = await storage.getFromStorage();

      expect(result, isNull);
    });

    test(
        'when calling getFromStorage with invalid JSON data then it throws an exception',
        () async {
      storage._storage['test_key'] = 'invalid-json';

      await expectLater(
        () => storage.getFromStorage(),
        throwsA(isA<Exception>()),
      );
    });

    group('when storage operations throw exceptions', () {
      test('then setOnStorage propagates setValue exception', () async {
        storage.shouldThrowOnSet = true;

        await expectLater(
          () => storage.setOnStorage(_authSuccess),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Storage error on setValue'),
          )),
        );
      });

      test('then getFromStorage propagates getValue exception', () async {
        storage.shouldThrowOnGet = true;

        await expectLater(
          () => storage.getFromStorage(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Storage error on getValue'),
          )),
        );
      });
    });

    test('when calling set then it inherits caching behavior', () async {
      await storage.set(_authSuccess);
      expect(storage.cachedAuthInfo.toString(), _authSuccess.toString());
      expect(identical(await storage.get(), storage.cachedAuthInfo), isTrue);

      await storage.set(null);
      expect(storage.cachedAuthInfo, isNull);
    });

    test('when calling get then it inherits caching behavior', () async {
      await storage.setOnStorage(_authSuccess);
      expect(identical(await storage.get(), storage.cachedAuthInfo), isTrue);
      expect(storage.cachedAuthInfo.toString(), _authSuccess.toString());
    });
  });
}

class TestKeyValueStorage extends KeyValueClientAuthInfoStorage {
  final Map<String, String> _storage = {};
  String? lastSetValue;
  bool shouldThrowOnGet = false;
  bool shouldThrowOnSet = false;

  @override
  Future<void> setValue(String? value) async {
    if (shouldThrowOnSet) {
      throw Exception('Storage error on setValue');
    }

    lastSetValue = value;
    if (value == null) {
      _storage.remove('test_key');
    } else {
      _storage['test_key'] = value;
    }
  }

  @override
  Future<String?> getValue() async {
    if (shouldThrowOnGet) {
      throw Exception('Storage error on getValue');
    }

    return _storage['test_key'];
  }

  void clear() {
    _storage.clear();
    lastSetValue = null;
  }
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
