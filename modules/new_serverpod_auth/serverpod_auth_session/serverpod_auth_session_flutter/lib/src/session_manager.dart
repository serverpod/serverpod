import 'dart:async';

import 'package:flutter/foundation.dart';
// TODO
// ignore: depend_on_referenced_packages
import 'package:meta/meta.dart';
import 'package:serverpod_auth_session_client/serverpod_auth_session_client.dart';

/// Session manager client a server using `serverpod_auth_session`.
class SessionManager implements AuthenticationKeyProvider {
  /// Creates a new session manager instance.
  SessionManager({
    KeyValueStorage? storage,
  }) : _storage = storage ?? SharedPreferencesKeyValueStorage();

  // TODO: Use secure and "normal"?
  //       Or should we simplify due to the little data being stored
  final KeyValueStorage _storage;

  final _authInfo = ValueNotifier<AuthInfo?>(null);

  String? _key;

  static const _sessionKeyStorageKey = 'session_key'; // TODO
  static const _userInfoStorageKey = 'userInfo'; // TODO

  var _init = false;

  /// Read the configuration from the storage
  Future<void> restore() async {
    if (_init) {
      throw Exception('SessionManager.init must only be called once.');
    }
    _init = true;

    final sessionKey = await _storage.get(_sessionKeyStorageKey);
    final userInfo = await _storage.get(_userInfoStorageKey);

    if (sessionKey != null) {
      _key = sessionKey;

      _authInfo.value = (
        authUserId: UuidValue.fromString(userInfo!),
        // TODO: Handle scopes
        scopeNames: {},
      );
    }
  }

  @override
  String? getAuthenticationKey() {
    return _key;
  }

  @override
  void onUnauthenticatedException(String authenticationKey) {
    if (authenticationKey == _key) {
      logout();
    }
  }

  /// Set the current session to a logged-in user described by [authSuccess].
  Future<void> setLoggedIn(AuthSuccess authSuccess) async {
    _key = authSuccess.sessionKey;

    _storage.set(_sessionKeyStorageKey, authSuccess.sessionKey);

    // TODO: Scopes as well
    _storage.set(_userInfoStorageKey, authSuccess.authUserId.uuid);
  }

  /// Drop the current user.
  ///
  /// This should be called after a `logout` endpoint has been called on the server.
  void logout() {
    _storage.set(_sessionKeyStorageKey, null);
    _storage.set(_userInfoStorageKey, null);

    _key = null;
    _authInfo.value = null;
  }
}

/// Info about the logged-in user.
// TODO: Should the `Scope` class move to shared (until we can have a model?)
// TODO: Do we already track `Scope.name` not being `null` as a breaking change for 3.0?
typedef AuthInfo = ({UuidValue authUserId, Set<String> scopeNames});

/// TODO: Will be added by https://github.com/serverpod/serverpod/pull/3712
typedef AuthSuccess = ({
  String sessionKey,
  UuidValue authUserId,
  Set<String> scopeNames
});

/// Storage interface
abstract class KeyValueStorage {
  /// Get
  FutureOr<String?> get(String key);

  /// Set
  FutureOr set(String key, String? value);
}

@internal
class SharedPreferencesKeyValueStorage implements KeyValueStorage {
  @override
  Future<String?> get(String key) {
    throw UnimplementedError();
  }

  @override
  Future<void> set(String key, String? value) {
    throw UnimplementedError();
  }
}
