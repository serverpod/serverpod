import 'package:serverpod_auth_backwards_compatibility_client/serverpod_auth_backwards_compatibility_client.dart'
    as backward_compatibility_client;
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart'
    as auth_flutter;
import 'package:shared_preferences/shared_preferences.dart';

extension SessionManagerLegacyImport on auth_flutter.SessionManager {
  static const _prefsKey = 'serverpod_authentication_key_production';

  Future<void> initAndImportLegacySessionIfNeeded(
    backward_compatibility_client.Caller caller, {
    final Future<String?> Function(String key)? legacyStringGetter,
  }) async {
    await init();

    if (authInfo.value != null) {
      return;
    }

    final String? legacySessionKey;
    if (legacyStringGetter != null) {
      legacySessionKey = await legacyStringGetter(_prefsKey);
    } else {
      final sharedPreferences = await SharedPreferences.getInstance();
      legacySessionKey = sharedPreferences.getString(_prefsKey);
    }

    if (legacySessionKey == null) {
      return;
    }

    final authSuccess = await caller.sessionMigration.convertSession(
      sessionKey: legacySessionKey,
    );

    if (authSuccess == null) {
      return;
    }

    await setLoggedIn(authSuccess);
  }
}
