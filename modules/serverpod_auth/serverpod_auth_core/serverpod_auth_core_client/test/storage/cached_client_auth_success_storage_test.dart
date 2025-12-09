import 'package:test/test.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import '../test_utils/storage_delegate.dart';

void main() {
  late TestCachedAuthSuccessStorage storage;

  group('Given an uninitialized CachedClientAuthSuccessStorage', () {
    setUp(() {
      storage = TestCachedAuthSuccessStorage.create();
    });

    test('when calling get then it returns null', () async {
      final result = await storage.get();

      expect(result, isNull);
    });

    test(
      'when calling get multiple times then null data is only retrieved from storage once.',
      () async {
        await storage.get();
        await storage.get();

        expect(storage.delegate.storageGetHitCount, 1);
      },
    );

    test(
      'when calling set with AuthSuccess data then stored data matches set data.',
      () async {
        await storage.set(_authSuccess);

        final cached = await storage.get();

        expect(cached.toString(), _authSuccess.toString());
      },
    );
  });

  group('Given a CachedClientAuthSuccessStorage with data in storage', () {
    setUp(() async {
      storage = TestCachedAuthSuccessStorage.create();
      await storage.delegate.set(_authSuccess);
    });

    test('when calling get then data is retrieved from storage', () async {
      final result = await storage.get();

      expect(result, isNotNull);
      expect(result!.toString(), _authSuccess.toString());
    });

    test(
      'when calling get multiple times then data is only retrieved from storage once.',
      () async {
        final result = await storage.get();
        final resultCached = await storage.get();

        expect(identical(result, resultCached), isTrue);
        expect(storage.delegate.storageGetHitCount, 1);
      },
    );

    test(
      'when calling clearCache before get then subsequent get retrieves from delegate storage.',
      () async {
        await storage.get();

        await storage.clearCache();
        await storage.get();

        expect(storage.delegate.storageGetHitCount, 2);
      },
    );

    group('when calling set with a new AuthSuccess data', () {
      final authSuccessNew = _authSuccess.copyWith(token: 'different-token');

      setUp(() async {
        await storage.set(authSuccessNew);
      });

      test('then new data replaces old stored data.', () async {
        final cached = await storage.get();

        expect(cached.toString(), authSuccessNew.toString());
      });

      test('then getting data does not hit the storage.', () async {
        await storage.get();

        expect(storage.delegate.storageGetHitCount, 0);
      });
    });

    test('when calling set with null then stored data is null.', () async {
      await storage.set(null);

      final cached = await storage.get();

      expect(cached, isNull);
    });
  });

  group('Given storage operations that throw exceptions', () {
    setUp(() {
      storage = TestCachedAuthSuccessStorage.create();
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

/// A [CachedClientAuthSuccessStorage] implementation for testing that exposes the
/// underlying delegate instance.
class TestCachedAuthSuccessStorage extends CachedClientAuthSuccessStorage {
  late final TestClientAuthSuccessStorage delegate;

  TestCachedAuthSuccessStorage._({required super.delegate});

  factory TestCachedAuthSuccessStorage.create() {
    final delegate = TestClientAuthSuccessStorage();
    final testStorage = TestCachedAuthSuccessStorage._(delegate: delegate);
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
