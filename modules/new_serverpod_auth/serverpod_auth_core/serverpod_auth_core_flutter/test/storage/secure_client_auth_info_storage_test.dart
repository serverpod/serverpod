import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';

void main() {
  late TestSecureKeyValueStorage storage;

  group('Given a SecureClientAuthInfoStorage created with default key', () {
    const defaultKey = 'serverpod_userinfo_key';

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create();
    });

    group('when calling set with AuthSuccess data', () {
      setUp(() async {
        await storage.set(_authSuccess);
      });

      test('then it stores the data using the default key', () async {
        final value = await storage.delegate.read(key: defaultKey);
        expect(value, _authSuccess.toString());
      });

      test('then it encodes and stores the data as JSON string', () async {
        final value = await storage.delegate.read(key: defaultKey);
        expect(value, isA<String>());
        expect(value, _authSuccess.toString());
      });

      test('then decoding the stored value returns the original object',
          () async {
        final value = await storage.delegate.read(key: defaultKey);
        expect(() => Protocol().decode<AuthSuccess>(value!), returnsNormally);

        final decoded = Protocol().decode<AuthSuccess>(value!);
        expect(decoded.toString(), _authSuccess.toString());
      });
    });

    test('when calling set with null then it stores null value', () async {
      await storage.set(null);

      expect(await storage.delegate.read(key: defaultKey), isNull);
    });

    test(
        'when calling get with stored data then it decodes and returns the AuthSuccess object',
        () async {
      await storage.set(_authSuccess);

      final result = await storage.get();

      expect(result, isNotNull);
      expect(result!.toString(), _authSuccess.toString());
    });

    test('when calling get with no stored data then it returns null', () async {
      final result = await storage.get();

      expect(result, isNull);
    });

    test('when calling get with invalid JSON data then it throws an exception',
        () async {
      await storage.delegate.write(key: defaultKey, value: 'invalid-json');

      await expectLater(() => storage.get(), throwsA(isA<Exception>()));
    });
  });

  group('Given a KeyValueClientAuthInfoStorage created with custom key', () {
    const customKey = 'custom_auth_key';

    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
      storage = TestSecureKeyValueStorage.create(authInfoStorageKey: customKey);
    });

    test('when calling set then it uses the custom key', () async {
      await storage.set(_authSuccess);
      final values = await storage.delegate.readAll();

      expect(values.length, 1);
      expect(values.keys.first, customKey);
      expect(values.values.first, isA<String>());
    });

    test('when calling get then it uses the custom key', () async {
      await storage.delegate.write(
        key: customKey,
        value: _authSuccess.toString(),
      );

      final result = await storage.get();

      expect(result, isNotNull);
      expect(result.toString(), _authSuccess.toString());
    });
  });
}

/// A [SecureClientAuthInfoStorage] implementation for testing that exposes the
/// underlying delegate instance.
class TestSecureKeyValueStorage extends SecureClientAuthInfoStorage {
  late final FlutterSecureStorage delegate;

  /// Creates a new [FlutterSecureKeyValueStorage].
  TestSecureKeyValueStorage._({
    super.secureStorage,
    super.authInfoStorageKey,
  });

  static TestSecureKeyValueStorage create({String? authInfoStorageKey}) {
    final delegate = FlutterSecureStorage();
    final testStorage = TestSecureKeyValueStorage._(
      secureStorage: delegate,
      authInfoStorageKey: authInfoStorageKey,
    );
    testStorage.delegate = delegate;
    return testStorage;
  }
}

final _authSuccess = AuthSuccess(
  authStrategy: AuthStrategy.session,
  token: 'session-key',
  authUserId: UuidValue.fromString('550e8400-e29b-41d4-a716-446655440000'),
  scopeNames: {'test1', 'test2'},
);
