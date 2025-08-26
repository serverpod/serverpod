import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import '/src/storage/base.dart';
import '/src/storage/secure.dart';

/// As applications can have more than one Serverpod client, they also need to
/// have separate auth session managers for each.
final _authSessionManagersCache =
    HashMap<ServerpodClientShared, ClientAuthSessionManager>.identity();

/// The [ClientAuthSessionManager] keeps track of and manages the signed-in
/// state of the user. Users are typically authenticated with Google, Apple,
/// or other methods. Please refer to the documentation to see supported
/// methods. Session information is stored in the secure shared preferences of
/// the app and persists between restarts of the app.
class ClientAuthSessionManager implements ClientAuthKeyProvider {
  /// The auth module's caller.
  Caller? _caller;

  /// The secure storage to keep user authentication info.
  final ClientAuthInfoStorage storage;

  /// Creates a new [ClientAuthSessionManager].
  ClientAuthSessionManager({
    /// Optionally override the caller. If not provided directly, the caller
    /// must be set before usage by calling [setCallerFromClient].
    Caller? caller,

    /// The secure storage to keep user authentication info. If missing, the
    /// session manager will create a [SecureClientAuthInfoStorage].
    ClientAuthInfoStorage? storage,
  })  : _caller = caller,
        storage = storage ?? SecureClientAuthInfoStorage();

  /// Sets the caller from the client's module lookup.
  void setCallerFromClient(ServerpodClientShared client) {
    _caller ??= client.getCaller();
  }

  /// The authentication module caller.
  Caller get caller {
    if (_caller != null) return _caller!;
    throw StateError('Caller not set. Set the caller before accessing it.');
  }

  final _authInfo = ValueNotifier<AuthSuccess?>(null);

  /// A listenable that provides access to the signed in user.
  ValueListenable<AuthSuccess?> get authInfo => _authInfo;

  /// Whether an user is currently signed in.
  bool get isAuthenticated => authInfo.value != null;

  @override
  Future<String?> get authHeaderValue async {
    final currentAuth = authInfo.value;
    if (currentAuth == null) return null;
    return wrapAsBearerAuthHeaderValue(currentAuth.token);
  }

  /// Restores any existing session from the storage and perform a refresh.
  Future<bool> initialize() async {
    await restore();
    return refreshAuthentication();
  }

  /// Restore the current sign in status from the storage.
  Future<void> restore() async {
    _authInfo.value = await storage.get();
  }

  /// Updates the signed in user on the storage and for open connections.
  Future<void> updateSignedInUser(AuthSuccess? authInfo) async {
    await storage.set(authInfo);
    _authInfo.value = authInfo;
    await caller.client.updateStreamingConnectionAuthenticationKey();
  }

  // MAYBE: Is this true/false return enough? A connection error could return
  // false, but also a 401 due to a sign out on other device. What would be the
  // best way for the app to know when to sign out forcefully, and when to just
  // ignore safely and continue until next refresh?
  /// Verifies the current sign in status of the user with the server and
  /// updates the information on the storage. Returns true if successful.
  Future<bool> refreshAuthentication() async {
    try {
      // TODO: Add the actual call to the authentication endpoint. Depending on
      // solving the code generation for the endpoints.
      // await updateSignedInUser(await caller.status.getUserInfo());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _signOut({required bool allDevices}) async {
    try {
      // TODO: Actually call the signout endpoint.
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
    return _authSessionManagersCache[this] ??
        (throw StateError(
          'To access the auth instance, first instantiate the session manager '
          'with a caller from this client.',
        ));
  }

  /// Sets the authentication session manager for this client.
  set authSessionManager(ClientAuthSessionManager authSessionManager) {
    authSessionManager.setCallerFromClient(this);
    authKeyProvider = authSessionManager;
    _authSessionManagersCache[this] = authSessionManager;
  }
}

extension on ServerpodClientShared {
  Caller getCaller() {
    var caller = moduleLookup.values.whereType<Caller>().firstOrNull;
    if (caller != null) return caller;
    throw StateError('No authentication module found.');
  }
}
