import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

import 'storage/secure_client_auth_info_storage.dart';

/// The [FlutterAuthSessionManager] keeps track of and manages the signed-in
/// state of the user for Flutter applications. Users are typically authenticated
/// with Google, Apple, or other methods. Please refer to the documentation to
/// see supported methods. Session information is stored in the secure shared
/// preferences of the app and persists between restarts of the app.
///
/// This class extends [ClientAuthSessionManager] and adds Flutter-specific
/// reactive primitives ([ValueNotifier] and [ValueListenable]) for state
/// management.
class FlutterAuthSessionManager extends ClientAuthSessionManager {
  final _authInfoNotifier = ValueNotifier<AuthSuccess?>(null);

  /// Creates a new [FlutterAuthSessionManager].
  FlutterAuthSessionManager({
    /// Optionally override the caller. If not provided directly, the caller
    /// must be set before usage by calling [setCaller].
    super.caller,

    /// The authentication key provider to use for each auth strategy. If not
    /// provided, a default one will be created as needed.
    super.authKeyProviderDelegates,

    /// The storage to keep user authentication info. If missing, the
    /// session manager will create a [SecureClientAuthInfoStorage].
    ClientAuthInfoStorage? storage,
  }) : super(storage: storage ?? SecureClientAuthInfoStorage());

  /// A listenable that provides access to the signed in user.
  ValueListenable<AuthSuccess?> get authInfoListenable => _authInfoNotifier;

  @override
  void onAuthInfoChanged() {
    _authInfoNotifier.value = authInfo;
  }
}

/// Extension for ServerpodClientShared to provide Flutter auth session management.
extension FlutterAuthSessionManagerExtension on ServerpodClientShared {
  /// The Flutter authentication session manager to sign in and manage user sessions.
  FlutterAuthSessionManager get flutterAuth {
    final currentProvider = authKeyProvider;
    if (currentProvider == null) {
      throw StateError(
        'To access the flutterAuth instance, first instantiate the session manager '
        'and set it as the "authKeyProvider" on the client.',
      );
    }
    if (currentProvider is! FlutterAuthSessionManager) {
      throw StateError(
        'The "authKeyProvider" is set to an unsupported type. Expected '
        '"FlutterAuthSessionManager", got "${currentProvider.runtimeType}".',
      );
    }
    return currentProvider;
  }

  /// Sets the Flutter authentication session manager for this client.
  set flutterAuthSessionManager(FlutterAuthSessionManager authSessionManager) {
    authSessionManager.setCaller(_getCaller());
    authKeyProvider = authSessionManager;
  }
}

extension on ServerpodClientShared {
  Caller _getCaller() {
    var caller = moduleLookup.values.whereType<Caller>().firstOrNull;
    if (caller != null) return caller;
    throw StateError('No authentication module found.');
  }
}
