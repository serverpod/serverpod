import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart';
import 'package:serverpod_auth_session_flutter/serverpod_auth_session_flutter.dart';
import 'package:serverpod_auth_session_flutter/src/shared_preferences_key_value_storage.dart';

/// Session manager client a server using `serverpod_auth_session`.
class SessionManager extends AuthenticationKeyManager {
  /// Creates a new session manager instance.
  SessionManager({
    KeyValueStorage? storage,

    /// Optional distinct secure storage for the session key (e.g. Keychain).
    KeyValueStorage? secureStorage,
  }) : _storage = storage ?? SharedPreferencesKeyValueStorage() {
    _secureStorage = secureStorage ?? _storage;
  }

  final KeyValueStorage _storage;

  late final KeyValueStorage _secureStorage;

  final _authInfo = ValueNotifier<AuthInfo?>(null);

  /// The currently logged in user.
  ValueListenable<AuthInfo?> get authInfo => _authInfo;

  String? _key;

  var _init = false;

  /// Read the configuration from the storage
  Future<void> init() async {
    if (_init) {
      throw RepeatedSessionManagerInitError();
    }
    _init = true;

    final sessionKey = await _secureStorage.get(
      SessionManagerStorageKeys.sessionKeyStorageKey,
    );

    if (sessionKey != null) {
      _key = sessionKey;

      final persistedUserId = await _storage.get(
        SessionManagerStorageKeys.authUserIdStorageKey,
      );
      if (persistedUserId == null) {
        throw const IncompleteSessionManagerStorageException(
          SessionManagerStorageKeys.authUserIdStorageKey,
        );
      }

      final persistedScopeNames = await _storage.get(
        SessionManagerStorageKeys.scopeNamesStorageKey,
      );
      if (persistedScopeNames == null) {
        throw const IncompleteSessionManagerStorageException(
          SessionManagerStorageKeys.scopeNamesStorageKey,
        );
      }

      _authInfo.value = (
        authUserId: UuidValue.fromString(persistedUserId),
        scopeNames:
            (jsonDecode(persistedScopeNames) as List).cast<String>().toSet(),
      );
    }
  }

  /// Set the current session to a logged-in user described by [authSuccess].
  Future<void> setLoggedIn(AuthSuccess authSuccess) async {
    _key = authSuccess.sessionKey;
    _authInfo.value = (
      authUserId: authSuccess.authUserId,
      scopeNames: authSuccess.scopeNames,
    );

    await _secureStorage.set(
      SessionManagerStorageKeys.sessionKeyStorageKey,
      authSuccess.sessionKey,
    );

    await _storage.set(
      SessionManagerStorageKeys.authUserIdStorageKey,
      authSuccess.authUserId.uuid,
    );

    await _storage.set(
      SessionManagerStorageKeys.scopeNamesStorageKey,
      jsonEncode(authSuccess.scopeNames.toList()),
    );
  }

  /// Drop the current user.
  ///
  /// This should be called after a `logout` endpoint has been called on the
  /// server.
  Future<void> logout() async {
    await _secureStorage.set(
        SessionManagerStorageKeys.sessionKeyStorageKey, null);
    await _storage.set(SessionManagerStorageKeys.authUserIdStorageKey, null);
    await _storage.set(SessionManagerStorageKeys.scopeNamesStorageKey, null);

    _key = null;
    _authInfo.value = null;
  }

  @override
  Future<String?> get() async {
    return _key;
  }

  @override
  Future<void> put(String key) {
    // This is never called by the Serverpod `Client`, and thus no need to implement it.
    throw UnimplementedError();
  }

  @override
  Future<void> remove() {
    // This is never called by the Serverpod `Client`, and thus no need to implement it.
    throw UnimplementedError();
  }
}

/// Info about the logged-in user.
typedef AuthInfo = ({UuidValue authUserId, Set<String> scopeNames});

@internal
abstract class SessionManagerStorageKeys {
  static const sessionKeyStorageKey = 'serverpod_auth_session.sessionKey';
  static const authUserIdStorageKey = 'serverpod_auth_session.authUserId';
  static const scopeNamesStorageKey = 'serverpod_auth_session.scopeNames';
}

/// Error to be thrown when a `SessionManager` is initialized multiple times.
class RepeatedSessionManagerInitError extends Error {
  @override
  String toString() {
    return 'SessionManager.init has been called multiple times. It must only be called once.';
  }
}

/// Exception to be thrown when the `SessionManager`'s storage does not contain
/// all expected keys.
class IncompleteSessionManagerStorageException implements Exception {
  final String _missingKey;

  /// Creates a new instance of this error.
  const IncompleteSessionManagerStorageException(this._missingKey);

  @override
  String toString() {
    return 'The SessionManager\'s key/value store was missing an entry for "$_missingKey"';
  }
}
