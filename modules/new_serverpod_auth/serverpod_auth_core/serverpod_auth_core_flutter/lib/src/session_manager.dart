import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as core;

import 'storage/secure_client_auth_info_storage.dart';

/// The [FlutterAuthSessionManager] keeps track of and manages the signed-in
/// state of the user for Flutter applications. Users are typically authenticated
/// with Google, Apple, or other methods. Please refer to the documentation to
/// see supported methods. Session information is stored in the secure shared
/// preferences of the app and persists between restarts of the app.
///
/// This class extends [core.ClientAuthSessionManager] and adds Flutter-specific
/// reactive primitives ([ValueNotifier] and [ValueListenable]) for state
/// management.
class FlutterAuthSessionManager extends core.ClientAuthSessionManager {
  final _authInfoNotifier = ValueNotifier<core.AuthSuccess?>(null);

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
    core.ClientAuthInfoStorage? storage,
  }) : super(storage: storage ?? SecureClientAuthInfoStorage());

  /// A listenable that provides access to the signed in user for Flutter apps.
  ///
  /// Use this to listen to authentication state changes in your Flutter UI:
  /// ```dart
  /// client.auth.authInfoListenable.addListener(() {
  ///   setState(() {
  ///     // Update UI based on client.auth.isAuthenticated
  ///   });
  /// });
  /// ```
  ///
  /// To get the current auth info value directly, use the [authInfo] property.
  ValueListenable<core.AuthSuccess?> get authInfoListenable =>
      _authInfoNotifier;

  @override
  void onAuthInfoChanged() {
    _authInfoNotifier.value = authInfo;
  }
}

/// Backward compatibility alias for [FlutterAuthSessionManager].
///
/// This typedef maintains backward compatibility for existing Flutter applications
/// that use `ClientAuthSessionManager`. New code should use [FlutterAuthSessionManager]
/// for Flutter applications or [core.ClientAuthSessionManager] for platform-agnostic code.
typedef ClientAuthSessionManager = FlutterAuthSessionManager;

/// Extension for ServerpodClientShared to provide auth session management.
extension ClientAuthSessionManagerExtension on core.ServerpodClientShared {
  /// The authentication session manager to sign in and manage user sessions.
  FlutterAuthSessionManager get auth {
    final currentProvider = authKeyProvider;
    if (currentProvider == null) {
      throw StateError(
        'To access the auth instance, first instantiate the session manager '
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

  /// Sets the authentication session manager for this client.
  set authSessionManager(FlutterAuthSessionManager authSessionManager) {
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
