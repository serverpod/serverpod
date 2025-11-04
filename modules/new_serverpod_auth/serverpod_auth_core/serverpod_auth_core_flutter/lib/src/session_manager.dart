import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import 'auth_key_providers/jwt_auth_key_provider.dart';
import 'auth_key_providers/sas_auth_key_provider.dart';
import 'storage/cached_client_auth_info_storage.dart';
import 'storage/client_auth_info_storage.dart';
import 'storage/secure_client_auth_info_storage.dart';

/// The [ClientAuthSessionManager] keeps track of and manages the signed-in
/// state of the user. Users are typically authenticated with Google, Apple,
/// or other methods. Please refer to the documentation to see supported
/// methods. Session information is stored in the secure shared preferences of
/// the app and persists between restarts of the app.
class ClientAuthSessionManager implements RefresherClientAuthKeyProvider {
  /// The auth module's caller.
  Caller? _caller;

  /// The authentication key provider to use.
  late final Map<String, ClientAuthKeyProvider> _authKeyProviderDelegates;

  /// The secure storage to keep user authentication info.
  final ClientAuthInfoStorage storage;

  /// Creates a new [ClientAuthSessionManager].
  ClientAuthSessionManager({
    /// Optionally override the caller. If not provided directly, the caller
    /// must be set before usage by calling [setCaller].
    Caller? caller,

    /// The authentication key provider to use for each auth strategy. If not
    /// provided, a default one will be created as needed.
    Map<String, ClientAuthKeyProvider>? authKeyProviderDelegates,

    /// The secure storage to keep user authentication info. If missing, the
    /// session manager will create a [SecureClientAuthInfoStorage].
    ClientAuthInfoStorage? storage,
  })  : _caller = caller,
        storage = storage ?? SecureClientAuthInfoStorage() {
    _authKeyProviderDelegates = authKeyProviderDelegates ?? {};
  }

  /// Sets the caller from the client's module lookup.
  void setCaller(Caller caller) {
    _caller = caller;
  }

  /// The authentication module caller.
  Caller get caller {
    if (_caller != null) return _caller!;
    throw StateError(
      'Caller not set on this session manager. Either set this session manager '
      'to a client by using the "authSessionManager" extension, or call the '
      '"setCaller" method before accessing the caller.',
    );
  }

  final _authInfo = ValueNotifier<AuthSuccess?>(null);

  /// A listenable that provides access to the signed in user.
  ValueListenable<AuthSuccess?> get authInfo => _authInfo;

  /// Whether an user is currently signed in.
  bool get isAuthenticated => authInfo.value != null;

  /// The authentication key provider to use for the current auth strategy.
  ClientAuthKeyProvider? get authKeyProviderDelegate {
    final authStrategyName = authInfo.value?.authStrategy;
    if (authStrategyName == null) return null;

    var authKeyProvider = _authKeyProviderDelegates[authStrategyName];
    if (authKeyProvider != null) return authKeyProvider;

    switch (AuthStrategy.fromJson(authStrategyName)) {
      case AuthStrategy.jwt:
        authKeyProvider = JwtAuthKeyProvider(
          getAuthInfo: () async => authInfo.value,
          onRefreshAuthInfo: updateSignedInUser,
          refreshEndpoint:
              caller.client.getEndpointOfType<EndpointRefreshJwtTokens>(),
        );
      case AuthStrategy.session:
        authKeyProvider = SasAuthKeyProvider(
          getAuthInfo: () async => authInfo.value,
        );
      default:
        throw UnimplementedError(
          'No authentication key provider found for auth strategy: $authStrategyName',
        );
    }

    _authKeyProviderDelegates[authStrategyName] = authKeyProvider;
    return authKeyProvider;
  }

  @override
  Future<String?> get authHeaderValue async =>
      authKeyProviderDelegate?.authHeaderValue;

  @override
  Future<RefreshAuthKeyResult> refreshAuthKey({bool force = false}) async {
    final authKeyProvider = authKeyProviderDelegate;
    if (authKeyProvider is! RefresherClientAuthKeyProvider) {
      return RefreshAuthKeyResult.skipped;
    }
    return authKeyProvider.refreshAuthKey(force: force);
  }

  /// Restores any existing session from the storage and validates it. If the
  /// authentication is no longer valid, the user is signed out from the current
  /// device, updating the [authInfo] value. If the refresh fails due to other
  /// reasons (network error, server error, etc.), returns false, but does not
  /// sign out the user. Returns true if the authentication was validated.
  Future<bool> initialize() async {
    await restore();
    return validateAuthentication();
  }

  /// Restore the current sign in status from the storage. If the underlying
  /// storage implements caching, the cache is cleared before restoring the
  /// value. This method can be called at any time to get the latest value from
  /// the storage.
  Future<void> restore() async {
    final storage = this.storage;
    if (storage is CachedClientAuthInfoStorage) {
      await storage.clearCache();
    }
    _authInfo.value = await storage.get();
  }

  /// Updates the signed in user on the storage and for open connections.
  Future<void> updateSignedInUser(AuthSuccess? authInfo) async {
    await storage.set(authInfo);
    _authInfo.value = authInfo;
    await caller.client.updateStreamingConnectionAuthenticationKey();
  }

  /// Verifies the current sign in status of the user with the server and
  /// updates the authentication info, if needed. If the user authentication is
  /// no longer valid, the user is signed out from the current device.
  Future<bool> validateAuthentication() async {
    try {
      if (isAuthenticated) {
        final refreshResult = await refreshAuthKey(force: true);
        if (refreshResult == RefreshAuthKeyResult.failedUnauthorized ||
            !await caller.status.isSignedIn()) {
          return await signOutDevice();
        }
      }
      return true;
    } on ServerpodClientException catch (_) {
      // Other errors, like network errors, should not sign out the user.
    }
    return false;
  }

  Future<bool> _signOut({required bool allDevices}) async {
    try {
      switch (allDevices) {
        case true:
          await caller.status.signOutAllDevices();
        case false:
          await caller.status.signOutDevice();
      }

      // Must be updated after the signout for the server to receive the header
      // info and recognize the signing out user. Otherwise, the call to the
      // status endpoint will go with no user info and no signout will be done.
      await updateSignedInUser(null);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Signs the user out from the current device.
  /// Returns true if successful.
  Future<bool> signOutDevice() async {
    return _signOut(allDevices: false);
  }

  /// Signs the user out from all connected devices.
  /// Returns true if successful.
  Future<bool> signOutAllDevices() async {
    return _signOut(allDevices: true);
  }
}

/// Extension for ServerpodClientShared to provide auth session management.
extension ClientAuthSessionManagerExtension on ServerpodClientShared {
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

extension on ServerpodClientShared {
  Caller getCaller() {
    var caller = moduleLookup.values.whereType<Caller>().firstOrNull;
    if (caller != null) return caller;
    throw StateError('No authentication module found.');
  }
}
