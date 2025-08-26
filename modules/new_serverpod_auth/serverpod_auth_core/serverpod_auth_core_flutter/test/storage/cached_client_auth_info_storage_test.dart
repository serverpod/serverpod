import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  group('Given a CachedClientAuthInfoStorage implementation', () {
    late TestCachedStorage storage;

    setUp(() {
      storage = TestCachedStorage();
    });

    test(
        'when accessing cachedAuthInfo before any operation then it throws StateError',
        () {
      expect(
        () => storage.cachedAuthInfo,
        throwsA(isA<StateError>().having(
          (e) => e.message,
          'message',
          contains('Tried to access the cached info before initializing'),
        )),
      );
    });

    group('when calling set with AuthSuccess data', () {
      setUp(() async {
        await storage.set(_authSuccess);
      });

      test('then it stores the data and caches it', () async {
        final cached = storage.cachedAuthInfo!;

        expect(cached.toString(), _authSuccess.toString());
        expect(storage.lastSetValue, isNotNull);
      });

      test('then subsequent calls to cachedAuthInfo return the same data',
          () async {
        final cached1 = storage.cachedAuthInfo!;
        final cached2 = storage.cachedAuthInfo!;

        expect(identical(cached1, cached2), isTrue);
      });
    });

    group('when calling set with null', () {
      setUp(() async {
        await storage.set(_authSuccess);
        expect(storage.cachedAuthInfo, isNotNull);
        await storage.set(null);
      });

      test('then it clears the data and caches null', () async {
        expect(storage.cachedAuthInfo, isNull);
        expect(storage.lastSetValue, isNull);
      });
    });

    group('when calling get for the first time', () {
      test('with data in storage then it retrieves from storage', () async {
        await storage.setOnStorage(_authSuccess);

        final result = await storage.get();
        final cached = storage.cachedAuthInfo!;

        expect(result, isNotNull);
        expect(result!.toString(), _authSuccess.toString());
        expect(identical(result, cached), isTrue);
      });

      test('with empty storage then it returns null', () async {
        final result = await storage.get();

        expect(result, isNull);
        expect(storage.cachedAuthInfo, isNull);
      });
    });

    group('when calling get after data is cached', () {
      test('then it returns cached data without hitting storage', () async {
        await storage.set(_authSuccess);
        storage.shouldThrowOnGet = true;

        final result = await storage.get();

        expect(result, isNotNull);
        expect(result!.toString(), _authSuccess.toString());

        final cached = storage.cachedAuthInfo!;
        expect(cached.toString(), _authSuccess.toString());
      });
    });

    group('when storage operations throw exceptions', () {
      test('then set propagates the exception', () async {
        storage.shouldThrowOnSet = true;

        await expectLater(
          () => storage.set(_authSuccess),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Storage error on set'),
          )),
        );
      });

      test('then get propagates the exception', () async {
        storage.shouldThrowOnGet = true;

        await expectLater(
          () => storage.get(),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Storage error on get'),
          )),
        );
      });
    });

    test('when updating data then new cached data replaces old cached data',
        () async {
      final authSuccess1 = _authSuccess;
      final authSuccess2 = _authSuccess.copyWith(token: 'different-token');

      await storage.set(authSuccess1);
      expect(storage.cachedAuthInfo, equals(authSuccess1));

      await storage.set(authSuccess2);
      final cached = storage.cachedAuthInfo!;
      expect(cached.token, equals(authSuccess2.token));
      expect(cached.token, isNot(equals(authSuccess1.token)));
    });
  });
}

class TestCachedStorage extends CachedClientAuthInfoStorage {
  final Map<String, String> _storage = {};
  AuthSuccess? lastSetValue;
  bool shouldThrowOnGet = false;
  bool shouldThrowOnSet = false;

  @override
  Future<void> setOnStorage(AuthSuccess? data) async {
    if (shouldThrowOnSet) {
      throw Exception('Storage error on set');
    }

    lastSetValue = data;
    if (data == null) {
      _storage.remove('test_key');
    } else {
      _storage['test_key'] = data.toString();
    }
  }

  @override
  Future<AuthSuccess?> getFromStorage() async {
    if (shouldThrowOnGet) {
      throw Exception('Storage error on get');
    }

    final value = _storage['test_key'];
    return value != null ? Protocol().decode<AuthSuccess>(value) : null;
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
