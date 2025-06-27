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

  var _didInit = false;

  /// Restores the persisted session from the storage, if any.
  Future<void> init() async {
    if (_didInit) {
      return;
    }
    _didInit = true;

    return _init();
  }

  Future<void> _init() async {
    final sessionKey = await _secureStorage.get(
      SessionManagerStorageKeys.sessionKey.key,
    );

    _key = sessionKey;

    if (sessionKey == null) {
      _authInfo.value = null;

      return;
    }

    final persistedUserId = await _storage.get(
      SessionManagerStorageKeys.authUserId.key,
    );
    if (persistedUserId == null) {
      throw IncompleteSessionManagerStorageException(
        SessionManagerStorageKeys.authUserId.key,
      );
    }

    final persistedScopeNames = await _storage.get(
      SessionManagerStorageKeys.scopeNames.key,
    );
    if (persistedScopeNames == null) {
      throw IncompleteSessionManagerStorageException(
        SessionManagerStorageKeys.scopeNames.key,
      );
    }

    _authInfo.value = (
      authUserId: UuidValue.withValidation(persistedUserId),
      scopeNames:
          (jsonDecode(persistedScopeNames) as List).cast<String>().toSet(),
    );
  }

  /// Set the current session to a logged-in user described by [authSuccess].
  Future<void> setLoggedIn(AuthSuccess authSuccess) async {
    await _secureStorage.set(
      SessionManagerStorageKeys.sessionKey.key,
      authSuccess.sessionKey,
    );

    await _storage.set(
      SessionManagerStorageKeys.authUserId.key,
      authSuccess.authUserId.uuid,
    );

    await _storage.set(
      SessionManagerStorageKeys.scopeNames.key,
      jsonEncode(authSuccess.scopeNames.toList()),
    );

    await _init();
  }

  /// Log out the current user.
  ///
  /// This should be called after a `logout` endpoint has been called on the
  /// server.
  Future<void> setLoggedOut() async {
    await _secureStorage.set(SessionManagerStorageKeys.sessionKey.key, null);
    await _storage.set(SessionManagerStorageKeys.authUserId.key, null);
    await _storage.set(SessionManagerStorageKeys.scopeNames.key, null);

    await _init();
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
enum SessionManagerStorageKeys {
  sessionKey('serverpod_auth_session.sessionKey'),
  authUserId('serverpod_auth_session.authUserId'),
  scopeNames('serverpod_auth_session.scopeNames');

  const SessionManagerStorageKeys(this.key);

  final String key;
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
