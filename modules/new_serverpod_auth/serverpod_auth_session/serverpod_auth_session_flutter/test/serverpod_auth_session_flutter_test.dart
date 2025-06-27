import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_auth_session_flutter/src/session_manager.dart';

void main() {
  group('Given a `SessionManager` created with a single empty storage, ', () {
    late TestStorage storage;
    late SessionManager sessionManager;

    setUp(() {
      storage = TestStorage();
      sessionManager = SessionManager(storage: storage);
    });

    test('when calling init, then it completes.', () async {
      await expectLater(sessionManager.init(), completes);
    });

    test('when getting the authentication key, then it returns `null`.',
        () async {
      expect(
        await sessionManager.get(),
        isNull,
      );
    });

    test('when logging-in, then all entries are written to the storage.',
        () async {
      // In here this is called without `init` first!
      await sessionManager.setLoggedIn(_authSucces);

      expect(
        storage.values,
        {
          SessionManagerStorageKeys.sessionKeyStorageKey:
              _authSucces.sessionKey,
          SessionManagerStorageKeys.authUserIdStorageKey:
              _authSucces.authUserId.toString(),
          SessionManagerStorageKeys.scopeNamesStorageKey: '["test1","test2"]'
        },
      );
    });
  });

  group(
      'Given a `SessionManager` created with a single empty storage which was then logged in, ',
      () {
    late TestStorage storage;
    late SessionManager sessionManager;

    setUp(() async {
      storage = TestStorage();
      sessionManager = SessionManager(storage: storage);

      await sessionManager.init();
      await sessionManager.setLoggedIn(_authSucces);
    });

    test('when reading the storage, then all keys are present.', () async {
      expect(
        storage.values,
        {
          SessionManagerStorageKeys.sessionKeyStorageKey:
              _authSucces.sessionKey,
          SessionManagerStorageKeys.authUserIdStorageKey:
              _authSucces.authUserId.toString(),
          SessionManagerStorageKeys.scopeNamesStorageKey: '["test1","test2"]'
        },
      );
    });

    test('when getting the authentication key, then it is returned.', () async {
      expect(await sessionManager.get(), 'session-key');
    });

    test('when getting the auth info, then it is returned.', () async {
      final authInfo = sessionManager.authInfo.value;

      expect(authInfo, isNotNull);
      expect(authInfo?.authUserId, _authSucces.authUserId);
      expect(authInfo?.scopeNames, {'test1', 'test2'});
    });
  });

  group('Given a `SessionManager` created with distinct empty storages, ', () {
    late TestStorage secureStorage;
    late TestStorage defaultStorage;
    late SessionManager sessionManager;

    setUp(() {
      secureStorage = TestStorage();
      defaultStorage = TestStorage();
      sessionManager = SessionManager(
        storage: defaultStorage,
        secureStorage: secureStorage,
      );
    });

    test('when calling init, then it completes.', () async {
      await expectLater(sessionManager.init(), completes);
    });

    test('when logging-in, then all entries are written to the storage.',
        () async {
      await sessionManager.setLoggedIn(_authSucces);

      expect(
        secureStorage.values,
        {
          SessionManagerStorageKeys.sessionKeyStorageKey:
              _authSucces.sessionKey,
        },
      );

      expect(
        defaultStorage.values,
        {
          SessionManagerStorageKeys.authUserIdStorageKey:
              _authSucces.authUserId.toString(),
          SessionManagerStorageKeys.scopeNamesStorageKey: '["test1","test2"]'
        },
      );
    });
  });

  group(
      'Given a `SessionManager` with a storage that only contains the session key, ',
      () {
    late TestStorage storage;
    late SessionManager sessionManager;

    setUp(() {
      storage = TestStorage()
        ..set(
          SessionManagerStorageKeys.sessionKeyStorageKey,
          'some-session-key',
        );

      sessionManager = SessionManager(
        storage: storage,
      );
    });

    test('when calling init, then it throws.', () async {
      await expectLater(
        () => sessionManager.init(),
        throwsA(isA<IncompleteSessionManagerStorageException>()),
      );
    });
  });

  group(
      'Given a `SessionManager` which has been init with a previous session from storage, ',
      () {
    late TestStorage storage;
    late SessionManager sessionManager;

    setUp(() async {
      storage = TestStorage()..setTestValues();

      sessionManager = SessionManager(
        storage: storage,
      );

      await sessionManager.init();
    });

    test('when calling init again, then it throws.', () async {
      await expectLater(
        () => sessionManager.init(),
        throwsA(isA<RepeatedSessionManagerInitError>()),
      );
    });

    test('when reading `authInfo`, then it is set.', () {
      expect(
        sessionManager.authInfo.value,
        isNotNull,
      );
    });

    test('when getting the authentication key, then it returns it.', () async {
      expect(
        await sessionManager.get(),
        'session-test',
      );
    });

    test('when calling `logout`, then the storage values are cleared.',
        () async {
      await sessionManager.setLoggedOut();

      expect(storage.values, isEmpty);
    });

    test('when calling `logout`, then `authInfo` is cleared.', () async {
      await sessionManager.setLoggedOut();

      expect(sessionManager.authInfo.value, isNull);
    });
  });
}

class TestStorage extends KeyValueStorage {
  final values = <String, String>{};

  @override
  String? get(String key) {
    return values[key];
  }

  @override
  void set(String key, String? value) {
    if (value == null) {
      values.remove(key);
    } else {
      values[key] = value;
    }
  }

  /// Sets all possible storage values to a working value.
  void setTestValues() {
    values.addAll({
      SessionManagerStorageKeys.sessionKeyStorageKey: 'session-test',
      SessionManagerStorageKeys.authUserIdStorageKey: const Uuid().v4(),
      SessionManagerStorageKeys.scopeNamesStorageKey: '["test1", "test2"]'
    });
  }
}

final _authSucces = AuthSuccess(
  sessionKey: 'session-key',
  authUserId: const Uuid().v4obj(),
  scopeNames: {'test1', 'test2'},
);
