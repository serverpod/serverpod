import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_backwards_compatibility_flutter/serverpod_auth_backwards_compatibility_flutter.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart'
    as auth_session_flutter;
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart'
    as legacy_auth_flutter;
import 'package:serverpod_new_auth_test_client/serverpod_new_auth_test_server_client.dart';

import 'utils/test_storage.dart';

void main() {
  test(
    'Given a session, when setting it on the `SessionManager`, then the server recognizes the user correctly.',
    () async {
      final client = Client(
        'http://localhost:8080/',
      );

      final email =
          'test_${DateTime.now().microsecondsSinceEpoch}@serverpod.dev';
      final password = 'Asdf123!!!!!';

      final userId =
          await client.emailAccountBackwardsCompatibilityTest.createLegacyUser(
        email: email,
        password: password,
      );

      final authKey = await client.emailAccountBackwardsCompatibilityTest
          .createLegacySession(
        userId: userId,
        scopes: {'test'},
      );

      final legacyStorage = _TestLegacyStorage();

      // Legacy setup

      final keyManager = legacy_auth_flutter.FlutterAuthenticationKeyManager(
        storage: legacyStorage,
      );

      final legacySessionClient = Client(
        'http://localhost:8080/',
        authenticationKeyManager: keyManager,
      );

      final legacySessionManager = legacy_auth_flutter.SessionManager(
        caller: legacySessionClient.modules.auth,
        storage: legacyStorage,
      );

      await legacySessionManager.registerSignedInUser(
        UserInfo(
          id: authKey.id,
          userIdentifier: '${authKey.id}',
          created: DateTime.now(),
          scopeNames: authKey.scopeNames,
          blocked: false,
        ),
        authKey.id!,
        authKey.key!,
      );

      expect(
        await legacySessionManager.keyManager.get(),
        '${authKey.id}:${authKey.key}',
      );

      expect(
        await legacySessionClient.emailAccountBackwardsCompatibilityTest
            .sessionUserIdentifer(),
        isNull, // old sessions do not work before migration
      );

      await legacySessionClient.emailAccountBackwardsCompatibilityTest
          .migrateUser(legacyUserId: userId);

      final newAuthUserId = await legacySessionClient
          .emailAccountBackwardsCompatibilityTest
          .getNewAuthUserId(userId: userId);

      expect(newAuthUserId, isNotNull);

      expect(
        await legacySessionClient.emailAccountBackwardsCompatibilityTest
            .sessionUserIdentifer(),
        isNull, // the session has not been migrated yet
      );

      final newSessionManager = auth_session_flutter.SessionManager(
        storage: TestStorage(),
      );

      final newSessionClient = Client(
        'http://localhost:8080/',
        authenticationKeyManager: newSessionManager,
      );

      await newSessionManager.initAndImportLegacySessionIfNeeded(
        newSessionClient.modules.serverpod_auth_backwards_compatibility,
        legacyStringGetter: legacyStorage.getString,
      );

      expect(
        await newSessionClient.emailAccountBackwardsCompatibilityTest
            .sessionUserIdentifer(),
        newAuthUserId!.uuid,
      );
    },
  );
}

class _TestLegacyStorage implements legacy_auth_flutter.Storage {
  final _values = <String, dynamic>{};

  @override
  Future<int?> getInt(String key) async {
    return _values[key];
  }

  @override
  Future<String?> getString(String key) async {
    return _values[key];
  }

  @override
  Future<void> remove(String key) async {
    _values.remove(key);
  }

  @override
  Future<void> setInt(String key, int value) async {
    _values[key] = value;
  }

  @override
  Future<void> setString(String key, String value) async {
    _values[key] = value;
  }
}
