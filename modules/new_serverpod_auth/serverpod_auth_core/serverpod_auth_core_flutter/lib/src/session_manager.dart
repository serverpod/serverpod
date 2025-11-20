import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as core;

import 'storage/secure_client_auth_info_storage.dart';

/// The [ClientAuthSessionManager] keeps track of and manages the signed-in
/// state of the user. Users are typically authenticated with Google, Apple,
/// or other methods. Please refer to the documentation to see supported
/// methods. Session information is stored in the secure shared preferences of
/// the app and persists between restarts of the app.
///
/// This Flutter-specific implementation wraps the platform-agnostic
/// [core.ClientAuthSessionManager] and adds reactive primitives for Flutter.
class ClientAuthSessionManager implements core.RefresherClientAuthKeyProvider {
  final core.ClientAuthSessionManager _delegate;
  final ValueNotifier<core.AuthSuccess?> _authInfoNotifier;

  /// Creates a new [ClientAuthSessionManager].
  ClientAuthSessionManager({
    /// Optionally override the caller. If not provided directly, the caller
    /// must be set before usage by calling [setCaller].
    core.Caller? caller,

    /// The authentication key provider to use for each auth strategy. If not
    /// provided, a default one will be created as needed.
    Map<String, core.ClientAuthKeyProvider>? authKeyProviderDelegates,

    /// The secure storage to keep user authentication info. If missing, the
    /// session manager will create a [SecureClientAuthInfoStorage].
    core.ClientAuthInfoStorage? storage,
  }) : _authInfoNotifier = ValueNotifier<core.AuthSuccess?>(null),
       _delegate = _FlutterSessionManagerDelegate(
         caller: caller,
         authKeyProviderDelegates: authKeyProviderDelegates,
         storage: storage ?? SecureClientAuthInfoStorage(),
       ) {
    // Set up the notifier callback
    (_delegate as _FlutterSessionManagerDelegate)._onAuthInfoChanged = () {
      _authInfoNotifier.value = _delegate.authInfo;
    };
  }

  /// Sets the caller from the client's module lookup.
  void setCaller(core.Caller caller) => _delegate.setCaller(caller);

  /// The authentication module caller.
  core.Caller get caller => _delegate.caller;

  /// A listenable that provides access to the signed in user.
  ValueListenable<core.AuthSuccess?> get authInfo => _authInfoNotifier;

  /// Whether an user is currently signed in.
  bool get isAuthenticated => _delegate.isAuthenticated;

  /// The storage to keep user authentication info.
  core.ClientAuthInfoStorage get storage => _delegate.storage;

  /// The authentication key provider to use for the current auth strategy.
  core.ClientAuthKeyProvider? get authKeyProviderDelegate =>
      _delegate.authKeyProviderDelegate;

  @override
  Future<String?> get authHeaderValue => _delegate.authHeaderValue;

  @override
  Future<core.RefreshAuthKeyResult> refreshAuthKey({bool force = false}) =>
      _delegate.refreshAuthKey(force: force);

  /// Restores any existing session from storage and validates with the server.
  Future<bool> initialize({
    Duration timeout = const Duration(seconds: 2),
  }) => _delegate.initialize(timeout: timeout);

  /// Restore the current sign in status from the storage.
  Future<void> restore() => _delegate.restore();

  /// Updates the signed in user on the storage and for open connections.
  Future<void> updateSignedInUser(core.AuthSuccess? authInfo) =>
      _delegate.updateSignedInUser(authInfo);

  /// Verifies the current sign in status of the user with the server.
  Future<bool> validateAuthentication({Duration? timeout}) =>
      _delegate.validateAuthentication(timeout: timeout);

  /// Signs the user out from the current device.
  Future<bool> signOutDevice() => _delegate.signOutDevice();

  /// Signs the user out from all connected devices.
  Future<bool> signOutAllDevices() => _delegate.signOutAllDevices();
}

class _FlutterSessionManagerDelegate extends core.ClientAuthSessionManager {
  void Function()? _onAuthInfoChanged;

  _FlutterSessionManagerDelegate({
    required super.storage,
    super.caller,
    super.authKeyProviderDelegates,
  });

  @override
  void onAuthInfoChanged() {
    _onAuthInfoChanged?.call();
  }
}

/// Extension for ServerpodClientShared to provide auth session management.
extension ClientAuthSessionManagerExtension on core.ServerpodClientShared {
  /// The authentication session manager to sign in and manage user sessions.
  ClientAuthSessionManager get auth {
    final currentProvider = authKeyProvider;
    if (currentProvider == null) {
      throw StateError(
        'To access the auth instance, first instantiate the session manager '
        'and set it as the "authKeyProvider" on the client.',
      );
    }
    if (currentProvider is! ClientAuthSessionManager) {
      throw StateError(
        'The "authKeyProvider" is set to an unsupported type. Expected '
        '"ClientAuthSessionManager", got "${currentProvider.runtimeType}".',
      );
    }
    return currentProvider;
  }

  /// Sets the authentication session manager for this client.
  set authSessionManager(ClientAuthSessionManager authSessionManager) {
    authSessionManager.setCaller(getCaller());
    authKeyProvider = authSessionManager;
  }
}

extension on core.ServerpodClientShared {
  core.Caller getCaller() {
    var caller = moduleLookup.values.whereType<core.Caller>().firstOrNull;
    if (caller != null) return caller;
    throw StateError('No authentication module found.');
  }
}
