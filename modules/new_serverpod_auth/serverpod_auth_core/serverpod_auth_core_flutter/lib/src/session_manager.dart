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
// TODO: Implement the provider here.
class ClientAuthSessionManager {
  // MAYBE: Is it worth making this class generic to the [AuthSuccess] so that
  // users can extend it to their own auth responses enhanced with user info?

  /// The auth module's caller.
  Caller caller;

  /// The secure storage to keep user authentication info.
  late final ClientAuthInfoStorage storage;

  /// Creates a new [ClientAuthSessionManager].
  ClientAuthSessionManager({
    required this.caller,

    /// Stores the authentication information that must be used as provider to
    /// the client. If not specified, will default to the [authKeyProvider] of
    /// the [client], in case it implements the storage interface. If it does
    /// not, an error will be thrown. If both attributes are missing, the
    /// session manager will use a [SecureClientAuthInfoStorage].
    ClientAuthInfoStorage? storage,
  }) {
    final maybeStorage = storage ?? caller.client.authKeyProvider;

    // To offer a good user experience, the [ClientSessionManager] will attempt
    // to initialize from the [authKeyProvider], if exists, or set it otherwise,
    // if a [storage] exists.
    if (maybeStorage == null) {
      storage = caller.client.authKeyProvider = FlutterSecureAuthKeyManager();
    } else if (storage == null) {
      if (caller.client.authKeyProvider is ClientAuthInfoStorage) {
        storage = caller.client.authKeyProvider as ClientAuthInfoStorage;
      }
    } else if (caller.client.authKeyProvider == null) {
      if (storage is ClientAuthKeyProvider) {
        caller.client.authKeyProvider = storage as ClientAuthKeyProvider;
      }
    }

    throw StateError(
      'To create the session manager, either set an authentication key '
      'provider on the client that also implements the ClientAuthInfoStorage '
      'interface or provide it through the storage property.',
    );
  }

  final _authInfo = ValueNotifier<AuthSuccess?>(null);

  /// A listenable that provides access to the signed in user.
  ValueListenable<AuthSuccess?> get authInfo => _authInfo;

  /// Whether an user is currently signed in.
  bool get isAuthenticated => authInfo.value != null;

  /// Restores any existing session from the storage and perform a refresh.
  Future<bool> initialize() async {
    await restore();
    return refreshAuthentication();
  }

  /// Restore the current sign in status from the storage.
  Future<void> restore() async {
    await storage.get();
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

/// Stores session information in a secure shared preferences of the app and
/// persists between restarts of the app.
class FlutterSecureAuthKeyManager extends SecureClientAuthInfoStorage
    implements ClientAuthKeyProvider {
  /// Creates a new [FlutterSecureAuthKeyManager].
  FlutterSecureAuthKeyManager({super.storage, super.authInfoStorageKey});

  @override
  Future<String?> get authHeaderValue async {
    final authInfo = await get();
    if (authInfo == null) return null;
    return wrapAsBearerAuthHeaderValue(authInfo.token);
  }
}

/// Extension for ServerpodClientShared to provide auth session management.
extension ClientAuthSessionManagerExtension on ServerpodClientShared {
  /// The authentication session manager to sign in and manage user sessions.
  ClientAuthSessionManager get auth {
    final manager = _authSessionManagersCache[this] ??
        (throw StateError(
          'To access the auth instance, first set the session manager through '
          'the `authSessionManager` property.',
        ));
    return manager;
  }

  /// Sets the authentication session manager for the client.
  set authSessionManager(ClientAuthSessionManager manager) {
    _authSessionManagersCache[this] = manager;
  }
}
